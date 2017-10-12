//
//  SKSettingsManager.m
//  Dharm
//
//  Created by Kirill Solovyov on 12.10.17.
//  Copyright © 2017 Kirill Solovyov. All rights reserved.
//

#import "SKSettingsManager.h"

static NSString * const kDifficultySwitchKey = @"difficultySwitch";
static NSString * const kDateFromPickerKey = @"dateFromPicker";
static NSString * const kDateToPickerKey = @"dateToPicker";

@interface SKSettingsManager()

@property (strong, nonatomic) NSUserDefaults *defaults;

@end

@implementation SKSettingsManager

+ (instancetype)sharedManager {
    static SKSettingsManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[SKSettingsManager alloc] init];
    });
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.defaults = [NSUserDefaults standardUserDefaults];
    }
    return self;
}

#pragma mark - Saving settings

- (void)saveDifficulty:(BOOL)difficulty {
    [[NSUserDefaults standardUserDefaults] setBool:difficulty forKey:kDifficultySwitchKey];
    if (self.delegate) {
        [self.delegate settingsDidChange];
    }
}

- (void)saveToDate:(NSDate *)toDate {
    [[NSUserDefaults standardUserDefaults] setObject:toDate forKey:kDateToPickerKey];
    if (self.delegate) {
        [self.delegate settingsDidChange];
    }
}

- (void)saveFromDate:(NSDate *)fromDate {
    [[NSUserDefaults standardUserDefaults] setObject:fromDate forKey:kDateFromPickerKey];
    if (self.delegate) {
        [self.delegate settingsDidChange];
    }
}

#pragma mark - Getting settings

- (BOOL)difficulty {
    return [self.defaults boolForKey:kDifficultySwitchKey];
}

- (NSDate *)toDate {
    return [self.defaults objectForKey:kDateToPickerKey];
}

- (NSDate *)fromDate {
    return [self.defaults objectForKey:kDateFromPickerKey];
}

@end
