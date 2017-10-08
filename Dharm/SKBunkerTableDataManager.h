//
//  SKBunkerTableDataManager.h
//  Dharm
//
//  Created by Kirill Solovyov on 05.10.17.
//  Copyright © 2017 Kirill Solovyov. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

@class SKBunkerTableDataManager;
@class SKBunkerTableViewController;

@protocol SKBunkerTableDataManagerDelegate

- (void)codeDidEnteredSuccess:(BOOL)flag;
- (void)codeDidnNotEnteredTimes:(NSInteger)times;
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string forMananger:(SKBunkerTableDataManager *)manager;

@end

@interface SKBunkerTableDataManager : NSObject <UITextFieldDelegate>

@property (weak, nonatomic) SKBunkerTableViewController<SKBunkerTableDataManagerDelegate> *delegate;

- (instancetype)initWithWithDelegate:(SKBunkerTableViewController<SKBunkerTableDataManagerDelegate> *)delegate;

@end
