//
//  LvPingHotelRating.h
//  JinJiangTravelPlus
//
//  Created by jerry on 12-12-10.
//  Copyright (c) 2012年 JinJiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LvPingHotelRating : NSObject

@property (nonatomic, assign) NSInteger hotelId;
@property (nonatomic, copy) NSString *hotelRate;
@property (nonatomic, copy) NSString *hotelRank;
@property (nonatomic, copy) NSString *hotelUrl;
@property (nonatomic, copy) NSString *writeUrl;
@property (nonatomic, strong) NSMutableArray *userRatings;

@end
