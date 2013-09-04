//
//  VipView.m
//  jinjiang
//
//  Created by Jeff.Yan on 11-11-7.
//  Copyright 2011年 W+K. All rights reserved.
//

#import "VipView.h"

#import "ClubVC.h"

#import "GlobalFunction.h"
#import "MainNC.h"
#import "NavigationView.h"
#import "jinjiangViewController.h"


@implementation VipView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [GlobalFunction addImage:self name:@"6_S2_bg.png" rect:FULLRECT];
        
        //
        UIButton *but=[UIButton buttonWithType:UIButtonTypeCustom];
        
        [but setImage:[UIImage imageNamed:@"6_s2_btn.png"] forState:UIControlStateNormal];
        
        but.bounds=CGRectMake(36, 425, 222,38);
        but.frame=CGRectMake(46, 440, 234,18);
        [but addTarget:self action:@selector(linkToWeb) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:but];
        
        but=[UIButton buttonWithType:UIButtonTypeCustom];
        
        but.backgroundColor=[UIColor clearColor];
        
        but.bounds=CGRectMake(718, 678, 112,30);
        but.frame=CGRectMake(718, 678, 112,30);
        [but addTarget:self action:@selector(linkToWeb) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:but];
        
    }
    return self;
}
-(void)linkToWeb{
    [jinjiangViewController toLink:VIPURL];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)dealloc
{
     NSLog(@"vipView dealloc");
    [super dealloc];
}

@end
