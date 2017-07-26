//
//  SKStoryPage.m
//  Dharm
//
//  Created by Кирилл on 06.07.17.
//  Copyright © 2017 Kirill Solovyov. All rights reserved.
//

#import "SKStoryPage.h"

@implementation SKStoryPage

- (instancetype)initWithIndex:(SKStoryPageNumber) index {
    self = [super init];
    if (self) {
        
        switch (index) {
                
            case SKStoryPageNumberTutorial:
                self.imageName = @"Tutorial";
                self.storyText = NSLocalizedString(@"TUTORIAL", nil);
                self.storyTitle = NSLocalizedString(@"TUTORIALTITLE", nil);
                self.chapter = 1;
                break;
            case SKStoryPageNumberOne:
                self.imageName = @"DesmondDharma";
                self.storyText = NSLocalizedString(@"TEXTONE", nil);
                self.storyTitle = NSLocalizedString(@"TITLEONE", nil);
                self.chapter = 1;
                break;
            case SKStoryPageNumberTwo:
                self.imageName = @"Door";
                self.storyText = NSLocalizedString(@"TEXTTWO", nil);
                self.storyTitle = NSLocalizedString(@"TITLETWO", nil);
                self.chapter = 1;
                break;
            case SKStoryPageNumberThree:
                self.imageName = @"Namaste";
                self.storyText = NSLocalizedString(@"TEXTTHREE", nil);
                self.storyTitle = NSLocalizedString(@"TITLETHREEE", nil);
                self.chapter = 1;
                break;
            case SKStoryPageNumberFour:
                self.imageName = @"Computer";
                self.storyText = NSLocalizedString(@"TEXTFOUR", nil);
                self.storyTitle = NSLocalizedString(@"TITLEFOUR", nil);
                self.chapter = 1;
                break;
// Chapter 2
            case SKStoryPageNumberFive:
                self.imageName = @"Ocean";
                self.storyText = NSLocalizedString(@"TEXTFIVE", nil);
                self.storyTitle = NSLocalizedString(@"TITLEFIVE", nil);
                self.chapter = 2;
                self.isChoise = YES;
                break;
            case SKStoryPageNumberSix:
                self.imageName = @"Baloon";
                self.storyText = NSLocalizedString(@"TEXTSIX", nil);
                self.storyTitle = NSLocalizedString(@"TITLESIX", nil);
                self.chapter = 2;
                break;
            case SKStoryPageNumberSeven:
                self.imageName = @"OnBaloon";
                self.storyText = NSLocalizedString(@"TEXTSEVEN", nil);
                self.storyTitle = NSLocalizedString(@"TITLESEVEN", nil);
                self.chapter = 2;
                break;
            case SKStoryPageNumberEight:
                self.imageName = @"kladovka";
                self.storyText = NSLocalizedString(@"TEXTEIGHT", nil);
                self.storyTitle = NSLocalizedString(@"TITLEEIGHT", nil);
                self.chapter = 2;
                break;
            case SKStoryPageNumberNine:
                self.imageName = @"monstr";
                self.storyText = NSLocalizedString(@"TEXTNINE", nil);
                self.storyTitle = NSLocalizedString(@"TITLENINE", nil);
                self.chapter = 2;
                break;
            case SKStoryPageNumberTen:
                self.imageName = @"ruchei";
                self.storyText = NSLocalizedString(@"TEXTTEN", nil);
                self.storyTitle = NSLocalizedString(@"TITLETEN", nil);
                self.chapter = 2;
                break;
            case SKStoryPageNumberEleven:
                self.imageName = @"OnBaloon";
                self.storyText = NSLocalizedString(@"TEXTELEVEN", nil);
                self.storyTitle = NSLocalizedString(@"TITLEELEVEN", nil);
                self.chapter = 2;
                break;
            case SKStoryPageNumberTwelve:
                self.imageName = @"monstr";
                self.storyText = NSLocalizedString(@"TEXTTWELVE", nil);
                self.storyTitle = NSLocalizedString(@"TITLETWELVE", nil);
                self.chapter = 2;
                break;
            case SKStoryPageNumberThirteen:
                self.imageName = @"jungle";
                self.storyText = NSLocalizedString(@"TEXTTHIRTEEN", nil);
                self.storyTitle = NSLocalizedString(@"TITLETHIRTEEN", nil);
                self.chapter = 2;
                self.isChoise = YES;
                break;
//Chapter 3
            case SKStoryPageNumberFourteen:
                self.imageName = @"cave";
                self.storyText = NSLocalizedString(@"TEXTFOURTEEN", nil);
                self.storyTitle = NSLocalizedString(@"TITLEFOURTEEN", nil);
                self.chapter = 3;
                break;
            case SKStoryPageNumberFifteen:
                self.imageName = @"likvidators";
                self.storyText = NSLocalizedString(@"TEXTFIFTEEN", nil);
                self.storyTitle = NSLocalizedString(@"TITLEFIFTEEN", nil);
                self.chapter = 3;
                break;
            case SKStoryPageNumberSixteen:
                self.imageName = @"island";
                self.storyText = NSLocalizedString(@"TEXTSIXTEEN", nil);
                self.storyTitle = NSLocalizedString(@"TITLESIXTEEN", nil);
                self.chapter = 3;
                break;
            case SKStoryPageNumberSeventeen:
                self.imageName = @"NaBeregu";
                self.storyText = NSLocalizedString(@"TEXTSEVENTEEN", nil);
                self.storyTitle = NSLocalizedString(@"TITLESEVENTEEN", nil);
                self.chapter = 3;
                self.isChoise = YES;
                break;
            case SKStoryPageNumberEightteen:
                self.imageName = @"drink";
                self.storyText = NSLocalizedString(@"TEXTEIGHTEEN", nil);
                self.storyTitle = NSLocalizedString(@"TITLEIGHTEEN", nil);
                self.chapter = 3;
                break;
            case SKStoryPageNumberNineteen:
                self.imageName = @"plain";
                self.storyText = NSLocalizedString(@"TEXTNINTEEN", nil);
                self.storyTitle = NSLocalizedString(@"TITLENINTEEN", nil);
                self.chapter = 3;
                break;
            case SKStoryPageNumberTwenty:
                self.imageName = @"dicaprio";
                self.storyText = NSLocalizedString(@"TEXTTWENTY", nil);
                self.storyTitle = NSLocalizedString(@"TITLETWENTY", nil);
                self.chapter = 3;
                break;
            case SKStoryPageNumberTwentyOne:
                self.imageName = @"DesmondDharma";
                self.storyText = NSLocalizedString(@"TEXTTWENTYONE", nil);
                self.storyTitle = NSLocalizedString(@"TITLETWENTYONE", nil);
                self.chapter = 3;
                break;
            case SKStoryPageNumberTwentyTwo:
                self.imageName = @"rassipaetsa";
                self.storyText = NSLocalizedString(@"TEXTTWENTYTWO", nil);
                self.storyTitle = NSLocalizedString(@"TITLETWENTYTWO", nil);
                self.chapter = 3;
                break;
                
// Thanks
            case SKStoryPageThanks:
                self.imageName = @"Tutorial";
                self.storyText = NSLocalizedString(@"TEXTTHANKS", nil);
                self.storyTitle = NSLocalizedString(@"TITLETHANKS", nil);
                self.chapter = 3;
                break;
                
// DisasterPages
            case SKStoryPageDisasterOne:
                self.imageName = @"Tutorial";
                self.storyText = NSLocalizedString(@"DISASTERONE", nil);
                break;
            case SKStoryPageDisasterTwo:
                self.imageName = @"Tutorial";
                self.storyText = NSLocalizedString(@"DISASTERTWO", nil);
                break;
            case SKStoryPageDisasterThree:
                self.imageName = @"Tutorial";
                self.storyText = NSLocalizedString(@"DISASTERTHREE", nil);
                break;
            default:
                break;
        }
    }
    return self;
}

- (NSArray *)pagesWithArrayOfIndexes:(NSArray<NSNumber *> *) indexes {
    
    NSMutableArray *pages = [NSMutableArray array];
    
    for (NSNumber *number in indexes) {
        
        NSInteger index = [number integerValue];
        
        if (index >= SKStoryPageNumberMax) {
            break;
        }
        
        SKStoryPage *page = [[SKStoryPage alloc] initWithIndex:index];
        [pages addObject:page];
    }

    return pages;
}

@end
