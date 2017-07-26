//
//  SKUser.h
//  Dharm
//
//  Created by Кирилл on 15.07.17.
//  Copyright © 2017 Kirill Solovyov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SKUser : NSObject 

@property (assign, nonatomic) NSInteger score;
@property (assign, nonatomic) NSInteger maxScore;
@property (strong, nonatomic) NSArray *notificationDatesArray;
@property (strong, nonatomic) NSArray *pagesIndexesArray;
@property (strong, nonatomic) NSSet *answeredPages;
@property (assign, nonatomic) BOOL isGameOver;

@end
