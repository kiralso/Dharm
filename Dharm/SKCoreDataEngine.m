//
//  SKCoreDataEngine.m
//  Dharm
//
//  Created by Кирилл on 08.04.17.
//  Copyright © 2017 Kirill Solovyov. All rights reserved.
//

#import "SKCoreDataEngine.h"
#import "SKCoreDataManager.h"
#import "SKUser+CoreDataClass.h"
#import "SKNotificationDate+CoreDataClass.h"
#import <CoreData/CoreData.h>

@interface SKCoreDataEngine()

@property(strong, nonatomic) NSManagedObjectContext *moc;

@end

@implementation SKCoreDataEngine

+ (SKCoreDataEngine *) sharedInstance {
    
    static SKCoreDataEngine *manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[SKCoreDataEngine alloc] init];
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

- (BOOL) updateUserWithScore:(NSInteger) score {
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"SKUser"];
    
    NSArray* array = [self.moc executeFetchRequest:request
                                             error:nil];
    
    SKUser *user = [array firstObject];
    
    user.score = score;
    
    NSError *error = nil;
    if (![self.moc save:&error]) {
        abort();
    }
    
    return YES;
}

- (void) createUser {
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"SKUser"];
    
    NSArray* array = [self.moc executeFetchRequest:request
                                             error:nil];
    
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"SKUser"
                                                         inManagedObjectContext:self.moc];
    
    if (!array || [array count] < 1) {
        SKUser *user = [[SKUser alloc] initWithEntity:entityDescription
                       insertIntoManagedObjectContext:self.moc];
        
        user.score = 0;
    }
    
}

@end
