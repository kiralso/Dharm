//
//  SKGameKitManager.h
//  Dharm
//
//  Created by Кирилл on 23.05.17.
//  Copyright © 2017 Kirill Solovyov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>

@protocol SKGameKitManagerDelegate
- (void) showAuthenticationController:(UIViewController *)authenticationController;
@end

@interface SKGameKitManager : NSObject

@property (strong, nonatomic) NSString *leaderboardIdentifier;
@property (weak, nonatomic) UIViewController<SKGameKitManagerDelegate> *delegate;

+ (SKGameKitManager *)sharedManager;
- (void)authenticateLocalPlayer;
- (void)reportScore:(int64_t)score;
- (void)loadLeaderboardWithIdentifier:(NSString *) leaderboardIdentifier
                  andCompetionHandler:(void(^)(NSArray<GKScore *> *scores, NSError *error))completionHandler;
@end
