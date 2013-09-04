//
//  PopLeaderView.m
//  jinjiang
//
//  Created by Jeff.Yan on 11-11-11.
//  Copyright 2011年 W+K. All rights reserved.
//

#import "PopLeaderView.h"
#import "GlobalFunction.h"

@implementation PopLeaderView


- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    UIView *hit=nil;
    hit=[super hitTest:point withEvent:event];
    if(hit!=nil){
        [GlobalFunction closeTouch];
    }
    return hit;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:FULLRECT];
    if (self) {
        //NSLog(@":::loadView:PopLeaderView::");
        self.backgroundColor=[UIColor clearColor];
        [GlobalFunction addImage:self name:@"pop_1.png"];
        UIButton *closeBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        closeBtn.frame = CGRectMake(990, 2, 32, 32);
        closeBtn.bounds=closeBtn.frame;
        closeBtn.tag = 100;
        [closeBtn setImage:[UIImage imageNamed:@"6_close.png"] forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(closeClickFun) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:closeBtn];
        
        self.alpha=0;
        [GlobalFunction fadeInOut:self to:1 time:0.4 hide:NO];

    }
    return self;
}


-(void)closeClickFun{
    
     [GlobalFunction fadeInOut:self to:0 time:0.4 hide:YES];
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
    [super dealloc];
}

@end
