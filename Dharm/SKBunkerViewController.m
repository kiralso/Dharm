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

static CGFloat const SKScoreTextLableHeight = 25.0;
static CGFloat const SKScoreTextLableWidth = 120.0;
static CGFloat const SKTimerTextLableHeight = 110.0;
static CGFloat const SKTimerTextLableWidth = 300.0;
static CGFloat const SKCodeTextFieldHeight = 35.0;
static CGFloat const SKCodeTextFieldWidth = 347.0;

@interface SKBunkerViewController () <SKStoryManagerDelegate, SKBunkerDataManagerDelegate, SKGameKitManagerDelegate, SKSettingsManagerDelegate>

@property (strong, nonatomic) SKStoryMenuViewController *storyVC;
@property (strong, nonatomic) SKBunkerDataManager *dataManager;
@property (strong, nonatomic) SKStoryManager *storyManager;
@property (strong, nonatomic) SKAlertManager *alertManager;
@property (strong, nonatomic) SKGameKitManager *gameCenterManager;
@property (strong, nonatomic) SKSettingsManager *settingsManager;
@property (strong, nonatomic) UIImageView *backgroundView;
@property (assign, nonatomic) BOOL isMenuHidden;

@end

@implementation SKBunkerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self viewControllerInit];
    [self notificationsInit];
    [self flagsInit];
    [self gesturesInit];
    [self managersInit];
    [self initializeScoreLabel];
    [self initializeTimerLabel];
    [self initializeCodeField];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self setupBackground];
    [self updateTimerLabelFrame];
    [self updateCodeFieldFrame];
    [self updateScoreLabelFrame];
    [self childControllersInit];
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

- (void)childControllersInit {
    self.storyVC = [[SKStoryMenuViewController alloc] init];
    self.storyVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SKStoryMenuViewController"];
    [self addChildViewController:self.storyVC];
}

#pragma mark - Score label

- (void)initializeScoreLabel {
    self.scoreLabel = [[UILabel alloc] init];
    self.scoreLabel.font = [UIFont fontWithName:@"Avenir Next" size:17.0];
    self.scoreLabel.textColor = [UIColor whiteColor];
    self.scoreLabel.textAlignment = NSTextAlignmentCenter;
}

- (void)updateScoreLabelFrame {
    CGFloat navigationBarHeight = self.navigationController.navigationBar.frame.size.height;
    CGFloat codeTextFieldX = (CGRectGetWidth(self.view.frame) - SKScoreTextLableWidth);
    CGFloat codeTextFieldY = (navigationBarHeight + SKScoreTextLableHeight + 10);
    self.scoreLabel.frame = CGRectMake(codeTextFieldX, codeTextFieldY, SKScoreTextLableWidth, SKScoreTextLableHeight);
    [self.view addSubview:self.scoreLabel];
}

#pragma mark - Timer label

- (void)initializeTimerLabel {
    self.timerLabel = [[UILabel alloc] init];
    self.timerLabel.font = [UIFont fontWithName:@"Avenir Next" size:80.0];
    self.timerLabel.textColor = [UIColor whiteColor];
    self.timerLabel.textAlignment = NSTextAlignmentCenter;
    self.timerLabel.text = @"108:00";
}

- (void)updateTimerLabelFrame {
    CGFloat navigationBarHeight = self.navigationController.navigationBar.frame.size.height;
    CGFloat timerTextFieldX = (CGRectGetWidth(self.view.frame) - SKTimerTextLableWidth) / 2;
    CGFloat timerTextFieldY = SKScoreTextLableHeight + navigationBarHeight + 30;
    self.timerLabel.frame = CGRectMake(timerTextFieldX, timerTextFieldY, SKTimerTextLableWidth, SKTimerTextLableHeight);
    [self.view addSubview:self.timerLabel];
}

#pragma mark - Code textfield

- (void)initializeCodeField {
    self.codeTextField = [[VMaskTextField alloc] init];
    self.codeTextField.placeholder = [NSString stringWithFormat:NSLocalizedString(@"ENTERTHECODEHERE", nil)];
    self.codeTextField.font = [UIFont fontWithName:@"Avenir Next" size:25.0];
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
}

- (void)updateCodeFieldFrame {
    CGFloat codeTextFieldX = (CGRectGetWidth(self.view.frame) - SKCodeTextFieldWidth) / 2;
    CGFloat codeTextFieldY = (CGRectGetHeight(self.view.frame) - SKCodeTextFieldHeight) / 1.15;
    self.codeTextField.frame = CGRectMake(codeTextFieldX, codeTextFieldY, SKCodeTextFieldWidth, SKCodeTextFieldHeight);
    [self.view addSubview:self.codeTextField];
}

#pragma mark - Background

- (void)setupBackground {
    self.backgroundView.frame = self.view.frame;
    self.backgroundView.image = [UIImage imageNamed:backgroundPath()];
    [self.view addSubview:self.backgroundView];
}

#pragma mark - SKBunkerDataManagerDelegate

- (void)updateScoreLabelWithScore:(NSInteger)score {
    __weak SKBunkerViewController *weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        weakSelf.scoreLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Score :%@", nil), @((int)score)];
    });
}

- (void)updateTimerLabelWithComponents:(NSDateComponents *)components {
    __weak SKBunkerViewController *weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        weakSelf.timerLabel.text = [NSString stringWithFormat:@"%003i:%02i",
                                    (int)components.minute, (int)components.second];
    });
}

- (void)codeDidEnteredSuccess:(BOOL)flag {
    if (flag) {
        NSInteger userScore = [SKUserDataManager sharedManager].user.score;
        NSInteger maxScore = [SKUserDataManager sharedManager].user.maxScore;
        if (userScore > maxScore || maxScore == 0) {
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
    NGSPopoverView *popover = [[NGSPopoverView alloc] initWithCornerRadius:10.f
                                                                 direction:NGSPopoverArrowPositionTop
                                                                 arrowSize:CGSizeMake(0, 0)];
    popover.contentView = label;
    popover.fillScreen = YES;
    [popover showFromView:sender animated:YES];
}

#pragma mark - Menu

- (void)showMenu {
    __weak SKBunkerViewController *weakSelf = self;
    [UIView animateWithDuration:0.3f animations:^{
        weakSelf.storyVC.view.frame = CGRectMake(0,
                                                 0,
                                                 UIScreen.mainScreen.bounds.size.width,
                                                 UIScreen.mainScreen.bounds.size.height);
        [weakSelf.view addSubview:self.storyVC.view];
    } completion:^(BOOL finished) {
        weakSelf.isMenuHidden = NO;
    }];
}

- (void)hideMenu {
    __weak SKBunkerViewController *weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.storyVC.view.frame = CGRectMake(-UIScreen.mainScreen.bounds.size.width,
                                                 0,
                                                 UIScreen.mainScreen.bounds.size.width,
                                                 UIScreen.mainScreen.bounds.size.height);
    } completion:^(BOOL finished) {
        [weakSelf.storyVC.view removeFromSuperview];
        weakSelf.isMenuHidden = YES;
    }];
}

#pragma mark - Keyboard

- (void)keyboardHide:(NSNotification *)notification {
    __weak SKBunkerViewController *weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        [weakSelf updateCodeFieldFrame];
    }];
}

- (void)keyboardShow:(NSNotification *)notification {
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    __weak SKBunkerViewController *weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        CGRect codeFieldFrame = weakSelf.codeTextField.frame;
        codeFieldFrame.origin.y -= keyboardSize.height;
        weakSelf.codeTextField.frame = codeFieldFrame;
    }];
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
