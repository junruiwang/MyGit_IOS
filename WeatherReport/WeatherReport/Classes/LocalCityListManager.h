//
//  LocalCityListManager.h
//  WeatherReport
//
//  Created by jerry on 13-5-17.
//  Copyright (c) 2013年 jerry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "City.h"

@interface LocalCityListManager : NSObject

- (BOOL)insertIntoFaverateWithCity:(City *) city;
- (BOOL)deleteCityInFaverate:(NSString *) cityName;

- (void)buildLocalFileToArray:(NSMutableArray *) cityArray;

@end
