//
//  SKSettingsViewController.m
//  Dharm
//
//  Created by Кирилл on 01.04.17.
//  Copyright © 2017 Kirill Solovov. All rights reserved.
//

#import "SKSettingsViewController.h"

@interface SKSettingsViewController ()

@end

static NSString * const difficultyKey = @"difficultyKey";
static NSString * const dateFromKey = @"dateFromKey";
static NSString * const dateToKey = @"dateToKey";

@implementation SKSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    self.difficultySwitch.on = [defaults boolForKey:difficultyKey];
    
    if ([defaults objectForKey:dateFromKey] && [defaults objectForKey:dateToKey]) {
        self.dateFromPicker.date = [defaults objectForKey:dateFromKey];
        self.dateToPicker.date = [defaults objectForKey:dateToKey];
    }
    
    [defaults synchronize];
    
    [self checkPickersForDifficulty];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    [[NSUserDefaults standardUserDefaults] setBool:self.difficultySwitch.on forKey:difficultyKey];
    
    [self checkPickersForDifficulty];
}

- (IBAction)dateFromPickerAction:(UIDatePicker *)sender {
    if (!self.difficultySwitch.on) {
        [[NSUserDefaults standardUserDefaults] setObject:self.dateFromPicker.date forKey:dateFromKey];
    }
}

- (IBAction)dateToPickerAction:(UIDatePicker *)sender {
    if (!self.difficultySwitch.on) {
        [[NSUserDefaults standardUserDefaults] setObject:self.dateToPicker.date forKey:dateToKey];
    }
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
