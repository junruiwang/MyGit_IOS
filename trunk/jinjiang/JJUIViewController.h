//
//  JJUIViewController.h
//  jinjiang
//
//  Created by Jeff.Yan on 11-10-27.
//  Copyright 2011年 W+K. All rights reserved.
//



#import <Foundation/Foundation.h>
#import "ControlView.h"

@class LoadingView;
@interface JJUIViewController : UIViewController {
    NSMutableDictionary *paths;
    NSMutableDictionary *temKeys;
    NSInteger tounchNum;
    NSInteger touchMode;
    NSMutableArray *btns;
    ControlView *controlView;
    BOOL isLeft;
    LoadingView *loading;
    
    UIImageView *cacheImage;
}
-(void)setTouchMode:(NSInteger)mode point:(CGPoint)point;
-(void)setTouchMode:(NSInteger)mode;
-(void)startDelay:(NSMutableDictionary *)nd;
-(void)checkMoveTouch:(NSSet *)touches;
-(void)checkEndTouch;

- (void)touchesBeganFun:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesMovedFun:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesEndedFun:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesCancelledFun:(NSSet *)touches withEvent:(UIEvent *)event;

-(void)outFun;

-(void)showLoading;
-(void)showLoadingAtIndex:(int)index;
-(void)hideLoading;

@end
