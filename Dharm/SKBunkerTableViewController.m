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
#import "SKGameKitHelper.h"

@import GoogleMobileAds;

@interface SKBunkerTableViewController () <GADBannerViewDelegate>

@property(nonatomic, strong) GADBannerView *bannerView;

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadTableView:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    
    UIColor *color = RGBA(207.f, 216.f, 220.f, 1.f);
    [self drawStatusBarOnNavigationViewWithColor:color];
    
    [self setBackgroundImageViewWithImageName:backgroundPath()];
}

- (void)viewDidAppear:(BOOL)animated {
    [self.tableView reloadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showAuthenticationViewController)
                                                 name:SKPresentAuthenticationViewControllerNotification
                                               object:nil];
    
    [[SKGameKitHelper sharedGameKitHelper] authenticateLocalPlayer];
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
            
            self.adCell.adView.adUnitID = kAdMobAdIdentifier;
            self.adCell.adView.adSize = kGADAdSizeSmartBannerPortrait;
            self.adCell.adView.rootViewController = self;
            self.adCell.adView.delegate = self;
            
            GADRequest *request = [GADRequest request];
            //request.testDevices = @[ kGADSimulatorID, @"9291ab358d305b95d038fc96c2e16e44" ];
            [self.adCell.adView loadRequest:request];
            
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
            return 60;//screenHeight * 0.1f;
    }
    
    return 1.f;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

#pragma mark - Notifications

- (void) reloadTableView:(NSNotification *) notification {

    [[SKMainObserver sharedObserver] checkScore];

    [self.scoreCell updateScoreLabel];

    [self.tableView reloadData];
}

- (void)showAuthenticationViewController {
    
    [self presentViewController:[SKGameKitHelper sharedGameKitHelper].authenticationViewController
                       animated:YES
                     completion:nil];
}

#pragma mark - Actions

- (IBAction)showInfoPopoverAction:(UIButton *)sender {

    UILabel *label = [[UILabel alloc] init];
    label.text = [NSString stringWithFormat:NSLocalizedString(@"POPOVER", nil), kMinutesBeforeFireDateToWarn];
    label.numberOfLines = 0;
    
    NGSPopoverView *popover = [[NGSPopoverView alloc] initWithCornerRadius:0.f
                                                                 direction:NGSPopoverArrowPositionAutomatic
                                                                 arrowSize:CGSizeMake(20, 10)];
    popover.contentView = label;
    popover.fillScreen = YES;
    
    [popover showFromView:sender animated:YES];
}

#pragma mark - GADBannerViewDelegate

- (void)adViewDidReceiveAd:(GADBannerView *)bannerView {
    NSLog(@"====== Success loading ======");
    self.adCell.adView = self.bannerView;
}

- (void)adView:(GADBannerView *)bannerView didFailToReceiveAdWithError:(GADRequestError *)error {
    NSLog(@"====== Loading failure , error - %@ ======", [error localizedDescription]);
}

@end
