//
//  SKUserDataManager.m
//  Dharm
//
//  Created by Кирилл on 09.04.17.
//  Copyright © 2017 Kirill Solovyov. All rights reserved.
//

#import "SKUserDataManager.h"
#import "SKCoreDataManager.h"
#import "SKUser+CoreDataClass.h"
#import "SKNotificationDate+CoreDataClass.h"
#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>

@interface SKUserDataManager()

@property(strong, nonatomic) NSManagedObjectContext *moc;
@property(assign, nonatomic) NSInteger systemVersion;

@end

@implementation SKUserDataManager

+ (SKUserDataManager *) sharedManager {
    
    static SKUserDataManager *manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[SKUserDataManager alloc] init];
    });
    
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        NSString *systemVersion = [[UIDevice currentDevice].systemVersion substringToIndex:1];
        
        self.systemVersion = [systemVersion integerValue];
        
        if (self.systemVersion < 10) {
            self.moc = [SKCoreDataManager sharedManager].oldManagedObjectContext;
        } else {
            self.moc = [SKCoreDataManager sharedManager].persistentContainer.viewContext;
        }
    }
    return self;
}

#pragma mark - User

- (void) createUser {
    
    SKUser * user = [self user];
    
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"SKUser"
                                                         inManagedObjectContext:self.moc];
    
    if (!user) {
        
        user = [[SKUser alloc] initWithEntity:entityDescription
                       insertIntoManagedObjectContext:self.moc];
        
        user.score = 0;
        
        NSError *error = nil;
        if (![self.moc save:&error]) {
            abort();
        }
    }
    
}

- (SKUser *) user {
    
    NSFetchRequest *request = [SKUser fetchRequest];
    NSError *error = nil;
    NSArray* array = [self.moc executeFetchRequest:request
                                             error:&error];
    
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
        return nil;
    }
    
    return [array firstObject];
}

- (void) updateUserWithScore:(NSInteger) score {
    
    SKUser *user = [self user];
    
    user.score = score;
    
    NSError *error = nil;
    if (![self.moc save:&error]) {
        abort();
    }
}

- (void) updateUserWithNotificationDateArray:(NSArray<SKNotificationDate *> *)array {
    
    SKUser *user = [self user];
    
    NSSet *dateSet = [NSSet setWithArray:array];
    
    user.notificationDate = dateSet;
    
    NSError *error = nil;
    if (![self.moc save:&error]) {
        abort();
    }
}

- (NSSet *) fireDates {
    
    NSSet* notificationDates = [[SKUserDataManager sharedManager] user].notificationDate;
    
    NSMutableSet *fireDatesSet = [NSMutableSet set];
    
    for (SKNotificationDate *date in notificationDates) {
        [fireDatesSet addObject:date.fireDate];
    }
    
    return fireDatesSet;
}

- (SKNotificationDate *) notificationDateWithFireDate:(NSDate *) fireDate warningDate:(NSDate *) warningDate andUser:(SKUser *) user {
    
    NSEntityDescription *entityDescription =
    [NSEntityDescription entityForName:@"SKNotificationDate"
                inManagedObjectContext:self.moc];
    
    SKNotificationDate *nd = [[SKNotificationDate alloc] initWithEntity:entityDescription
                                         insertIntoManagedObjectContext:self.moc];
    
    nd.fireDate = fireDate;
    nd.warningDate = warningDate;
    nd.user = user;
    
    NSError *error = nil;
    if (![self.moc save:&error]) {
        abort();
    }
    
    return nd;
}


@end
