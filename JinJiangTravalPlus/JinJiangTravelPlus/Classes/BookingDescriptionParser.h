//
//  BookingDescriptionParser.h
//  JinJiangTravelPlus
//
//  Created by Rong Hao on 13-7-31.
//  Copyright (c) 2013年 JinJiang. All rights reserved.
//

#import "GDataXMLParser.h"

@interface BookingDescriptionParser : GDataXMLParser

- (void)sendRequest:(NSString *)hotelBrand;

@end
