//
//  LoginSwitchView.m
//  JinJiangHotel
//
//  Created by jerry on 13-8-19.
//  Copyright (c) 2013年 jinjiang. All rights reserved.
//

#import "LoginSwitchView.h"

const unsigned int closeTag = 301;
const unsigned int leftButtonTag = 401;

@interface LoginSwitchView ()

@property(nonatomic, strong) NSString *backImageName;
@property(nonatomic, strong) NSString *secondImageName;
@property(nonatomic, strong) NSString *firstImageName;

- (void)switchOn:(id)sender;
- (void)switchOff:(id)sender;

@end

@implementation LoginSwitchView


- (void)transformToLogin
{
    self.backImageName = @"open_close _bg";
    self.firstImageName = @"open_close";
    self.secondImageName = @"open_close";
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self setOn:YES];
    [self setBackgroundColor:[UIColor clearColor]];
    
    UIImageView *backImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:self.backImageName]];
    backImg.frame = CGRectMake(0, 0, 72, 22);
    [self addSubview:backImg];
    
    UIImageView* img = [[UIImageView alloc] initWithFrame:CGRectMake(36, 0, 36, 22)];
    [img setImage:[UIImage imageNamed:self.secondImageName]];
    [img setTag:closeTag];
    [self addSubview:img];
    
    UIButton* btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn1 setFrame:CGRectMake(0, 0, 36, 22)];
    [btn1 setTag:leftButtonTag];
    [btn1 addTarget:self action:@selector(switchOff:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn1];
    
    UIButton* btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn2 setFrame:CGRectMake(36, 0, 36, 22)];
    [btn2 setTag:leftButtonTag+1];
    [btn2 addTarget:self action:@selector(switchOn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn2];
    
    UISwipeGestureRecognizer* tapGR = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(switchOff:)];
    [tapGR setDirection:UISwipeGestureRecognizerDirectionLeft]; [self addGestureRecognizer:tapGR];
    
    UISwipeGestureRecognizer* tapGL = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(switchOn:)];
    [tapGL setDirection:UISwipeGestureRecognizerDirectionRight];[self addGestureRecognizer:tapGL];
    
    
}

- (void)switchOn:(id)sender
{
    if (self.on == YES) {   return; }
    
    UIImageView* img = ((UIImageView*)([self viewWithTag:closeTag]));
    
    [UIView	 beginAnimations:nil context:nil];
    [UIView setAnimationDuration:SwithAnimateDuration];
    [img setImage:[UIImage imageNamed:self.firstImageName]];
    [img setFrame:CGRectMake(36, 0, 36, 22)];
    [UIView	commitAnimations];[self setOn:YES];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(switchViewDidEndSetting:)])
    {   [self.delegate switchViewDidEndSetting:self];   }
}

- (void)switchOff:(id)sender
{
    if (self.on == NO) {   return; }
    
    UIImageView* img = ((UIImageView*)([self viewWithTag:closeTag]));
    
    [UIView	 beginAnimations:nil context:nil];
    [UIView setAnimationDuration:SwithAnimateDuration];
    [img setImage:[UIImage imageNamed:self.secondImageName]];
    [img setFrame:CGRectMake(0, 0, 36, 22)];
    [UIView	commitAnimations];[self setOn:NO];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(switchViewDidEndSetting:)])
    {   [self.delegate switchViewDidEndSetting:self];   }
}


@end
