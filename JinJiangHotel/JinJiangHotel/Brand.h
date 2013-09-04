//
//  Brand.h
//  JinJiangTravalPlus
//
//  Created by jerry on 12-11-5.
//  Copyright (c) 2012年 Leon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Brand : NSObject

@property(nonatomic, copy) NSString *brandCode;
@property(nonatomic, copy) NSString *brandName;
@property(nonatomic, copy) NSString *brandImage;

@property BOOL isSelected;

- (id)initWithCode:(NSString *)brandCode name:(NSString *) brandName image:(NSString *) brandImage;

+(NSArray *)getBrandList;
+(NSString *)getStarHotelBrandCodes;
- (BOOL) isDefault;

@end
