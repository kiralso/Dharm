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
#import "SKMainObserver.h"
#import "NGSPopoverView.h"
#import "UIView+Shake.h"

@interface SKBunkerTableViewController ()

@property (nonatomic, assign, getter = isThrowingGestureEnabled) BOOL throwingGestureEnabled;
@property (nonatomic, assign, getter = isTapBlurToDismissEnabled) BOOL tapBlurToDismissEnabled;

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadTableView:)
                                                 name:SKMainObserverReloadViewControlerNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(shakeView:)
                                                 name:SKTimerTextChangedNotification
                                               object:nil];
    
    self.tapBlurToDismissEnabled = YES;
    self.throwingGestureEnabled = YES;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
            
            [self.timerCell startTimerToNextFireDate];
            
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
            return screenHeight * 0.05f;
    }
    
    return 10.f;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

#pragma mark - Notifications

- (void) reloadTableView:(NSNotification *) notification {
    
    [self.scoreCell updateScoreLabel];

    [self.tableView reloadData];
}

- (void) shakeView:(NSNotification *) notification {
    
    NSDateComponents *dateComponents = [notification.userInfo objectForKey:SKTimerTextUserInfoKey];

    if(!dateComponents.minute && dateComponents.second < 10) {
       [self.view shake:10
               withDelta:20
                   speed:0.1
          shakeDirection:ShakeDirectionVertical];
    }
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
