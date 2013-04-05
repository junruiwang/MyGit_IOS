//
//  BusStation.m
//  Bustime
//
//  Created by 汪君瑞 on 13-4-5.
//  Copyright (c) 2013年 Jerry Wang. All rights reserved.
//

#import "BusStation.h"

@implementation BusStation

- (id) initWithDictionary : (NSDictionary *) dict
{
    if (dict == nil) {
        self = [super init];
        return self;
    }
    
    if (self = [super init]) {
        self.standCode = [dict objectForKey:@"standCode"];
        self.standName = [dict objectForKey:@"standName"];
        self.trend = [dict objectForKey:@"trend"];;
        self.area = [dict objectForKey:@"area"];
        self.road = [dict objectForKey:@"road"];
        self.bus = [dict objectForKey:@"bus"];
    }
    return self;
}

@end
