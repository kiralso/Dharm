//
//  SKUtils.h
//  Dharm
//
//  Created by Кирилл on 08.05.17.
//  Copyright © 2017 Kirill Solovyov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

static NSInteger const kNumberOfDatesToGenerate = 30;
static NSInteger const kMinutesBeforeFireDateToWarn = 1;
static NSInteger const kMinutesYoSaveTheWorld = 2;

static NSString * const kScoreKey = @"kScoreKey";
static NSString * const kSafetyString = @"4 8 15 16 23 42";
static NSString * const kCodeEnteredKey = @"kCodeEnteredKey";

#pragma mark - NSUserDefaults keys

static NSString * const kDifficultySwitchKey = @"difficultySwitch";
static NSString * const kDateFromPickerKey = @"dateFromPicker";
static NSString * const kDateToPickerKey = @"dateToPicker";
static NSString * const kIsFirstTime = @"isFirstTime";

#pragma mark - BackgroundPaths

static NSString * const kPhoneBackground = @"dharm dark backgroundIPHONE.pdf";
static NSString * const kPadBackground = @"dharm background IPAD.pdf";

#pragma mark - AdMob

static NSString * const kAdMobAppIdentifier = @"ca-app-pub-1068109744372144~6470642114";
static NSString * const kAdMobAdIdentifier = @"ca-app-pub-1068109744372144/4959896114";

#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.f green:g/255.f blue:b/255.f alpha:a];

BOOL iPad();
BOOL iPhone();

NSString* backgroundPath();

