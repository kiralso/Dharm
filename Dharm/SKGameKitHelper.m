//
//  SKGameKitHelper.m
//  Dharm
//
//  Created by Кирилл on 23.05.17.
//  Copyright © 2017 Kirill Solovyov. All rights reserved.
//

#import "SKGameKitHelper.h"

@interface SKGameKitHelper()

@property (assign, nonatomic) BOOL enableGameCenter;

@end

NSString *const SKPresentAuthenticationViewControllerNotification = @"SKPresentAuthenticationViewControllerNotification";

@implementation SKGameKitHelper

+ (instancetype)sharedGameKitHelper {
    
    static SKGameKitHelper *sharedGameKitHelper;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedGameKitHelper = [[SKGameKitHelper alloc] init];
    });
    
    return sharedGameKitHelper;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.enableGameCenter = YES;
    }
    return self;
}

#pragma mark - Authentication

- (void)authenticateLocalPlayer {
    
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    
    localPlayer.authenticateHandler =^(UIViewController *viewController, NSError *error) {
        [self setLastError:error];
        
        if(viewController != nil) {
            [self setAuthenticationViewController:viewController];
        } else if([GKLocalPlayer localPlayer].isAuthenticated) {
            self.enableGameCenter = YES;
        } else {
            self.enableGameCenter = NO;
        }
    };
}

- (void)setAuthenticationViewController:(UIViewController *)authenticationViewController {
    
    if (authenticationViewController != nil) {
        
        self.authenticationViewController = authenticationViewController;
        
        [[NSNotificationCenter defaultCenter]
         postNotificationName:SKPresentAuthenticationViewControllerNotification
                       object:self];
    }
}

- (void)setLastError:(NSError *)error {
    
    _lastError = [error copy];
    
    if (_lastError) {
        NSLog(@"GameKitHelper ERROR: %@",[[_lastError userInfo] description]);
    }
}
@end
