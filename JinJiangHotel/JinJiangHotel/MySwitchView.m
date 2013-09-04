//
//  MySwitchView.m
//  JinJiangTravelPlus
//
//  Created by 吕 硕 on 13-1-4.
//  Copyright (c) 2013年 JinJiang. All rights reserved.
//

#import "MySwitchView.h"

const unsigned int imgTag = 911;
const unsigned int bt1Tag = 101;

@implementation MySwitchView

@synthesize on;


- (void)transformToSearch
{
    self.backImageName = @"filter_bar.png";
    self.firstImageName = @"filter_item.png";
    self.secondImageName = @"filter_item.png";
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self setOn:NO];
    [self setBackgroundColor:[UIColor clearColor]];
    
    UIImageView *backImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:self.backImageName]];
    backImg.frame = CGRectMake(0, 0, 274, 30);
    [self addSubview:backImg];
    
    UIImageView* img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 137, 30)];
    [img setImage:[UIImage imageNamed:self.secondImageName]];
    [img setTag:imgTag];
    [self addSubview:img];
    
    UIButton* btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn1 setFrame:CGRectMake(0, 0, 137, 30)];
    [btn1 setTag:bt1Tag];
    [btn1 addTarget:self action:@selector(switchOff:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn1];
    
    UIButton* btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn2 setFrame:CGRectMake(137, 0, 137, 30)];
    [btn2 setTag:bt1Tag+1];
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

    UIImageView* img = ((UIImageView*)([self viewWithTag:imgTag]));

    [UIView	 beginAnimations:nil context:nil];
    [UIView setAnimationDuration:SwithAnimateDuration];
    [img setImage:[UIImage imageNamed:self.firstImageName]];
    [img setFrame:CGRectMake(137, 0, 137, 30)];
    [UIView	commitAnimations];[self setOn:YES];

    if (self.delegate && [self.delegate respondsToSelector:@selector(switchViewDidEndSetting:)])
    {   [self.delegate switchViewDidEndSetting:self];   }
}

- (void)switchOff:(id)sender
{
    if (self.on == NO) {   return; }

    UIImageView* img = ((UIImageView*)([self viewWithTag:imgTag]));
    
    [UIView	 beginAnimations:nil context:nil];
    [UIView setAnimationDuration:SwithAnimateDuration];
    [img setImage:[UIImage imageNamed:self.secondImageName]];
    [img setFrame:CGRectMake(0, 0, 137, 30)];
    [UIView	commitAnimations];[self setOn:NO];

    if (self.delegate && [self.delegate respondsToSelector:@selector(switchViewDidEndSetting:)])
    {   [self.delegate switchViewDidEndSetting:self];   }
}

@end
