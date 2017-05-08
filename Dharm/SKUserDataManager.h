//
//  SKUserDataManager.h
//  Dharm
//
//  Created by Кирилл on 09.04.17.
//  Copyright © 2017 Kirill Solovyov. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SKUser;
@class SKNotificationDate;

@interface SKUserDataManager : NSObject

+ (SKUserDataManager *) sharedManager;

- (void) createUser;
- (SKUser *) user;
- (void) updateUserWithScore:(NSInteger) score;
- (void) updateUserWithNotificationDateArray:(NSArray *)array;
- (NSSet *) fireDates;
- (SKNotificationDate *) notificationDateWithFireDate:(NSDate *) fireDate warningDate:(NSDate *) warningDate andUser:(SKUser *) user;

@end
