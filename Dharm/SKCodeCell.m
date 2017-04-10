//
//  SKCodeCell.m
//  Dharm
//
//  Created by Кирилл on 09.04.17.
//  Copyright © 2017 Kirill Solovyov. All rights reserved.
//

#import "SKCodeCell.h"
#import "SKConstants.h"
#import "SKUserDataManager.h"
#import "SKUser+CoreDataClass.h"

@interface SKCodeCell () <UITextFieldDelegate>

@end

@implementation SKCodeCell 

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self updateScoreLabel];
    }
    return self;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if ([self.codeTextField.text isEqualToString:kSafetyString]) {
        
        NSInteger newScore = [[SKUserDataManager sharedInstance] user].score++;
        
        [[SKUserDataManager sharedInstance] updateUserWithScore:newScore];
        
        [self updateScoreLabel];
        
        return YES;
    }
    
    return NO;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSCharacterSet* validationSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    NSArray* components = [string componentsSeparatedByCharactersInSet:validationSet];
    
    if ([components count] > 1) {
        return NO;
    }
    
    NSString* newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSMutableString* resultString = [NSMutableString string];
    
    NSArray* validationComponents = [newString componentsSeparatedByCharactersInSet:validationSet];
    newString = [validationComponents componentsJoinedByString:@""];
    
    
    static const int localNumberMaxLength = 7;
    static const int countryCodeMaxLength = 1;
    static const int areaCodeMaxLength = 3;
    
    if ([newString length] > localNumberMaxLength + countryCodeMaxLength + areaCodeMaxLength) {
        return NO;
    }
    
    NSInteger localNumberLength = MIN([newString length], localNumberMaxLength);
    
    if (localNumberLength > 0) {
        
        NSString* number = [newString substringFromIndex:(int)[newString length] - localNumberLength];
        
        [resultString appendString:number];
        
        if ([resultString length] > 3) {
            
            [resultString insertString:@"-" atIndex:3];
            
        }
        
    }
    
    if ([newString length] > localNumberMaxLength) {
        
        NSInteger areaCodeLength = MIN((int)[newString length] - localNumberMaxLength, areaCodeMaxLength);
        
        NSRange areaRange = NSMakeRange((int)[newString length] - localNumberMaxLength - areaCodeLength, areaCodeLength);
        
        NSString* area = [newString substringWithRange:areaRange];
        
        area = [NSString stringWithFormat:@"(%@) ",area];
        
        [resultString insertString:area atIndex:0];
    }
    
    if ([newString length] > localNumberMaxLength + areaCodeMaxLength) {
        
        NSInteger countryCodeLength = MIN((int)[newString length] - localNumberMaxLength - areaCodeMaxLength, countryCodeMaxLength);
        
        NSRange countryCodeRange = NSMakeRange(0, countryCodeLength);
        
        NSString* countryCode = [newString substringWithRange:countryCodeRange];
        
        countryCode = [NSString stringWithFormat:@"+%@ ",countryCode];
        
        [resultString insertString:countryCode atIndex:0];
    }
    
    textField.text = resultString;
    
    return NO;
}

#pragma mark - Useful methods

- (void) updateScoreLabel {
    
    SKUser *user = [[SKUserDataManager sharedInstance] user];
    
    self.codeTextField.text = [NSString stringWithFormat:@"Score: %i",(int)user.score];
}

@end
