//
//  PrepareBuyCardParser.h
//  JinJiangTravelPlus
//
//  Created by Raphael.rong on 13-5-22.
//  Copyright (c) 2013年 JinJiang. All rights reserved.
//

#import "GDataXMLParser.h"
#import "BuyCardForm.h"

@interface PrepareBuyCardParser : GDataXMLParser

- (void)buyCardRequest:(BuyCardForm *)buyCardForm;
@end
