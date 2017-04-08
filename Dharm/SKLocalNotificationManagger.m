//
//  SKLocalNotificationManagger.m
//  Dharm
//
//  Created by Кирилл on 02.04.17.
//  Copyright © 2017 Kirill Solovov. All rights reserved.
//

#import "SKLocalNotificationManagger.h"
#import <UIKit/UIKit.h>

@implementation SKLocalNotificationManagger

+ (SKLocalNotificationManagger *) sharedManager {
    
    static SKLocalNotificationManagger *sharedManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
    sharedManager = [[SKLocalNotificationManagger alloc] init];
    });
    
    return sharedManager;
}

- (void) setLocalNotificationsForFireDates:(NSArray<NSDate *> *) dates {
    
    for (int i = 0; i < [dates count] ; i++) {
        
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        
        localNotification.fireDate = [dates objectAtIndex:i];
        localNotification.alertBody = @"Пора спасть мир!!!";
        localNotification.alertTitle = [NSString stringWithFormat:@"Notification # %d",i];
        localNotification.timeZone = [NSTimeZone defaultTimeZone];
        
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    }
}

@end
