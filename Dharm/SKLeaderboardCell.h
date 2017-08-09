//
//  SKLeaderboardCell.h
//  Dharm
//
//  Created by Кирилл on 08.08.17.
//  Copyright © 2017 Kirill Solovyov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SKLeaderboardCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *playerAliasLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *rowNumberLabel;

@property (weak, nonatomic) IBOutlet UIImageView *playerAvatarImage;

@end
