//
//  SKDateGenerator.h
//  Dharm
//
//  Created by Кирилл on 05.04.17.
//  Copyright © 2017 Kirill Solovov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SKDateGenerator : NSObject

- (NSDate *)localDateFromGMTDate:(NSDate *)date;
- (NSArray<NSDate *> *)fireDatesSinceNow;
- (NSDate *) firstFireDateSinceNowFromArray:(NSArray *)datesArray;
- (NSArray<NSDate *> *)warningDatesWithArray:(NSArray<NSDate *> *) array;
- (NSArray<NSDate *> *)fireDatesWithHoursAndMinutesBetweenComponents:(NSDateComponents *)startComponents andComponents:(NSDateComponents *)endComponents;
- (NSArray<NSDate *> *)datesArrayBetweenStartDate:(NSDate *)startDate andEndDate:(NSDate *)endDate;

@end
