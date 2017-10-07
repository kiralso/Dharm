//
//  SKAdCell.m
//  Dharm
//
//  Created by Кирилл on 09.04.17.
//  Copyright © 2017 Kirill Solovyov. All rights reserved.
//

#import "SKAdCell.h"

@implementation SKAdCell

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupCell];
    }
    return self;
}

- (void)setupCell {
    self.backgroundColor = [UIColor clearColor];
}

@end
