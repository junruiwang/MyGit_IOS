//
//  ClientAlipaySuccessViewController.h
//  JinJiangTravelPlus
//
//  Created by jerry on 13-6-3.
//  Copyright (c) 2013年 JinJiang. All rights reserved.
//

#import "JJViewController.h"
#import "UnionPaymentForm.h"

@interface ClientAlipaySuccessViewController : JJViewController

@property(nonatomic, strong) UIImageView *topImageView;
@property(nonatomic, strong) UIImageView *bottomImageView;
@property(nonatomic, strong) UIImageView *contentImageView;

@property (nonatomic,strong) UnionPaymentForm *paymentForm;

@end
