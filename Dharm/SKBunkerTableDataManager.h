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

@class SKBunkerTableDataManager;

@protocol SKBunkerTableDataManagerDelegate

- (void)codeCanBeEntered:(BOOL)flag;

- (void)codeDidnNotEnteredTimes:(NSInteger)times;

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string forMananger:(SKBunkerTableDataManager *)manager;

@end

@interface SKBunkerTableDataManager : NSObject <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) id <SKBunkerTableDataManagerDelegate> delegate;

- (instancetype)initWithTableView:(UITableView *)tableView;

@end
