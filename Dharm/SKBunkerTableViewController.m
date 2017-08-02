//
//  SKBunkerTableViewController.m
//  Dharm
//
//  Created by Кирилл on 09.04.17.
//  Copyright © 2017 Kirill Solovyov. All rights reserved.
//

#import "SKBunkerTableViewController.h"
#import "SKStoryMenuViewController.h"
#import "SKTutorialPageViewController.h"
#import "SKScoreCell.h"
#import "SKTimerCell.h"
#import "SKCodeCell.h"
#import "SKAdCell.h"
#import "SKTimer.h"
#import "SKUtils.h"
#import "SKMainObserver.h"
#import "NGSPopoverView.h"
#import "UIView+Shake.h"
#import "UIViewController+SKViewControllerCategory.h"
#import "UITableViewController+SKTableViewCategory.h"
#import "SKGameKitHelper.h"
#import "SKUserDataManager.h"
#import "SKStoryPage.h"
#import "SKStoryHelper.h"

@import GoogleMobileAds;

@interface SKBunkerTableViewController () <GADBannerViewDelegate, UITextFieldDelegate, SKStoryHelperDelegate>

@property (nonatomic, strong) GADBannerView *bannerView;
@property (assign, nonatomic) BOOL codeCanEntered;
@property (strong, nonatomic) UITextField *codeTextField;
@property (strong, nonatomic) SKTimer *timer;
@property (assign, nonatomic) BOOL isMenuHidden;
@property (strong, nonatomic) SKStoryMenuViewController *storyVC;
@property (strong, nonatomic) UISwipeGestureRecognizer *rightSwipe;
@property (strong, nonatomic) UISwipeGestureRecognizer *leftSwipe;
@property (strong, nonatomic) SKStoryHelper *storyHelper;

@end

typedef enum : NSUInteger {
    SKCellsScore,
    SKCellsTimer,
    SKCellsCode,
    SKCellsAd
} SKCells;

static NSString * const scoreCellIdentifier = @"scoreCell";
static NSString * const timerCellIdentifier = @"timerCell";
static NSString * const codeCellIdentifier = @"codeCell";
static NSString * const adCellIdentifier = @"adCell";

@implementation SKBunkerTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadTableView:)
                                                 name:SKMainObserverReloadViewControlerNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadTableView:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(checkCodeCanEntered:)
                                                 name:SKTimerTextChangedNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showAuthenticationViewController)
                                                 name:SKPresentAuthenticationViewControllerNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateTimeLabel:)
                                                 name:SKTimerTextChangedNotification
                                               object:nil];
    
    self.codeCanEntered = NO;
    self.isMenuHidden = YES;
    
    SKStoryMenuViewController *storyMenuVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SKStoryMenuViewController"];
    self.storyVC = storyMenuVC;

    self.rightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    self.rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:self.rightSwipe];
    
    self.leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    self.leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:self.leftSwipe];
    
    /*
    UIColor *color = RGBA(207.f, 216.f, 220.f, 1.f);
    [self drawStatusBarOnNavigationViewWithColor:color];
    */
    
    [self setBackgroundImageViewWithImageName:backgroundPath()];
    
    self.storyHelper = [[SKStoryHelper alloc] init];
    self.storyHelper.delegate = self;
    
    [self checkScore];
    
    [self.storyHelper showTutorial];
}

- (void)viewDidAppear:(BOOL)animated {
    [self.tableView reloadData];
    
    [[SKGameKitHelper sharedGameKitHelper] authenticateLocalPlayer];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    
    switch (indexPath.row) {
        case SKCellsScore:
            
            cell = [tableView dequeueReusableCellWithIdentifier:scoreCellIdentifier
                                                   forIndexPath:indexPath];
            
            self.scoreCell = (SKScoreCell *)cell;
            
            [self updateScoreLabel];
            
            return self.scoreCell;
        case SKCellsTimer:
            
            cell = [tableView dequeueReusableCellWithIdentifier:timerCellIdentifier
                                                   forIndexPath:indexPath];
            
            self.timerCell = (SKTimerCell *)cell;
            
            [self startTimerToNextFireDate];
            
            return self.timerCell;
        case SKCellsCode:
            
            cell = [tableView dequeueReusableCellWithIdentifier:codeCellIdentifier
                                                   forIndexPath:indexPath];
            
            self.codeCell = (SKCodeCell *)cell;
            self.codeCell.codeTextField.delegate = self;
            self.codeTextField = self.codeCell.codeTextField;
            
            return self.codeCell;
        case SKCellsAd:
            
            cell = [tableView dequeueReusableCellWithIdentifier:adCellIdentifier
                                                   forIndexPath:indexPath];
            
            self.adCell = (SKAdCell *)cell;
            
            self.adCell.adView.adUnitID = kAdMobAdIdentifier;
            self.adCell.adView.adSize = kGADAdSizeSmartBannerPortrait;
            self.adCell.adView.rootViewController = self;
            self.adCell.adView.delegate = self;
            
            GADRequest *request = [GADRequest request];
            [self.adCell.adView loadRequest:request];
            
            return self.adCell;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGRect rect = self.tableView.bounds;
    CGFloat screenHeight = rect.size.height;

    switch (indexPath.row) {
        case SKCellsScore:
            return screenHeight * 0.05f;
        case SKCellsTimer:
            return screenHeight * 0.52f;
        case SKCellsCode:
            return screenHeight * 0.15f;
        case SKCellsAd:
            return 60;
    }
    
    return 1.f;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

#pragma mark - Notifications

- (void) reloadTableView:(NSNotification *) notification {

    [self checkScore];
    
    [self updateScoreLabel];

    [self.tableView reloadData];
}

- (void)showAuthenticationViewController {
    
    [self presentViewController:[SKGameKitHelper sharedGameKitHelper].authenticationViewController
                       animated:YES
                     completion:nil];
}

- (void) checkCodeCanEntered:(NSNotification *) notification {
    
    NSDateComponents *dateComponents = [notification.userInfo objectForKey:SKTimerTextUserInfoKey];
    
    if (dateComponents.minute < kMinutesBeforeFireDateToWarn) {
        self.codeCanEntered = YES;
    } else {
        self.codeCanEntered = NO;
    }
}

- (void) updateTimeLabel:(NSNotification *) notification {
    
    NSDateComponents *dateComponents = [notification.userInfo objectForKey:SKTimerTextUserInfoKey];
    
    if (dateComponents.minute < kMinutesBeforeFireDateToWarn) {
        UIColor *customRed = RGBA(163.f, 26.f, 27.f, 1.f);
        
        self.timerCell.timerLabel.textColor = customRed;
    } else {
        self.timerCell.timerLabel.textColor = [UIColor whiteColor];
    }
    
    if (dateComponents.second < 1 && dateComponents.minute < 1) {
        
        [self startTimerToNextFireDate];
        
        [[SKMainObserver sharedObserver] updateDataWithScore:0];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.timerCell.timerLabel.text = [NSString stringWithFormat:@"%003i:%02i",
                                              (int)dateComponents.minute, (int)dateComponents.second];
        });
    }
}

#pragma mark - Actions

- (IBAction)showMenuAction:(UIBarButtonItem *)sender {
    
    if (self.isMenuHidden) {
        [self showMenu];
    } else {
        [self hideMenu];
    }
}

- (IBAction)showPopoverAction:(UIButton *)sender {
    
    UILabel *label = [[UILabel alloc] init];
    label.text = [NSString stringWithFormat:NSLocalizedString(@"POPOVER", nil), kMinutesBeforeFireDateToWarn];
    label.numberOfLines = 0;
    
    NGSPopoverView *popover = [[NGSPopoverView alloc] initWithCornerRadius:10.f
                                                                 direction:NGSPopoverArrowPositionTop
                                                                 arrowSize:CGSizeMake(0, 0)];
    popover.contentView = label;
    popover.fillScreen = YES;
    
    [popover showFromView:sender animated:YES];
}

/*
- (void) showStory {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    BOOL isFirstTime = [defaults boolForKey:kIsFirstTime];
    
    SKTutorialPageViewController *tutorialVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SKTutorialPageViewController"];
    
    NSInteger maxScore = [SKUserDataManager sharedManager].userMaxScore;
    NSInteger score = [SKUserDataManager sharedManager].userScore;

    if (!isFirstTime) {
        
        [defaults setBool:YES forKey:kIsFirstTime];
        tutorialVC.indexOfInitialViewController = 0;
        tutorialVC.isFromMenu = NO;
    } else if (maxScore == score && score != 0) {
        
        NSArray *allIndexes = [SKUserDataManager sharedManager].userPagesIndexesArray;
        NSRange range = NSMakeRange(0, [allIndexes count] -1);
        NSArray *indexes = [allIndexes subarrayWithRange:range];
        
        tutorialVC.indexOfInitialViewController = [[indexes lastObject] integerValue];
        tutorialVC.isFromMenu = NO;
        tutorialVC.storyPages = [[SKStoryPage alloc] pagesWithArrayOfIndexes:indexes];
    }
    [self presentViewController:tutorialVC animated:YES completion:nil];

}
*/
#pragma mark - Menu

- (void) showMenu {
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.storyVC.view.frame = CGRectMake(0,
                                             0,
                                             UIScreen.mainScreen.bounds.size.width,
                                             UIScreen.mainScreen.bounds.size.height);
        
        [self addChildViewController:self.storyVC];
        [self.view addSubview:self.storyVC.view];
        self.isMenuHidden = NO;
    }];
}

- (void) hideMenu {
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.storyVC.view.frame = CGRectMake(-UIScreen.mainScreen.bounds.size.width,
                                             0,
                                             UIScreen.mainScreen.bounds.size.width,
                                             UIScreen.mainScreen.bounds.size.height);
    } completion:^(BOOL finished) {
        [self.storyVC.view removeFromSuperview];
        self.isMenuHidden = YES;
    }];
}

#pragma mark - Gestures

- (void) handleSwipe:(UISwipeGestureRecognizer *) sender {
    
    switch (sender.direction) {
            
        case UISwipeGestureRecognizerDirectionRight:
            [self showMenu];
            break;
            
        case UISwipeGestureRecognizerDirectionLeft:
            [self hideMenu];
            break;
            
        default:
            break;
    }
}

#pragma mark - Alerts

- (void) showCantEnterAlert {
    
    NSString *alertTitle = NSLocalizedString(@"ALERTERROR", nil);
    NSString *alertMessage = NSLocalizedString(@"ALERTMESSAGE", nil);
    NSString *alertCancel = NSLocalizedString(@"OK", nil);
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:alertTitle
                                                                   message:alertMessage
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:alertCancel
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil];
    
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - GADBannerViewDelegate

- (void)adViewDidReceiveAd:(GADBannerView *)bannerView {
    NSLog(@"====== Success loading ======");
    self.adCell.adView = self.bannerView;
}

- (void)adView:(GADBannerView *)bannerView didFailToReceiveAdWithError:(GADRequestError *)error {
    NSLog(@"====== Loading failure , error - %@ ======", [error localizedDescription]);
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if ([self.codeTextField.text isEqualToString:kSafetyString]) {
        
        [self codeDidEntered];
        
        return YES;
    }
    
    return NO;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSCharacterSet* validationSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    NSArray* components = [string componentsSeparatedByCharactersInSet:validationSet];
    
    if ([components count] > 1) {
        return NO;
    } else if (self.codeCanEntered == NO) {
        [self showCantEnterAlert];
        return NO;
    }
    
    NSString* newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSMutableString* resultString = [NSMutableString string];
    
    NSArray* validationComponents = [newString componentsSeparatedByCharactersInSet:validationSet];
    newString = [validationComponents componentsJoinedByString:@""];
    
    static const int maxCodeLength = 10; //4815162342
    
    if ([newString length] > maxCodeLength) {
        return NO;
    }
    
    NSInteger currentCodeLength = MIN([newString length], maxCodeLength);
    
    NSString* number = [newString substringFromIndex:(int)[newString length] - currentCodeLength];
    
    [resultString appendString:number];
    
    if ([resultString length] > 1) {
        [resultString insertString:@" " atIndex:1];
    }
    
    if ([resultString length] > 3) {
        [resultString insertString:@" " atIndex:3];
    }
    
    if ([resultString length] > 6) {
        [resultString insertString:@" " atIndex:6];
    }
    
    if ([resultString length] > 9) {
        [resultString insertString:@" " atIndex:9];
    }
    if ([resultString length] > 12) {
        [resultString insertString:@" " atIndex:12];
    }
    
    textField.text = resultString;
    
    if ([textField.text isEqualToString:kSafetyString]) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [textField resignFirstResponder];
            textField.text = @"";
            
            [self codeDidEntered];
        });
    }
    
    return NO;
}

#pragma mark - Code

- (void) codeDidEntered {
    
    NSInteger maxScore = [SKUserDataManager sharedManager].userMaxScore;
    NSInteger newScore = [SKUserDataManager sharedManager].userScore + 1;
    
    if (newScore > maxScore) {
        [[SKUserDataManager sharedManager] updatePagesIndexesWithNextIndex];
    }
    /*
    NSString *identifier = [SKGameKitHelper sharedGameKitHelper].leaderboardIdentifier;
    [[SKGameKitHelper sharedGameKitHelper] reportScore:(int64_t) newScore forLeaderboardID: identifier];
    */
    [[SKGameKitHelper sharedGameKitHelper] reportScore:newScore];
    
    [[SKMainObserver sharedObserver] updateDataWithScore:newScore];
    
    [self.storyHelper showLastStory];
}

#pragma mark - Timer

- (void) startTimerInStart:(NSTimeInterval)start
                       end:(NSTimeInterval)end
               andInterval:(NSTimeInterval)interval {
    
    [self.timer stopTimer];
    
    self.timer = [[SKTimer alloc] initWithStartInSeconds:start
                                                 withEnd:end
                                             andInterval:interval];
    
    [self.timer startTimer];
}

- (void) startTimerToNextFireDate {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSTimeInterval start = [[SKMainObserver sharedObserver] timeIntervalBeforeNextFireDate];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self startTimerInStart:start
                                end:0.f
                        andInterval:0.1];
        });
    });
}

#pragma mark - Score

- (void) checkScore {
    
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
            
            if(result == NSOrderedAscending) {
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
        [self.storyHelper showDisasterWithPower:power];
    }
    
    if (recountDates) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kDifficultySwitchKey];
        [[SKMainObserver sharedObserver] updateNotificationDates];
    }
}

- (void) updateScoreLabel {
    
    dispatch_async(dispatch_get_main_queue(), ^{

        NSInteger score = [SKUserDataManager sharedManager].userScore;
    
        self.scoreCell.scoreLabel.text =
        [NSString stringWithFormat:NSLocalizedString(@"Score :%@", nil), @((int)score)];
    });
}

#pragma mark - SKStoryHelperDelegate

- (void) pagesDidLoad:(NSArray *)pages {
    
}

@end
