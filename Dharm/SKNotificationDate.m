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
    [encoder encodeObject:self.fireDate forKey:@"fireDate"];
    [encoder encodeObject:self.warningDate forKey:@"warningDate"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        self.fireDate = [decoder decodeObjectForKey:@"fireDate"];
        self.warningDate = [decoder decodeObjectForKey:@"warningDate"];
    }
    return self;
}
@end
