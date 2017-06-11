//
//  SKLeaderboardsViewController.m
//  Dharm
//
//  Created by Кирилл on 01.04.17.
//  Copyright © 2017 Kirill Solovov. All rights reserved.
//

#import "SKLeaderboardsViewController.h"
#import "UITableViewController+SKTableViewCategory.h"
#import "UIViewController+SKViewControllerCategory.h"
#import "SKUtils.h"
#import "SKGameKitHelper.h"

@interface SKLeaderboardsViewController ()

@property (strong, nonatomic) NSArray *usersArray;
@end

@implementation SKLeaderboardsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setBackgroundImageViewWithImageName:backgroundPath()];
    
    UIColor *color = RGBA(207.f, 216.f, 220.f, 1.f);
    [self drawStatusBarOnNavigationViewWithColor:color];
    
    self.usersArray = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSString *identifier = [SKGameKitHelper sharedGameKitHelper].leaderboardIdentifier;
    
    [[SKGameKitHelper sharedGameKitHelper] loadLeaderboardWithIdentifier:identifier andCompetionHandler:^(NSArray<GKScore *> *scores, NSError *error) {
        
        if (error != nil) {
            NSLog(@"ERROR - %@", error.localizedDescription);
        } else {
            
            self.usersArray = scores;
            
            [[self tableView] reloadData];
        }
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.usersArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"userCell" forIndexPath:indexPath];
    
    GKScore *score = [self.usersArray objectAtIndex:indexPath.row];
    
    cell.textLabel.text = score.player.alias;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Score %lld", score.value];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

@end
