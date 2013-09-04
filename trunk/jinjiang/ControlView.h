//
//  ControlView.h
//  jinjiang
//
//  Created by Jeff.Yan on 11-11-4.
//  Copyright 2011年 W+K. All rights reserved.
//

#import <UIKit/UIKit.h>


#import "ControlTopView.h"
#import "ControlLeftView.h"

//#define TOPRECT CGRectMake(0, 0, 222, 56)
#define TOPRECT CGRectMake(0, 0, 1024, 56)
@class PRTweenOperation;
@interface ControlView : UIView {
    BOOL topOpen;
    BOOL leftOpen;
    NSInteger topIndex;
    NSInteger leftIndex;
    NSMutableArray *topList;
    NSMutableArray *leftList;
    BOOL closeAuto;
    //PRTweenOperation *topTween;
    PRTweenOperation *leftTween1;
    PRTweenOperation *leftTween2;
    
}

@property (nonatomic, assign) BOOL closeAuto;

-(void)showTop:(NSInteger)toIndex;
-(void)showLeft:(NSInteger)toIndex;

-(void)addTop:(ControlTopView *)view;
-(void)addLeft:(ControlLeftView *)view;
-(void)stopStartHide:(BOOL)b;
-(void)showHide;



+(UIButton *)getTopButtom:(CGFloat)x width:(CGFloat)width;
+(UIButton *)getTopButtom2:(CGFloat)x width:(CGFloat)width;
//-(void)drawView:(CGRect)rect
@end
