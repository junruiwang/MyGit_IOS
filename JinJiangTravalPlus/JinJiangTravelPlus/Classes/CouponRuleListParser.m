//
//  CouponRuleListParser.m
//  JinJiangTravelPlus
//
//  Created by 胡 桂祁 on 1/11/13.
//  Copyright (c) 2013 JinJiang. All rights reserved.
//

#import "CouponRuleListParser.h"
#import "ParameterManager.h"
#import "GDataXMLNode.h"
#import "CouponRule.h"

@interface CouponRuleListParser()

@property (nonatomic,strong) NSMutableArray *couponRuleList;

@end

@implementation CouponRuleListParser



- (BOOL)parseXmlString:(NSString *)xmlString
{
    if ([super parseXmlString:xmlString])
    {
        NSError *error;
        GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithXMLString:xmlString options:0 error:&error];
        GDataXMLElement *rootElement = [document rootElement];
        GDataXMLNode *codeNode = [rootElement attributeForName:kKeyCode];
        NSString *code = [codeNode stringValue];
        if([@"0" isEqualToString:code])
        {
            GDataXMLElement *coupons = [rootElement elementsForName:kKeyCoupons][0];
            const unsigned int total = [[coupons attributeForName:@"total"] intValue];
            
            if (total > 0) {
                [self buildCouponRuleList:coupons];    
            }else{
                _couponRuleList = [[NSMutableArray alloc] initWithCapacity:1];
            }
            NSDictionary *data = @{@"couponRuleList" : _couponRuleList};
            if (self.delegate != nil && [self.delegate respondsToSelector:@selector(parser:DidParsedData:)]){
                    [self.delegate parser:self DidParsedData:data];
            }
        }
        else
        {
            NSString *message = [[rootElement elementsForName:kKeyMessage][0] stringValue];
            if (self.delegate != nil && [self.delegate respondsToSelector:@selector(parser:DidFailedParseWithMsg:)])
                    [self.delegate parser:self DidFailedParseWithMsg:message errCode:[code intValue]];
                            return NO;

        }
    }
    return YES;
}

- (void)couponRuleListRequest:(CouponRuleForm *)couponRuleForm
{
    ParameterManager *parameterManager = [[ParameterManager alloc] init];
    [parameterManager parserStringWithKey:@"bookingModule" WithValue:couponRuleForm.bookModule];
    [parameterManager parserFloatWithKey:@"orderAmount" WithValue:couponRuleForm.orderAmount];
    [parameterManager parserFloatWithKey:@"payAmount" WithValue:couponRuleForm.payAmount];
    [parameterManager parserIntegerWithKey:@"numRoomNights" WithValue:couponRuleForm.numRoomNights];
    [parameterManager parserStringWithKey:@"dateCheckIn" WithValue:couponRuleForm.dateCheckIn];
    self.requestString = [parameterManager serialization];
    self.serverAddress = kCouponRuleListURL;
    //NSLog([NSString stringWithFormat:@"优惠券规则请求,订单价格:%d,支付价格:%d", couponRuleForm.orderAmount,couponRuleForm.payAmount]);
    [self start];

    //requestString = [requestString stringByAppendingFormat:@"&orderAmount=%d", appDelegate.stayDetail.roomFee + appDelegate.stayDetail.ExtraFee];
    //requestString = [requestString stringByAppendingFormat:@"&payAmount=%d", appDelegate.stayDetail.roomFee + appDelegate.stayDetail.ExtraFee];
    //requestString = [requestString stringByAppendingFormat:@"&numRoomNights=%d", [appDelegate.stayDetail.checkOutDate daysIntervalSinceDate: appDelegate.stayDetail.checkInDate]];
    //requestString = [requestString stringByAppendingFormat:@"&dateCheckIn=%@", [appDelegate.stayDetail.checkInDate chineseDescription]];
}


- (void)buildCouponRuleList:(GDataXMLElement *)coupons
{
    NSMutableArray *couponRuleList = [[NSMutableArray alloc] initWithCapacity:20];
    if (_couponRuleList)
    {
        [_couponRuleList removeAllObjects];
    }
    _couponRuleList = couponRuleList;
    for (GDataXMLElement *couponElem in [coupons elementsForName:kKeyCoupon])
    {
        CouponRule *couponRule = [[CouponRule alloc] init];
        NSMutableArray *codeList = [[NSMutableArray alloc] initWithCapacity:20];

        NSString *ruleId = [[couponElem elementsForName:@"ruleId"][0] stringValue];
        couponRule.ruleId = ruleId;

        NSString *couponRuleName = [[couponElem elementsForName:kKeyCouponRuleName][0] stringValue];
        couponRule.couponRuleName = couponRuleName;

        const unsigned int couponAmount = [[couponElem elementsForName:kKeyCouponAmount][0] intValue];
        couponRule.couponAmount = couponAmount;

        const unsigned int couponMaxNum = [[couponElem elementsForName:kKeyCouponMaxNum][0] intValue];
        couponRule.couponMaxNum = couponMaxNum;

        GDataXMLElement *codeListElem = [couponElem elementsForName:kKeyCodeList][0];
        for(GDataXMLElement *couponCodeElem in [codeListElem elementsForName:kKeyCouponCode])
        {
            NSString *couponCode = [couponCodeElem stringValue];
            [codeList addObject:couponCode];
        }
        couponRule.codeList = codeList;
        [couponRuleList addObject:couponRule];
    }
}

@end
