//
//  JJHotel.m
//  JinJiangTravalPlus
//
//  Created by Leon on 11/7/12.
//  Copyright (c) 2012 Leon. All rights reserved.
//

#import "JJHotel.h"

@implementation JJHotel

- (id)init {
    if ((self = [super init]) != nil) {
    }
    return self;
}

- (id)initWithCoords:(CLLocationCoordinate2D)coords
{
	self = [super init];
	if (self != nil)
    {
        _coordinate = coords;
    }
	return self;
}

- (id)copyWithZone:(NSZone *)zonee
{
    JJHotel *hotel = [[self class] allocWithZone:zonee];
    hotel.name = [self.name copy];
    hotel.address = [self.address copy];
    hotel.icon = [self.icon copy];
    
    return self;
}

- (NSString *)name
{
    return [_name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSComparisonResult) compareDistance:(JJHotel *)hotel {
    return (self.distance < hotel.distance) ? NSOrderedAscending : NSOrderedDescending;
}

- (NSComparisonResult) compareDistanceDesc:(JJHotel *)hotel {
    return (self.distance > hotel.distance) ? NSOrderedAscending : NSOrderedDescending;
}

- (NSComparisonResult) compareStar:(JJHotel *)hotel {
    return (self.star > hotel.star) ? NSOrderedAscending : NSOrderedDescending;  // reverse order
}

- (NSComparisonResult) comparePrice:(JJHotel *)hotel {
    if (self.price == 0) return NSOrderedDescending;
    if (hotel.price == 0) return NSOrderedAscending;
    return (self.price < hotel.price) ? NSOrderedAscending : NSOrderedDescending;
}

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    
    self.hotelId = [coder decodeIntegerForKey:@"hotelId"];
    self.name = [coder decodeObjectForKey:@"name"];
    self.address = [coder decodeObjectForKey:@"address"];
    self.star = [coder decodeIntegerForKey:@"star"];
    self.icon = [coder decodeObjectForKey:@"icon"];
    self.cityName = [coder decodeObjectForKey:@"cityName"];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeInteger:self.hotelId forKey:@"hotelId"];
    [coder encodeObject:self.name forKey:@"name"];
    [coder encodeObject:self.address forKey:@"address"];
    [coder encodeInteger:self.star forKey:@"star"];
    [coder encodeObject:self.icon forKey:@"icon"];
    [coder encodeObject:self.cityName forKey:@"cityName"];
}

+ (JJHotelBrand)brandFromName:(NSString *)brandName
{
    NSDictionary *brandDict = @{@"JJHOTEL":@(JJHotelBrandJJHOTEL), @"SHANGYUE":@(JJHotelBrandSHANGYUE), @"JJINN":@(JJHotelBrandJJINN), @"BESTAY":@(JJHotelBrandBESTAY), @"BYL":@(JJHotelBrandBYL), @"JG":@(JJHotelBrandJG)};
    return (JJHotelBrand)[brandDict[brandName] intValue];
}

+ (NSString *)nameForBrand:(JJHotelBrand)brand
{
    NSDictionary *brandDict = @{@(JJHotelBrandJJHOTEL):@"JJHOTEL", @(JJHotelBrandSHANGYUE):@"SHANGYUE", @(JJHotelBrandJJINN):@"JJINN", @(JJHotelBrandBESTAY):@"BESTAY", @(JJHotelBrandBYL):@"BYL", @(JJHotelBrandJG):@"JG"};
    return (NSString *)brandDict[@(brand)];
}

+ (JJHotelOrigin)originFromName:(NSString *)originName
{
    NSDictionary *originDict = @{@"JREZ":@(JJHotelOriginJREZ), @"JJINN":@(JJHotelOriginJJINN), @"JGINN":@(JJHotelOriginJGINN), @"BESTAY":@(JJHotelOriginBESTAY)};
    return (JJHotelOrigin)[originDict[originName] intValue];
}

+ (NSString *)nameForOrigin:(JJHotelOrigin)origin
{
    NSDictionary *originDict = @{@(JJHotelOriginJREZ):@"JREZ", @(JJHotelOriginJJINN):@"JJINN", @(JJHotelOriginJGINN):@"JGINN", @(JJHotelOriginBESTAY):@"BESTAY"};
    return (NSString *)originDict[@(origin)];
}

+ (NSInteger)starFromName:(NSString *)starName
{
    NSDictionary *brandDict = @{@"FIVE":@(5), @"FOUR":@(4), @"THREE":@(3), @"TWO":@(2), @"ONE":@(1)};
    return [brandDict[starName] intValue];
}

@end

