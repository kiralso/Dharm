//
//  SKScoreCell.m
//  Dharm
//
//  Created by Кирилл on 09.04.17.
//  Copyright © 2017 Kirill Solovyov. All rights reserved.
//

#import "SKScoreCell.h"
#import "SKUserDataManager.h"

static CGFloat const SKScoreTextLableHeight = 25.0;
static CGFloat const SKScoreTextLableWidth = 120.0;

@implementation SKScoreCell

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
    self.scoreLabel = [[UILabel alloc] init];
    self.scoreLabel.font = [UIFont fontWithName:@"Avenir Next" size:17.0];
    self.scoreLabel.textColor = [UIColor whiteColor];
    self.scoreLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.contentView addSubview:self.scoreLabel];
}

- (void)setupCell {
    self.backgroundColor = [UIColor clearColor];
}

- (void)updateTextLabelFrame {
    CGFloat codeTextFieldX = (CGRectGetWidth(self.frame) - SKScoreTextLableWidth);
    CGFloat codeTextFieldY = (CGRectGetHeight(self.frame) - SKScoreTextLableHeight) / 2;
    self.scoreLabel.frame = CGRectMake(codeTextFieldX, codeTextFieldY, SKScoreTextLableWidth, SKScoreTextLableHeight);
}

@end
