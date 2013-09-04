//
//  JJNavigationBar.m
//  JinJiangHotel
//
//  Created by Rong Hao on 13-8-14.
//  Copyright (c) 2013年 jinjiang. All rights reserved.
//

#import "JJNavigationBar.h"

#define WORD_COLOR RGBCOLOR(160, 140, 25);

@implementation JJNavigationBar


- (id)initNavigationBarWithStyle:(JJNavigationBarStyle)barStyle
{
    if (self = [super initWithFrame:CGRectMake(0, 0, 320, 50)]) {
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed: @"navigation_bg.png"]];
        
        self.titleView = [[UIView alloc] initWithFrame:CGRectMake(50, 0, 270, 50)];
        
        switch (barStyle) {
            case JJDefaultBarStyle:
            {
                [self addMainTitle];
            }
                break;
                
            case JJTwoLineTilteBarStyle:
            {
                [self addMainTitleAndSubTitle];

            }
                break;
                
            default:
                break;
        }
        
        [self addSubview:self.titleView];
        [self addLeftBarButton:@"navigation_back.png"];
        
        self.mainLabel.minimumFontSize = 15;
        self.mainLabel.numberOfLines = 1;
        self.mainLabel.adjustsFontSizeToFitWidth = YES;
        
    }
    return self;
}

- (void)addMainTitle
{
    self.mainLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 170, 50)];
    _mainLabel.backgroundColor = [UIColor clearColor];
    _mainLabel.font = [UIFont boldSystemFontOfSize: 20.0f];
    _mainLabel.textAlignment = UITextAlignmentLeft;
    _mainLabel.textColor = WORD_COLOR;
    
    [self.titleView addSubview:_mainLabel];
}

- (void)addMainTitleAndSubTitle
{
    self.mainLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 170, 33)];
    _mainLabel.backgroundColor = [UIColor clearColor];
    _mainLabel.font = [UIFont boldSystemFontOfSize: 20.0f];
    _mainLabel.textAlignment = UITextAlignmentLeft;
    _mainLabel.textColor = WORD_COLOR;
    
    self.subTitleImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 0, 170, 17)];
    
    
    self.subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 170, 12)];
    _subTitleLabel.backgroundColor = [UIColor clearColor];
    _subTitleLabel.font = [UIFont boldSystemFontOfSize: 12.0f];
    _subTitleLabel.textAlignment = UITextAlignmentLeft;
    _subTitleLabel.textColor = WORD_COLOR;
    
    self.subTitleView = [[UIView alloc] initWithFrame:CGRectMake(5, 33, 170, 17)];
    self.subTitleView.backgroundColor = [UIColor clearColor];
    [self.subTitleView addSubview:self.subTitleImage];
    [self.subTitleView addSubview:self.subTitleLabel];
    [self.titleView addSubview:self.mainLabel];
    [self.titleView addSubview:self.subTitleView];
}

- (void)addLeftBarButton:(NSString *) imageName
{
    //add left back button
    self.backButton = [self generateNavButton:imageName action:@selector(backHome:)];
    _backButton.frame = CGRectMake(0, 0, 49, 50);
    UIImageView *sperateLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navigation_sperate_line.png"]];
    sperateLine.frame = CGRectMake(49, 0, 1, 50);
    
    [self addSubview:sperateLine];
    [self addSubview:self.backButton];
    
}

- (void)addRightBarButton:(NSString *)imageName
{
    self.rightButton = [self generateNavButton:imageName action:@selector(rightButtonPressed:)];
    _rightButton.frame = CGRectMake(220, 0, 50, 50);
    [self.titleView addSubview:_rightButton];
}


- (void)addOtherBarButton:(NSString *)imageName
{
    self.otherButton = [self generateNavButton:imageName action:@selector(otherButtonPressed:)];
    _otherButton.frame = CGRectMake(170, 0, 50, 50);
    [self.titleView addSubview:_otherButton];
}

- (UIButton *)generateNavButton:(NSString *)imageName action:(SEL)actionName
{
    UIButton* targetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [targetBtn setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [targetBtn setShowsTouchWhenHighlighted:YES];
    [targetBtn addTarget:self action:actionName forControlEvents:UIControlEventTouchUpInside];
    
    return targetBtn;
}

- (void)backHome:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(backButtonPressed)]) {
        [self.delegate backButtonPressed];
    } else {
        NSLog(@"please create method backButtonPressed");
    }
}

- (void)rightButtonPressed:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(rightButtonPressed)]) {
        [self.delegate rightButtonPressed];
    } else {
        NSLog(@"please create method rightButtonPressed");
    }
}

- (void)otherButtonPressed:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(otherButtonPressed)]) {
        [self.delegate otherButtonPressed];
    } else {
        NSLog(@"please create method otherButtonPressed");
    }
}

@end
