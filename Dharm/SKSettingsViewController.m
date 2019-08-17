//
//  SKSettingsViewController.m
//  Dharm
//
//  Created by Кирилл on 01.04.17.
//  Copyright © 2017 Kirill Solovov. All rights reserved.
//

#import "SKSettingsViewController.h"
#import "SKSettingsManager.h"
#import "SKUtils.h"
#import "AMViralSwitch.h"
#import "UIViewController+SKViewControllerCategory.h"
#import "SKLocalNotificationManager.h"
#import <PureLayout.h>

@interface SKSettingsViewController ()

@property (strong, nonatomic) SKSettingsManager *settingManager;

@end

static NSInteger const kHoursBetweenPickers = 3;

@implementation SKSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.settingManager = [SKSettingsManager sharedManager];
    
    [self setupUI];
}

- (void)setupUI {
    [self setupBackground];
    [self switchInit];
    [self pickersInit];
}

- (void)setupBackground {
    [self.backgroundView autoPinEdgesToSuperviewEdges];
    self.backgroundView.backgroundColor = [UIColor blackColor];
    self.backgroundView.image = [UIImage imageNamed:backgroundPath()];
    self.backgroundView.contentMode = UIViewContentModeScaleAspectFit;
}

- (void)switchInit {
    self.difficultySwitch.on = [self.settingManager difficulty];
    self.difficultySwitch.animationDuration = 2.0;
    self.difficultySwitch.animationElementsOff = @[
                                                   @{ AMElementView: self.view.layer,
                                                      AMElementKeyPath: @"backgroundColor",
                                                      AMElementFromValue:(id)[UIColor clearColor].CGColor,
                                                      AMElementToValue:(id)self.view.backgroundColor.CGColor}
                                                   ];
    self.difficultySwitch.animationElementsOn = @[
                                                  @{ AMElementView: self.view.layer,
                                                     AMElementKeyPath: @"backgroundColor",
                                                     AMElementFromValue:(id)self.view.backgroundColor.CGColor,
                                                     AMElementToValue:(id)[UIColor clearColor].CGColor}
                                                  ];
    [self showLabelsWithSwitch:self.difficultySwitch];
}

- (void)pickersInit {
    NSDate *toDate = [self.settingManager toDate];
    NSDate *fromDate = [self.settingManager fromDate];
    if (toDate && fromDate) {
        self.dateFromPicker.date = fromDate;
        self.dateToPicker.date = toDate;
    }
    [self.dateToPicker setValue:[UIColor whiteColor] forKey:@"textColor"];
    [self.dateFromPicker setValue:[UIColor whiteColor] forKey:@"textColor"];
}

#pragma mark - Actions

- (IBAction)difficultySwitchAction:(AMViralSwitch *)sender {
    [self showLabelsWithSwitch:sender];
    [self checkToPicker];
    [self.settingManager saveDifficulty:sender.on];
}

- (IBAction)dateFromPickerAction:(UIDatePicker *)sender {
    [self checkToPicker];
    [self.settingManager saveFromDate:sender.date];
}

- (IBAction)dateToPickerAction:(UIDatePicker *)sender {
    [self checkToPicker];
    [self.settingManager saveToDate:sender.date];
}

#pragma mark - Useful Methods

- (void)showLabelsWithSwitch:(UISwitch *)difficultySwitch {
    BOOL isHardcore = difficultySwitch.on;
    self.dateFromPicker.hidden = isHardcore;
    self.dateToPicker.hidden = isHardcore;
    for (UILabel *label in self.softcoreInfoCollectionOfLabels) {
        label.hidden = isHardcore;
    }
    self.info.hidden = !isHardcore;
}

- (void)checkToPicker {
    NSDate * date = [self checkTimeBetweenPickersWithHours:kHoursBetweenPickers];
    [self.dateToPicker setDate:date animated:YES];
}

- (NSDate *)checkTimeBetweenPickersWithHours:(NSInteger)hours {
    NSDateComponents *fromComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitHour
                                                                       fromDate:self.dateFromPicker.date];
    NSDateComponents *toComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitHour
                                                                     fromDate:self.dateToPicker.date];
    NSInteger hoursBetween = toComponents.hour - fromComponents.hour;
    if (ABS(hoursBetween) < hours || hoursBetween == 0) {
        return [[NSCalendar currentCalendar] dateByAddingUnit:NSCalendarUnitHour
                                                        value:hours
                                                       toDate:self.dateFromPicker.date
                                                      options:0];
    }
    return self.dateToPicker.date;
}

@end
