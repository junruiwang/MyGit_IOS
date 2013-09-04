//
//  CityInfo.h
//  JinJiangTravalPlus
//
//  Created by 胡 桂祁 on 11/5/12.
//  Copyright (c) 2012 Leon. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface City : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *namePinyin;
@property (nonatomic, assign) float longitude;
@property (nonatomic, assign) float latitude;

@property (nonatomic) NSInteger section;


- (NSString *)title;
- (NSComparisonResult) comparePinyin:(City *)city;


@end