//
//  UITableViewController+SKTableViewCategory.m
//  Dharm
//
//  Created by Кирилл on 01.05.17.
//  Copyright © 2017 Kirill Solovyov. All rights reserved.
//

#import "UITableViewController+SKTableViewCategory.h"

@implementation UITableViewController (SKTableViewCategory)

- (void)setBackgroundImageViewWithImageName:(NSString *)imageName {
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    tempImageView.frame = self.tableView.frame;
    self.tableView.backgroundView = tempImageView;
}

@end
