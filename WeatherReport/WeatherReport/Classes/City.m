//
//  City.m
//  WeatherReport
//
//  Created by jerry on 13-5-17.
//  Copyright (c) 2013年 jerry. All rights reserved.
//

#import "City.h"

@implementation City

+ (City *)unarchived:(NSData *) data
{
    City *city = (City *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    return city;
}

- (id) initWithDictionary : (NSDictionary *) dict
{
    if (dict == nil) {
        self = [super init];
        return self;
    }
    
    if (self = [super init]) {
        
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
        self.province = [aDecoder decodeObjectForKey:@"province"];
        self.cityName = [aDecoder decodeObjectForKey:@"cityName"];
        self.searchCode = [aDecoder decodeObjectForKey:@"searchCode"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.province forKey:@"province"];
    [aCoder encodeObject:self.cityName forKey:@"cityName"];
    [aCoder encodeObject:self.searchCode forKey:@"searchCode"];
}

#pragma mark - NSCopying
- (id)copyWithZone:(NSZone *)zone
{
    City *city = [[self class] allocWithZone:zone];
    self.province = [self.province copyWithZone:zone];
    self.cityName = [self.cityName copyWithZone:zone];
    self.searchCode = [self.searchCode copyWithZone:zone];
    return city;
}

@end
