//
//  HotelListParser.h
//  JinJiangTravalPlus
//
//  Created by Leon on 11/7/12.
//  Copyright (c) 2012 Leon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDataXMLParser.h"

@interface HotelListParser : GDataXMLParser

-(void)getHotelList:(NSInteger)pageIndex  orderName:(NSString *)orderName orderVal:(NSString *)orderVal;

@end
