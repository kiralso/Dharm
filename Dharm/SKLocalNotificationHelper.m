//
//  SKLocalNotificationHelper.m
//  Dharm
//
//  Created by Kirill Solovyov on 03.10.17.
//  Copyright © 2017 Kirill Solovyov. All rights reserved.
//

#import "SKLocalNotificationHelper.h"
#import "SKUserDataManager.h"
#import "SKUtils.h"
#import "SKDateGenerator.h"
#import "UIApplication+SKNotificationManager.h"
#import "SKNotificationDate.h"

typedef enum : NSUInteger {
    SKWarningLocalNotification,
    SKFailLocalNotification,
} SKLocalNotification;

@interface SKLocalNotificationHelper()

@property (strong, nonatomic) SKDateGenerator *dateGenerator;

@end

@implementation SKLocalNotificationHelper

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.dateGenerator = [[SKDateGenerator alloc] init];
    }
    return self;
}

- (void)updateNotificationDatesWithCompletion:(void(^)(NSArray<NSDate *> *))handler {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *datesArray = nil;
    BOOL isHardcore = [defaults boolForKey:kDifficultySwitchKey];
    
    if (isHardcore) {
        datesArray = [self.dateGenerator fireDatesSinceNow];
    } else {
        NSDate *startDate = [defaults valueForKey:kDateFromPickerKey];
        NSDate *endDate = [defaults valueForKey:kDateToPickerKey];
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
