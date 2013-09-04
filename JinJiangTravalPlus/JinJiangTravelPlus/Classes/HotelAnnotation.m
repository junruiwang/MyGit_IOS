//
//  HotelAnnotation.m
//  JinJiangTravelPlus
//
//  Created by 吕 硕 on 12-12-18.
//  Copyright (c) 2012年 JinJiang. All rights reserved.
//

#import "HotelAnnotation.h"

#pragma mark - HotelAnnotation

@implementation HotelAnnotation

@synthesize coordinate;
@synthesize name;
@synthesize description;
@synthesize latitude;
@synthesize longitude;

-(id) initWithName:(NSString*)nn andSubtitle:(NSString*)sbtitle
       andLatitude:(CLLocationDegrees)latitude1 andLongitude:(CLLocationDegrees)longitude1
{
	self = [super init];
	if (self != nil) {
		coordinate.latitude = latitude1;
		coordinate.longitude = longitude1;
        self.latitude = latitude1;
        self.longitude = longitude1;
		self.name = nn; self.description = sbtitle;
	}
	return self;
}

- (NSString *)subtitle
{
	return self.description;
}

- (NSString *)title
{
	return self.name;
}

@end

#pragma mark - HotelInfo

@implementation HotelInfo

@synthesize hotelId, hotelCode, star, price, name;
@synthesize address, coordinate, distance, icon;
@synthesize iconUrlString, zone, brand;
@synthesize cityName = _cityName;
@synthesize hasCoupon = _hasCoupon;

- (id)init {
    if ((self = [super init]) != nil) {
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zonee
{
    HotelInfo *info = [[self class] allocWithZone:zonee];
    info.name = name;
    info.address = address;
    info.icon = icon;
    
    return self;
}

- (NSString *)title {
    return name;
}

- (NSString *)subtitle {
    return address;
}

#ifdef __IPAD__
// optional
- (NSString *)subtitle
{
    return address;
}
#endif

- (NSComparisonResult) compareDistance:(HotelInfo *)hotel {
    return (self.distance < hotel.distance) ? NSOrderedAscending : NSOrderedDescending;
}

- (NSComparisonResult) compareDistanceDesc:(HotelInfo *)hotel {
    return (self.distance > hotel.distance) ? NSOrderedAscending : NSOrderedDescending;
}

- (NSComparisonResult) compareStar:(HotelInfo *)hotel {
    return (self.star > hotel.star) ? NSOrderedAscending : NSOrderedDescending;  // reverse order
}

- (NSComparisonResult) comparePrice:(HotelInfo *)hotel {
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

@end

#pragma mark HotelDetailInfo

@implementation HotelDetailInfo

@synthesize hotelId, star, score, coordinate, name;
@synthesize tel, address, description, holdTime;
@synthesize diningFacilities, locationInfo, panorama;
@synthesize policyInfo, images, cityName, facadeUrl;

@end

