//
//  SKBunkerTableDataManager.m
//  Dharm
//
//  Created by Kirill Solovyov on 05.10.17.
//  Copyright © 2017 Kirill Solovyov. All rights reserved.
//

//Models
#import "SKBunkerTableDataManager.h"
#import "SKUserDataManager.h"
#import "SKSafetyCodeManager.h"
#import "SKLocalNotificationHelper.h"
#import "UIColor+SKColorCategory.h"
#import "SKDateGenerator.h"
#import "SKTimer.h"
#import "SKUtils.h"

//Views
#import "SKScoreCell.h"
#import "SKTimerCell.h"
#import "SKCodeCell.h"
#import "SKAdCell.h"

typedef NS_ENUM(NSInteger, SKCell) {
    SKCellsScore,
    SKCellsTimer,
    SKCellsAd,
    SKCellsCode
};

@interface SKBunkerTableDataManager() <SKTimerDelegate, SKSafetyCodeManagerDelegate>

//Models
@property (strong, nonatomic) SKTimer *timer;
@property (strong, nonatomic) SKLocalNotificationHelper *localNotificationHelper;
@property (strong, nonatomic) SKSafetyCodeManager *codeManager;

//Cells
@property (strong, nonatomic) SKScoreCell *scoreCell;
@property (strong, nonatomic) SKTimerCell *timerCell;
@property (strong, nonatomic) SKCodeCell *codeCell;
@property (strong, nonatomic) SKAdCell *adCell;

//Flags
@property (assign, nonatomic) BOOL showDisaster;
@end

//Constants
static NSString * const scoreCellIdentifier = @"scoreCell";
static NSString * const timerCellIdentifier = @"timerCell";
static NSString * const codeCellIdentifier = @"codeCell";
static NSString * const adCellIdentifier = @"adCell";

static NSInteger const SKNumberOfSections = 1;
static NSInteger const SKNumberOfRows = 4;

@implementation SKBunkerTableDataManager 

@synthesize codeCanEntered;

- (instancetype)init {
    self = [super init];
    if (self) {
        self.localNotificationHelper = [[SKLocalNotificationHelper alloc] init];
        self.showDisaster = YES;
    }
    return self;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return SKNumberOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return SKNumberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (indexPath.row == SKCellsScore) {
        cell = [tableView dequeueReusableCellWithIdentifier:scoreCellIdentifier
                                                                        forIndexPath:indexPath];
        self.scoreCell = (SKScoreCell *)cell;
        [self updateScoreLabel];
    } else if (indexPath.row == SKCellsTimer) {
        cell = [tableView dequeueReusableCellWithIdentifier:timerCellIdentifier
                                                         forIndexPath:indexPath];
        self.timerCell = (SKTimerCell *)cell;
        [self checkScore];
        [self startTimerToNextFireDate];
    } else if (indexPath.row == SKCellsCode) {
        cell = [tableView dequeueReusableCellWithIdentifier:codeCellIdentifier
                                                        forIndexPath:indexPath];
        self.codeCell = (SKCodeCell *)cell;
        self.codeManager = [[SKSafetyCodeManager alloc] initWithTextField:self.codeCell.codeTextField];
        self.codeManager.delegate = self;
    } else if (indexPath.row == SKCellsAd) {
        cell = [tableView dequeueReusableCellWithIdentifier:adCellIdentifier
                                               forIndexPath:indexPath];
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGRect rect = self.delegate.tableView.bounds;
    CGFloat screenHeight = rect.size.height;
    CGFloat height;
    if (indexPath.row == SKCellsScore) {
        height = 40.f;
    } else if (indexPath.row == SKCellsTimer) {
        height = screenHeight * 0.52f;
    } else if (indexPath.row == SKCellsCode) {
        height = 60;
    } else if (indexPath.row == SKCellsAd) {
        height = screenHeight * 0.15f;
    } else {
        height = 0;
    }
    return height;
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
        self.timerCell.timerLabel.textColor = [UIColor warningRedColor];
        [self codeCanBeEntered:YES];
    } else {
        self.timerCell.timerLabel.textColor = [UIColor whiteColor];
        [self codeCanBeEntered:NO];
    }
    __weak SKBunkerTableDataManager *weakSelf = self;
    if (components.second < 1 && components.minute < 1) {
        [self startTimerToNextFireDate];
        [self.localNotificationHelper updateNotificationDatesWithCompletion:^(NSArray *dates) {
            [weakSelf updateScoreLabel];
            [[SKUserDataManager sharedManager] updateUserWithScore:0];
        }];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.timerCell.timerLabel.text = [NSString stringWithFormat:@"%003i:%02i",
                                                  (int)components.minute, (int)components.second];
        });
    }
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
    
    if (resetScore) {
        [[SKUserDataManager sharedManager] updateUserWithScore:0];
        [self.delegate codeDidnNotEnteredTimes:power];
    }
    
    if (recountDates && self.showDisaster) {
        self.showDisaster = NO;
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kDifficultySwitchKey];
        __weak SKBunkerTableDataManager *weakSelf = self;
        [self.localNotificationHelper updateNotificationDatesWithCompletion:^(NSArray *dates) {
            [weakSelf.delegate.tableView reloadData];
        }];
    }
    [self updateScoreLabel];
}

- (void) updateScoreLabel {
    __weak SKBunkerTableDataManager *weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        NSInteger score = [SKUserDataManager sharedManager].user.score;
        self.scoreCell.scoreLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Score :%@", nil), @((int)score)];
        [weakSelf.delegate.tableView reloadData];
    });
}

#pragma mark - SKSafetyCodeManagerDelegate

- (void)codeDidEnteredSuccess:(BOOL)flag {
    [self.delegate codeDidEnteredSuccess:flag];
}

#pragma mark - Helpful Functions

- (void) codeCanBeEntered:(BOOL)flag {
    if (flag) {
        self.codeCanEntered = YES;
    } else {
        self.codeCanEntered = NO;
    }
}

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

@end
