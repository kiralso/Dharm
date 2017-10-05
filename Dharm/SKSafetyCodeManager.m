//
//  SKSafetyCodeManager.m
//  Dharm
//
//  Created by Kirill Solovyov on 05.10.17.
//  Copyright © 2017 Kirill Solovyov. All rights reserved.
//

#import "SKSafetyCodeManager.h"
#import "VMaskTextField.h"
#import "SKUtils.h"
@import UIKit;

@interface SKSafetyCodeManager()<UITextFieldDelegate>
@property (strong,nonatomic) VMaskTextField *textField;
@end

@implementation SKSafetyCodeManager

- (instancetype)initWithTextField:(UITextField *)textField {
    self = [super init];
    if (self) {
        self.textField = (VMaskTextField *)textField;
        self.textField.mask = @"# # ## ## ## ##"; // 4 8 15 16 23 42
        self.textField.delegate = self;
    }
    return self;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSCharacterSet* validationSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    NSArray* components = [string componentsSeparatedByCharactersInSet:validationSet];
    NSString *resultString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if ([components count] <= 1) {
        if (self.delegate.codeCanEntered) {
            if ([resultString isEqualToString:kSafetyString]) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [textField resignFirstResponder];
                    textField.text = @"";
                    [self.delegate codeDidEnteredSuccess:YES];
                });
            }
            return  [self.textField shouldChangeCharactersInRange:range replacementString:string];
        } else {
            [textField resignFirstResponder];
            [self.delegate codeDidEnteredSuccess:NO];
        }
    }
    return NO;
}

@end
