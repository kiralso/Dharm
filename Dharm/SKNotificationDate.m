//
//  SKNotificationDate.m
//  Dharm
//
//  Created by Кирилл on 15.07.17.
//  Copyright © 2017 Kirill Solovyov. All rights reserved.
//

#import "SKNotificationDate.h"

@interface SKNotificationDate() <NSCoding>

@end

static NSString * const fireDateKey = @"fireDateKey";
static NSString * const warningDateKey = @"warningDateKey";

@implementation SKNotificationDate

- (instancetype)initWithFireDate:(NSDate *)fireDate warningDate:(NSDate *)warningDate {
    self = [super init];
    if (self) {
        self.fireDate = fireDate;
        self.warningDate = warningDate;
    }
    return self;
}

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.fireDate forKey:fireDateKey];
    [encoder encodeObject:self.warningDate forKey:warningDateKey];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        self.fireDate = [decoder decodeObjectForKey:fireDateKey];
        self.warningDate = [decoder decodeObjectForKey:warningDateKey];
    }
    return self;
}
@end
