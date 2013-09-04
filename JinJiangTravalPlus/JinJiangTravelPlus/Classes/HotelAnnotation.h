//
//  HotelAnnotation.h
//  JinJiangTravelPlus
//
//  Created by 吕 硕 on 12-12-18.
//  Copyright (c) 2012年 JinJiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

#pragma mark - HotelAnnotation

@interface HotelAnnotation : NSObject <MKAnnotation>

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* description;
@property (nonatomic) double latitude;
@property (nonatomic) double longitude;

-(id) initWithName:(NSString*)nn andSubtitle:(NSString*)sbtitle
       andLatitude:(CLLocationDegrees)latitude1 andLongitude:(CLLocationDegrees)longitude1;

@end

#pragma mark - HotelInfo

@interface HotelInfo : NSObject <MKAnnotation, NSCoding, NSCopying>
{
    NSInteger hotelId;
    NSString *hotelCode;
    NSInteger star;
    NSInteger price;
    CLLocationCoordinate2D coordinate;
    CLLocationDistance distance;
    NSString *name;
    NSString *address;
    NSString *iconUrlString;
    NSString *zone;
    NSString *brand;
    UIImage *icon;
}

@property NSInteger hotelId;
@property NSInteger star;
@property NSInteger price;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, assign) CLLocationDistance distance;
@property (nonatomic, strong) NSString *hotelCode;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *iconUrlString;
@property (nonatomic, strong) NSString *zone;
@property (nonatomic, strong) NSString *brand;
@property (nonatomic, retain) UIImage *icon;
@property (nonatomic, strong) NSString *cityName;
@property (nonatomic, assign) BOOL hasCoupon;

- (NSString *)title;
- (NSString *)subtitle;
- (NSComparisonResult) compareDistance:(HotelInfo *)hotel;
- (NSComparisonResult) comparePrice:(HotelInfo *)hotel;
- (NSComparisonResult) compareStar:(HotelInfo *)hotel;

@end

#pragma mark - HotelDetailInfo

@interface HotelDetailInfo : NSObject <MKAnnotation>
{
    NSInteger hotelId;
    NSInteger star;
    CGFloat score;
    CLLocationCoordinate2D coordinate;
    NSString *name;
    NSString *tel;
    NSString *address;
    NSString *description;
    NSString *policyInfo;
    NSString *holdTime;
    NSString *diningFacilities;
    NSString *locationInfo;
    NSString *panorama;
    NSMutableArray *images;
}

@property NSInteger hotelId;
@property NSInteger star;
@property CGFloat score;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *tel;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) NSString *policyInfo;
@property (nonatomic, strong) NSString *holdTime;
@property (nonatomic, strong) NSString *diningFacilities;
@property (nonatomic, strong) NSString *locationInfo;
@property (nonatomic, strong) NSString *panorama;
@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, strong) NSString *cityName;
@property (nonatomic, strong) NSString *facadeUrl;

@end
