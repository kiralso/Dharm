//
//  SKTutorialPageViewController.h
//  Dharm
//
//  Created by Кирилл on 27.06.17.
//  Copyright © 2017 Kirill Solovyov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SKTutorialPageViewController : UIPageViewController

@property (assign, nonatomic) NSInteger indexOfInitialViewController;
@property (strong, nonatomic) NSArray *storyPages;
@property (assign, nonatomic) BOOL isTutorial;

@end
