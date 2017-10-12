//
//  SKBunkerViewController.h
//  Dharm
//
//  Created by Кирилл on 09.04.17.
//  Copyright © 2017 Kirill Solovyov. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VMaskTextField;

@interface SKBunkerViewController : UIViewController

@property (strong, nonatomic) UILabel *timerLabel;
@property (strong, nonatomic) UILabel *scoreLabel;
@property (strong, nonatomic) VMaskTextField *codeTextField;

- (IBAction)showMenuAction:(UIBarButtonItem *)sender;
- (IBAction)showPopoverAction:(UIButton *)sender;

@end
