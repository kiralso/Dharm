//
//  SKTimerCell.h
//  Dharm
//
//  Created by Кирилл on 09.04.17.
//  Copyright © 2017 Kirill Solovyov. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SKTimer;

@interface SKTimerCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *timerLabel;

@property (strong, nonatomic) SKTimer *timer;

- (void) startTimerInStart:(NSTimeInterval)start end:(NSTimeInterval)end andInterval:(NSTimeInterval)interval;
- (void) startTimerToNextFireDate;

@end
