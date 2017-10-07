//
//  SKCodeCell.m
//  Dharm
//
//  Created by Кирилл on 09.04.17.
//  Copyright © 2017 Kirill Solovyov. All rights reserved.
//

#import "SKCodeCell.h"

#import "VMaskTextField.h"
#import "UIColor+SKColorCategory.h"

static CGFloat const SKCodeTextFieldHeight = 35.0;
static CGFloat const SKCodeTextFieldWidth = 347.0;

static NSString * const SKTextFieldPlaceholderText = @"enter the code here";

@interface SKCodeCell () <UITextFieldDelegate>

@property (strong, nonatomic) VMaskTextField *codeTextField;

@end

@implementation SKCodeCell

#pragma mark - Initialization

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupCell];
        [self initializeTextField];
    }
    return self;
}

#pragma mark - Public

- (void)updateCell {
    [self updateTextFieldFrame];
}

#pragma mark - SKCodeCell

- (void)setupCell {
    self.backgroundColor = [UIColor clearColor];
}

- (void)initializeTextField {
    self.codeTextField = [[VMaskTextField alloc] init];
    self.codeTextField.placeholder = SKTextFieldPlaceholderText;
    self.codeTextField.font = [UIFont fontWithName:@"Avenir Next" size:25.0];
    self.codeTextField.mask = @"# # ## ## ## ##"; // 4 8 15 16 23 42
    self.codeTextField.delegate = self;
    self.codeTextField.adjustsFontSizeToFitWidth = YES;
    self.codeTextField.minimumFontSize = 13.0;
    self.codeTextField.textAlignment = NSTextAlignmentCenter;
    self.codeTextField.textColor = [UIColor whiteColor];
    self.codeTextField.keyboardType = UIKeyboardTypeNumberPad;
    [self.codeTextField setValue:[UIColor textFieldPlaceholderColor]
                    forKeyPath:@"_placeholderLabel.textColor"];
    
    [self.contentView addSubview:self.codeTextField];
}

- (void)updateTextFieldFrame {
    CGFloat codeTextFieldX = (CGRectGetWidth(self.frame) - SKCodeTextFieldWidth) / 2;
    CGFloat codeTextFieldY = (CGRectGetHeight(self.frame) - SKCodeTextFieldHeight) / 2;
    self.codeTextField.frame = CGRectMake(codeTextFieldX, codeTextFieldY, SKCodeTextFieldWidth, SKCodeTextFieldHeight);
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (self.delegate) {
        return [self.delegate textField:textField shouldChangeCharactersInRange:range replacementString:string cell:self];
    } else {
        return NO;
    }
}

@end
