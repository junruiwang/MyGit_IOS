//
//  City.h
//  WeatherReport
//
//  Created by jerry on 13-5-17.
//  Copyright (c) 2013年 jerry. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface City : NSObject<NSCoding, NSCopying>

@property(nonatomic, copy) NSString *province;
@property(nonatomic, copy) NSString *cityName;
@property(nonatomic, copy) NSString *searchCode;

+ (City *)unarchived:(NSData *) data;

- (id) initWithDictionary : (NSDictionary *) dict;
- (NSData *)archived;

@end
