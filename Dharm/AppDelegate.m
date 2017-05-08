//
//  AppDelegate.m
//  Dharm
//
//  Created by Кирилл on 01.04.17.
//  Copyright © 2017 Kirill Solovov. All rights reserved.
//

#import "AppDelegate.h"
#import "SKCoreDataManager.h"
#import "SKMainObserver.h"
#import "SKUtils.h"
#import "SKUserDataManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge | UIUserNotificationTypeAlert categories:nil]];
        
    [[SKUserDataManager sharedManager] createUser];
    
    NSSet *fireDates = [[SKUserDataManager sharedManager] fireDates];
    
    BOOL recountDates = YES;
    
    if ([fireDates count] != 0) {
        
        NSMutableSet *datesAfterNow = [NSMutableSet set];
        
        NSDate *currentDate = [NSDate date];
        
        NSComparisonResult result;
        
        for (NSDate *date in fireDates) {
            result = [currentDate compare:date];
            
            if(result == NSOrderedAscending) {
                [datesAfterNow addObject:date];
            } else {
                [[SKUserDataManager sharedManager] updateUserWithScore:0];
            }
        }
        
        if ([datesAfterNow count] > 0) {
            recountDates = NO;
        }
    }
    
    if (recountDates) {
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kDifficultySwitchKey];

        [[SKMainObserver sharedObserver] updateNotificationDates];
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    [[SKCoreDataManager sharedManager] saveContext];
}

@end
