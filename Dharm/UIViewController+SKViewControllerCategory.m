//
//  UIViewController+SKViewControllerCategory.m
//  Dharm
//
//  Created by Кирилл on 01.05.17.
//  Copyright © 2017 Kirill Solovyov. All rights reserved.
//

#import "UIViewController+SKViewControllerCategory.h"

@implementation UIViewController (SKViewControllerCategory)

- (void) drawStatusBarOnNavigationViewWithColor: (UIColor *)color {
    
    if (self.navigationController) {
        
        UIApplication *app = [UIApplication sharedApplication];
        CGFloat statusBarHeight = app.statusBarFrame.size.height;
        
        UIView *statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, -statusBarHeight, [UIScreen mainScreen].bounds.size.width, statusBarHeight)];
        statusBarView.backgroundColor = color;
        [self.navigationController.navigationBar addSubview:statusBarView];
    }
}

@end
