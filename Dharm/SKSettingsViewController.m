//
//  SKSettingsViewController.m
//  Dharm
//
//  Created by Кирилл on 01.04.17.
//  Copyright © 2017 Kirill Solovov. All rights reserved.
//

#import "SKSettingsViewController.h"
#import "SKConstants.h"
#import "SKMainObserver.h"

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
    
    [self checkDifficultyInFromPicker:self.dateFromPicker andToPicker:self.dateToPicker withSwitch:self.difficultySwitch];
    
    [self addObserver:[SKMainObserver sharedObserver]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)dealloc {
    [self removeObserver:[SKMainObserver sharedObserver]];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

#pragma mark - UITableViewDelegate

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

#pragma mark - Actions

- (IBAction)difficultySwitchAction:(UISwitch *)sender {
    
    [self checkDifficultyInFromPicker:self.dateFromPicker andToPicker:self.dateToPicker withSwitch:self.difficultySwitch];
    
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

- (void) checkDifficultyInFromPicker:(UIDatePicker *) fromPicker andToPicker:(UIDatePicker *) toPicker withSwitch:(UISwitch *) dSwitch {
    
    if (dSwitch.on) {
        fromPicker.enabled = NO;
        toPicker.enabled = NO;
    } else {
        fromPicker.enabled = YES;
        toPicker.enabled = YES;
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
