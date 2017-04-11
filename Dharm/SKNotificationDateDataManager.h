//
//  SKNotificationDateDataManager.h
//  Dharm
//
//  Created by Кирилл on 11.04.17.
//  Copyright © 2017 Kirill Solovyov. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SKNotificationDate;
@class SKUser;

@interface SKNotificationDateDataManager : NSObject

+ (SKNotificationDateDataManager *) sharedManager;

- (SKNotificationDate *) createWithFireDate:(NSDate *) fireDate warningDate:(NSDate *) warningDate andUser:(SKUser *) user;

@end
