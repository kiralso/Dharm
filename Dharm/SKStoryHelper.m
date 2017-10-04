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
    
    if ([self.delegate respondsToSelector:@selector(pagesDidLoad:)]) {
        [self.delegate pagesDidLoad:pages];
    }
    
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
    
    BOOL isGameOver = [SKUserDataManager sharedManager].user.isGameOver;
    
    if (!isGameOver) {
        
        SKTutorialPageViewController *storyVC = [self.delegate.storyboard instantiateViewControllerWithIdentifier:@"SKTutorialPageViewController"];
        
        NSArray *indexes = [self pagesIndexesWithoutLast];
        NSArray *pages = [[SKStoryPage alloc] pagesWithArrayOfIndexes:indexes];
        
        if ([indexes count] != [pages count]) {
            return;
        }
        
        NSInteger initialIndex = [indexes count] - 1;

        storyVC.indexOfInitialViewController = initialIndex;
        storyVC.storyPages = pages;
        
        if ([self.delegate respondsToSelector:@selector(pagesDidLoad:)]) {
            [self.delegate pagesDidLoad:pages];
        }
        
        [self.delegate presentViewController:storyVC animated:YES completion:nil];
    }
}

- (void)showStoryAtIndex:(NSInteger)index {
    
    SKTutorialPageViewController *storyVC = [self.delegate.storyboard instantiateViewControllerWithIdentifier:@"SKTutorialPageViewController"];
    storyVC.indexOfInitialViewController = index;
    storyVC.storyPages = [self loadPages];
    
    [self.delegate presentViewController:storyVC animated:YES completion:nil];
}

#pragma mark - Story Pages

- (void) updatePagesIndexesWithNewIndex:(NSInteger)index {
    
    NSMutableArray *indexes = [NSMutableArray arrayWithArray:[SKUserDataManager sharedManager].user.pagesIndexesArray];
    NSNumber *newIndex = @(index);
    
    [indexes addObject:newIndex];
    
    [SKUserDataManager sharedManager].user.pagesIndexesArray = indexes;
    
    [[SKUserDataManager sharedManager] saveUser];
}

- (void) updatePagesIndexesWithNextIndex {
    
    NSMutableArray *indexes = [NSMutableArray arrayWithArray:[SKUserDataManager sharedManager].user.pagesIndexesArray];
    SKStoryPageNumber lastIndex = [[indexes lastObject] integerValue];
    NSNumber *nextIndex = nil;
    
    switch (lastIndex) {
        case SKStoryPageNumberNine:
            nextIndex = @(SKStoryPageNumberThirteen);
            break;
        case SKStoryPageNumberNineteen:
            nextIndex = @(SKStoryPageThanks);
            break;
        case SKStoryPageNumberTwenty:
            nextIndex = @(SKStoryPageThanks);
            break;
        case SKStoryPageNumberMax : // last possible page + 1
            [SKUserDataManager sharedManager].user.isGameOver = YES;
            return;
        default:
            nextIndex = @(lastIndex + 1);
            break;
    }
    
    [indexes addObject:nextIndex];
    
    [SKUserDataManager sharedManager].user.pagesIndexesArray = indexes;
    
    [[SKUserDataManager sharedManager] saveUser];
}

- (void) updatePagesIndexesWithNextIndexAndAnswer:(BOOL)yesNo {
    
    NSMutableArray *pagesIndexes = [NSMutableArray arrayWithArray:[SKUserDataManager sharedManager].user.pagesIndexesArray];
    NSMutableSet *answeredPages = [NSMutableSet setWithSet:[SKUserDataManager sharedManager].user.answeredPages];
    
    NSArray *tmpArray = [pagesIndexes subarrayWithRange:NSMakeRange(0, [pagesIndexes count] - 1)];
    NSMutableArray *subIndexes = [NSMutableArray arrayWithArray:tmpArray];
    
    NSInteger lastIndex = [[subIndexes lastObject] integerValue];
    NSInteger nextIndex = 0;
    
    switch (lastIndex) {
        case 5:
            if (yesNo) { //Stay in bunker
                nextIndex = 6;
            } else {
                nextIndex = 10;
            }
            break;
        case 13:
            if (yesNo) { //Save Desmond
                nextIndex = 14;
            } else {
                nextIndex = 21;
            }
            break;
        case 17:
            if (yesNo) { //Drink or not
                nextIndex = 18;
            } else {
                nextIndex = 20;
            }
            break;
            
        default:
            nextIndex = lastIndex + 1;
            break;
    }
    
    [answeredPages addObject:@(lastIndex)];
    [subIndexes addObject:@(nextIndex)];
    
    [SKUserDataManager sharedManager].user.pagesIndexesArray = subIndexes;
    [SKUserDataManager sharedManager].user.answeredPages = answeredPages;
    [[SKUserDataManager sharedManager] saveUser];
}

#pragma mark - Private

- (NSArray *)pagesIndexesWithoutLast {
    
    NSArray *pagesIndexesArray = [SKUserDataManager sharedManager].user.pagesIndexesArray;
    NSRange range = NSMakeRange(0, [pagesIndexesArray count] -1);
    NSArray *indexes = [pagesIndexesArray subarrayWithRange:range];
    
    return indexes;
}

@end
