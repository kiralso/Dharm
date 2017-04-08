//
//  SKDateGenerator.h
//  Dharm
//
//  Created by Кирилл on 05.04.17.
//  Copyright © 2017 Kirill Solovov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SKDateGenerator : NSObject

- (NSArray<NSDate *> *) fireDatesSinceNow;
- (NSDate *) firstFireDateSinceNowFromSet:(NSSet *) set;
- (NSArray<NSDate *> *) warningDatesWithArray:(NSArray<NSDate *> *) array;

@end
