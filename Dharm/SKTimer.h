//
//  SKTimer.h
//  Dharm
//
//  Created by Кирилл on 02.04.17.
//  Copyright © 2017 Kirill Solovov. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MSWeakTimer;

extern NSString* const SKTimerTextChangedNotification;
extern NSString* const SKTimerTextUserInfoKey;

@protocol SKTimerDelegate
- (void)timerComponentsDidChange:(NSDateComponents *)components;
@end

@interface SKTimer : NSObject

@property (weak, nonatomic) id<SKTimerDelegate> delegate;
@property (strong, nonatomic) MSWeakTimer *timer;

- (instancetype)initWithStartInSeconds:(NSTimeInterval)start
                                   end:(NSTimeInterval)end
                              interval:(NSTimeInterval)interval
                           andDelegate:(id<SKTimerDelegate>)delegate;
- (void)startTimer;
- (void)timerDidFinish;
- (void)resetTimer;
- (void)stopTimer;

@end
