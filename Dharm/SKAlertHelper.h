//
//  SKAlertHelper.h
//  Dharm
//
//  Created by Kirill Solovyov on 01.10.17.
//  Copyright © 2017 Kirill Solovyov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SKAlertHelper : NSObject

- (void) showCantEnterCodeAlertOnViewController:(UIViewController *_Nonnull)viewController;
- (void) showResetStoryAlertOnViewController:(UIViewController *_Nonnull)viewController
                               withOkHandler:(void(^_Nullable)(UIAlertAction * _Nonnull action)) handler;

@end
