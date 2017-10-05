//
//  SKUser.m
//  Dharm
//
//  Created by Кирилл on 15.07.17.
//  Copyright © 2017 Kirill Solovyov. All rights reserved.
//

#import "SKUser.h"

@interface SKUser() <NSCoding>

@end

@implementation SKUser

#pragma mark - NSCoder

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:@(self.score) forKey:@"score"];
    [encoder encodeObject:@(self.maxScore) forKey:@"maxScore"];
    [encoder encodeObject:self.notificationDatesArray forKey:@"notificationDatesArray"];
    [encoder encodeObject:self.pagesIndexesArray forKey:@"pagesIndexesArray"];
    [encoder encodeObject:self.answeredPages forKey:@"answeredPages"];
    [encoder encodeObject:@(self.isGameOver) forKey:@"isGameOver"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        self.score = [[decoder decodeObjectForKey:@"score"] integerValue];
        self.maxScore = [[decoder decodeObjectForKey:@"maxScore"] integerValue];
        self.notificationDatesArray = [decoder decodeObjectForKey:@"notificationDatesArray"];
        self.pagesIndexesArray = [decoder decodeObjectForKey:@"pagesIndexesArray"];
        self.answeredPages = [decoder decodeObjectForKey:@"answeredPages"];
        self.isGameOver = [[decoder decodeObjectForKey:@"isGameOver"] boolValue];
    }
    return self;
}

@end
