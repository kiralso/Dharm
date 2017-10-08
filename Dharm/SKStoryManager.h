//
//  SKStoryManager.h
//  Dharm
//
//  Created by Кирилл on 16.07.17.
//  Copyright © 2017 Kirill Solovyov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol SKStoryManagerDelegate;
@class SKStoryPage;

@protocol SKStoryManagerDelegate
@optional
- (void)pagesDidLoad:(NSArray *)pages;
@end

@interface SKStoryManager : NSObject

@property (weak, nonatomic) UIViewController<SKStoryManagerDelegate> *delegate;

- (NSArray<SKStoryPage *> *)loadPages;

- (void)showTutorial;
- (void)showLastStory;
- (void)showStoryAtIndex:(NSInteger)index;
- (void)showDisasterWithPower:(NSInteger)index;

- (void)updatePagesIndexesWithNewIndex:(NSInteger)index;
- (void)updatePagesIndexesWithNextIndex;
- (void)updatePagesIndexesWithNextIndexAndAnswer:(BOOL) yesNo;

@end
