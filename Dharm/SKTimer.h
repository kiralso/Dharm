//
//  SKTimer.h
//  Dharm
//
//  Created by Кирилл on 02.04.17.
//  Copyright © 2017 Kirill Solovov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SKTimer : NSObject

extern NSString* const SKTimerTimerTextChangedNotification;
extern NSString* const SKTimerTimerTextUserInfoKey;

@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) NSDateComponents *timerComponents;

- (instancetype)initWithStartInSeconds:(NSTimeInterval)start withEnd:(NSTimeInterval) end andInterval:(NSTimeInterval) interval;
- (void) startTimer;
- (void) timerDidFinish;
- (void) resetTimer;

@end
