//
//  SKBunkerViewController.h
//  Dharm
//
//  Created by Кирилл on 01.04.17.
//  Copyright © 2017 Kirill Solovov. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SKTimer;

@interface SKBunkerViewController : UIViewController

@property (strong, nonatomic) SKTimer *timer;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UITextField *safetyCode;

- (IBAction)infoAction:(UIBarButtonItem *)sender;

@end
