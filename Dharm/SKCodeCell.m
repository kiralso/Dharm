//
//  SKCodeCell.m
//  Dharm
//
//  Created by Кирилл on 09.04.17.
//  Copyright © 2017 Kirill Solovyov. All rights reserved.
//

#import "SKCodeCell.h"
#import "SKUtils.h"
#import "SKUserDataManager.h"
#import "SKUser+CoreDataClass.h"
#import "SKMainObserver.h"
#import "SKTimer.h"

@interface SKCodeCell () <UITextFieldDelegate>

@property (assign, nonatomic) BOOL codeCanEntered;

@end

@implementation SKCodeCell

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(checkCodeCanEntered:)
                                                     name:SKTimerTextChangedNotification
                                                   object:nil];
        self.codeCanEntered = NO;
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Notifications

- (void) checkCodeCanEntered:(NSNotification *) notification {

    NSDateComponents *dateComponents = [notification.userInfo objectForKey:SKTimerTextUserInfoKey];

    if (dateComponents.minute < kMinutesBeforeFireDateToWarn) {
        self.codeCanEntered = YES;
    } else {
        self.codeCanEntered = NO;
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if ([self.codeTextField.text isEqualToString:kSafetyString]) {
        
        [[SKMainObserver sharedObserver] codeDidEntered];
        
        return YES;
    }
    
    return NO;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSCharacterSet* validationSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    NSArray* components = [string componentsSeparatedByCharactersInSet:validationSet];
    
    if ([components count] > 1 || self.codeCanEntered == NO) {
        return NO;
    }
    
    NSString* newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSMutableString* resultString = [NSMutableString string];
    
    NSArray* validationComponents = [newString componentsSeparatedByCharactersInSet:validationSet];
    newString = [validationComponents componentsJoinedByString:@""];
    
    static const int maxCodeLength = 10; //4815162342
    
    if ([newString length] > maxCodeLength) {
        return NO;
    }
    
    NSInteger currentCodeLength = MIN([newString length], maxCodeLength);
    
    NSString* number = [newString substringFromIndex:(int)[newString length] - currentCodeLength];
    
    [resultString appendString:number];
    
    if ([resultString length] > 1) {
        [resultString insertString:@" " atIndex:1];
    }
    
    if ([resultString length] > 3) {
        [resultString insertString:@" " atIndex:3];
    }
    
    if ([resultString length] > 6) {
        [resultString insertString:@" " atIndex:6];
    }
    
    if ([resultString length] > 9) {
        [resultString insertString:@" " atIndex:9];
    }
    if ([resultString length] > 12) {
        [resultString insertString:@" " atIndex:12];
    }
    
    textField.text = resultString;
    
    if ([textField.text isEqualToString:kSafetyString]) {
                
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [textField resignFirstResponder];
            textField.text = @"";
            
            [[SKMainObserver sharedObserver] codeDidEntered];
        });
    }
    return NO;
}

@end
