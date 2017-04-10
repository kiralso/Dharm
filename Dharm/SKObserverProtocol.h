//
//  SKObserverProtocol.h
//  Dharm
//
//  Created by Кирилл on 10.04.17.
//  Copyright © 2017 Kirill Solovyov. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SKObserverProtocol <NSObject>

- (void) removeObserver:(NSObject *) observer;
- (void) addObserver:(NSObject *) observer;

@end
