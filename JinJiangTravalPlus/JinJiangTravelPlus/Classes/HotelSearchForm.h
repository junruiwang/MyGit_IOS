//
//  HotelSearchForm.h
//  JinJiangTravalPlus
//
//  Created by jerry on 12-11-2.
//  Copyright (c) 2012年 Leon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BusinessCircle.h"
#import "kal.h"
#import "Brand.h"
#import "PriceRange.h"
#import "StarLevel.h"

@interface HotelSearchForm : NSObject

@property(nonatomic, strong) NSString *cityName;
@property(nonatomic, assign) CLLocationCoordinate2D searchPoint;
@property(nonatomic, strong) KalDate *checkinDate;
@property(nonatomic, strong) KalDate *checkoutDate;
@property(nonatomic, strong) Brand *hotelBrand;
@property(nonatomic, strong) BusinessCircle *businessCircle;
@property(nonatomic, copy) NSString *area;
@property(nonatomic, strong) PriceRange *priceRange;
@property(nonatomic, strong) StarLevel *starLevel;
@property(nonatomic, assign) NSInteger nightNums;

@end
