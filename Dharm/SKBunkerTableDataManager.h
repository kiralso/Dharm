//
//  SKBunkerTableDataManager.h
//  Dharm
//
//  Created by Kirill Solovyov on 05.10.17.
//  Copyright © 2017 Kirill Solovyov. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

@class SKScoreCell;
@class SKTimerCell;
@class SKCodeCell;

@protocol SKBunkerTableDataManagerDelegate
- (void)codeDidEnteredSuccess:(BOOL)flag;
- (void)codeDidnNotEnteredTimes:(NSInteger)times;
@end

@interface SKBunkerTableDataManager : NSObject <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) UITableViewController<SKBunkerTableDataManagerDelegate> *delegate;
@property (assign, nonatomic) BOOL codeCanEntered;

@end
