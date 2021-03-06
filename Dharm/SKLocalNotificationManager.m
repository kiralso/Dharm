//
//  SKLocalNotificationManager.m
//  Dharm
//
//  Created by Kirill Solovyov on 03.10.17.
//  Copyright © 2017 Kirill Solovyov. All rights reserved.
//

#import "SKLocalNotificationManager.h"
#import "SKSettingsManager.h"
#import "SKUserDataManager.h"
#import "SKUtils.h"
#import "SKDateGenerator.h"
#import "UIApplication+SKNotificationManager.h"
#import "SKNotificationDate.h"

typedef NS_ENUM(NSUInteger, SKLocalNotification) {
    SKWarningLocalNotification,
    SKFailLocalNotification,
};

@interface SKLocalNotificationManager()

@property (strong, nonatomic) SKDateGenerator *dateGenerator;

@end

@implementation SKLocalNotificationManager

- (instancetype)init {
    self = [super init];
    if (self) {
        self.dateGenerator = [[SKDateGenerator alloc] init];
    }
    return self;
}

- (void)updateNotificationDatesWithCompletion:(void(^)(NSArray<NSDate *> *))handler {
    SKSettingsManager *settingsManager = [SKSettingsManager sharedManager];
    NSArray *datesArray;
    BOOL isHardcore = [settingsManager difficulty];
    if (isHardcore) {
        datesArray = [self.dateGenerator fireDatesSinceNow];
    } else {
        NSDate *startDate = [settingsManager fromDate];
        NSDate *endDate = [settingsManager toDate];
        datesArray = [self.dateGenerator datesArrayBetweenStartDate:startDate
                                                         andEndDate:endDate];
    }
    [self localNotificationsAndSaveDatesArray:datesArray];
    if (handler) {
        handler(datesArray);
    }
}

#pragma mark - Private Methods

- (void)scheduleLocalNotificationsForDates:(NSArray<NSDate *> *)dates withType:(SKLocalNotification)type {
    NSString *title = nil;
    NSString *body = nil;
    switch (type) {
        case SKWarningLocalNotification:
            title = NSLocalizedString(@"SAVETHEWORLD", nil);
            body = NSLocalizedString(@"ROCKIE", nil);
            break;
        case SKFailLocalNotification:
            title = NSLocalizedString(@"SORRY", nil);
            body = NSLocalizedString(@"SHAME", nil);
            break;
    }
    [[UIApplication sharedApplication] scheduleLocalNotificationsForFireDates:dates
                                                                        title:title
                                                                andAllertBody:body];
}

- (void)localNotificationsAndSaveDatesArray:(NSArray <NSDate *> *)dates {
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    NSArray *warningDates = [self.dateGenerator warningDatesWithArray:dates];
    [self scheduleLocalNotificationsForDates:dates withType:SKFailLocalNotification];
    [self scheduleLocalNotificationsForDates:warningDates withType:SKWarningLocalNotification];
    NSMutableArray *notificationsArray = [NSMutableArray array];
    for (int i = 0; i < [dates count]; i++) {
        SKNotificationDate * nd = [[SKNotificationDate alloc] initWithFireDate:dates[i]
                                                                   warningDate:warningDates[i]];
        [notificationsArray addObject:nd];
    }
    [[SKUserDataManager sharedManager] updateUserWithNotificationDateArray:notificationsArray];
}


@end
