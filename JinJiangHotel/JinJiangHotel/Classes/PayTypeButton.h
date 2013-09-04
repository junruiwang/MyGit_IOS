//
//  PayTypeButton.h
//  JinJiangHotel
//
//  Created by jerry on 13-8-28.
//  Copyright (c) 2013年 jinjiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PayType.h"

@interface PayTypeButton : UIButton

@property (nonatomic, strong) UILabel *mainTitleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) UIImageView *selectedArrow;
@property (nonatomic, strong) PayType *payType;

@end
