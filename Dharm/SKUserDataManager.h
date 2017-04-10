//
//  SKUserDataManager.h
//  Dharm
//
//  Created by Кирилл on 09.04.17.
//  Copyright © 2017 Kirill Solovyov. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SKUser;

@interface SKUserDataManager : NSObject

+ (SKUserDataManager *) sharedInstance;

- (void) createUser;
- (SKUser *) user;
- (void) updateUserWithScore:(NSInteger) score;
- (void) updateUserWithNotificationDateArray:(NSArray *)array;

@end
