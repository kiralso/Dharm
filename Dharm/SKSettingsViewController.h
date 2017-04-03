//
//  SKSettingsViewController.h
//  Dharm
//
//  Created by Кирилл on 01.04.17.
//  Copyright © 2017 Kirill Solovov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SKSettingsViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UISwitch *difficultySwitch;
@property (weak, nonatomic) IBOutlet UIDatePicker *dateFromPicker;
@property (weak, nonatomic) IBOutlet UIDatePicker *dateToPicker;

- (IBAction)difficultySwitchAction:(UISwitch *)sender;
- (IBAction)dateFromPickerAction:(UIDatePicker *)sender;
- (IBAction)dateToPickerAction:(UIDatePicker *)sender;

@end
