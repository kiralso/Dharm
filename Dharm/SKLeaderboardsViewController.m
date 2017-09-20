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
#import "SKGameKitHelper.h"
#import "CBStoreHouseRefreshControl.h"
#import "SKLeaderboardCell.h"

@interface SKLeaderboardsViewController ()<UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSArray *usersArray;

@property (nonatomic, strong) CBStoreHouseRefreshControl *storeHouseRefreshControl;

@end

@implementation SKLeaderboardsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setBackgroundImageViewWithImageName:backgroundPath()];

    self.usersArray = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self loadPlayers];
    
    self.storeHouseRefreshControl = [CBStoreHouseRefreshControl attachToScrollView:self.tableView
                                                                            target:self
                                                                     refreshAction:@selector(refreshTriggered)
                                                                             plist:@"storehouse"
                                                                             color:[UIColor whiteColor]
                                                                         lineWidth:3.0
                                                                        dropHeight:50
                                                                             scale:1
                                                              horizontalRandomness:150
                                                           reverseLoadingAnimation:YES
                                                           internalAnimationFactor:0.5];
}

-(void)loadPlayers {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

    NSString *identifier = [SKGameKitHelper sharedGameKitHelper].leaderboardIdentifier;

    __weak SKLeaderboardsViewController *weakSelf = self;
    
    [[SKGameKitHelper sharedGameKitHelper] loadLeaderboardWithIdentifier:identifier
                                                     andCompetionHandler:^(NSArray<GKScore *> *scores,
                                                                           NSError *error) {
        
        if (error) {
            NSLog(@"ERROR - %@", error.localizedDescription);
        } else {
            weakSelf.usersArray = scores;
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            [[weakSelf tableView] reloadData];
        }
    }];

}

-(UIImage *)playerAvatarWithIndex:(NSInteger)index {
    
    switch (index) {
        case 0:
            return [UIImage imageNamed:@"hurley"];
        case 1:
            return [UIImage imageNamed:@"John Lock"];
        case 2:
            return [UIImage imageNamed:@"ben"];
        case 3:
            return [UIImage imageNamed:@"jack"];
        case 4:
            return [UIImage imageNamed:@"kate"];
        case 5:
            return [UIImage imageNamed:@"sawer"];
        case 6:
            return [UIImage imageNamed:@"sayid"];
        case 7:
            return [UIImage imageNamed:@"juliet"];
        case 8:
            return [UIImage imageNamed:@"faraday"];
        case 9:
            return [UIImage imageNamed:@"charlie"];
        case 10:
            return [UIImage imageNamed:@"claire"];
        case 11:
            return [UIImage imageNamed:@"sun"];
        case 12:
            return [UIImage imageNamed:@"jin"];
        case 13:
            return [UIImage imageNamed:@"desmond"];
        case 14:
            return [UIImage imageNamed:@"eco"];
        case 15:
            return [UIImage imageNamed:@"richard"];
        case 16:
            return [UIImage imageNamed:@"russo"];
        case 17:
            return [UIImage imageNamed:@"Ethan"];
        case 18:
            return [UIImage imageNamed:@"lapidus"];
        case 19:
            return [UIImage imageNamed:@"michael"];
        default:
            return nil;
    }
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.usersArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SKLeaderboardCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SKLeaderboardCell"
                                                              forIndexPath:indexPath];
    
    GKScore *score = [self.usersArray objectAtIndex:indexPath.row];
    
    cell.playerAliasLabel.text = [NSString stringWithFormat:@"%@", score.player.alias];
    cell.scoreLabel.text = [NSString stringWithFormat:@"%lld", score.value];
    cell.rowNumberLabel.text = [NSString stringWithFormat:@"%ld", indexPath.row + 1];
    cell.playerAvatarImage.image = [self playerAvatarWithIndex:indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.f;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.storeHouseRefreshControl scrollViewDidScroll];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self.storeHouseRefreshControl scrollViewDidEndDragging];
}

#pragma mark - CBStoreHouseRefreshControl

- (void)refreshTriggered {

    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

    [self performSelector:@selector(finishRefreshControl) withObject:nil afterDelay:1.0 inModes:@[NSRunLoopCommonModes]];
}

- (void)finishRefreshControl {
    
    [self loadPlayers];
    [self.storeHouseRefreshControl finishingLoading];
}
@end
