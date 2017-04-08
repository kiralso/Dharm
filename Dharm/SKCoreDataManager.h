//
//  SKCoreDataManager.h
//  Dharm
//
//  Created by Кирилл on 08.04.17.
//  Copyright © 2017 Kirill Solovyov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface SKCoreDataManager : NSObject

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;

+ (SKCoreDataManager *) sharedManager;

@end
