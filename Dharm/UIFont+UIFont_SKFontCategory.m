//
//  UIFont+UIFont_SKFontCategory.m
//  Dharm
//
//  Created by Kirill Solovyov on 03.06.2018.
//  Copyright © 2018 Kirill Solovyov. All rights reserved.
//

#import "UIFont+UIFont_SKFontCategory.h"

// Font sizes
static CGFloat const small = 17.0;
static CGFloat const medium = 25.0;
static CGFloat const huge = 80.0;

@implementation UIFont (UIFont_SKFontCategory)

+ (UIFont *)regularWithSize:(CGFloat)size {
    return [UIFont fontWithName:@"Avenir Next" size:size];
}

#pragma mark - Font sizes

+ (CGFloat)small {
    return small;
}

+ (CGFloat)medium {
    return medium;
}

+ (CGFloat)huge {
    return huge;
}

@end
