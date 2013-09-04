//
//  MemberCardPriceParser.m
//  JinJiangTravelPlus
//
//  Created by Raphael.rong on 13-5-22.
//  Copyright (c) 2013年 JinJiang. All rights reserved.
//

#import "MemberCardPriceParser.h"
#import "GDataXMLNode.h"

@implementation MemberCardPriceParser
- (BOOL)parseXmlString:(NSString *)xmlString
{
    if (xmlString != nil )
    {
        float price = xmlString.floatValue;
        if (price > 0) {
            NSDictionary *data = @{@"price":xmlString};
            if(self.delegate != nil && [self.delegate respondsToSelector:@selector(parser:DidParsedData:)])
            {   [self.delegate parser:self DidParsedData:data]; }
        }
    }
    return YES;
}
@end
