//
//  SKStoryHelper.m
//  Dharm
//
//  Created by Кирилл on 16.07.17.
//  Copyright © 2017 Kirill Solovyov. All rights reserved.
//

#import "SKStoryHelper.h"
#import "SKStoryPage.h"
#import "SKUserDataManager.h"
#import "SKTutorialPageViewController.h"
#import "SKTutorialViewController.h"
#import "SKUtils.h"

@implementation SKStoryHelper

- (NSArray<SKStoryPage *> *)loadPages {
    
    NSArray *pagesIndexesArray = [self pagesIndexesWithoutLast];

    NSArray* pages = [[SKStoryPage alloc] pagesWithArrayOfIndexes:pagesIndexesArray];
    
    [self.delegate pagesDidLoad:pages];
    
    return pages;
}

- (void)showTutorial {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    BOOL isFirstTime = [defaults boolForKey:kIsFirstTime];
    
    SKTutorialPageViewController *tutorialVC = [self.delegate.storyboard instantiateViewControllerWithIdentifier:@"SKTutorialPageViewController"];

    if (!isFirstTime) {
        
        [defaults setBool:YES forKey:kIsFirstTime];
        
        tutorialVC.indexOfInitialViewController = SKStoryPageNumberTutorial;
        tutorialVC.isTutorial = YES;
        tutorialVC.storyPages = [self loadPages];
        
        [self.delegate presentViewController:tutorialVC animated:YES completion:nil];
    }
}

- (void)showDisasterWithPower:(NSInteger)power {
    
    SKTutorialViewController *viewController = [self.delegate.storyboard instantiateViewControllerWithIdentifier:@"SKTutorialViewController"];
    
    viewController.isDisaster = YES;
    viewController.disasterPower = power;
    
    [self.delegate presentViewController:viewController animated:YES completion:nil];
}

- (void)showLastStory {
    
    NSInteger score = [SKUserDataManager sharedManager].userScore;
    BOOL isGameOver = [SKUserDataManager sharedManager].isGameOver;
    
    if (score != 0 && !isGameOver) {
        
        SKTutorialPageViewController *storyVC = [self.delegate.storyboard instantiateViewControllerWithIdentifier:@"SKTutorialPageViewController"];
        
        NSArray *indexes = [self pagesIndexesWithoutLast];
        NSArray *pages = [[SKStoryPage alloc] pagesWithArrayOfIndexes:indexes];
        
        if ([indexes count] != [pages count]) {
            return;
        }
        
        NSInteger initialIndex = [indexes count] - 1;

        storyVC.indexOfInitialViewController = initialIndex;
        storyVC.storyPages = pages;
        
        [self.delegate pagesDidLoad:pages];
        
        [self.delegate presentViewController:storyVC animated:YES completion:nil];
    }
}

- (void)showStoryAtIndex:(NSInteger)index {
    
    SKTutorialPageViewController *storyVC = [self.delegate.storyboard instantiateViewControllerWithIdentifier:@"SKTutorialPageViewController"];
    storyVC.indexOfInitialViewController = index;
    storyVC.storyPages = [self loadPages];
    
    [self.delegate presentViewController:storyVC animated:YES completion:nil];
}

#pragma mark - Private

- (NSArray *)pagesIndexesWithoutLast {
    
    NSArray *pagesIndexesArray = [SKUserDataManager sharedManager].userPagesIndexesArray;
    NSRange range = NSMakeRange(0, [pagesIndexesArray count] -1);
    NSArray *indexes = [pagesIndexesArray subarrayWithRange:range];
    
    return indexes;
}

@end
