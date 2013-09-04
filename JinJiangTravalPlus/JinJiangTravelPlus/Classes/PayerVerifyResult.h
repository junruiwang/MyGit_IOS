//
//  PayerVerifyResult.h
//  JinJiangTravelPlus
//
//  Created by 胡 桂祁 on 12/27/12.
//  Copyright (c) 2012 JinJiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PayerVerifyResult : NSObject

@property(nonatomic,copy) NSString *code;

@property(nonatomic,copy) NSString *msg;

@property(nonatomic,copy) NSString *verifyResult;

@property(nonatomic,copy) NSString *trackNo;

@property(nonatomic,copy) NSString *errorMsg;

-(void)mockWhiteUnioCard;

-(void)mockNewOrGrayUnioCard;

-(void)mockBlackUnioCard;

-(void)mockLimitedUnioCard;

-(void)mockNONSUPPORTUnioCard;


@end
