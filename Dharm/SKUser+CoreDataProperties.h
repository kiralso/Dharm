//
//  SKUser+CoreDataProperties.h
//  Dharm
//
//  Created by Кирилл on 08.04.17.
//  Copyright © 2017 Kirill Solovyov. All rights reserved.
//

#import "SKUser+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface SKUser (CoreDataProperties)

+ (NSFetchRequest<SKUser *> *)fetchRequest;

@property (nonatomic) int16_t score;
@property (nullable, nonatomic, retain) NSSet<SKNotificationDate *> *fireDate;

@end

@interface SKUser (CoreDataGeneratedAccessors)

- (void)addFireDateObject:(SKNotificationDate *)value;
- (void)removeFireDateObject:(SKNotificationDate *)value;
- (void)addFireDate:(NSSet<SKNotificationDate *> *)values;
- (void)removeFireDate:(NSSet<SKNotificationDate *> *)values;

@end

NS_ASSUME_NONNULL_END
