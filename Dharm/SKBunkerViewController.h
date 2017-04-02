//
//  SKBunkerViewController.h
//  Dharm
//
//  Created by Кирилл on 01.04.17.
//  Copyright © 2017 Kirill Solovov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SKBunkerViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UITextField *safetyCode;

- (IBAction)infoAction:(UIBarButtonItem *)sender;

@end
