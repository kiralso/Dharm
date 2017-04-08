//
//  SKUser+CoreDataProperties.m
//  Dharm
//
//  Created by Кирилл on 08.04.17.
//  Copyright © 2017 Kirill Solovyov. All rights reserved.
//

#import "SKUser+CoreDataProperties.h"

@implementation SKUser (CoreDataProperties)

+ (NSFetchRequest<SKUser *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"SKUser"];
}

@dynamic score;
@dynamic fireDate;

@end
