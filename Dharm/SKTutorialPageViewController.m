//
//  SKTutorialPageViewController.m
//  Dharm
//
//  Created by Кирилл on 27.06.17.
//  Copyright © 2017 Kirill Solovyov. All rights reserved.
//

#import "SKTutorialPageViewController.h"
#import "SKTutorialViewController.h"
#import "SKUserDataManager.h"
#import "SKStoryPage.h"

@interface SKTutorialPageViewController () <UIPageViewControllerDataSource>

@end

@implementation SKTutorialPageViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSource = self;
    SKTutorialViewController *initialViewController = [self viewControllerAtIndex:self.indexOfInitialViewController];
    [self setViewControllers:@[initialViewController]
                   direction:UIPageViewControllerNavigationDirectionForward
                    animated:YES
                  completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (SKTutorialViewController *)viewControllerAtIndex:(NSInteger)index {
    SKTutorialViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SKTutorialViewController"];
    viewController.pageIndex = index;
    viewController.isTutorial = self.isTutorial;
    if (self.storyPages) {
        viewController.pagesArray = self.storyPages;
    } else {
        NSArray *pagesIndexesArray = [SKUserDataManager sharedManager].user.pagesIndexesArray;
        NSMutableArray* pages = [NSMutableArray array];
        for (NSNumber *index in pagesIndexesArray) {
            SKStoryPage *page = [[SKStoryPage alloc] initWithIndex:[index integerValue]];
            [pages addObject:page];
        }
        viewController.pagesArray = pages;
    }
    return viewController;
}

#pragma mark - UIPageViewControllerDataSource

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController
     viewControllerBeforeViewController:(UIViewController *)viewController {
    NSInteger index = ((SKTutorialViewController *) viewController).pageIndex;
    if (index == 0 || index == NSNotFound) {
        return nil;
    }
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
       viewControllerAfterViewController:(UIViewController *)viewController {
    NSInteger index = ((SKTutorialViewController *) viewController).pageIndex;
    NSInteger maxIndex = [((SKTutorialViewController *) viewController).pagesArray count];
    if (index == NSNotFound) {
        return nil;
    }
    index++;
    if (index == maxIndex) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

@end
