//
//  UIApplication+SKNotificationManager.m
//  Dharm
//
//  Created by Кирилл on 10.04.17.
//  Copyright © 2017 Kirill Solovyov. All rights reserved.
//

#import "UIApplication+SKNotificationManager.h"

@implementation UIApplication (SKNotificationManager)

- (void) setLocalNotificationsForFireDates:(NSArray<NSDate *> *) dates title:(NSString *) title andAllertBody:(NSString *) body {
        
    for (int i = 0; i < [dates count] ; i++) {
        
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        
        localNotification.fireDate = [dates objectAtIndex:i];
        localNotification.alertBody = body;
        localNotification.alertTitle = title;
        localNotification.timeZone = [NSTimeZone defaultTimeZone];
        localNotification.soundName = UILocalNotificationDefaultSoundName;
        
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    }
}

@end
