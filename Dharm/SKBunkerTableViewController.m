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
#import "SKTimer.h"
#import "SKUtils.h"
#import "SKMainObserver.h"
#import "NGSPopoverView.h"
#import "UIView+Shake.h"
#import "UIViewController+SKViewControllerCategory.h"
#import "UITableViewController+SKTableViewCategory.h"

@interface SKBunkerTableViewController ()

@property (nonatomic, assign, getter = isThrowingGestureEnabled) BOOL throwingGestureEnabled;
@property (nonatomic, assign, getter = isTapBlurToDismissEnabled) BOOL tapBlurToDismissEnabled;

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
    
    self.tapBlurToDismissEnabled = YES;
    self.throwingGestureEnabled = YES;
    
    UIColor *color = RGBA(207.f, 216.f, 220.f, 1.f);
    [self drawStatusBarOnNavigationViewWithColor:color];
    
    [self setBackgroundImageViewWithImageName:backgroundPath()];
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
            
            return self.scoreCell;
        case SKCellsTimer:
            
            cell = [tableView dequeueReusableCellWithIdentifier:timerCellIdentifier
                                                   forIndexPath:indexPath];
            
            self.timerCell = (SKTimerCell *)cell;
            
            [self.timerCell startTimerToNextFireDate];
            
            return self.timerCell;
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
            return screenHeight * 0.1f;
    }
    
    return 1.f;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

#pragma mark - Notifications

- (void) reloadTableView:(NSNotification *) notification {
    
    [self.scoreCell updateScoreLabel];

    [self.tableView reloadData];
}

- (IBAction)showInfoPopoverAction:(UIButton *)sender {

    UILabel *label = [[UILabel alloc] init];
    label.text = @"4 8 15 16 23 42";
    label.numberOfLines = 0;
    
    NGSPopoverView *popover = [[NGSPopoverView alloc] initWithCornerRadius:0.f
                                                                 direction:NGSPopoverArrowPositionAutomatic
                                                                 arrowSize:CGSizeMake(20, 10)];
    popover.contentView = label;
    popover.fillScreen = YES;
    
    [popover showFromView:sender animated:YES];
    
}

@end
