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

@end

@implementation SKUserDataManager

+ (SKUserDataManager *)sharedManager {
    static SKUserDataManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[SKUserDataManager alloc] init];
    });
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.defaults = [NSUserDefaults standardUserDefaults];
        self.user = [self loadUser];
    }
    return self;
}

#pragma mark - User

- (SKUser *)loadUser {
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
    return user;
}

- (void)saveUser {
    NSData *encodedUser = [NSKeyedArchiver archivedDataWithRootObject:self.user];
    [self.defaults setObject:encodedUser forKey:kUserKey];
    [self.defaults synchronize];
}

- (void)resetUser {
    self.user.score = 0;
    self.user.maxScore = 0;
    self.user.pagesIndexesArray = @[@0, @1, @2, @3, @4, @5];
    self.user.answeredPages = [NSSet set];
    self.user.isGameOver = NO;
    [self saveUser];
}

#pragma mark - Score

- (void)updateUserWithScore:(NSInteger) score {
    if (self.user.maxScore < score) {
        self.user.maxScore = score;
    }
    self.user.score = score;
    [self saveUser];
}

#pragma mark - Notification Dates

- (void)updateUserWithNotificationDateArray:(NSArray<SKNotificationDate *> *)array {
    self.user.notificationDatesArray = array;
    [self saveUser];
}

- (NSArray *)fireDates {
    NSMutableArray *fireDatesArray = [NSMutableArray array];
    for (SKNotificationDate *date in self.user.notificationDatesArray) {
        [fireDatesArray addObject:date.fireDate];
    }
    return fireDatesArray;
}

- (SKNotificationDate *)notificationDateWithFireDate:(NSDate *)fireDate
                                         warningDate:(NSDate *)warningDate {
    NSMutableArray *datesArray = [NSMutableArray arrayWithArray:self.user.notificationDatesArray];
    SKNotificationDate *notificationDate = [[SKNotificationDate alloc] initWithFireDate:fireDate
                                                                            warningDate:warningDate];
    [datesArray addObject:notificationDate];
    self.user.notificationDatesArray = datesArray;
    [self saveUser];
    return notificationDate;
}

@end
