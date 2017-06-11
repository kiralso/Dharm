//
//  SKGameKitHelper.h
//  Dharm
//
//  Created by Кирилл on 23.05.17.
//  Copyright © 2017 Kirill Solovyov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>

extern NSString * const SKPresentAuthenticationViewControllerNotification;

@interface SKGameKitHelper : NSObject

@property (nonatomic, readonly) UIViewController *authenticationViewController;
@property (nonatomic, readonly) NSError *lastError;
@property (strong, nonatomic) NSString *leaderboardIdentifier;

+ (instancetype) sharedGameKitHelper;
- (void) authenticateLocalPlayer;
- (void) reportScore:(NSInteger) score;

- (void) loadLeaderboardWithIdentifier:(NSString *) leaderboardIdentifier
                   andCompetionHandler:(void(^)(NSArray<GKScore *> *scores, NSError *error))completionHandler;

- (void) reportScore: (int64_t) score forLeaderboardID: (NSString*) leaderboardIdentifier;

@end
