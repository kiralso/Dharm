//
//  SKStoryMenuViewController.h
//  Dharm
//
//  Created by Кирилл on 06.07.17.
//  Copyright © 2017 Kirill Solovyov. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SKBunkerDataManager;

@interface SKStoryMenuViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *menuTableView;

@property (strong, nonatomic) SKBunkerDataManager *bunkerDataManager;

@end
