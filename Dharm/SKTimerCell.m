//
//  SKTimerCell.m
//  Dharm
//
//  Created by Кирилл on 09.04.17.
//  Copyright © 2017 Kirill Solovyov. All rights reserved.
//

#import "SKTimerCell.h"

static CGFloat const SKTimerTextLableHeight = 110.0;
static CGFloat const SKTimerTextLableWidth = 300.0;

@implementation SKTimerCell

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupCell];
        [self initializeTextLabel];
    }
    return self;
}

#pragma mark - Public

- (void)updateCell {
    [self updateTextLabelFrame];
}

#pragma mark - SKCodeCell

- (void)initializeTextLabel {
    self.timerLabel = [[UILabel alloc] init];
    self.timerLabel.font = [UIFont fontWithName:@"Avenir Next" size:80.0];
    self.timerLabel.textColor = [UIColor whiteColor];
    self.timerLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.contentView addSubview:self.timerLabel];
}

- (void)setupCell {
    self.backgroundColor = [UIColor clearColor];
}

- (void)updateTextLabelFrame {
    CGFloat timerTextFieldX = (CGRectGetWidth(self.frame) - SKTimerTextLableWidth) / 2;
    CGFloat timerTextFieldY = (CGRectGetHeight(self.frame) - SKTimerTextLableHeight) / 1.3;
    self.timerLabel.frame = CGRectMake(timerTextFieldX, timerTextFieldY, SKTimerTextLableWidth, SKTimerTextLableHeight);
}

@end
