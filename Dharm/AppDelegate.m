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
    
    [[SKMainObserver sharedObserver] checkScore];
    
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [[SKCoreDataManager sharedManager] saveContext];
}

@end
