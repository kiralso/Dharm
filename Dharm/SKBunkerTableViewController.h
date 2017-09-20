//
//  SKBunkerTableViewController.h
//  Dharm
//
//  Created by Кирилл on 09.04.17.
//  Copyright © 2017 Kirill Solovyov. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SKScoreCell;
@class SKTimerCell;
@class SKCodeCell;
@class SKAdCell;

@interface SKBunkerTableViewController : UITableViewController

@property (strong, nonatomic) SKScoreCell *scoreCell;
@property (strong, nonatomic) SKTimerCell *timerCell;
@property (strong, nonatomic) SKCodeCell *codeCell;
@property (strong, nonatomic) SKAdCell *adCell;

- (IBAction)showMenuAction:(UIBarButtonItem *)sender;
- (IBAction)showPopoverAction:(UIButton *)sender;

@end
