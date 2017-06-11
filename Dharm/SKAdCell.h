//
//  SKAdCell.h
//  Dharm
//
//  Created by Кирилл on 09.04.17.
//  Copyright © 2017 Kirill Solovyov. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GADBannerView;

@interface SKAdCell : UITableViewCell

@property (weak, nonatomic) IBOutlet GADBannerView *adView;

@end
