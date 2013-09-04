//
//  AlipayParser.h
//  JinJiangTravelPlus
//
//  Created by jerry on 13-5-29.
//  Copyright (c) 2013年 JinJiang. All rights reserved.
//

#import "GDataXMLParser.h"
#import "AlipayForm.h"

@interface AlipayParser : GDataXMLParser

-(void)payment:(AlipayForm *)form;

@end
