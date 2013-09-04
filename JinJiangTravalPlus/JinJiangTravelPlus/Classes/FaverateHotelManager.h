//
//  FaverateHotelManager.h
//  JinJiangTravelPlus
//
//  Created by jerry on 13-3-8.
//  Copyright (c) 2013年 JinJiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FaverateHotelManager : NSObject

- (BOOL)insertIntoFaverateWithHote:(NSDictionary *)hotel;
- (BOOL)isHotelInFaverate:(NSString *)hotelId;
- (BOOL)deleteFromHotelInFaverate:(NSString *)hotelId;
- (void)selectDistinctCityIntoArray:(NSMutableArray *)array;
- (void)selectHotelsInFaverateByCity:(NSString *)cityName intoArray:(NSMutableArray *)array;

@end
