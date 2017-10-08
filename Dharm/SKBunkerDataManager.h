//
//  SKBunkerDataManager.h
//  Dharm
//
//  Created by Kirill Solovyov on 05.10.17.
//  Copyright © 2017 Kirill Solovyov. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

@class SKBunkerDataManager;
@class SKBunkerViewController;

@protocol SKBunkerDataManagerDelegate

- (void)codeDidEnteredSuccess:(BOOL)flag;
- (void)codeDidnNotEnteredTimes:(NSInteger)times;

@end

@interface SKBunkerDataManager : NSObject <UITextFieldDelegate>

@property (weak, nonatomic) SKBunkerViewController<SKBunkerDataManagerDelegate> *delegate;

- (instancetype)initWithWithDelegate:(SKBunkerViewController<SKBunkerDataManagerDelegate> *)delegate;

@end
