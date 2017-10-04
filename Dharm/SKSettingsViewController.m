//
//  SKSettingsViewController.m
//  Dharm
//
//  Created by Кирилл on 01.04.17.
//  Copyright © 2017 Kirill Solovov. All rights reserved.
//

#import "SKSettingsViewController.h"
#import "SKUtils.h"
#import "AMViralSwitch.h"
#import "UIViewController+SKViewControllerCategory.h"
#import "SKLocalNotificationHelper.h"

@interface SKSettingsViewController ()

@end

static NSInteger const kHoursBetweenPickers = 3;

@implementation SKSettingsViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    self.difficultySwitch.on = [defaults boolForKey:kDifficultySwitchKey];
    
    if ([defaults objectForKey:kDateFromPickerKey] && [defaults objectForKey:kDateToPickerKey]) {
        self.dateFromPicker.date = [defaults objectForKey:kDateFromPickerKey];
        self.dateToPicker.date = [defaults objectForKey:kDateToPickerKey];
    }
    
    [defaults synchronize];
    
    [self checkDifficultyInFromPicker:self.dateFromPicker
                             toPicker:self.dateToPicker
                           withSwitch:self.difficultySwitch
                            infoLabel:self.info];
    
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
    
    UIImage *image = [UIImage imageNamed:backgroundPath()];
    
    self.backgroundView.image = image;
    
    [self.dateToPicker setValue:[UIColor whiteColor] forKey:@"textColor"];
    [self.dateFromPicker setValue:[UIColor whiteColor] forKey:@"textColor"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Actions

- (IBAction)difficultySwitchAction:(AMViralSwitch *)sender {
    
    [self checkDifficultyInFromPicker:self.dateFromPicker
                             toPicker:self.dateToPicker
                           withSwitch:self.difficultySwitch
                            infoLabel:self.info];
    
    [self saveSettings];
    
    [self checkToPicker];
}

- (IBAction)dateFromPickerAction:(UIDatePicker *)sender {
    
    [self saveSettings];
    [self checkToPicker];
}

- (IBAction)dateToPickerAction:(UIDatePicker *)sender {
    
    [self saveSettings];
    [self checkToPicker];
}

#pragma mark - Useful Methods

- (void) checkDifficultyInFromPicker:(UIDatePicker *) fromPicker toPicker:(UIDatePicker *) toPicker withSwitch:(UISwitch *) dSwitch infoLabel:(UILabel *) label {
    
    if (dSwitch.on) {
        fromPicker.hidden = YES;
        toPicker.hidden = YES;
        
        for (UILabel *label in self.softcoreInfoCollectionOfLabels) {
            label.hidden = YES;
        }
        
        label.hidden = NO;
    } else {
        toPicker.hidden = NO;
        fromPicker.hidden = NO;
        
        for (UILabel *label in self.softcoreInfoCollectionOfLabels) {
            label.hidden = NO;
        }
        
        label.hidden = YES;
    }
}

- (NSDate *) checkTimeInFromPicker:(UIDatePicker *) fromPicker andToPicker:(UIDatePicker *) toPicker withHoursBetween:(NSInteger) hours {
    
    NSDateComponents *fromComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitHour
                                                          fromDate:fromPicker.date];
    NSDateComponents *toComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitHour
                                                                    fromDate:toPicker.date];
    
    NSInteger hoursBetween = toComponents.hour - fromComponents.hour;
    if (ABS(hoursBetween) < hours || hoursBetween == 0) {
        return [[NSCalendar currentCalendar] dateByAddingUnit:NSCalendarUnitHour
                                                               value:hours
                                                              toDate:fromPicker.date
                                                             options:0];
    }

    return toPicker.date;
}

- (void) checkToPicker {
    
    NSDate * date = [self checkTimeInFromPicker:self.dateFromPicker
                                    andToPicker:self.dateToPicker
                               withHoursBetween:kHoursBetweenPickers];

    [self.dateToPicker setDate:date animated:YES];
}

- (void) saveSettings {
    [[NSUserDefaults standardUserDefaults] setObject:self.dateFromPicker.date forKey:kDateFromPickerKey];
    [[NSUserDefaults standardUserDefaults] setObject:self.dateToPicker.date forKey:kDateToPickerKey];
    [[NSUserDefaults standardUserDefaults] setBool:self.difficultySwitch.on forKey:kDifficultySwitchKey];
    
    SKLocalNotificationHelper *notificationHelper = [[SKLocalNotificationHelper alloc] init];
    [notificationHelper updateNotificationDatesWithCompletion:nil];
}

@end
