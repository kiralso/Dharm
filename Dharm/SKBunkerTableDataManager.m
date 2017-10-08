//
//  SKBunkerTableDataManager.m
//  Dharm
//
//  Created by Kirill Solovyov on 05.10.17.
//  Copyright © 2017 Kirill Solovyov. All rights reserved.
//

//Models
#import "SKBunkerTableDataManager.h"
#import "SKBunkerTableViewController.h"
#import "SKUserDataManager.h"
#import "VMaskTextField.h"
#import "SKLocalNotificationHelper.h"
#import "UIColor+SKColorCategory.h"
#import "SKDateGenerator.h"
#import "SKTimer.h"
#import "SKUtils.h"

@interface SKBunkerTableDataManager() <SKTimerDelegate>

//Models
@property (strong, nonatomic) SKTimer *timer;
@property (strong, nonatomic) SKLocalNotificationHelper *localNotificationHelper;
@property (assign ,nonatomic) BOOL codeCanEntered;

//Flags
@property (assign, nonatomic) BOOL showDisaster;
@end

@implementation SKBunkerTableDataManager 

- (instancetype)initWithWithDelegate:(SKBunkerTableViewController<SKBunkerTableDataManagerDelegate> *)delegate {
    self = [super init];
    if (self) {
        self.localNotificationHelper = [[SKLocalNotificationHelper alloc] init];
        self.showDisaster = YES;
        self.delegate = delegate;
        [self checkScore];
        [self.delegate updateScore];
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
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSTimeInterval start = [self timeIntervalBeforeNextFireDate];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self startTimerInStart:start
                                end:0.f
                        andInterval:0.1];
        });
    });
}

#pragma mark - SKTimerDelegate

- (void)timerComponentsDidChange:(NSDateComponents *)components {
    if (components.minute < kMinutesBeforeFireDateToWarn) {
        self.delegate.timerLabel.textColor = [UIColor warningRedColor];
        [self codeCanBeEntered:YES];
    } else {
        self.delegate.timerLabel.textColor = [UIColor whiteColor];
        [self codeCanBeEntered:NO];
    }
    __weak SKBunkerTableDataManager *weakSelf = self;
    if (components.second < 1 && components.minute < 1) {
        [self.localNotificationHelper updateNotificationDatesWithCompletion:^(NSArray *dates) {
            [weakSelf.delegate updateScore];
            [[SKUserDataManager sharedManager] updateUserWithScore:0];
            [weakSelf startTimerToNextFireDate];
        }];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.delegate.timerLabel.text = [NSString stringWithFormat:@"%003i:%02i",
                                                  (int)components.minute, (int)components.second];
        });
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSCharacterSet* validationSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    NSArray* components = [string componentsSeparatedByCharactersInSet:validationSet];
    NSString *resultString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if ([components count] <= 1) {
        if (self.codeCanEntered) {
            if ([resultString isEqualToString:kSafetyString]) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [textField resignFirstResponder];
                    textField.text = @"";
                    NSInteger userScore = [SKUserDataManager sharedManager].user.score + 1;
                    __weak SKBunkerTableDataManager *weakSelf = self;
                    [self.localNotificationHelper updateNotificationDatesWithCompletion:^(NSArray *dates) {
                        [[SKUserDataManager sharedManager] updateUserWithScore:userScore];
                        [weakSelf checkScore];
                        [weakSelf startTimerToNextFireDate];
                    }];
                    [self.delegate codeDidEnteredSuccess:YES];
                });
            }
            return [self.delegate.codeTextField shouldChangeCharactersInRange:range replacementString:string];
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
    [self.delegate updateScore];
}

- (void)recountDates {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kDifficultySwitchKey];
    __weak SKBunkerTableDataManager *weakSelf = self;
    [self.localNotificationHelper updateNotificationDatesWithCompletion:^(NSArray *dates) {
        [weakSelf checkScore];
        [weakSelf startTimerToNextFireDate];
    }];
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
