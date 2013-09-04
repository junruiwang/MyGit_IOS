//
//  ContactView.m
//  jinjiang
//
//  Created by Jeff.Yan on 11-11-8.
//  Copyright 2011年 W+K. All rights reserved.
//

#import "ContactView.h"

#import "GlobalFunction.h"



@implementation ContactView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
         [GlobalFunction addImage:self name:@"8_s2_bg.png" rect:FULLRECT];
        
        UIButton *but=[UIButton buttonWithType:UIButtonTypeCustom];
        
        [but setImage:[UIImage imageNamed:@"8_s2_btn_0.png"] forState:UIControlStateNormal];
        but.frame=CGRectMake(374, 242, 258, 47);
         but.bounds=but.frame;
        but.tag=100;
        [but addTarget:self action:@selector(linkToWeb:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:but];
        
        but=[UIButton buttonWithType:UIButtonTypeCustom];
        
        [but setImage:[UIImage imageNamed:@"8_s2_btn_1.png"] forState:UIControlStateNormal];
        
        but.frame=CGRectMake(374, 302, 318, 47);
        
        but.bounds=but.frame;
        but.tag=101;
        
        [but addTarget:self action:@selector(linkToWeb:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:but];
    }
    return self;
}
-(void)linkToWeb:(id)sender {
    UIButton *btn = (UIButton *)sender;
    NSInteger ii=btn.tag;
    switch (ii) {
        case 100:
             [jinjiangViewController toLink:SITEURL];
            break;
        case 101:
            [jinjiangViewController emailSend:EMAIL_ADDRESS];
            break;
    }
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
    NSLog(@"ContactView dealloc");
    [super dealloc];
}

@end
