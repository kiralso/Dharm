//
//  SKTimerCell.m
//  Dharm
//
//  Created by Кирилл on 09.04.17.
//  Copyright © 2017 Kirill Solovyov. All rights reserved.
//

#import "SKTimerCell.h"
#import "SKTimer.h"

@interface SKTimerCell()

@property (assign, nonatomic) NSTimeInterval timerEndInSeconds;
@property (assign, nonatomic) NSTimeInterval timerStartInSeconds;
@property (assign, nonatomic) NSTimeInterval timerIntervalInSeconds;

@end

@implementation SKTimerCell

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.timerEndInSeconds = 0.0;
        self.timerStartInSeconds = 0.1 * 60.0;
        self.timerIntervalInSeconds = 1.0;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(updateTimeLabel:)
                                                     name:SKTimerTextChangedNotification
                                                   object:nil];
        
        [self startTimerWithDefaultParameters:NO];

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
        [self startTimerWithDefaultParameters:YES];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.timerLabel.text = [NSString stringWithFormat:@"%003i:%02i",
                                    (int)dateComponents.minute, (int)dateComponents.second];
        });
    }
}

- (void) startTimerWithDefaultParameters:(BOOL) yesOrNo {
    
    if (yesOrNo) {
        self.timer = [[SKTimer alloc] initWithStartInSeconds:108 * 60.f
                                                     withEnd:0.0
                                                 andInterval:0.1];
    } else {
        self.timer = [[SKTimer alloc] initWithStartInSeconds:self.timerStartInSeconds
                                                     withEnd:self.timerEndInSeconds
                                                 andInterval:self.timerIntervalInSeconds];
    }
    
    [self.timer startTimer];
}


@end
