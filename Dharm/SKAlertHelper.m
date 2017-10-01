//
//  SKAlertHelper.m
//  Dharm
//
//  Created by Kirill Solovyov on 01.10.17.
//  Copyright © 2017 Kirill Solovyov. All rights reserved.
//

#import "SKAlertHelper.h"

@implementation SKAlertHelper

- (void) showCantEnterCodeAlertOnViewController:(UIViewController *_Nonnull)viewController {
    
    NSString *alertTitle = NSLocalizedString(@"ALERTERROR", nil);
    NSString *alertMessage = NSLocalizedString(@"ALERTMESSAGE", nil);
    NSString *alertCancel = NSLocalizedString(@"OK", nil);
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:alertTitle
                                                                   message:alertMessage
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:alertCancel
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil];
    
    [alert addAction:cancelAction];
    [viewController presentViewController:alert animated:YES completion:nil];
}

- (void) showResetStoryAlertOnViewController:(UIViewController *_Nonnull)viewController
                               withOkHandler:(void(^_Nullable)(UIAlertAction * _Nonnull action)) handler {
    
    NSString *alertTitle = NSLocalizedString(@"RESETTITLE", nil);
    NSString *alertMessage = NSLocalizedString(@"RESETMESSAGE", nil);
    NSString *okTitle = NSLocalizedString(@"OK", nil);
    NSString *cancelTitle = NSLocalizedString(@"CANCEL", nil);
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:alertTitle
                                                                   message:alertMessage
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:okTitle
                                                       style:UIAlertActionStyleDefault
                                                     handler:handler];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelTitle
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil];
    
    [alert addAction:okAction];
    [alert addAction:cancelAction];
    
    [viewController presentViewController:alert animated:YES completion:nil];
}

@end
