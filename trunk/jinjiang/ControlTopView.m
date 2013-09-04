//
//  ControlTopView.m
//  jinjiang
//
//  Created by Jeff.Yan on 11-11-4.
//  Copyright 2011年 W+K. All rights reserved.
//

#import "ControlTopView.h"
#import "GlobalFunction.h"

@implementation ControlTopView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *nullView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024, 60)];
        [self addSubview:nullView];
        [nullView release];
        // Initialization code
    }
    return self;
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

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    if(!self.userInteractionEnabled)return nil;
    UIView *hit=nil;
    NSArray *nr=self.subviews;
    for (NSInteger i=[nr count]-1;i>=0;i--){
        UIView *temView=[nr objectAtIndex:i];
        CGPoint temPoint=[self convertPoint:point toView:temView];
        
        hit= [temView hitTest:temPoint withEvent:event];
        if(hit!=nil){
            [GlobalFunction closeTouch];
            return hit;
        }
    }
    return nil;
}

@end
