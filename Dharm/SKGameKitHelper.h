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

@protocol SKGameKitHelperDelegate

- (void) showAuthenticationController:(UIViewController *)authenticationController;

@end

@interface SKGameKitHelper : NSObject

@property (strong, nonatomic) NSString *leaderboardIdentifier;
@property (weak, nonatomic) UIViewController<SKGameKitHelperDelegate> *delegate;

- (void) authenticateLocalPlayer;
- (void) reportScore:(int64_t) score;

- (void) loadLeaderboardWithIdentifier:(NSString *) leaderboardIdentifier
                   andCompetionHandler:(void(^)(NSArray<GKScore *> *scores, NSError *error))completionHandler;

@end
