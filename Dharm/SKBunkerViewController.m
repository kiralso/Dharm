//
//  SKBunkerViewController.m
//  Dharm
//
//  Created by Кирилл on 01.04.17.
//  Copyright © 2017 Kirill Solovov. All rights reserved.
//

#import "SKBunkerViewController.h"
#import "SKTimer.h"
#import "SKLocalNotificationManagger.h"
#import "SKConstants.h"

@interface SKBunkerViewController ()

@property (assign, nonatomic) NSTimeInterval timerEndInSeconds;
@property (assign, nonatomic) NSTimeInterval timerStartInSeconds;
@property (assign, nonatomic) NSTimeInterval timerIntervalInSeconds;
@property (assign, nonatomic) NSInteger score;

@end

@implementation SKBunkerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.score = [[NSUserDefaults standardUserDefaults] integerForKey:kScoreKey];
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %i",(int)self.score];
    
    self.timerEndInSeconds = 0.0;
    self.timerStartInSeconds = 0.1 * 60.0;
    self.timerIntervalInSeconds = 1.0;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateTimeLabel:)
                                                 name:SKTimerTextChangedNotification
                                               object:nil];
    
    [self startTimerWithDefaultParameters:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Useful methods

- (void) updateTimeLabel:(NSNotification *) notification {
    
    NSDateComponents *dateComponents = [notification.userInfo objectForKey:SKTimerTextUserInfoKey];
    
    if (dateComponents.minute < 4) {
        self.timeLabel.textColor = [UIColor redColor];
    } else {
        self.timeLabel.textColor = [UIColor darkGrayColor];
    }
    
    if (dateComponents.second < 1 && dateComponents.minute < 1) {
        [self startTimerWithDefaultParameters:YES];
    } else {
        self.timeLabel.text = [NSString stringWithFormat:@"%003i:%02i",
                               (int)dateComponents.minute, (int)dateComponents.second];
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
