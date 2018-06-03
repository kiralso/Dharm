//
//  SKTutorialViewController.h
//  Dharm
//
//  Created by Кирилл on 24.06.17.
//  Copyright © 2017 Kirill Solovyov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SKTutorialViewController : UIViewController

// Properties
@property (assign, nonatomic) NSInteger pageIndex;
@property (assign, nonatomic) NSInteger disasterPower;
@property (strong, nonatomic) NSArray *pagesArray;
@property (assign, nonatomic) BOOL isTutorial;
@property (assign, nonatomic) BOOL isDisaster;

// Outlets
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) IBOutlet UIButton *yesButton;
@property (weak, nonatomic) IBOutlet UIButton *noButton;
@property (weak, nonatomic) IBOutlet UIProgressView *progressBar;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;

// Actions
- (IBAction)doneAction:(UIButton *)sender;
- (IBAction)yesAction:(UIButton *)sender;
- (IBAction)noAction:(UIButton *)sender;

@end
