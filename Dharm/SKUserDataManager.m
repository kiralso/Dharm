//
//  SKUserDataManager.m
//  Dharm
//
//  Created by Кирилл on 09.04.17.
//  Copyright © 2017 Kirill Solovyov. All rights reserved.
//

#import "SKUserDataManager.h"
#import "SKUser.h"
#import "SKNotificationDate.h"

static NSString *const kUserKey = @"SKUser";

@interface SKUserDataManager()

@property (strong, nonatomic) NSUserDefaults *defaults;

@property(strong, nonatomic) SKUser *user;

@end

@implementation SKUserDataManager

+ (SKUserDataManager *) sharedManager {
    
    static SKUserDataManager *manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[SKUserDataManager alloc] init];
    });
    
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.defaults = [NSUserDefaults standardUserDefaults];
        self.user = [self loadUser];
    }
    return self;
}
#pragma mark - User

- (SKUser *) loadUser {
    
    NSData *storedUser = [self.defaults objectForKey:kUserKey];
    SKUser *user = nil;
    
    if (storedUser) {
        user = [NSKeyedUnarchiver unarchiveObjectWithData:storedUser];
    } else {
        user = [[SKUser alloc] init];
        user.notificationDatesArray = [NSArray array];
        user.answeredPages = [NSSet set];
        user.pagesIndexesArray = @[@0, @1, @2, @3, @4, @5];
        user.isGameOver = NO;
    }
    
    self.userScore = user.score;
    self.userMaxScore = user.maxScore;
    self.userNotificationDates = user.notificationDatesArray;
    self.userPagesIndexesArray = user.pagesIndexesArray;
    self.userAnsweredPages = user.answeredPages;
    self.isGameOver = user.isGameOver;
    
    return user;
}

- (void) saveUser {
    
    if (self.user) {
        
        self.userScore = self.user.score;
        self.userMaxScore = self.user.maxScore;
        self.userNotificationDates = self.user.notificationDatesArray;
        self.userPagesIndexesArray = self.user.pagesIndexesArray;
        self.userAnsweredPages = self.user.answeredPages;
        self.isGameOver = self.user.isGameOver;
        
        NSData *encodedUser = [NSKeyedArchiver archivedDataWithRootObject:self.user];
        [self.defaults setObject:encodedUser forKey:kUserKey];
        [self.defaults synchronize];
    }
}

- (void) resetUser {
    
    self.user.score = 0;
    self.user.maxScore = 0;
    self.user.pagesIndexesArray = @[@0, @1, @2, @3, @4, @5];
    self.user.answeredPages = [NSSet set];
    self.user.isGameOver = NO;
    
    [self saveUser];
}

#pragma mark - Score

- (void) updateUserWithScore:(NSInteger) score {
    
    if (self.user.maxScore < score) {
        self.user.maxScore = score;
    }
    
    self.user.score = score;
    
    [self saveUser];
}

#pragma mark - Notification Dates

- (void) updateUserWithNotificationDateArray:(NSArray<SKNotificationDate *> *)array {
    
    self.user.notificationDatesArray = array;
    [self saveUser];
}

- (NSArray *) fireDates {
    
    NSMutableArray *fireDatesArray = [NSMutableArray array];
    
    for (SKNotificationDate *date in self.user.notificationDatesArray) {
        [fireDatesArray addObject:date.fireDate];
    }

    return fireDatesArray;
}

- (SKNotificationDate *) notificationDateWithFireDate:(NSDate *) fireDate
                                          warningDate:(NSDate *) warningDate {
    
    NSMutableArray *datesArray = [NSMutableArray arrayWithArray:self.user.notificationDatesArray];
    
    SKNotificationDate *notificationDate = [[SKNotificationDate alloc] initWithFireDate:fireDate
                                                                            warningDate:warningDate];
    
    [datesArray addObject:notificationDate];
    
    self.user.notificationDatesArray = datesArray;
    
    [self saveUser];
    
    return notificationDate;
}

#pragma mark - Story Pages

- (void) updatePagesIndexesWithNewIndex:(NSInteger)index {
    
    NSMutableArray *indexes = [NSMutableArray arrayWithArray:self.user.pagesIndexesArray];
    NSNumber *newIndex = @(index);
    
    [indexes addObject:newIndex];
    
    self.user.pagesIndexesArray = indexes;
    
    [self saveUser];
}

- (void) updatePagesIndexesWithNextIndex {
    
    NSMutableArray *indexes = [NSMutableArray arrayWithArray:self.user.pagesIndexesArray];
    NSInteger lastIndex = [[indexes lastObject] integerValue];
    NSNumber *nextIndex = nil;

    switch (lastIndex) {
        case 9:
            nextIndex = @(13);
            break;
        case 19:
            nextIndex = @(23);
            break;
        case 20:
            nextIndex = @(23);
            break;
        case 24: // last possible page + 1
            self.user.isGameOver = YES;
            return;
        default:
            nextIndex = @(lastIndex + 1);
            break;
    }
    
    [indexes addObject:nextIndex];
    
    self.user.pagesIndexesArray = indexes;
    
    [self saveUser];
}

- (void) updatePagesIndexesWithNextIndexAndAnswer:(BOOL) yesNo {
    
    NSMutableArray *pagesIndexes = [NSMutableArray arrayWithArray:self.user.pagesIndexesArray];
    NSMutableSet *answeredPages = [NSMutableSet setWithSet:self.user.answeredPages];
    
    NSArray *tmpArray = [pagesIndexes subarrayWithRange:NSMakeRange(0, [pagesIndexes count] - 1)];
    NSMutableArray *subIndexes = [NSMutableArray arrayWithArray:tmpArray];

    NSInteger lastIndex = [[subIndexes lastObject] integerValue];
    NSInteger nextIndex = 0;

    switch (lastIndex) {
        case 5:
            if (yesNo) { //Stay in bunker
                nextIndex = 6;
            } else {
                nextIndex = 10;
            }
            break;
        case 13:
            if (yesNo) { //Save Desmond
                nextIndex = 14;
            } else {
                nextIndex = 21;
            }
            break;
        case 17:
            if (yesNo) { //Drink or not
                nextIndex = 18;
            } else {
                nextIndex = 20;
            }
            break;
            
        default:
            nextIndex = lastIndex + 1;
            break;
    }
    
    [answeredPages addObject:@(lastIndex)];
    [subIndexes addObject:@(nextIndex)];
    
    self.user.pagesIndexesArray = subIndexes;
    self.user.answeredPages = answeredPages;
    
    [self saveUser];
}
@end
