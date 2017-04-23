//
//  SKCodeCell.h
//  Dharm
//
//  Created by Кирилл on 09.04.17.
//  Copyright © 2017 Kirill Solovyov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKObserverProtocol.h"

@interface SKCodeCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField *codeTextField;

@end
