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

@interface SKStoryHelper : NSObject

@property (weak, nonatomic) UIViewController<SKStoryHelperDelegate> *delegate;

- (NSArray<SKStoryPage *> *)loadPages;

- (void)showTutorial;
- (void)showLastStory;
- (void)showStoryAtIndex:(NSInteger)index;
- (void)showDisasterWithPower:(NSInteger)index;

@end

@protocol SKStoryHelperDelegate

@optional
- (void)pagesDidLoad:(NSArray *)pages;

@end
