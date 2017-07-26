//
//  SKNotificationDate.h
//  Dharm
//
//  Created by Кирилл on 15.07.17.
//  Copyright © 2017 Kirill Solovyov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SKNotificationDate : NSObject

@property(strong, nonatomic) NSDate *fireDate;
@property(strong, nonatomic) NSDate *warningDate;

- (instancetype)initWithFireDate:(NSDate *) fireDate warningDate:(NSDate *) warningDate;

@end
