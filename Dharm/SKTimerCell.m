//
//  SKTimerCell.m
//  Dharm
//
//  Created by Кирилл on 09.04.17.
//  Copyright © 2017 Kirill Solovyov. All rights reserved.
//

#import "SKTimerCell.h"
#import "SKTimer.h"
#import "SKConstants.h"
#import "SKMainObserver.h"

@interface SKTimerCell()

@end

@implementation SKTimerCell

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(updateTimeLabel:)
                                                     name:SKTimerTextChangedNotification
                                                   object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Useful methods

- (void) updateTimeLabel:(NSNotification *) notification {
    
    NSDateComponents *dateComponents = [notification.userInfo objectForKey:SKTimerTextUserInfoKey];
    
    if (dateComponents.minute < 4) {
        self.timerLabel.textColor = [UIColor redColor];
    } else {
        self.timerLabel.textColor = [UIColor darkGrayColor];
    }
    
    if (dateComponents.second < 1 && dateComponents.minute < 1) {
        
        [self startTimerToNextFireDate];
        
        [[SKMainObserver sharedObserver] updateDataWithScore:0];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.timerLabel.text = [NSString stringWithFormat:@"%003i:%02i",
                                    (int)dateComponents.minute, (int)dateComponents.second];
        });
    }
}

- (void) startTimerInStart:(NSTimeInterval)start end:(NSTimeInterval)end andInterval:(NSTimeInterval)interval {
    
        [self.timer.timer invalidate];
        
        self.timer = [[SKTimer alloc] initWithStartInSeconds:start
                                                     withEnd:end
                                                 andInterval:interval];
        
        [self.timer startTimer];
}

- (void) startTimerToNextFireDate {
    
    NSTimeInterval start = [[SKMainObserver sharedObserver] timeIntervalBeforeNextFireDate];
    
    [self startTimerInStart:start
                        end:0.f
                andInterval:0.1];
}

@end
