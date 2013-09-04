//
//  CouponListParser.m
//  JinJiangTravelPlus
//
//  Created by jerry on 12-12-22.
//  Copyright (c) 2012年 JinJiang. All rights reserved.
//

#import "CouponListParser.h"
#import "GDataXMLNode.h"
#import "JJCoupon.h"

@implementation CouponListParser

- (BOOL)parseXmlString:(NSString *)xmlString
{
    if ([super parseXmlString:xmlString] )
    {
        NSError* error;
        GDataXMLDocument* document = [[GDataXMLDocument alloc] initWithXMLString:xmlString options:0 error:&error];
        GDataXMLElement *rootElement = [document rootElement];

        NSMutableArray *couponList = [[NSMutableArray alloc] init];
        int total = 0;
        if ([rootElement elementsForName:@"coupons"].count > 0)
        {
            GDataXMLElement *couponsElement = [rootElement firstElementForName:@"coupons"];
            NSArray *couponElementArray = [couponsElement elementsForName:@"coupon"];
            total = [[couponsElement attributeForName:@"total"] intValue];

            for (GDataXMLElement *couponElement in couponElementArray)
            {
                JJCoupon *coupon = [[JJCoupon alloc] init];
                coupon.code = [[couponElement firstElementForName:@"code"] stringValue];
                coupon.amount = [[couponElement firstElementForName:@"amount"] intValue];
                coupon.status = [JJCoupon couponStatusFromName:[[couponElement firstElementForName:@"status"] stringValue]];
                //[NSDate dateFromString:[parser currentString] format:@"yyyy-MM-dd"];
                coupon.startDate = [[couponElement firstElementForName:@"startDate"] stringValue];
                coupon.endDate = [[couponElement firstElementForName:@"endDate"] stringValue];
                coupon.category = [[couponElement firstElementForName:@"category"] stringValue];
                coupon.usePlate = [[couponElement firstElementForName:@"usePlate"] stringValue];
                [couponList addObject:coupon];
            }
            NSDictionary *data = @{@"total":@(total) ,@"couponList":couponList};

            if(self.delegate != nil && [self.delegate respondsToSelector:@selector(parser:DidParsedData:)])
            {   [self.delegate parser:self DidParsedData:data]; }
        }
    }
    return YES;
}

@end
