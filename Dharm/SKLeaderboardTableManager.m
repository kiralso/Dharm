//
//  SKLeaderboardTableManager.m
//  Dharm
//
//  Created by Kirill Solovyov on 06.10.17.
//  Copyright © 2017 Kirill Solovyov. All rights reserved.
//

#import "SKLeaderboardTableManager.h"
#import "SKLeaderboardCell.h"
@import GameKit;

static NSInteger const SKNumberOfSections = 1;
static CGFloat const SKHeightForRow = 80.0f;

@implementation SKLeaderboardTableManager

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return SKNumberOfSections;
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
    return SKHeightForRow;
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

@end
