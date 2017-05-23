//
//  SKMainObserver.h
//  Dharm
//
//  Created by Кирилл on 10.04.17.
//  Copyright © 2017 Kirill Solovyov. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString* const SKMainObserverReloadViewControlerNotification;

@interface SKMainObserver : NSObject

+ (SKMainObserver *) sharedObserver;
- (void) updateNotificationDates;
- (NSTimeInterval) timeIntervalBeforeNextFireDate;
- (void) updateData;
- (void) updateDataWithScore:(NSInteger)score;
- (void) codeDidEntered;
- (void) checkScore;

@end
