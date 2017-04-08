//
//  SKInfoViewController.m
//  Dharm
//
//  Created by Кирилл on 04.04.17.
//  Copyright © 2017 Kirill Solovov. All rights reserved.
//

#import "SKInfoViewController.h"

@interface SKInfoViewController ()

@end

@implementation SKInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - Actions

- (IBAction)okAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
