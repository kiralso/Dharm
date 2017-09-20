//
//  SKUserDataManager.h
//  Dharm
//
//  Created by Кирилл on 09.04.17.
//  Copyright © 2017 Kirill Solovyov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKUser.h"

@class SKUser;
@class SKNotificationDate;

@interface SKUserDataManager : NSObject

@property(strong, nonatomic) SKUser *user;

+ (SKUserDataManager *) sharedManager;

- (SKUser *) loadUser;
- (void) saveUser;
- (void) resetUser;

//score
- (void) updateUserWithScore:(NSInteger)score;

//notification dates
- (void) updateUserWithNotificationDateArray:(NSArray *)array;
- (NSArray *)fireDates;
- (SKNotificationDate *)notificationDateWithFireDate:(NSDate *)fireDate warningDate:(NSDate *)warningDate;

@end
