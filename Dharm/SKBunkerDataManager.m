//
//  SKBunkerDataManager.m
//  Dharm
//
//  Created by Kirill Solovyov on 05.10.17.
//  Copyright © 2017 Kirill Solovyov. All rights reserved.
//

//Models
#import "SKBunkerDataManager.h"
#import "SKBunkerViewController.h"
#import "SKUserDataManager.h"
#import "VMaskTextField.h"
#import "SKLocalNotificationManager.h"
#import "SKSettingsManager.h"
#import "UIColor+SKColorCategory.h"
#import "SKDateGenerator.h"
#import "SKTimer.h"
#import "SKUtils.h"

@interface SKBunkerDataManager() <SKTimerDelegate>

@property (weak,nonatomic) id<SKBunkerDataManagerDelegate> delegate;

//Models
@property (strong, nonatomic) SKTimer *timer;
@property (strong, nonatomic) SKLocalNotificationManager *localNotificationManager;

//Flags
@property (assign, nonatomic) BOOL showDisaster;
@property (assign, nonatomic) BOOL codeCanEntered;

@end

@implementation SKBunkerDataManager

- (instancetype)initWithWithDelegate:(id<SKBunkerDataManagerDelegate>)delegate {
    self = [super init];
    if (self) {
        self.localNotificationManager = [[SKLocalNotificationManager alloc] init];
        self.showDisaster = YES;
        self.delegate = delegate;
        [self checkScore];
        NSInteger score = [SKUserDataManager sharedManager].user.score;
        [self.delegate updateScoreLabelWithScore:score];
        [self startTimerToNextFireDate];
    }
    return self;
}

#pragma mark - Timer

- (void)startTimerInStart:(NSTimeInterval)start
                      end:(NSTimeInterval)end
              andInterval:(NSTimeInterval)interval {
    [self.timer stopTimer];
    self.timer = [[SKTimer alloc] initWithStartInSeconds:start
                                                     end:end
                                                interval:interval
                                             andDelegate:self];
    [self.timer startTimer];
}

- (void)startTimerToNextFireDate {
    __weak SKBunkerDataManager *weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSTimeInterval start = [weakSelf timeIntervalBeforeNextFireDate];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf startTimerInStart:start
                                    end:0.f
                            andInterval:0.1];
        });
    });
}

#pragma mark - SKTimerDelegate

- (void)timerComponentsDidChange:(NSDateComponents *)components {
    [self.delegate updateTimerLabelWithComponents:components];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSCharacterSet* validationSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    NSArray* components = [string componentsSeparatedByCharactersInSet:validationSet];
    NSString *resultString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if ([components count] <= 1) {
        if (self.codeCanEntered) {
            if ([resultString isEqualToString:kSafetyString]) {
                __weak SKBunkerDataManager *weakSelf = self;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [textField resignFirstResponder];
                    textField.text = @"";
                    NSInteger userScore = [SKUserDataManager sharedManager].user.score + 1;
                    [weakSelf resetTimerAndScoreWithScore:userScore];
                    [weakSelf.delegate codeDidEnteredSuccess:YES];
                });
            }
            return [(VMaskTextField *)textField shouldChangeCharactersInRange:range replacementString:string];
        } else {
            [textField resignFirstResponder];
            [self.delegate codeDidEnteredSuccess:NO];
        }
    }
    return NO;
}

#pragma mark - Score

- (void)checkScore {
    NSArray *fireDates = [[SKUserDataManager sharedManager] fireDates];
    BOOL recountDates = YES;
    BOOL resetScore = NO;
    NSInteger power = 0;
    if ([fireDates count] != 0) {
        NSMutableArray *datesAfterNow = [NSMutableArray array];
        NSDate *currentDate = [NSDate date];
        NSComparisonResult result;
        for (NSDate *date in fireDates) {
            result = [currentDate compare:date];
            if (result == NSOrderedAscending) {
                [datesAfterNow addObject:date];
            } else {
                resetScore = YES;
                power++;
            }
        }
        if ([datesAfterNow count] > 0) {
            recountDates = NO;
        }
    }
    if (resetScore && self.showDisaster) {
        self.showDisaster = NO;
        [[SKUserDataManager sharedManager] updateUserWithScore:0];
        [self.delegate codeDidnNotEnteredTimes:power];
    }
    if (recountDates) {
        [self recountDates];
    }
    NSInteger score = [SKUserDataManager sharedManager].user.score;
    [self.delegate updateScoreLabelWithScore:score];
}

- (void)recountDates {
    SKSettingsManager *settingsManager = [SKSettingsManager sharedManager];
    [settingsManager saveDifficulty:YES];
    __weak SKBunkerDataManager *weakSelf = self;
    [self.localNotificationManager updateNotificationDatesWithCompletion:^(NSArray *dates) {
        [weakSelf checkScore];
        [weakSelf startTimerToNextFireDate];
    }];
}

- (void)resetTimerAndScoreWithScore:(NSInteger)score {
    __weak SKBunkerDataManager *weakSelf = self;
    [self.localNotificationManager updateNotificationDatesWithCompletion:^(NSArray *dates) {
        [weakSelf.delegate updateScoreLabelWithScore:score];
        [[SKUserDataManager sharedManager] updateUserWithScore:score];
        [weakSelf startTimerToNextFireDate];
    }];
}

- (void)updateData {
    [self checkScore];
    [self startTimerToNextFireDate];
}

#pragma mark - Helpful Functions

- (NSTimeInterval)timeIntervalBeforeNextFireDate {
    NSArray *fireDates = [[SKUserDataManager sharedManager] fireDates];
    SKDateGenerator *generator = [[SKDateGenerator alloc] init];
    NSDate *closeFiredate = [generator firstFireDateSinceNowFromArray:fireDates];
    NSDateComponents *startRangeComponents =[[NSCalendar currentCalendar] components:NSCalendarUnitSecond
                                                                            fromDate:[NSDate date]
                                                                              toDate:closeFiredate
                                                                             options:0];
    return (NSTimeInterval)startRangeComponents.second;
}

- (void)codeCanBeEntered:(BOOL)flag {
    if (flag) {
        self.codeCanEntered = YES;
    } else {
        self.codeCanEntered = NO;
    }
}

@end
