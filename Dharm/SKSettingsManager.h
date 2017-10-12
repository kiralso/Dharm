//
//  SKSettingsManager.h
//  Dharm
//
//  Created by Kirill Solovyov on 12.10.17.
//  Copyright © 2017 Kirill Solovyov. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SKSettingsManagerDelegate

- (void)settingsDidChange;

@end

@interface SKSettingsManager : NSObject

@property (weak, nonatomic) id<SKSettingsManagerDelegate> delegate;

+ (instancetype)sharedManager;

- (void)saveDifficulty:(BOOL)difficulty;
- (void)saveToDate:(NSDate *)toDate;
- (void)saveFromDate:(NSDate *)fromDate;

- (BOOL)difficulty;
- (NSDate *)toDate;
- (NSDate *)fromDate;

@end
