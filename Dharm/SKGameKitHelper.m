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

NSString *const kLeaderboardIdentifier = @"grp.com.dharm.leaderboard";

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
        
        if (error) {
            NSLog(@"GameKitHelper ERROR: %@",[error localizedDescription]);
        }
        
        if (viewController) {
            
            [self setAuthenticationViewController:viewController];
            
        } else if([GKLocalPlayer localPlayer].isAuthenticated) {
            
            self.enableGameCenter = YES;
            
            [[GKLocalPlayer localPlayer] setDefaultLeaderboardIdentifier:kLeaderboardIdentifier completionHandler:^(NSError * _Nullable error) {
                
                if (error != nil) {
                    NSLog(@"%@", [error localizedDescription]);
                } else {
                    self.leaderboardIdentifier = kLeaderboardIdentifier;
                }
            }];
            
        } else {
            self.enableGameCenter = NO;
        }
    };
}

- (void)setAuthenticationViewController:(UIViewController *)authenticationViewController {
    
    if (authenticationViewController != nil) {
        
        _authenticationViewController = authenticationViewController;
        
        [[NSNotificationCenter defaultCenter]
         postNotificationName:SKPresentAuthenticationViewControllerNotification
                       object:self];
    }
}

#pragma mark - Player Actions

- (void) reportScore:(int64_t)score {
    
    if ([GKLocalPlayer localPlayer].isAuthenticated) {
        
        NSLog(@"IDENTIFIER - %@", self.leaderboardIdentifier);
        GKScore *scoreReporter = [[GKScore alloc] initWithLeaderboardIdentifier: self.leaderboardIdentifier];
        scoreReporter.value = score;
        scoreReporter.context = 0;
        
        [GKScore reportScores:@[scoreReporter] withCompletionHandler:^(NSError *error) {
            
            if (error) {
                NSLog(@"%@", error.description);
            }
        }];
        
        NSLog(@"%lld", score);
    }
}

- (void) loadLeaderboardWithIdentifier:(NSString *) leaderboardIdentifier
                   andCompetionHandler:(void(^)(NSArray<GKScore *> *scores, NSError * error))completionHandler {
    
    if ([SKGameKitHelper sharedGameKitHelper].leaderboardIdentifier) {
        
        GKLeaderboard *leaderboardRequest = [[GKLeaderboard alloc] init];
        
        leaderboardRequest.playerScope = GKLeaderboardPlayerScopeGlobal;
        leaderboardRequest.timeScope = GKLeaderboardTimeScopeAllTime;
        leaderboardRequest.identifier = leaderboardIdentifier;
        leaderboardRequest.range = NSMakeRange(1,20);
        
        [leaderboardRequest loadScoresWithCompletionHandler:completionHandler];
    }
}

@end
