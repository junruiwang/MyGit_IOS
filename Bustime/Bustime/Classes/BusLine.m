//
//  BusLine.m
//  Bustime
//
//  Created by 汪君瑞 on 13-4-1.
//  Copyright (c) 2013年 Jerry Wang. All rights reserved.
//

#import "BusLine.h"

@implementation BusLine

- (id) initWithDictionary : (NSDictionary *) dict
{
    if (dict == nil) {
        self = [super init];
        _stationArray = [[NSMutableArray alloc] initWithCapacity:10];
        return self;
    }
    
    if (self = [super init]) {
        self.lineNumber = [dict objectForKey:@"lineNumber"];
        self.lineCode = [dict objectForKey:@"lineGuid"];
        self.totalStation = [[dict objectForKey:@"totalStation"] intValue];
        self.startStation = [dict objectForKey:@"startStation"];
        self.endStation = [dict objectForKey:@"endStation"];
        self.runTime = [dict objectForKey:@"runTime"];
        _stationArray = [[NSMutableArray alloc] initWithCapacity:10];
    }
    return self;
}

@end
