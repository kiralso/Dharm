//
//  SKTimer.m
//  Dharm
//
//  Created by Кирилл on 02.04.17.
//  Copyright © 2017 Kirill Solovov. All rights reserved.
//

#import "SKTimer.h"

@interface SKTimer ()

@property (assign, nonatomic) NSTimeInterval timerEndInSeconds;
@property (assign, nonatomic) NSTimeInterval timerIntervalInSeconds;
@property (assign, nonatomic) NSTimeInterval timerStartInSeconds;

@end

NSString* const SKTimerTimerTextChangedNotification = @"SKTimerTimerTextChangedNotification";
NSString* const SKTimerTimerTextUserInfoKey = @"SKTimerTimerTextUserInfoKey";

@implementation SKTimer

- (instancetype)initWithStartInSeconds:(NSTimeInterval)start withEnd:(NSTimeInterval) end andInterval:(NSTimeInterval) interval {
    
    self = [super init];
    
    if (self) {
        _timer = [[NSTimer alloc] init];
        _timerStartInSeconds = start;
        _timerEndInSeconds = end;
        _timerIntervalInSeconds = interval;
    }
    return self;
}

- (void) startTimer {
    
    if (!self.timer.valid) { //prevent more than one timer on the thread
        
        self.timerComponents = [self dateComponentsFromTimeInterval:self.timerStartInSeconds];
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:self.timerIntervalInSeconds
                                                      target:self
                                                    selector:@selector(timerDidFinish)
                                                    userInfo:nil
                                                     repeats:YES];
    }
}

- (void) timerDidFinish {
    
    self.timerStartInSeconds = self.timerStartInSeconds - self.timerIntervalInSeconds;
    
    if (self.timerStartInSeconds <= 0) {
        [self.timer invalidate];
    }
    
    self.timerComponents = [self dateComponentsFromTimeInterval:self.timerStartInSeconds];
}

- (void) resetTimer {
    
    [self.timer invalidate];
    
    self.timerStartInSeconds = self.timerEndInSeconds;
    
    self.timerComponents = [self dateComponentsFromTimeInterval:self.timerStartInSeconds];
}

- (void) setTimerComponents:(NSDateComponents *)timerComponents {
    
    _timerComponents = timerComponents;
    
    NSDictionary *dictionary = [NSDictionary dictionaryWithObject:timerComponents
                                                           forKey:SKTimerTimerTextUserInfoKey];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:SKTimerTimerTextChangedNotification
                                                        object:nil
                                                      userInfo:dictionary];
}

#pragma mark - Time Filter

- (NSDateComponents *) dateComponentsFromTimeInterval:(NSTimeInterval) time {
    
    int minutes = time/60;
    int seconds = time - (double)minutes * 60;
    
    NSDateComponents *components = [[NSDateComponents alloc] init];
    
    components.minute = minutes;
    components.second = seconds;
    
    return components;
}

@end
