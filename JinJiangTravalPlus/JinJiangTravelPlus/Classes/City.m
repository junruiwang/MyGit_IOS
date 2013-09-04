//
//  CityInfo.m
//  JinJiangTravalPlus
//
//  Created by 胡 桂祁 on 11/5/12.
//  Copyright (c) 2012 Leon. All rights reserved.
//

#import "City.h"

@implementation City

- (NSString *)title {
    return self.name;
}

- (NSComparisonResult) comparePinyin:(City *)city {
    return [self.namePinyin compare:city.namePinyin options:NSDiacriticInsensitiveSearch | NSCaseInsensitiveSearch];
}


@end
