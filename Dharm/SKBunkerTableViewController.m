//
//  SKBunkerTableViewController.m
//  Dharm
//
//  Created by Кирилл on 09.04.17.
//  Copyright © 2017 Kirill Solovyov. All rights reserved.
//

//Controllers
#import "SKBunkerTableViewController.h"
#import "SKStoryMenuViewController.h"

//Models
#import "SKUtils.h"
#import "NGSPopoverView.h"
#import "SKUserDataManager.h"
#import "SKBunkerTableDataManager.h"
#import "SKStoryHelper.h"
#import "SKAlertHelper.h"
#import "SKGameKitHelper.h"
#import "SKLocalNotificationHelper.h"
#import "UITableViewController+SKTableViewCategory.h"

@interface SKBunkerTableViewController () <UITextFieldDelegate, SKStoryHelperDelegate, SKBunkerTableDataManagerDelegate>

@property (strong, nonatomic) SKStoryMenuViewController *storyVC;
@property (assign, nonatomic) BOOL isMenuHidden;
@property (strong, nonatomic) UISwipeGestureRecognizer *rightSwipe;
@property (strong, nonatomic) UISwipeGestureRecognizer *leftSwipe;
@property (strong, nonatomic) SKBunkerTableDataManager *tableManager;
@property (strong, nonatomic) SKStoryHelper *storyHelper;
@property (strong, nonatomic) SKAlertHelper *alertHelper;
@property (strong, nonatomic) SKGameKitHelper *gameCenterHelper;
@property (strong, nonatomic) SKLocalNotificationHelper *localNotificationHelper;

@end

@implementation SKBunkerTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadTableView:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    [self flagsInit];
    [self gesturesInit];
    [self managersInit];
    [self childControllersInit];
    [self setBackgroundImageViewWithImageName:backgroundPath()];
    [self.storyHelper showTutorial];
}

- (void)viewDidAppear:(BOOL)animated {
    [self.gameCenterHelper authenticateLocalPlayer];
    [super viewDidAppear:animated];
    [self.tableView reloadData];
}

#pragma mark - Initialization

- (void)flagsInit {
    self.tableView.allowsSelection = NO;
    self.isMenuHidden = YES;
}

- (void)gesturesInit {
    self.rightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    self.leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    self.rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;
    self.leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:self.rightSwipe];
    [self.view addGestureRecognizer:self.leftSwipe];
}

- (void)managersInit {
    self.tableManager = [[SKBunkerTableDataManager alloc] init];
    self.storyHelper = [[SKStoryHelper alloc] init];
    self.alertHelper = [[SKAlertHelper alloc] init];
    self.gameCenterHelper = [SKGameKitHelper sharedManager];
    self.localNotificationHelper = [[SKLocalNotificationHelper alloc] init];
    self.tableManager.delegate = self;
    self.tableView.delegate = self.tableManager;
    self.tableView.dataSource = self.tableManager;
    self.storyHelper.delegate = self;
}

- (void)childControllersInit {
    self.storyVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SKStoryMenuViewController"];
    [self addChildViewController:self.storyVC];
}

#pragma mark - SKBunkerTableDataManagerDelegate

- (void)codeDidEnteredSuccess:(BOOL)flag {
    if (flag) {
        NSInteger userScore = [SKUserDataManager sharedManager].user.score + 1;
        NSInteger maxScore = [SKUserDataManager sharedManager].user.maxScore;
        if (userScore > maxScore || maxScore == 0) {
            [self.storyHelper updatePagesIndexesWithNextIndex];
            [self.storyHelper showLastStory];
        }
        __weak SKBunkerTableViewController *weakSelf = self;
        [self.localNotificationHelper updateNotificationDatesWithCompletion:^(NSArray *dates) {
            [weakSelf.tableView reloadData];
            [[SKUserDataManager sharedManager] updateUserWithScore:userScore];
        }];
        [self.gameCenterHelper reportScore:(int64_t)userScore];
    } else {
        [self.alertHelper showCantEnterCodeAlertOnViewController:self];
    }
}

- (void)codeDidnNotEnteredTimes:(NSInteger)times {
    [self.storyHelper showDisasterWithPower:times];
}

#pragma mark - Notifications

- (void) reloadTableView:(NSNotification *)notification {
    [self.tableView reloadData];
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
    [UIView animateWithDuration:0.3f animations:^{
        self.storyVC.view.frame = CGRectMake(0,
                                             0,
                                             UIScreen.mainScreen.bounds.size.width,
                                             UIScreen.mainScreen.bounds.size.height);
        [self.view addSubview:self.storyVC.view];
    } completion:^(BOOL finished) {
        self.isMenuHidden = NO;
    }];
}

- (void)hideMenu {
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

- (void)handleSwipe:(UISwipeGestureRecognizer *)sender {
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

@end
