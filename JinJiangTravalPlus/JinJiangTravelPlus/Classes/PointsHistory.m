//
//  PointsHistory.m
//  JinJiangTravelPlus
//
//  Created by 胡 桂祁 on 7/17/13.
//  Copyright (c) 2013 JinJiang. All rights reserved.
//

#import "PointsHistory.h"

@implementation PointsHistory




- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_month forKey:@"month"];
    [aCoder encodeObject:_addPoints forKey:@"addPoints"];
    [aCoder encodeObject:_remainPoints forKey:@"remainPoints"];
    [aCoder encodeObject:_usePoints forKey:@"usePoints"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        self.month = [aDecoder decodeObjectForKey:@"month"];
        self.addPoints = [aDecoder decodeObjectForKey:@"addPoints"];
        self.remainPoints = [aDecoder decodeObjectForKey:@"remainPoints"];
        self.usePoints = [aDecoder decodeObjectForKey:@"usePoints"];
    }
    return self;
}

+(PointsHistory *)unArchived:(NSData *) data
{
    return (PointsHistory *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
}

- (NSData *)archived
{
    return [NSKeyedArchiver archivedDataWithRootObject:self];
}

@end
