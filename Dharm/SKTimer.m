//
//  SKTimer.m
//  Dharm
//
//  Created by Кирилл on 02.04.17.
//  Copyright © 2017 Kirill Solovov. All rights reserved.
//

#import "SKTimer.h"
#import <MSWeakTimer.h>


@interface SKTimer ()

@property (assign, nonatomic) NSTimeInterval timerEndInSeconds;
@property (assign, nonatomic) NSTimeInterval timerIntervalInSeconds;
@property (assign, nonatomic) NSTimeInterval timerStartInSeconds;

@end

NSString* const SKTimerTextChangedNotification = @"SKTimerTextChangedNotification";
NSString* const SKTimerTextUserInfoKey = @"SKTimerTextUserInfoKey";

@implementation SKTimer

- (instancetype)initWithStartInSeconds:(NSTimeInterval)start
                               withEnd:(NSTimeInterval)end
                              interval:(NSTimeInterval)interval
                           andDelegate:(id<SKTimerDelegate>)delegate {
    
    self = [super init];
    
    if (self) {
        self.timerStartInSeconds = start;
        self.timerEndInSeconds = end;
        self.timerIntervalInSeconds = interval;
        self.delegate = delegate;
    }
    return self;
}

- (void) startTimer {
    
    NSDateComponents *timerComponents = [self dateComponentsFromTimeInterval:self.timerStartInSeconds];
    [self.delegate timerComponentsDidChange:timerComponents];

    self.timer = [MSWeakTimer scheduledTimerWithTimeInterval:self.timerIntervalInSeconds
                                                      target:self
                                                    selector:@selector(timerDidFinish)
                                                    userInfo:nil
                                                     repeats:YES
                                               dispatchQueue:dispatch_get_main_queue()];
}

- (void) timerDidFinish {
    
    self.timerStartInSeconds = self.timerStartInSeconds - self.timerIntervalInSeconds;
    
    if (self.timerStartInSeconds <= 0) {
        [self stopTimer];
    }
    
    NSDateComponents *timerComponents = [self dateComponentsFromTimeInterval:self.timerStartInSeconds];
    [self.delegate timerComponentsDidChange:timerComponents];
}

- (void) resetTimer {
    
    [self stopTimer];
    self.timerStartInSeconds = self.timerEndInSeconds;
    NSDateComponents *timerComponents = [self dateComponentsFromTimeInterval:self.timerStartInSeconds];
    [self.delegate timerComponentsDidChange:timerComponents];
}

- (void) stopTimer {
    [self.timer invalidate];
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
