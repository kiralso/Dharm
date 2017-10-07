//
//  SKScoreCell.h
//  Dharm
//
//  Created by Кирилл on 09.04.17.
//  Copyright © 2017 Kirill Solovyov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SKScoreCell : UITableViewCell

@property (strong, nonatomic)UILabel *scoreLabel;

- (void)updateCell;

@end
