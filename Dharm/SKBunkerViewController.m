//
//  SKBunkerViewController.m
//  Dharm
//
//  Created by Кирилл on 09.04.17.
//  Copyright © 2017 Kirill Solovyov. All rights reserved.
//

//Controllers
#import "SKBunkerViewController.h"
#import "SKStoryMenuViewController.h"

//Models
#import "SKUtils.h"
#import "NGSPopoverView.h"
#import "SKUserDataManager.h"
#import "SKBunkerDataManager.h"
#import "SKStoryManager.h"
#import "SKAlertManager.h"
#import "SKSettingsManager.h"
#import "VMaskTextField.h"
#import "SKGameKitManager.h"
#import "UITableViewController+SKTableViewCategory.h"
#import "UIColor+SKColorCategory.h"
#import "UIFont+UIFont_SKFontCategory.h"
#import <PureLayout.h>

static CGFloat const SKScoreTextLableHeight = 25.0;
static CGFloat const SKScoreTextLableWidth = 120.0;
static CGFloat const SKTimerTextLableHeight = 110.0;
static CGFloat const SKTimerTextLableWidth = 300.0;
static CGFloat const SKCodeTextFieldHeight = 35.0;
static CGFloat const SKCodeTextFieldWidth = 347.0;
static CGFloat const SKAnimation300Milliseconds = 0.3;
static CGFloat const SKCornerRadius = 10.0;

@interface SKBunkerViewController () <SKStoryManagerDelegate, SKBunkerDataManagerDelegate, SKGameKitManagerDelegate, SKSettingsManagerDelegate>

@property (strong, nonatomic) SKStoryMenuViewController *menuViewController;
@property (strong, nonatomic) SKBunkerDataManager *dataManager;
@property (strong, nonatomic) SKStoryManager *storyManager;
@property (strong, nonatomic) SKAlertManager *alertManager;
@property (strong, nonatomic) SKGameKitManager *gameCenterManager;
@property (strong, nonatomic) SKSettingsManager *settingsManager;
@property (strong, nonatomic) UIImageView *backgroundView;
@property (assign, nonatomic) BOOL isMenuHidden;
@property (strong, nonatomic) NSLayoutConstraint *textFieldBottomConstraint;

@end

@implementation SKBunkerViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self notificationsInit];
    [self flagsInit];
    [self gesturesInit];
    [self managersInit];
    [self setupMenuViewController];
    [self setupUI];

    if (isFirstTime()) {
        [self.storyManager showTutorial];
    } else {
        [self.gameCenterManager authenticateLocalPlayer];
    }
}

#pragma mark - Initialization

- (void)viewControllerInit {
    self.backgroundView = [[UIImageView alloc] init];
    self.navigationController.navigationBar.topItem.title = [NSString stringWithFormat:NSLocalizedString(@"BUNKER", nil)];
}

- (void)notificationsInit {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateData:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
}

- (void)flagsInit {
    self.isMenuHidden = YES;
}

- (void)gesturesInit {
    UISwipeGestureRecognizer *rightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    UISwipeGestureRecognizer *leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    UISwipeGestureRecognizer *downSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    
    downSwipe.direction = UISwipeGestureRecognizerDirectionDown;
    rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;
    leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
    
    [self.view addGestureRecognizer:rightSwipe];
    [self.view addGestureRecognizer:leftSwipe];
    [self.view addGestureRecognizer:downSwipe];
}

- (void)managersInit {
    self.storyManager = [[SKStoryManager alloc] init];
    self.alertManager = [[SKAlertManager alloc] init];
    self.dataManager = [[SKBunkerDataManager alloc] initWithWithDelegate: self];
    self.gameCenterManager = [SKGameKitManager sharedManager];
    self.settingsManager = [SKSettingsManager sharedManager];
    self.storyManager.delegate = self;
    self.gameCenterManager.delegate = self;
    self.settingsManager.delegate = self;
}

- (void)setupMenuViewController {
    self.menuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SKStoryMenuViewController"];
    self.menuViewController.bunkerDataManager = self.dataManager;
    [self addChildViewController:self.menuViewController];
    [self.menuViewController willMoveToParentViewController:self];
    
    self.menuViewController.view.frame = CGRectMake(-UIScreen.mainScreen.bounds.size.width,
                                                    0,
                                                    UIScreen.mainScreen.bounds.size.width,
                                                    UIScreen.mainScreen.bounds.size.height);
}

- (void)setupUI {
    [self viewControllerInit];
    [self setupBackground];
    [self setupScoreLabel];
    [self setupTimerLabel];
    [self setupCodeField];
}

#pragma mark - Score label

- (void)setupScoreLabel {
    self.scoreLabel = [[UILabel alloc] init];
    self.scoreLabel.font = [UIFont regularWithSize:[UIFont small]];
    self.scoreLabel.textColor = [UIColor whiteColor];
    self.scoreLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:self.scoreLabel];
    [self.scoreLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:8];
    [self.scoreLabel autoPinEdgeToSuperviewEdge:ALEdgeTrailing];
    [self.scoreLabel autoSetDimension:ALDimensionHeight toSize:SKScoreTextLableHeight];
    [self.scoreLabel autoSetDimension:ALDimensionWidth toSize:SKScoreTextLableWidth];
}

#pragma mark - Timer label

- (void)setupTimerLabel {
    self.timerLabel = [[UILabel alloc] init];
    self.timerLabel.font = [UIFont regularWithSize:[UIFont huge]];
    self.timerLabel.textColor = [UIColor whiteColor];
    self.timerLabel.textAlignment = NSTextAlignmentCenter;
    self.timerLabel.text = NSLocalizedString(@"108:00", nil);
    
    [self.view addSubview:self.timerLabel];
    [self.timerLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.scoreLabel withOffset:16];
    [self.timerLabel autoPinEdgeToSuperviewEdge:ALEdgeTrailing];
    [self.timerLabel autoPinEdgeToSuperviewEdge:ALEdgeLeading];
    [self.timerLabel autoSetDimension:ALDimensionHeight toSize:SKTimerTextLableHeight];
    [self.timerLabel autoSetDimension:ALDimensionWidth toSize:SKTimerTextLableWidth];
}

#pragma mark - Code textfield

- (void)setupCodeField {
    self.codeTextField = [[VMaskTextField alloc] init];
    self.codeTextField.placeholder = [NSString stringWithFormat:NSLocalizedString(@"ENTERTHECODEHERE", nil)];
    self.codeTextField.font = [UIFont regularWithSize:[UIFont medium]];
    self.codeTextField.mask = @"# # ## ## ## ##"; // 4 8 15 16 23 42
    self.codeTextField.delegate = self.dataManager;
    self.codeTextField.adjustsFontSizeToFitWidth = YES;
    self.codeTextField.minimumFontSize = 13.0;
    self.codeTextField.textAlignment = NSTextAlignmentCenter;
    self.codeTextField.textColor = [UIColor whiteColor];
    self.codeTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.codeTextField.keyboardAppearance = UIKeyboardAppearanceDark;
    [self.codeTextField setValue:[UIColor textFieldPlaceholderColor]
                      forKeyPath:@"_placeholderLabel.textColor"];
    
    [self.view addSubview:self.codeTextField];
    self.textFieldBottomConstraint = [self.codeTextField autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:16];
    [self.codeTextField autoPinEdgeToSuperviewEdge:ALEdgeTrailing];
    [self.codeTextField autoPinEdgeToSuperviewEdge:ALEdgeLeading];
    [self.codeTextField autoSetDimension:ALDimensionHeight toSize:SKCodeTextFieldHeight];
    [self.codeTextField autoSetDimension:ALDimensionWidth toSize:SKCodeTextFieldWidth];
}

#pragma mark - Background

- (void)setupBackground {
    [self.view addSubview:self.backgroundView];
    [self.backgroundView autoPinEdgesToSuperviewEdges];
    self.backgroundView.backgroundColor = [UIColor blackColor];
    self.backgroundView.image = [UIImage imageNamed:backgroundPath()];
    self.backgroundView.contentMode = UIViewContentModeScaleAspectFit;
}

#pragma mark - SKBunkerDataManagerDelegate

- (void)updateScoreLabelWithScore:(NSInteger)score {
    __weak SKBunkerViewController *weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        weakSelf.scoreLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Score :%@", nil), @((int)score)];
    });
}

- (void)updateTimerLabelWithComponents:(NSDateComponents *)components {
    if (components.minute < kMinutesBeforeFireDateToWarn) {
        self.timerLabel.textColor = [UIColor warningRedColor];
        [self.dataManager codeCanBeEntered:YES];
    } else {
        self.timerLabel.textColor = [UIColor whiteColor];
        [self.dataManager codeCanBeEntered:NO];
    }
    if (components.second < 1 && components.minute < 1) {
        [self.dataManager resetTimerAndScoreWithScore:0];
    } else {
        __weak SKBunkerViewController *weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.timerLabel.text = [NSString stringWithFormat:@"%003i:%02i",
                                        (int)components.minute, (int)components.second];
        });
    }
}

- (void)codeDidEnteredSuccess:(BOOL)flag {
    if (flag) {
        NSInteger userScore = [SKUserDataManager sharedManager].user.score;
        NSInteger maxScore = [SKUserDataManager sharedManager].user.maxScore;
        if (userScore == maxScore) {
            [self.storyManager updatePagesIndexesWithNextIndex];
            [self.storyManager showLastStory];
        }
        [self updateScoreLabelWithScore:userScore];
        [self.gameCenterManager reportScore:(int64_t)userScore];
    } else {
        [self.alertManager showCantEnterCodeAlertOnViewController:self];
    }
}

- (void)codeDidnNotEnteredTimes:(NSInteger)times {
    [self.storyManager showDisasterWithPower:times];
}

#pragma mark - SKGameKitHelperDelegate

- (void)showAuthenticationController:(UIViewController *)authenticationController {
        [self presentViewController:authenticationController
                           animated:YES
                         completion:nil];
}

#pragma mark - SKSettingsManagerDelegate

- (void)settingsDidChange {
    NSInteger currentScore = [SKUserDataManager sharedManager].user.score;
    [self.dataManager resetTimerAndScoreWithScore:currentScore];
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
    NGSPopoverView *popover = [[NGSPopoverView alloc] initWithCornerRadius:SKCornerRadius
                                                                 direction:NGSPopoverArrowPositionTop
                                                                 arrowSize:CGSizeMake(0, 0)];
    popover.contentView = label;
    popover.fillScreen = YES;
    [popover showFromView:sender animated:YES];
}

#pragma mark - Menu

- (void)showMenu {
    [self.view addSubview:self.menuViewController.view];
    __weak SKBunkerViewController *weakSelf = self;
    [UIView animateWithDuration:SKAnimation300Milliseconds animations:^{
        weakSelf.menuViewController.view.frame = CGRectMake(0,
                                                            0,
                                                            UIScreen.mainScreen.bounds.size.width,
                                                            UIScreen.mainScreen.bounds.size.height);
        [weakSelf.view layoutSubviews];
    } completion:^(BOOL finished) {
        weakSelf.isMenuHidden = NO;
    }];
}

- (void)hideMenu {
    __weak SKBunkerViewController *weakSelf = self;
    [UIView animateWithDuration:SKAnimation300Milliseconds animations:^{
        weakSelf.menuViewController.view.frame = CGRectMake(-UIScreen.mainScreen.bounds.size.width,
                                                            0,
                                                            UIScreen.mainScreen.bounds.size.width,
                                                            UIScreen.mainScreen.bounds.size.height);
    } completion:^(BOOL finished) {
        [weakSelf.menuViewController.view removeFromSuperview];
        weakSelf.isMenuHidden = YES;
    }];
}

#pragma mark - Keyboard

- (void)keyboardHide:(NSNotification *)notification {
    __weak SKBunkerViewController *weakSelf = self;
    [UIView animateWithDuration:SKAnimation300Milliseconds animations:^{
        weakSelf.textFieldBottomConstraint.constant = -16;
        [weakSelf.view layoutSubviews];
    }];
}

- (void)keyboardShow:(NSNotification *)notification {
    CGFloat keyboardHeight = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    CGFloat tabBarHeight = self.tabBarController.tabBar.frame.size.height;
    __weak SKBunkerViewController *weakSelf = self;
    [UIView animateWithDuration:SKAnimation300Milliseconds animations:^{
        weakSelf.textFieldBottomConstraint.constant = weakSelf.textFieldBottomConstraint.constant - keyboardHeight + tabBarHeight;
        [weakSelf.view layoutSubviews];
    }];
}

#pragma mark - Notifications

- (void)updateData:(NSNotification *)notification {
    [self.dataManager updateData];
}

#pragma mark - Gestures

- (void)handleSwipe:(UISwipeGestureRecognizer *)sender {
    if (sender.direction == UISwipeGestureRecognizerDirectionRight) {
        [self showMenu];
    } else if (sender.direction == UISwipeGestureRecognizerDirectionLeft) {
        [self hideMenu];
    } else if (sender.direction == UISwipeGestureRecognizerDirectionDown){
        [self.codeTextField resignFirstResponder];
    }
}


@end
