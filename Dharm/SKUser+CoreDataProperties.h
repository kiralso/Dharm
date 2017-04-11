//
//  SKUser+CoreDataProperties.h
//  Dharm
//
//  Created by Кирилл on 11.04.17.
//  Copyright © 2017 Kirill Solovyov. All rights reserved.
//

#import "SKUser+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface SKUser (CoreDataProperties)

+ (NSFetchRequest<SKUser *> *)fetchRequest;

@property (nonatomic) int16_t score;
@property (nullable, nonatomic, retain) NSSet<SKNotificationDate *> *notificationDate;

@end

@interface SKUser (CoreDataGeneratedAccessors)

- (void)addNotificationDateObject:(SKNotificationDate *)value;
- (void)removeNotificationDateObject:(SKNotificationDate *)value;
- (void)addNotificationDate:(NSSet<SKNotificationDate *> *)values;
- (void)removeNotificationDate:(NSSet<SKNotificationDate *> *)values;

@end

NS_ASSUME_NONNULL_END
