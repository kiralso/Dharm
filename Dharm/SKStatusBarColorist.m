//
//  SKStatusBarColorist.m
//  Dharm
//
//  Created by Кирилл on 01.05.17.
//  Copyright © 2017 Kirill Solovyov. All rights reserved.
//

#import "SKStatusBarColorist.h"

@implementation SKStatusBarColorist

- (void) drawStatusBarBackgroundWithColor:(UIColor *) color {

    UIApplication *app = [UIApplication sharedApplication];
    CGFloat statusBarHeight = app.statusBarFrame.size.height;
    
    UIView *statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, -statusBarHeight, [UIScreen mainScreen].bounds.size.width, statusBarHeight)];
    statusBarView.backgroundColor = [UIColor yellowColor];
    [self.navigationController.navigationBar addSubview:statusBarView];

}

@end
