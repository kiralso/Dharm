//
//  SKLeaderboardsViewController.m
//  Dharm
//
//  Created by Кирилл on 01.04.17.
//  Copyright © 2017 Kirill Solovov. All rights reserved.
//

#import "SKLeaderboardsViewController.h"
#import "UITableViewController+SKTableViewCategory.h"
#import "SKUtils.h"
#import "SKGameKitManager.h"
#import "SKLeaderboardTableManager.h"

@interface SKLeaderboardsViewController() <SKGameKitManagerDelegate>

@property (strong, nonatomic) SKGameKitManager *gameCenterManager;
@property (strong, nonatomic) SKLeaderboardTableManager *tableManager;

@end

@implementation SKLeaderboardsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBackgroundImageViewWithImageName:backgroundPath()];
    self.gameCenterManager = [SKGameKitManager sharedManager];
    self.tableManager = [[SKLeaderboardTableManager alloc] init];
    self.tableView.delegate = self.tableManager;
    self.tableView.dataSource = self.tableManager;
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (isFirstTime()) {
        [self.gameCenterManager authenticateLocalPlayer];
    }
    [self loadPlayers];
    self.refreshControl = [[UIRefreshControl alloc]init];
    [self.tableView addSubview:self.refreshControl];
    [self.refreshControl addTarget:self
                            action:@selector(refreshTable)
                  forControlEvents:UIControlEventValueChanged];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

#pragma mark - Helpful functions

- (void)refreshTable {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self loadPlayers];
    [self.refreshControl endRefreshing];
    [self.tableView reloadData];
}

- (void)loadPlayers {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSString *identifier = self.gameCenterManager.leaderboardIdentifier;
    if (identifier) {
        __weak SKLeaderboardsViewController *weakSelf = self;
        [self.gameCenterManager loadLeaderboardWithIdentifier:identifier
                                         andCompetionHandler:^(NSArray<GKScore *> *scores,
                                                               NSError *error) {
                                             
                                             if (error) {
                                                 NSLog(@"ERROR - %@", error.localizedDescription);
                                             } else {
                                                 weakSelf.tableManager.usersArray = scores;
                                                 [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                                                 [[weakSelf tableView] reloadData];
                                             }
                                         }];
    }
}

#pragma mark - SKGameKitHelperDelegate

- (void)showAuthenticationController:(UIViewController *)authenticationController {
    [self presentViewController:authenticationController
                       animated:YES
                     completion:nil];
}

@end
