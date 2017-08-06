//
//  SKTutorialViewController.m
//  Dharm
//
//  Created by Кирилл on 24.06.17.
//  Copyright © 2017 Kirill Solovyov. All rights reserved.
//

#import "SKTutorialViewController.h"
#import "SKTutorialPageViewController.h"
#import "SKStoryPage.h"
#import "SKUserDataManager.h"

@implementation SKTutorialViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    
    if (self.isDisaster) {
        [self setupDisasterPage:self.disasterPower];
    } else {
        [self setupPageAtIndex:self.pageIndex];
    }
    
    self.textView.textColor = [UIColor whiteColor];
}

- (void) viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.textView setContentOffset:CGPointZero animated:NO];
}

#pragma mark - Actions

- (IBAction)doneAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)yesAction:(UIButton *)sender {
    
    [[SKUserDataManager sharedManager] updatePagesIndexesWithNextIndexAndAnswer:YES];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)noAction:(UIButton *)sender {
    
    [[SKUserDataManager sharedManager] updatePagesIndexesWithNextIndexAndAnswer:NO];

    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Other

- (void) setupPageAtIndex:(NSInteger)index {
    
    SKStoryPage *page = self.pagesArray[index];
    NSInteger numberOfPages = [self.pagesArray count];
    float progress = (float) (index + 1) / numberOfPages;

    self.imageView.image = [UIImage imageNamed:page.imageName];
    self.textView.text = page.storyText;
    self.progressBar.progress = progress;
    NSString *progressText = [NSString stringWithFormat:NSLocalizedString(@"PROGRESS", nil), index + 1, numberOfPages];
    self.progressLabel.text = progressText;
    
    if (!page.isChoise) {
        self.yesButton.hidden = YES;
        self.noButton.hidden = YES;
    } else {
        
        NSSet *answeredPages = [SKUserDataManager sharedManager].userAnsweredPages;
        NSNumber *pageNumber = [SKUserDataManager sharedManager].userPagesIndexesArray[index];
        
        if ([answeredPages member:pageNumber]) {
            self.yesButton.hidden = YES;
            self.noButton.hidden = YES;
        } else {
            self.doneButton.hidden = YES;
        }
    }
    
    if (self.isTutorial && index != SKStoryPageNumberFour) {
        self.doneButton.hidden = YES;
    }
}

- (void)setupDisasterPage:(NSInteger)power {
    
    if (power >= 3) {
        power = 3;
        [[SKUserDataManager sharedManager] resetUser];
    }
    
    SKStoryPage *page = [[SKStoryPage alloc] initWithIndex:SKStoryPageNumberMax + power];
    
    self.progressLabel.hidden = YES;
    self.progressBar.hidden = YES;
    self.yesButton.hidden = YES;
    self.noButton.hidden = YES;
    
    self.imageView.image = [UIImage imageNamed:page.imageName];
    self.textView.text = page.storyText;
}

@end
