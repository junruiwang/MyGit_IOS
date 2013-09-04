//
//  CouponRuleView.h
//  JinJiangHotel
//
//  Created by jerry on 13-8-29.
//  Copyright (c) 2013年 jinjiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CouponRule.h"

@class CouponRuleView;
@protocol CouponRuleViewDelegate <NSObject>

- (void)checkButtonHandler:(CouponRuleView *) couponRuleView;
- (void)subButtonHandler:(CouponRuleView *) couponRuleView;
- (void)addButtonHandler:(CouponRuleView *) couponRuleView;

@end

@interface CouponRuleView : UIView

@property (nonatomic, strong) UIButton *checkButton;
@property (nonatomic, strong) UIImageView *selectedArrow;
@property (nonatomic, strong) UILabel *couponAmountLabel;
@property (nonatomic, strong) UIImageView *subImageView;
@property (nonatomic, strong) UIImageView *addImageView;
@property (nonatomic, strong) UIImageView *numberImageView;
@property (nonatomic, strong) UILabel *couponCountLabel;
@property (nonatomic, strong) UIButton *subButton;
@property (nonatomic, strong) UIButton *addButton;
@property (nonatomic,weak) id<CouponRuleViewDelegate> delegate;
@property (nonatomic) NSUInteger currentIndex;

@property (nonatomic, strong) CouponRule *couponRule;

@end
