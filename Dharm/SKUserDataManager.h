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

@property (assign, nonatomic) NSInteger userScore;
@property (assign, nonatomic) NSInteger userMaxScore;
@property (strong, nonatomic) NSArray *userNotificationDates;
@property (strong, nonatomic) NSArray *userPagesIndexesArray;
@property (strong, nonatomic) NSSet *userAnsweredPages;
@property (assign, nonatomic) BOOL isGameOver;

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

//story pages
- (void) updatePagesIndexesWithNewIndex:(NSInteger)index;
- (void) updatePagesIndexesWithNextIndex;
- (void) updatePagesIndexesWithNextIndexAndAnswer:(BOOL) yesNo;

@end
