//
//  SKStoryHelper.h
//  Dharm
//
//  Created by Кирилл on 16.07.17.
//  Copyright © 2017 Kirill Solovyov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol SKStoryHelperDelegate;
@class SKStoryPage;

@protocol SKStoryHelperDelegate
@optional
- (void)pagesDidLoad:(NSArray *)pages;
@end

@interface SKStoryHelper : NSObject

@property (weak, nonatomic) UIViewController<SKStoryHelperDelegate> *delegate;

- (NSArray<SKStoryPage *> *)loadPages;

- (void)showTutorial;
- (void)showLastStory;
- (void)showStoryAtIndex:(NSInteger)index;
- (void)showDisasterWithPower:(NSInteger)index;

- (void)updatePagesIndexesWithNewIndex:(NSInteger)index;
- (void)updatePagesIndexesWithNextIndex;
- (void)updatePagesIndexesWithNextIndexAndAnswer:(BOOL) yesNo;

@end
