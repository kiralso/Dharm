//
//  SKNotificationDate+CoreDataProperties.m
//  Dharm
//
//  Created by Кирилл on 08.04.17.
//  Copyright © 2017 Kirill Solovyov. All rights reserved.
//

#import "SKNotificationDate+CoreDataProperties.h"

@implementation SKNotificationDate (CoreDataProperties)

+ (NSFetchRequest<SKNotificationDate *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"SKNotificationDate"];
}

@dynamic fireDate;
@dynamic warningDate;
@dynamic user;

@end
