//
//  SKSafetyCodeManager.h
//  Dharm
//
//  Created by Kirill Solovyov on 05.10.17.
//  Copyright © 2017 Kirill Solovyov. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UITextField;

@protocol SKSafetyCodeManagerDelegate

@property (assign, nonatomic) BOOL codeCanEntered;

- (void)codeDidEnteredSuccess:(BOOL)flag;

@end

@interface SKSafetyCodeManager : NSObject

@property (strong, nonatomic) id<SKSafetyCodeManagerDelegate> delegate;

- (instancetype)initWithTextField:(UITextField *)textField;

@end
