//
//  SKStoryPage.h
//  Dharm
//
//  Created by Кирилл on 06.07.17.
//  Copyright © 2017 Kirill Solovyov. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, SKStoryPageNumber) {
    //pages
    SKStoryPageNumberTutorial,
    SKStoryPageNumberOne,
    SKStoryPageNumberTwo,
    SKStoryPageNumberThree,
    SKStoryPageNumberFour,
    SKStoryPageNumberFive,
    SKStoryPageNumberSix,
    SKStoryPageNumberSeven,
    SKStoryPageNumberEight,
    SKStoryPageNumberNine,
    SKStoryPageNumberTen,
    SKStoryPageNumberEleven,
    SKStoryPageNumberTwelve,
    SKStoryPageNumberThirteen,
    SKStoryPageNumberFourteen,
    SKStoryPageNumberFifteen,
    SKStoryPageNumberSixteen,
    SKStoryPageNumberSeventeen,
    SKStoryPageNumberEightteen,
    SKStoryPageNumberNineteen,
    SKStoryPageNumberTwenty,
    SKStoryPageNumberTwentyOne,
    SKStoryPageNumberTwentyTwo,
    SKStoryPageThanks,
    
    SKStoryPageNumberMax,
    //disaster pages
    SKStoryPageDisasterOne,
    SKStoryPageDisasterTwo,
    SKStoryPageDisasterThree
};

@interface SKStoryPage : NSObject

@property (assign, nonatomic) NSInteger chapter;
@property (strong, nonatomic) NSString *imageName;
@property (strong, nonatomic) NSString *storyText;
@property (strong, nonatomic) NSString *storyTitle;
@property (assign, nonatomic) BOOL isChoise;

- (instancetype)initWithIndex:(SKStoryPageNumber)index;
- (NSArray *)pagesWithArrayOfIndexes:(NSArray<NSNumber *> *)indexes;

@end
