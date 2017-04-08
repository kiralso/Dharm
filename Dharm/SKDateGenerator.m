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
    
    for (int i = 0; i < kNumberOfDatesToGenerate; i++) {
        
        NSDate *date= [[NSCalendar currentCalendar] dateByAddingUnit:NSCalendarUnitMinute
                                                               value:kMinutesYoSaveTheWorld * i
                                                              toDate:[NSDate date]
                                                             options:0];
        
        [dates addObject:date];
    }
    
    NSArray * datesArray = [NSArray arrayWithArray:dates];
    
    return datesArray;
}

- (NSDate *) firstFireDateSinceNowFromSet:(NSSet *) set {
    
    NSDate * fireDate = [[NSDate alloc] init];
    
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
        
        if (components.second < startRange) {
            startRange = components.second;
            fireDate = date;
        }
    }
    
    return fireDate;
}

#pragma mark - warning dates

- (NSArray<NSDate *> *) warningDatesWithArray:(NSArray<NSDate *> *) array {
    
    NSMutableArray *dates = [NSMutableArray array];
    
    for (NSDate *dateFromArray in array) {
        
        NSDate *date= [[NSCalendar currentCalendar] dateByAddingUnit:NSCalendarUnitMinute
                                                               value:-4
                                                              toDate:dateFromArray
                                                             options:0];
        
        [dates addObject:date];
    }
    
    NSArray * datesArray = [NSArray arrayWithArray:dates];
    
    return datesArray;
}


@end
