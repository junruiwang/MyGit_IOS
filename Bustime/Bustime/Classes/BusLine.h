//
//  BusLine.h
//  Bustime
//
//  Created by 汪君瑞 on 13-4-1.
//  Copyright (c) 2013年 Jerry Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BusSingleLine.h"

@interface BusLine : NSObject

@property(nonatomic, copy) NSString *lineNumber;
@property(nonatomic, copy) NSString *lineCode;
@property(nonatomic, assign) NSInteger totalStation;
@property(nonatomic, copy) NSString *startStation;
@property(nonatomic, copy) NSString *endStation;
@property(nonatomic, copy) NSString *runTime;

@property (nonatomic, strong) NSMutableArray *stationArray;

- (id) initWithDictionary : (NSDictionary *) dict;

@end
