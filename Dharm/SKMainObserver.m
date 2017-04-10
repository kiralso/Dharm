//
//  SKMainObserver.m
//  Dharm
//
//  Created by Кирилл on 10.04.17.
//  Copyright © 2017 Kirill Solovyov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKUserDataManager.h"
#import "SKMainObserver.h"
#import "SKConstants.h"
#import "SKDateGenerator.h"
#import "UIApplication+SKNotificationManager.h"
#import "SKSettingsViewController.h"

@implementation SKMainObserver

+ (SKMainObserver *) sharedObserver {
    
    static SKMainObserver *manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[SKMainObserver alloc] init];
    });
    
    return manager;
}

#pragma mark - Observe

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    SKDateGenerator *generator = [[SKDateGenerator alloc] init];
    NSArray *datesArray = nil;
    
    if ([keyPath isEqualToString:kDifficultySwitchKey]) {
        
        UISwitch *newSwitch = [change objectForKey:NSKeyValueChangeNewKey];
        
        if (newSwitch.isOn) {
            
            datesArray = [generator fireDatesSinceNow];
            
            [self localNotificationsAndSaveDatesArray:datesArray withDateGenerator:generator];
        } else {
            
            datesArray = [self datesArrayBetweenDatePickersOnViewController:object withDateGenerator:generator];
            
            [self localNotificationsAndSaveDatesArray:datesArray withDateGenerator:generator];
        }
    }
    
    if ([keyPath isEqualToString:kDateToPickerKey] || [keyPath isEqualToString:kDateFromPickerKey]) {
        
        datesArray = [self datesArrayBetweenDatePickersOnViewController:object withDateGenerator:generator];
        
        [self localNotificationsAndSaveDatesArray:datesArray withDateGenerator:generator];
    }
}

#pragma mark - Useful Methods

- (void) localWarningAndFailNotificationsForDates: (NSArray <NSDate *> *) dates andDatesGenerator:(SKDateGenerator *) generator {
        
    NSArray *warningDatesArray = [generator warningDatesWithArray:dates];
    
    [[UIApplication sharedApplication] setLocalNotificationsForFireDates:dates
                                                                   title:kAlertTitle
                                                           andAllertBody:kAlertBody];
    
    [[UIApplication sharedApplication] setLocalNotificationsForFireDates:warningDatesArray
                                                                   title:kWarningTitle
                                                           andAllertBody:kWarningBody];
}

- (NSArray<NSDate *> *) datesArrayBetweenDatePickersOnViewController:(SKSettingsViewController *) vc withDateGenerator:(SKDateGenerator *) generator {
    
    NSDate *dateTo = vc.dateToPicker.date;
    
    NSDateComponents *componentsTo =[[NSCalendar currentCalendar]
                                     components:NSCalendarUnitHour | NSCalendarUnitMinute
                                     fromDate:dateTo];
    
    NSDate *dateFrom = vc.dateFromPicker.date;
    
    NSDateComponents *componentsFrom =[[NSCalendar currentCalendar]
                                       components:NSCalendarUnitHour | NSCalendarUnitMinute
                                       fromDate:dateFrom];
    
    NSArray *datesArray = [generator fireDatesWithHoursAndMinutesBetweenComponents:componentsFrom andComponents:componentsTo];
    
    return datesArray;
}

- (void) localNotificationsAndSaveDatesArray:(NSArray <NSDate *> *) datesArray withDateGenerator:(SKDateGenerator *) generator {
    
    [self localWarningAndFailNotificationsForDates:datesArray
                                 andDatesGenerator:generator];
    
    [[SKUserDataManager sharedInstance] updateUserWithNotificationDateArray:datesArray];
}

@end
