//
//  SKLeaderboardsNavigationController.m
//  Dharm
//
//  Created by Кирилл on 23.05.17.
//  Copyright © 2017 Kirill Solovyov. All rights reserved.
//

#import "SKLeaderboardsNavigationController.h"
#import "SKGameKitHelper.h"

@interface SKLeaderboardsNavigationController ()

@end

@implementation SKLeaderboardsNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showAuthenticationViewController)
                                                 name:SKPresentAuthenticationViewControllerNotification
                                               object:nil];
    
    [[SKGameKitHelper sharedGameKitHelper] authenticateLocalPlayer];
}

-(void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - GameCenter

- (void)showAuthenticationViewController
{
    SKGameKitHelper *gameKitHelper = [SKGameKitHelper sharedGameKitHelper];
    
    [self.topViewController presentViewController:gameKitHelper.authenticationViewController
                                         animated:YES
                                       completion:nil];
}

@end
