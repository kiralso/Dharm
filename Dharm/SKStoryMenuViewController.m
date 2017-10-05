//
//  SKStoryMenuViewController.m
//  Dharm
//
//  Created by Кирилл on 06.07.17.
//  Copyright © 2017 Kirill Solovyov. All rights reserved.
//

#import "SKStoryMenuViewController.h"
#import "SKStoryMenuTableViewCell.h"
#import "SKStoryResetTableViewCell.h"
#import "SKTutorialPageViewController.h"
#import "SKStoryPage.h"
#import "SKUserDataManager.h"
#import "SKStoryHelper.h"
#import "SKAlertHelper.h"
#import "SKLocalNotificationHelper.h"

typedef NS_ENUM(NSInteger, SKTableSection) {
    SKTableSectionPartOne,
    SKTableSectionPartTwo,
    SKTableSectionPartThree,
    SKTableSectionResetStory,
    SKTableSectionNumberOfSections,
};

@interface SKStoryMenuViewController () <UITableViewDelegate, UITableViewDataSource, SKStoryHelperDelegate>

@property (strong, nonatomic) NSArray *pagesArray;
@property (assign, nonatomic) NSInteger numberOfPagesInPartOne;
@property (assign, nonatomic) NSInteger numberOfPagesInPartTwo;
@property (assign, nonatomic) NSInteger numberOfPagesInPartThree;
@property (strong, nonatomic) SKStoryHelper *storyHelper;
@property (strong, nonatomic) SKAlertHelper *alertHelper;

@end

@implementation SKStoryMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.menuTableView.delegate = self;
    self.menuTableView.dataSource = self;
    self.alertHelper = [[SKAlertHelper alloc] init];
    self.storyHelper = [[SKStoryHelper alloc] init];
    self.storyHelper.delegate = self;
    self.pagesArray = [self.storyHelper loadPages];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.pagesArray = [self.storyHelper loadPages];
    [self.menuTableView reloadData];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == SKTableSectionResetStory) {
        __weak SKStoryMenuViewController *weakSelf = self;
        [self.alertHelper showResetStoryAlertOnViewController:self
                                                withOkHandler:^(UIAlertAction * _Nonnull action) {
                                                    [[SKUserDataManager sharedManager] resetUser];
                                                    weakSelf.pagesArray = [weakSelf.storyHelper loadPages];
                                                    [weakSelf.menuTableView reloadData];
                                                    UITableViewController *vc = (UITableViewController *)weakSelf.parentViewController;
                                                    [vc.tableView reloadData];
                                                    SKLocalNotificationHelper *notificationHelper = [[SKLocalNotificationHelper alloc] init];
                                                    [notificationHelper updateNotificationDatesWithCompletion:nil];
        }];
    } else {
        NSInteger index = [self storyIndexFromIndexPath:indexPath];
        [self.storyHelper showStoryAtIndex:index];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return SKTableSectionNumberOfSections;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *header = @"";
    if (section == SKTableSectionPartOne) {
        header = NSLocalizedString(@"CHAPTERONE", nil);
    } else if (section == SKTableSectionPartTwo) {
        header = NSLocalizedString(@"CHAPTERTWO", nil);
    } else if (section == SKTableSectionPartThree) {
        header = NSLocalizedString(@"CHAPTERTHREE", nil);
    }
    return header;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger numberOfRows = 0;
    if (section == SKTableSectionPartOne) {
        numberOfRows = self.numberOfPagesInPartOne;
    } else if (section == SKTableSectionPartTwo) {
        numberOfRows = self.numberOfPagesInPartTwo;
    } else if (section == SKTableSectionPartThree) {
        numberOfRows = self.numberOfPagesInPartThree;
    } else if (section == SKTableSectionResetStory) {
        numberOfRows = 1;
    }
    return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (indexPath.section == SKTableSectionResetStory) {
        cell = [self.menuTableView dequeueReusableCellWithIdentifier:@"SKStoryResetTableViewCell"
                                                        forIndexPath:indexPath];
        self.resetCell = (SKStoryResetTableViewCell *) cell;
        self.resetCell.resetLabel.text = NSLocalizedString(@"RESET", nil);
        cell = self.resetCell;
    } else {
        cell = [self.menuTableView dequeueReusableCellWithIdentifier:@"SKStoryMenuTableViewCell"
                                                        forIndexPath:indexPath];
        self.menuCell = (SKStoryMenuTableViewCell *) cell;
        NSInteger index = [self storyIndexFromIndexPath:indexPath];
        NSString *title = [self.pagesArray[index] storyTitle];
        self.menuCell.titleLabel.text = [NSString stringWithFormat:@"%ld. %@", (index + 1), title];
        cell = self.menuCell;
    }
    return cell;
}

#pragma mark - Useful methods 

- (NSInteger)storyIndexFromIndexPath:(NSIndexPath *)indexPath {
    NSInteger index = 0;
    if (indexPath.section == SKTableSectionPartOne) {
        index = indexPath.row;
    } else if (indexPath.section == SKTableSectionPartTwo) {
        index = indexPath.row + self.numberOfPagesInPartOne;
    } else if (indexPath.section == SKTableSectionPartThree) {
        index = indexPath.row + self.numberOfPagesInPartOne + self.numberOfPagesInPartTwo;
    } else if (indexPath.section == SKTableSectionResetStory) {
        index = 0;
    }
    return index;
}

#pragma mark - SKStoryHelperDelegate

- (void)pagesDidLoad:(NSArray *)pages {
    self.numberOfPagesInPartOne = 0;
    self.numberOfPagesInPartTwo = 0;
    self.numberOfPagesInPartThree = 0;
    for (SKStoryPage *page in pages) {
        if (page.chapter == SKTableSectionPartOne + 1) {
            self.numberOfPagesInPartOne++;
        } else if (page.chapter == SKTableSectionPartTwo + 1) {
            self.numberOfPagesInPartTwo++;
        } else if (page.chapter == SKTableSectionPartThree + 1) {
            self.numberOfPagesInPartThree++;
        }
    }
}

@end
