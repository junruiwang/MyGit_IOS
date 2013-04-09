//
//  BusStation.m
//  Bustime
//
//  Created by 汪君瑞 on 13-4-5.
//  Copyright (c) 2013年 Jerry Wang. All rights reserved.
//

#import "BusStation.h"

@implementation BusStation

+ (BusStation *)unarchived:(NSData *) data
{
    return (BusStation *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
}

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

- (NSData *)archived
{
    return [NSKeyedArchiver archivedDataWithRootObject:self];
}

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        self.standCode = [aDecoder decodeObjectForKey:@"standCode"];
        self.standName = [aDecoder decodeObjectForKey:@"standName"];
        self.trend = [aDecoder decodeObjectForKey:@"trend"];
        self.area = [aDecoder decodeObjectForKey:@"area"];
        self.road = [aDecoder decodeObjectForKey:@"road"];
        self.bus = [aDecoder decodeObjectForKey:@"bus"];
    }
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.standCode forKey:@"standCode"];
    [aCoder encodeObject:self.standName forKey:@"standName"];
    [aCoder encodeObject:self.trend forKey:@"trend"];
    [aCoder encodeObject:self.area forKey:@"area"];
    [aCoder encodeObject:self.road forKey:@"road"];
    [aCoder encodeObject:self.bus forKey:@"bus"];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone
{
    BusStation *busStation = [[self class] allocWithZone:zone];
    self.standCode = [self.standCode copyWithZone:zone];
    self.standName = [self.standName copyWithZone:zone];
    self.trend = [self.trend copyWithZone:zone];
    self.area = [self.area copyWithZone:zone];
    self.road = [self.road copyWithZone:zone];
    self.bus = [self.bus copyWithZone:zone];
    return busStation;
}

@end
