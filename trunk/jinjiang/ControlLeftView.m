//
//  ControlLeftView.m
//  jinjiang
//
//  Created by Jeff.Yan on 11-11-4.
//  Copyright 2011年 W+K. All rights reserved.
//

#import "ControlLeftView.h"

#import "GlobalFunction.h"

@implementation ControlLeftView

@synthesize showRect=_showRect,hideRect=_hideRect;

-(void)setShowRect:(CGRect)showRect{
    _showRect=showRect;
    if(_showRect.origin.x>0){
        _hideRect=_showRect;
    }else{
        _hideRect=CGRectMake(-_showRect.size.width, _showRect.origin.y, _showRect.size.width, _showRect.size.height);
    }
    self.frame=_hideRect;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.showRect=frame;
        isOut=YES;
        UIView *nullView=[[UIView alloc] initWithFrame:frame];
        [self addSubview:nullView ];
        [nullView release];
    }
    return self;
}
-(void)removeFromSuperview{
    

    [super removeFromSuperview];
    
}
-(void)hide{
   isOut=YES;
}
-(void)show{
    if(isOut){

    }
    isOut=NO;
}



- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    if(!self.userInteractionEnabled)return nil;
    UIView *hit=nil;
    CALayer *lay=nil;
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
    lay=[self.layer hitTest:point];
    if(lay!=nil){
        [GlobalFunction closeTouch];
            return self;
    }

    return nil;
}
- (void)dealloc
{

    [super dealloc];
}

@end
