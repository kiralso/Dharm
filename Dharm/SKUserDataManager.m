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

@interface SKUserDataManager()

@property(strong, nonatomic) NSManagedObjectContext *moc;

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
        self.moc = [SKCoreDataManager sharedManager].persistentContainer.viewContext;
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
    
    NSArray* array = [self.moc executeFetchRequest:request
                                             error:nil];
    
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

@end
