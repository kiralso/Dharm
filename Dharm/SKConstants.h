//
//  SKConstants.h
//  Dharm
//
//  Created by Кирилл on 08.04.17.
//  Copyright © 2017 Kirill Solovov. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSInteger const kNumberOfDatesToGenerate = 30;
static NSInteger const kMinutesBeforeFireDateToWarn = 4;
static NSInteger const kMinutesYoSaveTheWorld = 108;
static NSString * const kScoreKey = @"scoreKey";
static NSString * const kSafetyString = @"4 8 15 16 23 42";

#pragma mark - NSUserDefaults keys

static NSString * const kDifficultySwitchKey = @"difficultySwitch";
static NSString * const kDateFromPickerKey = @"dateFromPicker";
static NSString * const kDateToPickerKey = @"dateToPicker";

#pragma mark - Alert messages

static NSString * const kAlertTitle = @"Очень жаль!";
static NSString * const kAlertBody = @"Увы, молодой человек, вы никого не спасли!";
static NSString * const kWarningTitle = @"Опять пора спасать мир!";
static NSString * const kWarningBody = @"Новобранец, у тебя 4 минуты, чтобы ввести код!";


@interface SKConstants : NSObject

@end
