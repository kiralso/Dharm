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
        
        if (error) {
            NSLog(@"GameKitHelper ERROR: %@",[error localizedDescription]);
        }
        
        if(viewController != nil) {
            [self setAuthenticationViewController:viewController];
        } else if([GKLocalPlayer localPlayer].isAuthenticated) {
            
            self.enableGameCenter = YES;
            
            [[GKLocalPlayer localPlayer] loadDefaultLeaderboardIdentifierWithCompletionHandler:^(NSString *leaderboardIdentifier, NSError *error) {
                
                if (error != nil) {
                    NSLog(@"%@", [error localizedDescription]);
                } else {
                    self.leaderboardIdentifier = leaderboardIdentifier;
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

- (void) reportScore:(NSInteger) score {
    
    if ([GKLocalPlayer localPlayer].isAuthenticated) {
        
        NSLog(@"SCORE - %lld", (int64_t) score);
        
        GKScore *bestScore = [[GKScore alloc] initWithLeaderboardIdentifier:self.leaderboardIdentifier];

        if (bestScore.value > score) {
            return;
        }
        
        NSLog(@"BEST SCORE - %lld", bestScore.value);

        bestScore.value = (int64_t) score;
        NSLog(@"IDENTIFIER - %@", bestScore.leaderboardIdentifier);
        
        [GKScore reportScores:@[bestScore] withCompletionHandler:^(NSError * _Nullable error) {
            
            if (error) {
                NSLog(@"%@", error.localizedDescription);
            }
            
            GKScore *bestScore = [[GKScore alloc] initWithLeaderboardIdentifier:self.leaderboardIdentifier];
            
            NSLog(@"%@", bestScore.description);
            
            NSLog(@"BEST SCORE - %lld", bestScore.value);
        }];
    }
}

- (void) reportScore: (int64_t) score forLeaderboardID: (NSString*) identifier {
    
    GKScore *scoreReporter = [[GKScore alloc] initWithLeaderboardIdentifier: identifier];
    scoreReporter.value = score;
    scoreReporter.context = 0;
    
    NSArray *scores = @[scoreReporter];
    [GKScore reportScores:scores withCompletionHandler:^(NSError *error) {
        //Do something interesting here.
    }];
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
