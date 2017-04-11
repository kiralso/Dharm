//
//  SKNotificationDateDataManager.m
//  Dharm
//
//  Created by Кирилл on 11.04.17.
//  Copyright © 2017 Kirill Solovyov. All rights reserved.
//
#import <CoreData/CoreData.h>
#import "SKNotificationDateDataManager.h"
#import "SKNotificationDate+CoreDataClass.h"
#import "SKUser+CoreDataClass.h"
#import "SKCoreDataManager.h"

@interface SKNotificationDateDataManager()

@property(strong, nonatomic) NSManagedObjectContext *moc;

@end

@implementation SKNotificationDateDataManager

+ (SKNotificationDateDataManager *) sharedManager {
    
    static SKNotificationDateDataManager *manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[SKNotificationDateDataManager alloc] init];
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

- (SKNotificationDate *) createWithFireDate:(NSDate *) fireDate warningDate:(NSDate *) warningDate andUser:(SKUser *) user{
    
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
