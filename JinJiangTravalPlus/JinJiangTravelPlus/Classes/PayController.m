//
//  PaymentController.m
//  JinJiangTravelPlus
//
//  Created by 胡 桂祁 on 12/31/12.
//  Copyright (c) 2012 JinJiang. All rights reserved.
//

#import "PayController.h"
#import "UIViewController+Categories.h"

@implementation PayController

-(id)init
{
    self = [super init];
    self.unionPaymentParser = [[UnionPaymentParser alloc] init];
    self.unionPaymentParser.delegate = self;
    return self;
}


- (void)parser:(GDataXMLParser *)parser DidParsedData:(NSDictionary *)data {
    UnionPaymentResult *unionPaymentResult = [data valueForKey:@"unionPaymentResult"];
    
    if([unionPaymentResult.status isEqualToString:@"SUCCESS"])
    {
        [self.delegate applySuccessProcess];
//        [self showAlertMessage:@"您支付请求已经被受理，稍后会收到银联的020-96585支付确认电话，请保持手机畅通！"];
    }
    else {
        [self.delegate applyFailProcess];
//        [self showAlertMessage:@"支付申请失败，请致电1010-1666完成支付!"];
    }
}

- (void)parser:(GDataXMLParser *)parser DidFailedParseWithMsg:(NSString *)msg errCode:(NSInteger)code {
    [self showAlertMessage:msg];
}


- (void)showAlertMessage:(NSString *)msg
{
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:NSLocalizedString(@"信息提示", nil)
                              message:msg
                              delegate:nil
                              cancelButtonTitle:NSLocalizedString(@"Ok", nil)
                              otherButtonTitles:nil];
    [alertView show];
}


@end
