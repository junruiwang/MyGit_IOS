//
//  LeftScrollView.h
//  jinjiang
//
//  Created by Jeff.Yan on 11-11-14.
//  Copyright 2011年 W+K. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "ControlLeftView.h"
#import "LeftViewCell.h"


@protocol LeftScrollViewDelegate;

@interface LeftScrollView : ControlLeftView <UIScrollViewDelegate,LeftViewCellDelegate>{
    UIView *bgView;
    UIScrollView *scrView;
    
    CGRect fullFrame;
    
    CGFloat sh;
    
    NSArray *data;
    
    
    NSMutableArray *viewList;
    
    
    BOOL isDown;
    
    BOOL isBottom;
    
    Class cellClass;
    
    NSInteger selectId;
    
    id <LeftScrollViewDelegate> delegate;
}

-(void)setData:(NSArray *)_data cc:(NSString *)cc _sh:(CGFloat)_sh;
@property (nonatomic, assign) id <LeftScrollViewDelegate> delegate;
@property (nonatomic, retain) UIView *bgView;
@property (nonatomic, assign)  BOOL isBottom;
@end

@protocol LeftScrollViewDelegate
//-(void)selectView:(LeftScrollView *)leftScrollView index:(NSInteger)index;
-(void)selectView:(LeftScrollView *)leftScrollView index:(NSInteger)index dic:(id)dic;
@end
