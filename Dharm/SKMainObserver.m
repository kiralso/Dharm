//
//  SKMainObserver.m
//  Dharm
//
//  Created by Кирилл on 10.04.17.
//  Copyright © 2017 Kirill Solovyov. All rights reserved.
//

#import "SKMainObserver.h"
#import "SKUserDataManager.h"
#import "SKUtils.h"
#import "SKDateGenerator.h"
#import "UIApplication+SKNotificationManager.h"
#import "SKSettingsViewController.h"
#import "SKCodeCell.h"
#import "SKGameKitHelper.h"

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

#pragma mark - Useful Methods

- (void) updateDataWithScore:(NSInteger)score {
    
    [[SKUserDataManager sharedManager] updateUserWithScore:score];
    
    [self updateData];
}

- (void) updateData {
    
    [self updateNotificationDates];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:SKMainObserverReloadViewControlerNotification
                                                        object:nil];
}

- (NSTimeInterval) timeIntervalBeforeNextFireDate {
    
    NSArray *fireDates = [[SKUserDataManager sharedManager] fireDates];
    
    SKDateGenerator *generator = [[SKDateGenerator alloc] init];
    
    NSDate *closeFiredate = [generator firstFireDateSinceNowFromArray:fireDates];
    
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
        
        datesArray = [generator datesArrayBetweenStartDate:startDate
                                           andEndDate:endDate];
        
        [self localNotificationsAndSaveDatesArray:datesArray withDateGenerator:generator];
    }
}

- (NSArray<SKNotificationDate *> *) localWarningAndFailNotificationsForDates: (NSArray <NSDate *> *) dates andDatesGenerator:(SKDateGenerator *) generator {
        
    NSArray *warningDatesArray = [generator warningDatesWithArray:dates];
    
    NSString *alertTitle = NSLocalizedString(@"SORRY", nil);
    NSString *alertBody = NSLocalizedString(@"SHAME", nil);
    NSString *warningTitle = NSLocalizedString(@"SAVETHEWORLD", nil);
    NSString *warningBody = NSLocalizedString(@"ROCKIE", nil);
    
    [[UIApplication sharedApplication] setLocalNotificationsForFireDates:dates
                                                                   title:alertTitle
                                                           andAllertBody:alertBody];
    
    [[UIApplication sharedApplication] setLocalNotificationsForFireDates:warningDatesArray
                                                                   title:warningTitle
                                                           andAllertBody:warningBody];
    
    NSMutableArray *notificationsArray = [NSMutableArray array];
    
    for (int i = 0; i < [dates count]; i++) {
        SKNotificationDate * nd =
        [[SKUserDataManager sharedManager] notificationDateWithFireDate:dates[i]
                                                            warningDate:warningDatesArray[i]];
        
        [notificationsArray addObject:nd];
    }
    return notificationsArray;
}

- (NSArray<NSDate *> *) datesArrayBetweenDatePickersOnViewController:(SKSettingsViewController *) vc withDateGenerator:(SKDateGenerator *) generator {
    
    NSDate *startDate = vc.dateFromPicker.date;
    NSDate *endDate = vc.dateToPicker.date;
    
    NSArray *datesArray = [generator datesArrayBetweenStartDate:startDate
                                                andEndDate:endDate];
    
    return datesArray;
}

- (void) localNotificationsAndSaveDatesArray:(NSArray <NSDate *> *) datesArray withDateGenerator:(SKDateGenerator *) generator {
    
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    NSArray *notificationsArray = [self localWarningAndFailNotificationsForDates:datesArray
                                                               andDatesGenerator:generator];
    
    [[SKUserDataManager sharedManager] updateUserWithNotificationDateArray:notificationsArray];
}

@end
