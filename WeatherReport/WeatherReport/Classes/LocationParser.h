//
//  LocationParser.h
//  JinJiangTravalPlus
//
//  Created by 汪君瑞 on 12-11-9.
//  Copyright (c) 2012年 Leon. All rights reserved.
//

#import "BaseParser.h"

@interface LocationParser : BaseParser

- (void)reverseGeocodingPosition:(NSString *)criteria;

@end
