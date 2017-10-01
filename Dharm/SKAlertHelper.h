//
//  SKAlertHelper.h
//  Dharm
//
//  Created by Kirill Solovyov on 01.10.17.
//  Copyright © 2017 Kirill Solovyov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol SKAlertHelperDelegate

@optional
- (void) showCantEnterCodeAlert;
- (void) showResetStoryAlertWithOkHandler:(void(^_Nullable)(UIAlertAction * _Nonnull action)) handler;

@end


@interface SKAlertHelper : NSObject

@property (weak, nonatomic) UIViewController<SKAlertHelperDelegate> * _Nullable delegate;

- (void) showCantEnterCodeAlert;
- (void) showResetStoryAlertWithOkHandler:(void(^_Nullable)(UIAlertAction * _Nonnull action)) handler;

@end
