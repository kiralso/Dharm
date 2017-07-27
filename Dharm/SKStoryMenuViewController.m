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
#import "SKUtils.h"
#import "SKUserDataManager.h"
#import "SKMainObserver.h"
#import "SKStoryHelper.h"

enum: NSInteger {
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

@end

@implementation SKStoryMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.menuTableView.delegate = self;
    self.menuTableView.dataSource = self;
    
    self.storyHelper = [[SKStoryHelper alloc] init];
    self.storyHelper.delegate = self;
    
    self.pagesArray = [self.storyHelper loadPages];
}

-(void)viewDidAppear:(BOOL)animated {
    
    self.pagesArray = [self.storyHelper loadPages];

    [self.menuTableView reloadData];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == SKTableSectionResetStory) {
        
        [self showResetAlert];
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
    
    switch (section) {
        case SKTableSectionPartOne:
            return NSLocalizedString(@"CHAPTERONE", nil);
        case SKTableSectionPartTwo:
            return NSLocalizedString(@"CHAPTERTWO", nil);
        case SKTableSectionPartThree:
            return NSLocalizedString(@"CHAPTERTHREE", nil);
        case SKTableSectionResetStory:
            return NSLocalizedString(@"RESET", nil);
        default:
            return @"";
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    switch (section) {
        case SKTableSectionPartOne:
            return self.numberOfPagesInPartOne;
            
        case SKTableSectionPartTwo:
            return self.numberOfPagesInPartTwo;
            
        case SKTableSectionPartThree:
            return self.numberOfPagesInPartThree;
            
        case SKTableSectionResetStory:
            return 1;
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    
    switch (indexPath.section) {
            
        case SKTableSectionResetStory:
            
            cell = [self.menuTableView dequeueReusableCellWithIdentifier:@"SKStoryResetTableViewCell"
                                                            forIndexPath:indexPath];
            
            self.resetCell = (SKStoryResetTableViewCell *) cell;
            self.resetCell.resetLabel.text = @"RESET";
            return self.resetCell;
            
        default:
            
            cell = [self.menuTableView dequeueReusableCellWithIdentifier:@"SKStoryMenuTableViewCell"
                                                            forIndexPath:indexPath];
            self.menuCell = (SKStoryMenuTableViewCell *) cell;
            
            NSInteger index = [self storyIndexFromIndexPath:indexPath];
            NSString *title = [self.pagesArray[index] storyTitle];
            
            self.menuCell.titleLabel.text = [NSString stringWithFormat:@"%ld. %@", (index + 1), title];
            return self.menuCell;
    }
}

#pragma mark - Useful methods 

- (NSInteger)storyIndexFromIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
            
        case SKTableSectionPartOne:
            return indexPath.row;
            
        case SKTableSectionPartTwo:
            return indexPath.row + self.numberOfPagesInPartOne;
            
        case SKTableSectionPartThree:
            return indexPath.row + self.numberOfPagesInPartOne + self.numberOfPagesInPartTwo;
            
        case SKTableSectionResetStory:
            return 0;
        default:
            break;
    }
    
    return 0;
}

- (void) showResetAlert {
    
    NSString *alertTitle = NSLocalizedString(@"RESETTITLE", nil);
    NSString *alertMessage = NSLocalizedString(@"RESETMESSAGE", nil);
    NSString *okTitle = NSLocalizedString(@"OK", nil);
    NSString *cancelTitle = NSLocalizedString(@"CANCEL", nil);

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:alertTitle
                                                                   message:alertMessage
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:okTitle
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         
                                                         [[SKUserDataManager sharedManager] resetUser];
                                                         
                                                         self.pagesArray = [self.storyHelper loadPages];
                                                         
                                                         [self.menuTableView reloadData];
                                                         
                                                         [[SKMainObserver sharedObserver] updateData];
                                                     }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelTitle
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil];
    
    [alert addAction:okAction];
    [alert addAction:cancelAction];

    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - SKStoryHelperDelegate

- (void)pagesDidLoad:(NSArray *)pages {
    
    self.numberOfPagesInPartOne = 0;
    self.numberOfPagesInPartTwo = 0;
    self.numberOfPagesInPartThree = 0;

    for (SKStoryPage *page in pages) {
        
        switch (page.chapter) {
            case SKTableSectionPartOne + 1:
                self.numberOfPagesInPartOne++;
                break;
            case SKTableSectionPartTwo + 1:
                self.numberOfPagesInPartTwo++;
                break;
            case SKTableSectionPartThree + 1:
                self.numberOfPagesInPartThree++;
                break;
            default:
                break;
        }
    }
}

@end