//
//  ConditionView.h
//  JinJiangTravalPlus
//
//  Created by jerry on 12-11-6.
//  Copyright (c) 2012年 Leon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConditionView : UIView

@property(nonatomic, strong)    UIView *contentView;
@property(nonatomic, copy)      NSString *title;
@property(nonatomic, strong)    UILabel *titleLabel;
@property(nonatomic, strong)    UIView *topView;

- (void)addContentView:(UIView *)contentView;

@end
