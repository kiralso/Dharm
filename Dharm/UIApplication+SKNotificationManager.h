//
//  UIApplication+SKNotificationManager.h
//  Dharm
//
//  Created by Кирилл on 10.04.17.
//  Copyright © 2017 Kirill Solovyov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIApplication (SKNotificationManager)

- (void)scheduleLocalNotificationsForFireDates:(NSArray<NSDate *> *) dates title:(NSString *) title andAllertBody:(NSString *) body;

@end
