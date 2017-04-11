//
//  SKBunkerTableViewController.m
//  Dharm
//
//  Created by Кирилл on 09.04.17.
//  Copyright © 2017 Kirill Solovyov. All rights reserved.
//

#import "SKBunkerTableViewController.h"
#import "SKScoreCell.h"
#import "SKTimerCell.h"
#import "SKLogoCell.h"
#import "SKCodeCell.h"
#import "SKAdCell.h"
#import "SKUserDataManager.h"
#import "SKTimer.h"

@interface SKBunkerTableViewController ()

@property (assign, nonatomic) NSTimeInterval timerEndInSeconds;
@property (assign, nonatomic) NSTimeInterval timerStartInSeconds;
@property (assign, nonatomic) NSTimeInterval timerIntervalInSeconds;

@end

typedef enum : NSUInteger {
    SKCellsScore,
    SKCellsTimer,
    SKCellsLogo,
    SKCellsCode,
    SKCellsAd
} SKCells;

static NSString * const scoreCellIdentifier = @"scoreCell";
static NSString * const timerCellIdentifier = @"timerCell";
static NSString * const logoCellIdentifier = @"logoCell";
static NSString * const codeCellIdentifier = @"codeCell";
static NSString * const adCellIdentifier = @"adCell";

@implementation SKBunkerTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[SKUserDataManager sharedManager] createUser];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    
    switch (indexPath.row) {
        case SKCellsScore:
            
            cell = [tableView dequeueReusableCellWithIdentifier:scoreCellIdentifier
                                                   forIndexPath:indexPath];
            
            self.scoreCell = (SKScoreCell *)cell;
            
            return self.scoreCell;
        case SKCellsTimer:
            
            cell = [tableView dequeueReusableCellWithIdentifier:timerCellIdentifier
                                                   forIndexPath:indexPath];
            
            self.timerCell = (SKTimerCell *)cell;
            
            return self.timerCell;
        case SKCellsLogo:
            
            cell = [tableView dequeueReusableCellWithIdentifier:logoCellIdentifier
                                                   forIndexPath:indexPath];
                        
            self.logoCell = (SKLogoCell *)cell;
            
            return self.logoCell;
        case SKCellsCode:
            
            cell = [tableView dequeueReusableCellWithIdentifier:codeCellIdentifier
                                                   forIndexPath:indexPath];
            
            self.codeCell = (SKCodeCell *)cell;
            
            return self.codeCell;
        case SKCellsAd:
            
            cell = [tableView dequeueReusableCellWithIdentifier:adCellIdentifier
                                                   forIndexPath:indexPath];
            
            self.adCell = (SKAdCell *)cell;
            
            return self.adCell;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGFloat screenHeight = rect.size.height;
    
    switch (indexPath.row) {
        case SKCellsScore:
            return screenHeight * 0.05f;
        case SKCellsTimer:
            return screenHeight * 0.15f;
        case SKCellsLogo:
            return screenHeight * 0.5f;
        case SKCellsCode:
            return screenHeight * 0.1f;
        case SKCellsAd:
            return screenHeight * 0.1f;
    }
    
    return 40.f;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

@end
