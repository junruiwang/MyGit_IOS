//
//  PriceRange.h
//  JinJiangTravelPlus
//
//  Created by huguiqi on 11/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//



@interface PriceRange : NSObject

@property (nonatomic, copy) NSString *minPrice;
@property (nonatomic, copy) NSString *maxPrice;
@property (nonatomic, copy) NSString *textShow;
@property BOOL lsSelected;

- (id)initWithMinPrice:(NSString *)minPrice maxPrice:(NSString *)maxPrice;

+(NSArray *)getPriceList;

- (BOOL) isDefault;

@end
