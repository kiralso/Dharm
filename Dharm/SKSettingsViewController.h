//
//  SKSettingsViewController.h
//  Dharm
//
//  Created by Кирилл on 01.04.17.
//  Copyright © 2017 Kirill Solovov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMViralSwitch.h"

@class AMViralSwitch;

@interface SKSettingsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *backgroundView;
@property (weak, nonatomic) IBOutlet UISwitch *difficultySwitch;
@property (weak, nonatomic) IBOutlet UIDatePicker *dateFromPicker;
@property (weak, nonatomic) IBOutlet UIDatePicker *dateToPicker;
@property (weak, nonatomic) IBOutlet UILabel *info;
@property (weak, nonatomic) IBOutlet UILabel *hardcoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *toDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *fromDateLabel;

- (IBAction)difficultySwitchAction:(UISwitch *)sender;
- (IBAction)dateFromPickerAction:(UIDatePicker *)sender;
- (IBAction)dateToPickerAction:(UIDatePicker *)sender;

@end
