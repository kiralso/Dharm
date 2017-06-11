//
//  SKScoreCell.m
//  Dharm
//
//  Created by Кирилл on 09.04.17.
//  Copyright © 2017 Kirill Solovyov. All rights reserved.
//

#import "SKScoreCell.h"
#import "SKUser+CoreDataClass.h"
#import "SKUserDataManager.h"

@implementation SKScoreCell

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self updateScoreLabel];
    }
    return self;
}

- (void) updateScoreLabel {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        SKUser *user = [[SKUserDataManager sharedManager] user];
        
        self.scoreLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Score :%@", nil), @(user.score)];
    });
}

- (void) updateScoreLabelWithScore:(NSInteger) score {
    self.scoreLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Score :%@", nil), @((long)score)];
}

@end
