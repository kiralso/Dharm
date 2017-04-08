//
//  SKNotificationDate+CoreDataProperties.h
//  Dharm
//
//  Created by Кирилл on 08.04.17.
//  Copyright © 2017 Kirill Solovyov. All rights reserved.
//

#import "SKNotificationDate+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface SKNotificationDate (CoreDataProperties)

+ (NSFetchRequest<SKNotificationDate *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSDate *fireDate;
@property (nullable, nonatomic, copy) NSDate *warningDate;
@property (nullable, nonatomic, retain) SKUser *user;

@end

NS_ASSUME_NONNULL_END
