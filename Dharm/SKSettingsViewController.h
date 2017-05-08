//
//  SKSettingsViewController.h
//  Dharm
//
//  Created by Кирилл on 01.04.17.
//  Copyright © 2017 Kirill Solovov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKObserverProtocol.h"
#import "AMViralSwitch.h"

@class AMViralSwitch;

@interface SKSettingsViewController : UIViewController <SKObserverProtocol>


@property (weak, nonatomic) IBOutlet AMViralSwitch *difficultySwitch;
@property (weak, nonatomic) IBOutlet UIDatePicker *dateFromPicker;
@property (weak, nonatomic) IBOutlet UIDatePicker *dateToPicker;
@property (weak, nonatomic) IBOutlet UILabel *info;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *softcoreInfoCollectionOfLabels;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundView;

- (IBAction)difficultySwitchAction:(AMViralSwitch *)sender;
- (IBAction)dateFromPickerAction:(UIDatePicker *)sender;
- (IBAction)dateToPickerAction:(UIDatePicker *)sender;

@end
