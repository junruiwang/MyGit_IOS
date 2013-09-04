//
//  ControlView.m
//  jinjiang
//
//  Created by Jeff.Yan on 11-11-4.
//  Copyright 2011年 W+K. All rights reserved.
//

#import "ControlView.h"
#import "GlobalFunction.h"

#import "ControlTopView.h"
#import "ControlLeftView.h"

@implementation ControlView

@synthesize closeAuto;

-(void)stopStartHide:(BOOL)b{
    if(b){
        closeAuto=YES;
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(showHide) object:nil];
        //[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(showHide) object:nil];
    }else{
        closeAuto=NO;
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(showHide) object:nil];
        //[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(showHide) object:nil];
        if(topOpen || leftOpen){
            [self performSelector:@selector(showHide) withObject:nil afterDelay:3.4f];
        }
        
        //[self performSelector:@selector(showHide) withObject:nil afterDelay:3.4f];
    }
}

-(void)showHide{
    if(topOpen){
        [self showTop:-1];
    }else{
        [self showTop:topIndex]; 
    }
    if(leftOpen){
        [self showLeft:-1];
    }else{
        [self showLeft:leftIndex]; 
    }
}
-(void)showTop:(NSInteger)toIndex{
    //topIndex!=toIndex || 
    //NSLog(@"::::%d:::%d:::%d",topIndex,toIndex,topOpen);
    if(topIndex!=toIndex || !topOpen){
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(showHide) object:nil];
        ControlTopView *view;
        if((topIndex!=toIndex) && topOpen && topIndex>=0 && topIndex<[topList count]){
            view=[topList objectAtIndex:topIndex];
            //NSLog(@"showTop:::1:%@",view);
            
            
            [PRTween tween:view property:@"alpha" from:view.alpha to:0.0 duration:0.4];
            view.userInteractionEnabled=NO;
            //[GlobalFunction fadeInOut:view to:0 time:0.5 hide:YES];
        }
        if(toIndex==-1){
            topOpen=NO;
        }else{
            topOpen=YES;
            topIndex=toIndex;
            if(topIndex>=0 && topIndex<[topList count]){
                view=[topList objectAtIndex:topIndex];
                
                [self addSubview:view];
                //NSLog(@"showTop:::2:%@",view);
                view.userInteractionEnabled=YES;
                [PRTween tween:view property:@"alpha" from:view.alpha to:1 duration:0.4];
                //[GlobalFunction fadeInOut:view to:1 time:0.4 hide:NO];
            }
            if(!closeAuto)
                [self performSelector:@selector(showHide) withObject:nil afterDelay:3.8f];
        }
    }
}
-(void)showLeft:(NSInteger)toIndex{
    //
    if(leftIndex!=toIndex || !leftOpen){
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(showHide) object:nil];
        ControlLeftView *view;
        if((leftIndex!=toIndex) && leftOpen && leftIndex>=0 && leftIndex<[leftList count]){
            view=[leftList objectAtIndex:leftIndex];
            [view hide];
            if(view.hideRect.origin.x<=0){
                //[PRTween removeTweenOperation:topTween];
                // Release2Nil(topTween)
                if(leftTween1)[PRTween removeTweenOperation:leftTween1];
                Release2Nil(leftTween1);
                leftTween1=[[PRTweenCGRectLerp lerp:view property:@"frame" from:view.frame to:view.hideRect duration:0.3] retain]; 
                view.userInteractionEnabled=NO;
                [PRTween tween:view property:@"alpha" from:view.alpha to:0 duration:0.4];
                //[GlobalFunction moveView:view to:view.hideRect time:0.4];
                
            }else{
                view.userInteractionEnabled=NO;
                [PRTween tween:view property:@"alpha" from:view.alpha to:0 duration:0.4];
                //[GlobalFunction fadeInOut:view to:0 time:0.4 hide:YES];
            }
        }
        if(toIndex==-1){
            leftOpen=NO;
        }else{
            [self showTop:topIndex];
            leftOpen=YES;
            leftIndex=toIndex;
            if(leftIndex>=0 && leftIndex<[leftList count]){
                view=[leftList objectAtIndex:leftIndex];
                
                [self insertSubview:view atIndex:0];
                
                [view show];
                
                if(view.showRect.origin.x<=0){
                    //NSLog(@"view.showRect:::%@::%@",NSStringFromCGRect(view.showRect),NSStringFromCGRect(view.frame));
                    if(leftTween2)[PRTween removeTweenOperation:leftTween2];
                    Release2Nil(leftTween2);
                    leftTween2=[[PRTweenCGRectLerp lerp:view property:@"frame" from:view.frame to:view.showRect duration:0.3] retain]; 
                    view.userInteractionEnabled=YES;
                    [PRTween tween:view property:@"alpha" from:view.alpha to:1 duration:0.4];
                    //[GlobalFunction moveView:view to:view.showRect time:0.4];
                }else{
                    view.userInteractionEnabled=YES;
                    [PRTween tween:view property:@"alpha" from:view.alpha to:1 duration:0.4];
                    //[GlobalFunction fadeInOut:view to:1 time:0.4 hide:NO];
                }
            }
            if(!closeAuto)
                [self performSelector:@selector(showHide) withObject:nil afterDelay:3.4f];
        }
        
        
    }
    
}
-(void)addTop:(ControlTopView *)view{
    view.alpha=0;
    [topList addObject:view];
}
-(void)addLeft:(ControlLeftView *)view{
    if(view.frame.origin.x>0){
        view.alpha=0;
    }
    
    
    [leftList addObject:view];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        closeAuto=NO;
        topOpen=NO;
        leftOpen=NO;
        topIndex=-1;
        leftIndex=-1;
        topList=[[NSMutableArray alloc] init];
        leftList=[[NSMutableArray alloc] init];
        // Initialization code
    }
    return self;
}



- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    UIView *hit=nil;
    NSArray *nr=self.subviews;
    for (NSInteger i=0;i<[nr count];i++){
        UIView *temView=[nr objectAtIndex:i];
        CGPoint temPoint=[self convertPoint:point toView:temView];
        
        hit= [temView hitTest:temPoint withEvent:event];
        if(hit!=nil){
            // [GlobalFunction closeTouch];
            return hit;
        }
        
        
    }
    return nil;
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */


+(UIButton *)getTopButtom:(CGFloat)x width:(CGFloat)width{
    UIButton *uv=[UIButton buttonWithType:UIButtonTypeCustom];
    [uv setBackgroundImage:[UIImage imageNamed:@"top_bg.png"] forState:UIControlStateNormal];
    [uv setBackgroundImage:[UIImage imageNamed:@"top_bg_o.png"] forState:UIControlStateHighlighted];
    [uv setBackgroundImage:[UIImage imageNamed:@"top_bg_o.png"] forState:UIControlStateSelected];
    uv.frame = CGRectMake(x,0, width, 56);
    [uv imageRectForContentRect:uv.frame];
    return uv;
}

+(UIButton *)getTopButtom2:(CGFloat)x width:(CGFloat)width{
    UIButton *uv=[UIButton buttonWithType:UIButtonTypeCustom];
    [uv setBackgroundImage:[UIImage imageNamed:@"top_bg_o.png"] forState:UIControlStateNormal];
    [uv setBackgroundImage:[UIImage imageNamed:@"top_bg.png"] forState:UIControlStateHighlighted];
    [uv setBackgroundImage:[UIImage imageNamed:@"top_bg.png"] forState:UIControlStateSelected];
    uv.frame = CGRectMake(x,0, width, 56);
    [uv imageRectForContentRect:uv.frame];
    return uv;
}



- (void)dealloc
{
    if(topList)[GlobalFunction removeViews:topList];
    if(leftList)[GlobalFunction removeViews:leftList];
    
    if(leftTween1)[PRTween removeTweenOperation:leftTween1];
    Release2Nil(leftTween1);
    if(leftTween2)[PRTween removeTweenOperation:leftTween2];
    Release2Nil(leftTween2);
    Release2Nil(topList);
    Release2Nil(leftList);
    
    [super dealloc];
}

@end
