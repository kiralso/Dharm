//
//  SKCodeCell.h
//  Dharm
//
//  Created by Кирилл on 09.04.17.
//  Copyright © 2017 Kirill Solovyov. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SKCodeCell;

@protocol SKCodeCellDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string cell:(SKCodeCell *)cell;
@end

@interface SKCodeCell : UITableViewCell

@property (weak, nonatomic) id <SKCodeCellDelegate> delegate;

- (void)updateCell;

@end
