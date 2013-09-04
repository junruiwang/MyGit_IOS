//
//  JJHotel.h
//  JinJiangTravalPlus
//
//  Created by Leon on 11/7/12.
//  Copyright (c) 2012 Leon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MKAnnotation.h>

typedef enum {
    JJHotelBrandKnown = 0,
    JJHotelBrandJJHOTEL,
    JJHotelBrandSHANGYUE,
    JJHotelBrandJJINN,
    JJHotelBrandBESTAY,
    JJHotelBrandBYL,
    JJHotelBrandJG,
} JJHotelBrand;

typedef enum {
    JJHotelOriginKnown = 0,
    JJHotelOriginJREZ,
    JJHotelOriginJJINN,
    JJHotelOriginJGINN,
    JJHotelOriginBESTAY,
} JJHotelOrigin;

@interface JJHotel : NSObject <MKAnnotation, NSCoding, NSCopying> 

@property (nonatomic, copy) NSString* title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* hotelRate;
@property (nonatomic, strong) NSString* imageUrl;
@property (nonatomic, strong) NSString* address;
@property (nonatomic, copy) NSString *telphone;
@property (nonatomic, strong) UIImage* icon;
@property (nonatomic, strong) NSString* cityName;
@property (nonatomic, strong) NSString* zone;

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, assign) NSInteger star;
@property (nonatomic, assign) NSInteger price;
@property (nonatomic, assign) JJHotelBrand brand;
@property (nonatomic, assign) BOOL hasCoupon;
@property (nonatomic, assign) CLLocationDistance distance;
@property (nonatomic, assign) NSInteger hotelId;
@property (nonatomic, copy) NSString *hotelCode;
@property (nonatomic, assign) JJHotelOrigin origin;

- (id)initWithCoords:(CLLocationCoordinate2D) coords;
- (NSComparisonResult) compareDistance:(JJHotel *)hotel;
- (NSComparisonResult) comparePrice:(JJHotel *)hotel;
- (NSComparisonResult) compareStar:(JJHotel *)hotel;

+ (JJHotelBrand)brandFromName:(NSString *)brandName;
+ (NSString *)nameForBrand:(JJHotelBrand)brand;
+ (JJHotelOrigin)originFromName:(NSString *)originName;
+ (NSString *)nameForOrigin:(JJHotelOrigin)origin;
+ (NSInteger)starFromName:(NSString *)starName;

@end
