//
//  SKDateGenerator.m
//  Dharm
//
//  Created by Кирилл on 05.04.17.
//  Copyright © 2017 Kirill Solovov. All rights reserved.
//

#import "SKDateGenerator.h"
#import "SKConstants.h"

@implementation SKDateGenerator

#pragma mark - fire dates

- (NSArray<NSDate *> *) fireDatesSinceNow {
    
    NSMutableArray *dates = [NSMutableArray array];
    
    for (int i = 1; i <= kNumberOfDatesToGenerate; i++) {
        
        NSDate *date= [NSDate dateWithTimeIntervalSinceNow:kMinutesYoSaveTheWorld * 60 * i];

        date = [self localDateFromGMTDate:date];
        
        [dates addObject:date];
    }
    
    NSArray * datesArray = [NSArray arrayWithArray:dates];
    
    return datesArray;
}

- (NSDate *) firstFireDateSinceNowFromSet:(NSSet *) set {
    
    NSDate * fireDate = nil;
    
    NSDateComponents *startRangeComponents =[[NSCalendar currentCalendar] components:NSCalendarUnitSecond
                                                                            fromDate:[NSDate date]
                                                                              toDate:[set anyObject]
                                                                             options:0];
    NSInteger startRange = startRangeComponents.second;
    
    for (NSDate *date in set) {
        
        NSDateComponents *components =[[NSCalendar currentCalendar] components:NSCalendarUnitSecond
                                                                      fromDate:[NSDate date]
                                                                        toDate:date
                                                                       options:0];
        
        if (components.second < startRange && components.second > 0) {
            startRange = components.second;
            fireDate = date;
        }
    }
    
    return fireDate;
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
        
        date = [self localDateFromGMTDate:date];
        
        BOOL isStartHoursAreEqual = startComponents.hour == components.hour;
        BOOL isEndHoursAreEqual = endComponents.hour == components.hour;
        BOOL isHourGood = NO;
        
        if (startComponents.hour > endComponents.hour) {
            
            BOOL isGoodBeforeMidnight = components.hour < 24 && components.hour > startComponents.hour;
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
        
        NSDate *date= [[NSCalendar currentCalendar] dateByAddingUnit:NSCalendarUnitMinute
                                                               value:-kMinutesBeforeFireDateToWarn
                                                              toDate:dateFromArray
                                                             options:0];
        
        [dates addObject:date];
    }
    
    NSArray * datesArray = [NSArray arrayWithArray:dates];
    
    return datesArray;
}

#pragma mark - Local date

-(NSDate *) localDateFromGMTDate:(NSDate *) date {
    NSTimeZone *tz = [NSTimeZone defaultTimeZone];
    NSInteger seconds = [tz secondsFromGMTForDate: date];
    return [NSDate dateWithTimeInterval: seconds sinceDate: date];
}

@end

