//
//  CouponRuleView.m
//  JinJiangHotel
//
//  Created by jerry on 13-8-29.
//  Copyright (c) 2013年 jinjiang. All rights reserved.
//

#import "CouponRuleView.h"

@interface CouponRuleView ()

- (void)checkButtonClicked;
- (void)subButtonClicked;
- (void)addButtonClicked;

@end

@implementation CouponRuleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadPageViews];
    }
    return self;
}


- (void)loadPageViews
{
    self.checkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.checkButton.frame = CGRectMake(11, 8, 30, 30);
    [self.checkButton addTarget:self action:@selector(checkButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.checkButton setImage:[UIImage imageNamed:@"check_arrow_board"] forState:UIControlStateNormal];
    [self addSubview:self.checkButton];
    
    self.selectedArrow = [[UIImageView alloc] initWithFrame:CGRectMake(11, 9, 30, 30)];
    self.selectedArrow.image = [UIImage imageNamed:@"check_arrow"];
    self.selectedArrow.hidden = YES;
    [self addSubview:self.selectedArrow];
    
    self.couponAmountLabel = [[UILabel alloc] initWithFrame:CGRectMake(49, 13, 42, 21)];
    self.couponAmountLabel.font = [UIFont boldSystemFontOfSize:12];
    self.couponAmountLabel.textColor = RGBCOLOR(161, 127, 48);
    self.couponAmountLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:self.couponAmountLabel];
    
    self.subImageView = [[UIImageView alloc] initWithFrame:CGRectMake(121, 9, 36, 28)];
    self.subImageView.image = [UIImage imageNamed:@"room_sub_bg"];
    self.subImageView.hidden = YES;
    [self addSubview:self.subImageView];
    
    self.addImageView = [[UIImageView alloc] initWithFrame:CGRectMake(195, 9, 36, 28)];
    self.addImageView.image = [UIImage imageNamed:@"room_add_bg"];
    self.addImageView.hidden = YES;
    [self addSubview:self.addImageView];
    
    self.numberImageView = [[UIImageView alloc] initWithFrame:CGRectMake(163, 9, 26, 28)];
    self.numberImageView.image = [UIImage imageNamed:@"room_number_bg"];
    self.numberImageView.hidden = YES;
    [self addSubview:self.numberImageView];
    
    self.couponCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(168, 12, 16, 21)];
    self.couponCountLabel.font = [UIFont boldSystemFontOfSize:17];
    self.couponCountLabel.textColor = RGBCOLOR(67, 67, 67);
    self.couponCountLabel.textAlignment = NSTextAlignmentCenter;
    self.couponCountLabel.backgroundColor = [UIColor clearColor];
    self.couponCountLabel.hidden = YES;
    [self addSubview:self.couponCountLabel];
    
    self.subButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.subButton.frame = CGRectMake(121, 9, 36, 28);
    [self.subButton addTarget:self action:@selector(subButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.subButton setImage:[UIImage imageNamed:@"room_sub"] forState:UIControlStateNormal];
    self.subButton.hidden = YES;
    [self addSubview:self.subButton];
    
    self.addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.addButton.frame = CGRectMake(195, 9, 36, 28);
    [self.addButton addTarget:self action:@selector(addButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.addButton setImage:[UIImage imageNamed:@"room_add"] forState:UIControlStateNormal];
    self.addButton.hidden = YES;
    [self addSubview:self.addButton];
    
}

- (void)checkButtonClicked
{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(checkButtonHandler:)]) {
        [self.delegate checkButtonHandler:self];
    }
}

- (void)subButtonClicked
{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(subButtonHandler:)]) {
        [self.delegate subButtonHandler:self];
    }
}

- (void)addButtonClicked
{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(addButtonHandler:)]) {
        [self.delegate addButtonHandler:self];
    }
}

@end
