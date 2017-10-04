//
//  SKLocalNotificationHelper.h
//  Dharm
//
//  Created by Kirill Solovyov on 03.10.17.
//  Copyright © 2017 Kirill Solovyov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SKLocalNotificationHelper: NSObject

- (void)updateNotificationDatesWithCompletion:(void(^)(NSArray<NSDate *> *))handler;

@end
