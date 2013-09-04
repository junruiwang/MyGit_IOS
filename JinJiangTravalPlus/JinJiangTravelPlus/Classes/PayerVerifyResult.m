//
//  PayerVerifyResult.m
//  JinJiangTravelPlus
//
//  Created by 胡 桂祁 on 12/27/12.
//  Copyright (c) 2012 JinJiang. All rights reserved.
//

#import "PayerVerifyResult.h"

@implementation PayerVerifyResult


//self.sysTrackNo = trackNo;
//
//if([result isEqualToString:@"WHITE"]){
//    needMoreInfo = NO;
//    payBtn.enabled = YES;
//} else if ([result isEqualToString:@"NEW"] || [result isEqualToString:@"GRAY"]) {
//    needMoreInfo = YES;
//    payBtn.enabled = YES;
//} else if ([result isEqualToString:@"BLACK"]) {
//    [self showAlertMessage:@"系统不支持该银行卡"];
//} else if ([result isEqualToString:@"LIMITED"]) {
//    [self showAlertMessage:@"该卡交易时间受限"];
//} else if ([result isEqualToString:@"NONSUPPORT"]) {
//    [self showAlertMessage:@"系统不支持该银行卡"];
//}


-(void)mockWhiteUnioCard
{
    self.verifyResult = @"WHITE";
    self.trackNo = @"";
}

-(void)mockNewOrGrayUnioCard
{
    self.verifyResult = @"NEW";
    self.trackNo = @"";
}

-(void)mockBlackUnioCard
{
    self.verifyResult = @"BLACK";
    self.trackNo = @"";
    self.errorMsg=@"系统不支持该银行卡";
}

-(void)mockLimitedUnioCard
{
    self.verifyResult = @"LIMITED";
    self.trackNo = @"";
    self.errorMsg=@"系统不支持该银行卡";
}

-(void)mockNONSUPPORTUnioCard
{
    self.verifyResult = @"NONSUPPORT";
    self.trackNo = @"";
    self.errorMsg=@"系统不支持该银行卡";
}


@end
