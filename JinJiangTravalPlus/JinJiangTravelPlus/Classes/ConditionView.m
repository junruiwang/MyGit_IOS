//
//  ConditionView.m
//  JinJiangTravalPlus
//
//  Created by jerry on 12-11-6.
//  Copyright (c) 2012年 Leon. All rights reserved.
//

#import "ConditionView.h"

@interface ConditionView ()

@property(nonatomic, strong) UIView *bottomAboveView;
@property(nonatomic, strong) UIView *bottomBelowView;

@end

@implementation ConditionView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        const unsigned int ww = frame.size.width;
        self.topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ww, 44)];
        UIImage* img0 = [UIImage imageNamed:@"filter_top.png"];
        self.topView.backgroundColor = [UIColor colorWithPatternImage:img0];

        const unsigned int www = frame.size.width - 20;
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, www, 44)];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.text = @"";
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        self.titleLabel.shadowColor = [UIColor grayColor];
        self.titleLabel.shadowOffset = CGSizeMake(0, -1);

        const unsigned int w1 = frame.size.width;
        const unsigned int h1 = frame.size.height-44;
        UIImage* img1 = [UIImage imageNamed:@"filter_bottom-1.png"];
        self.bottomAboveView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, w1, h1-40)];
        self.bottomAboveView.backgroundColor = [UIColor colorWithPatternImage:img1];
        
        
        UIImage* img2 = [UIImage imageNamed:@"filter_bottom-2.png"];
        self.bottomBelowView = [[UIView alloc] initWithFrame:CGRectMake(0, 4+h1, w1, 20)];
        self.bottomBelowView.backgroundColor = [UIColor colorWithPatternImage:img2];

        const unsigned int w0 = frame.size.width-16;
        const unsigned int h0 = frame.size.height-44;
        self.contentView = [[UIView alloc] initWithFrame:CGRectMake(16, 44, w0, h0)];
        self.contentView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.topView];
        [self addSubview:self.bottomAboveView];
        [self addSubview:self.bottomBelowView];
        [self addSubview:self.contentView];
        [self.topView addSubview:self.titleLabel];
    }

    return self;
}

- (void)setTitle:(NSString *)title
{
    self.titleLabel.text = title;
}

- (void)addContentView:(UIView *)contentView
{
    for (UIView *subview in self.contentView.subviews)
    {
        [subview removeFromSuperview];
    }
    contentView.frame = self.contentView.bounds;
    [self.contentView addSubview:contentView];
}

@end
