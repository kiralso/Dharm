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
    
    [self checkPickersForDifficulty];
    
    [self addObserver:[SKMainObserver sharedObserver]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    [[NSUserDefaults standardUserDefaults] setBool:self.difficultySwitch.on forKey:kDifficultySwitchKey];
    [self checkPickersForDifficulty];
    
    [self setValue:sender forKey:kDifficultySwitchKey];
}

- (IBAction)dateFromPickerAction:(UIDatePicker *)sender {
    [[NSUserDefaults standardUserDefaults] setObject:self.dateFromPicker.date forKey:kDateFromPickerKey];
    
    [self setValue:sender forKey:kDateFromPickerKey];
}

- (IBAction)dateToPickerAction:(UIDatePicker *)sender {
    [[NSUserDefaults standardUserDefaults] setObject:self.dateToPicker.date forKey:kDateToPickerKey];
    
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

- (void) checkPickersForDifficulty {
    
    if (self.difficultySwitch.on) {
        self.dateFromPicker.enabled = NO;
        self.dateToPicker.enabled = NO;
    } else {
        self.dateFromPicker.enabled = YES;
        self.dateToPicker.enabled = YES;
    }
}
@end
