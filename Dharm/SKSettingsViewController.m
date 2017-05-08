//
//  SKSettingsViewController.m
//  Dharm
//
//  Created by Кирилл on 01.04.17.
//  Copyright © 2017 Kirill Solovov. All rights reserved.
//

#import "SKSettingsViewController.h"
#import "SKUtils.h"
#import "SKMainObserver.h"
#import "AMViralSwitch.h"
#import "UIViewController+SKViewControllerCategory.h"

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
    
    [self addObserver:[SKMainObserver sharedObserver]];
    
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
    
    UIColor *color = RGBA(207.f, 216.f, 220.f, 1.f);
    [self drawStatusBarOnNavigationViewWithColor:color];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)dealloc {
    [self removeObserver:[SKMainObserver sharedObserver]];
}

#pragma mark - Actions

- (IBAction)difficultySwitchAction:(AMViralSwitch *)sender {
    
    [self checkDifficultyInFromPicker:self.dateFromPicker
                             toPicker:self.dateToPicker
                           withSwitch:self.difficultySwitch
                            infoLabel:self.info];
    
    [self saveSettings];
    
    [self checkToPicker];
    
    [self setValue:sender forKey:kDifficultySwitchKey];
}

- (IBAction)dateFromPickerAction:(UIDatePicker *)sender {
    
    [self saveSettings];
    
    [self checkToPicker];
    
    [self setValue:sender forKey:kDateFromPickerKey];
}

- (IBAction)dateToPickerAction:(UIDatePicker *)sender {
    
    [self saveSettings];
    
    [self checkToPicker];
    
    [self setValue:sender forKey:kDateToPickerKey];
}

#pragma mark - Observer

- (void) addObserver:(NSObject *) observer {
    
    [self addObserver:observer
           forKeyPath:kDifficultySwitchKey
              options:NSKeyValueObservingOptionNew
              context:nil];
    
    [self addObserver:observer
           forKeyPath:kDateFromPickerKey
              options:NSKeyValueObservingOptionNew
              context:nil];
    
    [self addObserver:observer
           forKeyPath:kDateToPickerKey
              options:NSKeyValueObservingOptionNew
              context:nil];
}

- (void) removeObserver:(NSObject *) observer {
    
    [self removeObserver:observer
              forKeyPath:kDifficultySwitchKey];
    
    [self removeObserver:observer
              forKeyPath:kDateFromPickerKey];
    
    [self removeObserver:observer
              forKeyPath:kDateToPickerKey];
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
}

@end