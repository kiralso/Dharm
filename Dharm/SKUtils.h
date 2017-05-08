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
static NSInteger const kMinutesBeforeFireDateToWarn = 1.0;
static NSInteger const kMinutesYoSaveTheWorld = 2.0;

static NSString * const kScoreKey = @"kScoreKey";
static NSString * const kSafetyString = @"4 8 15 16 23 42";
static NSString * const kCodeEnteredKey = @"kCodeEnteredKey";

#pragma mark - NSUserDefaults keys

static NSString * const kDifficultySwitchKey = @"difficultySwitch";
static NSString * const kDateFromPickerKey = @"dateFromPicker";
static NSString * const kDateToPickerKey = @"dateToPicker";

#pragma mark - Alert messages

static NSString * const kAlertTitle = @"Очень жаль!";
static NSString * const kAlertBody = @"Увы, молодой человек, вы никого не спасли!";
static NSString * const kWarningTitle = @"Опять пора спасать мир!";
static NSString * const kWarningBody = @"Новобранец, у тебя 4 минуты, чтобы ввести код!";

#pragma mark - BackgroundPaths

static NSString * const kPhoneBackground = @"dharm background3.pdf";
static NSString * const kPadBackground = @"dharmBackgroundIPAD.pdf";

#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.f green:g/255.f blue:b/255.f alpha:a];

BOOL iPad();
BOOL iPhone();

NSString* backgroundPath();
