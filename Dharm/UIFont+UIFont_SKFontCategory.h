//
//  UIFont+UIFont_SKFontCategory.h
//  Dharm
//
//  Created by Kirill Solovyov on 03.06.2018.
//  Copyright © 2018 Kirill Solovyov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (UIFont_SKFontCategory)

+ (UIFont *)regularWithSize:(CGFloat)size;

#pragma mark - Font sizes

+ (CGFloat)small;
+ (CGFloat)medium;
+ (CGFloat)huge;

@end
