//
//  SKLeaderboardTableManager.h
//  Dharm
//
//  Created by Kirill Solovyov on 06.10.17.
//  Copyright © 2017 Kirill Solovyov. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

@interface SKLeaderboardTableManager : NSObject <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSArray *usersArray;

@end
