//
//  SKDateGenerator.m
//  Dharm
//
//  Created by Кирилл on 05.04.17.
//  Copyright © 2017 Kirill Solovov. All rights reserved.
//

#import "SKDateGenerator.h"
#import "SKUtils.h"

@implementation SKDateGenerator

#pragma mark - fire dates

- (NSArray<NSDate *> *) fireDatesSinceNow {
    
    NSMutableArray *dates = [NSMutableArray array];
    
    for (int i = 1; i <= kNumberOfDatesToGenerate; i++) {
        
        NSDate *date= [NSDate dateWithTimeIntervalSinceNow:kMinutesYoSaveTheWorld * 60 * i];
        
        [dates addObject:date];
    }
    
    NSArray * datesArray = [NSArray arrayWithArray:dates];
    
    return datesArray;
}

- (NSDate *) firstFireDateSinceNowFromArray:(NSArray *) datesArray {
    
    NSDate * fireDate = nil;
        
    NSDateComponents *startRangeComponents =[[NSCalendar currentCalendar] components:NSCalendarUnitSecond
                                                                            fromDate:[NSDate date]
                                                                              toDate:[datesArray firstObject]
                                                                             options:0];
    NSInteger startRange = ABS(startRangeComponents.second);

    for (NSDate *date in datesArray) {
        
        NSDateComponents *components =[[NSCalendar currentCalendar] components:NSCalendarUnitSecond
                                                                      fromDate:[NSDate date]
                                                                        toDate:date
                                                                       options:0];
        
        if (components.second < startRange && components.second > 0) {
            startRange = components.second;
            fireDate = date;
        }
    }
    
    if (fireDate) {
        return fireDate;
    } else {
        return [datesArray firstObject];
    }    
}

- (NSArray<NSDate *> *) fireDatesWithHoursAndMinutesBetweenComponents:(NSDateComponents *) startComponents andComponents:(NSDateComponents *) endComponents {

    NSMutableArray *dates = [NSMutableArray array];

    int i = 0;
    while ([dates count] < 30) {
        i++;

        NSDate *date= [NSDate dateWithTimeIntervalSinceNow:kMinutesYoSaveTheWorld * 60 * i];
        
        NSDateComponents *components = [[NSCalendar currentCalendar]
                                        components:NSCalendarUnitHour | NSCalendarUnitMinute
                                        fromDate:date];
                
        BOOL isStartHoursAreEqual = startComponents.hour == components.hour;
        BOOL isEndHoursAreEqual = endComponents.hour == components.hour;
        BOOL isHourGood = NO;
        
        if (startComponents.hour > endComponents.hour) {
            
            BOOL isGoodBeforeMidnight = components.hour < 24 && components.hour >= startComponents.hour;
            BOOL isGoodAfterMidnight = components.hour >= 0 && components.hour <= endComponents.hour;

            if (isGoodBeforeMidnight || isGoodAfterMidnight) {
                isHourGood = YES;
            }
        } else {
            isHourGood = startComponents.hour <= components.hour && endComponents.hour >= components.hour;
        }
        
        BOOL isStartMinutesGood = startComponents.minute < components.minute;
        BOOL isEndMinutesGood = endComponents.minute > components.minute;
        
        if (isStartHoursAreEqual) {
            if (isHourGood && isStartMinutesGood) {
                [dates addObject:date];
            }
        } else if (isEndHoursAreEqual) {
            if (isHourGood && isEndMinutesGood) {
                [dates addObject:date];
            }
        } else if (isHourGood) {
                [dates addObject:date];
        }
    }

    return dates;
}

#pragma mark - warning dates

- (NSArray<NSDate *> *) warningDatesWithArray:(NSArray<NSDate *> *) array {
    
    NSMutableArray *dates = [NSMutableArray array];
    for (NSDate *dateFromArray in array) {
        
        NSDate *date= [NSDate dateWithTimeInterval:-kMinutesBeforeFireDateToWarn*60 sinceDate:dateFromArray];

        [dates addObject:date];
    }
    return [NSArray arrayWithArray:dates];;
}

#pragma mark - Local date

-(NSDate *) localDateFromGMTDate:(NSDate *) date {
    
    NSTimeZone *tz = [NSTimeZone defaultTimeZone];
    NSInteger seconds = [tz secondsFromGMTForDate: date];
    return [NSDate dateWithTimeInterval: seconds sinceDate: date];
}

#pragma mark - Other

- (NSArray<NSDate *> *) datesArrayBetweenStartDate:(NSDate *)startDate andEndDate:(NSDate *)endDate {
    
    NSDate *dateTo = endDate;
    NSDateComponents *componentsTo =[[NSCalendar currentCalendar]
                                     components:NSCalendarUnitHour | NSCalendarUnitMinute
                                     fromDate:dateTo];
    
    NSDate *dateFrom = startDate;
    NSDateComponents *componentsFrom =[[NSCalendar currentCalendar]
                                       components:NSCalendarUnitHour | NSCalendarUnitMinute
                                       fromDate:dateFrom];
    
    return [self fireDatesWithHoursAndMinutesBetweenComponents:componentsFrom andComponents:componentsTo];;
}

@end

