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
#import "SKStoryManager.h"
#import "SKAlertManager.h"
#import "SKLocalNotificationManager.h"

typedef NS_ENUM(NSInteger, SKTableSection) {
    SKTableSectionPartOne,
    SKTableSectionPartTwo,
    SKTableSectionPartThree,
    SKTableSectionResetStory,
    SKTableSectionNumberOfSections,
};

@interface SKStoryMenuViewController () <UITableViewDelegate, UITableViewDataSource, SKStoryManagerDelegate>

@property (strong, nonatomic) NSArray *pagesArray;
@property (assign, nonatomic) NSInteger numberOfPagesInPartOne;
@property (assign, nonatomic) NSInteger numberOfPagesInPartTwo;
@property (assign, nonatomic) NSInteger numberOfPagesInPartThree;
@property (strong, nonatomic) SKStoryManager *storyManager;
@property (strong, nonatomic) SKAlertManager *alertManager;

@end

@implementation SKStoryMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.menuTableView.delegate = self;
    self.menuTableView.dataSource = self;
    self.alertManager = [[SKAlertManager alloc] init];
    self.storyManager = [[SKStoryManager alloc] init];
    self.storyManager.delegate = self;
    self.pagesArray = [self.storyManager loadPages];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.pagesArray = [self.storyManager loadPages];
    self.menuTableView.frame = CGRectMake(0,
                                          self.navigationController.navigationBar.frame.size.height + 20,
                                          self.view.frame.size.width / 1.5,
                                          self.view.frame.size.height - self.tabBarController.tabBar.frame.size.height);
    [self.menuTableView reloadData];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == SKTableSectionResetStory) {
        __weak SKStoryMenuViewController *weakSelf = self;
        [self.alertManager showResetStoryAlertOnViewController:self
                                                withOkHandler:^(UIAlertAction * _Nonnull action) {
                                                    [[SKUserDataManager sharedManager] resetUser];
                                                    weakSelf.pagesArray = [weakSelf.storyManager loadPages];
                                                    [weakSelf.menuTableView reloadData];
                                                    UITableViewController *vc = (UITableViewController *)weakSelf.parentViewController;
                                                    [vc.tableView reloadData];
                                                    SKLocalNotificationManager *notificationManager = [[SKLocalNotificationManager alloc] init];
                                                    [notificationManager updateNotificationDatesWithCompletion:nil];
        }];
    } else {
        NSInteger index = [self storyIndexFromIndexPath:indexPath];
        [self.storyManager showStoryAtIndex:index];
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
