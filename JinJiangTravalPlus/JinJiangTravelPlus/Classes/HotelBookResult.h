//
//  HotelBookReslut.h
//  JinJiangTravelPlus
//
//  Created by huguiqi on 12-12-7.
//  Copyright (c) 2012年 JinJiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HotelBookResult : NSObject

@property (nonatomic,copy) NSString *code;
@property (nonatomic,copy) NSString *successFlag;
@property (nonatomic,copy) NSString *message;
@property (nonatomic,copy) NSString *orderStatus;
@property (nonatomic,copy) NSString *orderNo;
@property (nonatomic,copy) NSString *orderId;
//仅供游客预订时自动注册使用
@property (nonatomic,copy) NSString *isMember;

- (id)initWithCode:(NSString *)code successFlag:(NSString *)successFlag message:(NSString *)message orderStatus:(NSString *)orderStatus orderNo:(NSString *)orderNo orderId:(NSString *)orderId;

+ (id)objectWithCode:(NSString *)code successFlag:(NSString *)successFlag message:(NSString *)message orderStatus:(NSString *)orderStatus orderNo:(NSString *)orderNo orderId:(NSString *)orderId;


@end
