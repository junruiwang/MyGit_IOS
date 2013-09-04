//
//  LocationParser.h
//  JinJiangTravalPlus
//
//  Created by 汪君瑞 on 12-11-9.
//  Copyright (c) 2012年 Leon. All rights reserved.
//

#import "GDataXMLParser.h"

@interface LocationParser : GDataXMLParser

- (void)reverseGeocodingPosition:(NSString *)criteria isGetingCityName:(BOOL)getingCityName;

@end
