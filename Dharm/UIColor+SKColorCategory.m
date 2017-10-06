//
//  UIColor+SKColorCategory.m
//  Dharm
//
//  Created by Kirill Solovyov on 02.10.17.
//  Copyright © 2017 Kirill Solovyov. All rights reserved.
//

#import "UIColor+SKColorCategory.h"
#import "SKUtils.h"

@implementation UIColor (SKColorCategory)

+ (UIColor *)warningRedColor {
    return RGBA(163.f, 26.f, 27.f, 1.f);
}

+ (UIColor *)textFieldPlaceholderColor {
    return RGBA(110.0, 110.0, 110.0, 1.f);

}

@end
