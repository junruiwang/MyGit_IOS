//
//  MinusOrAddButton.h
//  JinJiangTravelPlus
//
//  Created by huguiqi on 13-1-10.
//  Copyright (c) 2013年 JinJiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MinusOrAddButton.h"

@interface MinusOrAddObj : NSObject

@property (nonatomic,strong) MinusOrAddButton *minusButton;
@property (nonatomic,strong) MinusOrAddButton *addButton;
@property (nonatomic,strong) UILabel *couponSizeLabel;

- (void)showMinusOrAddObj;
- (void)hiddenMinusOrAddObj;
- (void)makeMinusOrAddBtnDark;
- (void)disabledMinusBtn;
- (void)enableAddButton;
- (void)disabledAddBtn;
@end
