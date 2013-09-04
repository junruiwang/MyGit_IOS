//
//  RootWindowUI.m
//  jinjiang
//
//  Created by Jeff.Yan on 11-11-2.
//  Copyright 2011年 W+K. All rights reserved.
//

#import "RootWindowUI.h"

#import "MainNC.h"
#import "TouchPointObj.h"
#import "NavigationView.h"

#import "JJUIViewController.h"
#import "jinjiangViewController.h"


@implementation RootWindowUI

//touchView
//touchView
@synthesize isClose;

static RootWindowUI *_instance = nil;

+(id)sharedInstance{
    
    @synchronized(self)
    {
        if (_instance == nil) {
            _instance =[[RootWindowUI alloc] initWithFrame:CGRectMake(0, 0, 768, 1024)]; 
             _instance.multipleTouchEnabled=YES;
            jinjiangViewController *rvc=[jinjiangViewController sharedInstance];
            _instance.isClose=NO;
            [_instance addSubview:rvc.view];
        }
    }
    return _instance;

}
+(void)shareRelease{
    Release2Nil(_instance);    
}
+(void)closeOpen:(BOOL)b{
    [[RootWindowUI sharedInstance] setIsClose:b];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor whiteColor];
        touchView=nil;
    }
    return self;
}
- (void)dealloc
{
    [jinjiangViewController shareRelease];
    [super dealloc];
    
}

+(void)setTouchView:(JJUIViewController *)view{
    [[RootWindowUI sharedInstance] setTouchView:view];
}
-(void)setTouchView:(JJUIViewController *)view{
    touchView=view;
}
-(void)closeTouch{
    isReady=NO;
}
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    
    //NSLog(@":::windwos hitest");
    isReady=YES;
    return [super hitTest:point withEvent:event];
}
- (void)sendEvent:(UIEvent *)event
{
    
     //NSLog(@"[RootWindowUI closeOpen:NO]::::%d:%d:%@",isClose,isReady,touchView);
    // NSLog(@":::windwos sendEvent");
    if(!isClose && isReady && touchView!=nil){
        NSSet *touches =[event touchesForWindow:self];
        NSMutableSet *began = nil;
        NSMutableSet *moved = nil;
        NSMutableSet *ended = nil;
        NSMutableSet *cancelled = nil;
    
    // sort the touches by phase so we can handle them similarly to normal event dispatch
        for(UITouch *touch in touches) {
            switch ([touch phase]) {
                case UITouchPhaseBegan:
                    if (!began) began = [[NSMutableSet alloc] init];
                    [began addObject:touch];
                    break;
                case UITouchPhaseMoved:
                    if (!moved) moved =[[NSMutableSet alloc] init];
                    [moved addObject:touch];
                    break;
                case UITouchPhaseEnded:
                    if (!ended) ended = [[NSMutableSet alloc] init];
                    [ended addObject:touch];
                    break;
                case UITouchPhaseCancelled:
                    if (!cancelled) cancelled = [[NSMutableSet alloc] init];
                    [cancelled addObject:touch];
                    break;
                default:
                    break;
            }
        }
    // call our methods to handle the touches
        if (began)     [touchView touchesBeganFun:began withEvent:event];
        if (moved)     [touchView touchesMovedFun:moved withEvent:event];
        if (ended)     [touchView touchesEndedFun:ended withEvent:event];
        if (cancelled) [touchView touchesCancelledFun:cancelled withEvent:event];
        
        Release2Nil(began);
        Release2Nil(moved);
        Release2Nil(ended);
        Release2Nil(cancelled);
    }else{
        if(touchView!=nil){
            [touchView touchesCancelledFun:nil withEvent:event];
        }
    }
    
    [super sendEvent:event];
}

@end
