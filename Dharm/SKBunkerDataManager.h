//
//  SKBunkerDataManager.h
//  Dharm
//
//  Created by Kirill Solovyov on 05.10.17.
//  Copyright © 2017 Kirill Solovyov. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

@class SKBunkerViewController;

@protocol SKBunkerDataManagerDelegate

- (void)codeDidEnteredSuccess:(BOOL)flag;
- (void)codeDidnNotEnteredTimes:(NSInteger)times;

- (void)updateScoreLabelWithScore:(NSInteger)score;
- (void)updateTimerLabelWithComponents:(NSDateComponents *)components;

@end

@interface SKBunkerDataManager : NSObject <UITextFieldDelegate>

- (instancetype)initWithWithDelegate:(id<SKBunkerDataManagerDelegate>)delegate;
- (void)resetTimerAndScoreWithScore:(NSInteger)score;
- (void)codeCanBeEntered:(BOOL)flag;
- (void)updateData;

@end
