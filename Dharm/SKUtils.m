//
//  SKUtils.m
//  Dharm
//
//  Created by Кирилл on 08.05.17.
//  Copyright © 2017 Kirill Solovyov. All rights reserved.
//

#import "SKUtils.h"

BOOL iPad() {
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
}

BOOL iPhone() {
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone);
}

BOOL isFirstTime() {
    return ![[NSUserDefaults standardUserDefaults] boolForKey:kIsFirstTime];
}

NSString* backgroundPath() {
    if (iPhone()) {
        return kPhoneBackground;
    }
    if (iPad()) {
        return kPadBackground;
    }
    return nil;
}
