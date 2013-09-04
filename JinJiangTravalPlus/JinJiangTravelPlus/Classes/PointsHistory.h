//
//  PointsHistory.h
//  JinJiangTravelPlus
//
//  Created by 胡 桂祁 on 7/17/13.
//  Copyright (c) 2013 JinJiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PointsHistory : NSObject <NSCoding>

@property(nonatomic,copy) NSString *month;

@property(nonatomic,copy) NSString *usePoints;

@property(nonatomic,copy) NSString *addPoints;

@property(nonatomic,copy) NSString *remainPoints;

- (NSData *)archived;

+(PointsHistory *)unArchived:(NSData *) data;

@end
