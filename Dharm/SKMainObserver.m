//
//  SKMainObserver.m
//  Dharm
//
//  Created by Кирилл on 10.04.17.
//  Copyright © 2017 Kirill Solovyov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKUserDataManager.h"
#import "SKNotificationDateDataManager.h"
#import "SKNotificationDate+CoreDataClass.h"
#import "SKUser+CoreDataClass.h"
#import "SKMainObserver.h"
#import "SKConstants.h"
#import "SKDateGenerator.h"
#import "UIApplication+SKNotificationManager.h"
#import "SKSettingsViewController.h"
#import "SKCodeCell.h"

NSString* const SKMainObserverReloadViewControlerNotification = @"SKMainObserverReloadViewControlerNotification";

@implementation SKMainObserver

+ (SKMainObserver *) sharedObserver {
    
    static SKMainObserver *manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[SKMainObserver alloc] init];
    });
    
    return manager;
}

#pragma mark - KVO

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString:kDateToPickerKey] ||
        [keyPath isEqualToString:kDateFromPickerKey] ||
        [keyPath isEqualToString:kDifficultySwitchKey]) {
    
        [self updateDataWithScore:0];
    }
}

#pragma mark - Useful Methods

- (void) codeDidEntered {
    
    NSInteger newScore = [[SKUserDataManager sharedManager] user].score + 1;
    
    [self updateDataWithScore:newScore];
}

- (void) updateDataWithScore:(NSInteger)score {
    
    [[SKUserDataManager sharedManager] updateUserWithScore:score];
    
    [self updateNotificationDates];
        
    [[NSNotificationCenter defaultCenter] postNotificationName:SKMainObserverReloadViewControlerNotification
                                                        object:nil];
}

- (NSTimeInterval) timeIntervalBeforeNextFireDate {
    
    NSSet *fireDates = [[SKUserDataManager sharedManager] fireDates];
    
    SKDateGenerator *generator = [[SKDateGenerator alloc] init];
    
    NSDate *closeFiredate = [generator firstFireDateSinceNowFromSet:fireDates];
    
    NSDateComponents *startRangeComponents =[[NSCalendar currentCalendar] components:NSCalendarUnitSecond
                                                                            fromDate:[NSDate date]
                                                                              toDate:closeFiredate
                                                                             options:0];
    
    return (NSTimeInterval) startRangeComponents.second;
}

- (void) updateNotificationDates {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSArray *datesArray = nil;
    
    SKDateGenerator *generator = [[SKDateGenerator alloc] init];
    
    BOOL isHardcore = [defaults boolForKey:kDifficultySwitchKey];
    
    if (isHardcore) {
        
        datesArray = [generator fireDatesSinceNow];
        
        [self localNotificationsAndSaveDatesArray:datesArray withDateGenerator:generator];
        
    } else {
        
        NSDate *startDate = [defaults valueForKey:kDateFromPickerKey];
        NSDate *endDate = [defaults valueForKey:kDateToPickerKey];
        
        datesArray = [self datesArrayBetweenStartDate:startDate
                                           andEndDate:endDate
                                    withDateGenerator:generator];
        
        [self localNotificationsAndSaveDatesArray:datesArray withDateGenerator:generator];
    }
}

- (NSArray<SKNotificationDate *> *) localWarningAndFailNotificationsForDates: (NSArray <NSDate *> *) dates andDatesGenerator:(SKDateGenerator *) generator {
        
    NSArray *warningDatesArray = [generator warningDatesWithArray:dates];
    
    [[UIApplication sharedApplication] setLocalNotificationsForFireDates:dates
                                                                   title:kAlertTitle
                                                           andAllertBody:kAlertBody];
    
    [[UIApplication sharedApplication] setLocalNotificationsForFireDates:warningDatesArray
                                                                   title:kWarningTitle
                                                           andAllertBody:kWarningBody];
    
    NSMutableArray *notificationsArray = [NSMutableArray array];
    SKUser *user = [[SKUserDataManager sharedManager] user];
    
    for (int i = 0; i < [dates count]; i++) {
        SKNotificationDate * nd =
        [[SKNotificationDateDataManager sharedManager] createWithFireDate:dates[i]
                                                              warningDate:warningDatesArray[i]
                                                                  andUser:user];
        
        [notificationsArray addObject:nd];
    }
    return notificationsArray;
}

- (NSArray<NSDate *> *) datesArrayBetweenDatePickersOnViewController:(SKSettingsViewController *) vc withDateGenerator:(SKDateGenerator *) generator {
    
    NSDate *startDate = vc.dateFromPicker.date;
    NSDate *endDate = vc.dateToPicker.date;
    
    NSArray *datesArray = [self datesArrayBetweenStartDate:startDate
                                                andEndDate:endDate
                                         withDateGenerator:generator];
    
    return datesArray;
}

- (NSArray<NSDate *> *) datesArrayBetweenStartDate:(NSDate *)startDate andEndDate:(NSDate *)endDate withDateGenerator:(SKDateGenerator *) generator {
    
    NSDate *dateTo = endDate;
    
    NSDateComponents *componentsTo =[[NSCalendar currentCalendar]
                                     components:NSCalendarUnitHour | NSCalendarUnitMinute
                                     fromDate:dateTo];
    
    NSDate *dateFrom = startDate;
    
    NSDateComponents *componentsFrom =[[NSCalendar currentCalendar]
                                       components:NSCalendarUnitHour | NSCalendarUnitMinute
                                       fromDate:dateFrom];
    
    NSArray *datesArray = [generator fireDatesWithHoursAndMinutesBetweenComponents:componentsFrom andComponents:componentsTo];
    
    return datesArray;
}

- (void) localNotificationsAndSaveDatesArray:(NSArray <NSDate *> *) datesArray withDateGenerator:(SKDateGenerator *) generator {
    
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    NSArray *notificationsArray = [self localWarningAndFailNotificationsForDates:datesArray
                                                               andDatesGenerator:generator];
    
    [[SKUserDataManager sharedManager] updateUserWithNotificationDateArray:notificationsArray];
}

@end
