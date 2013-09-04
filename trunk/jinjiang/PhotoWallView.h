//
//  PhotoWallView.h
//  jinjiang
//
//  Created by Jeff.Yan on 11-11-22.
//  Copyright 2011年 W+K. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PRTween.h"
#import "JYScrollView.h"
#import "PhotoListView.h"
#import "Magzine.h"

@class ControlTopView,PhotoListView;
//JYScrollViewDelegate
@interface PhotoWallView : UIView <UIScrollViewDelegate,PhotoListViewDelegate>{
    UIScrollView *photoWall;
    
    PhotoListView *listView;
    
    Magzine *data;
    
    
    NSInteger selectId;
    NSInteger openId;
    
    NSInteger aNum;
    
    NSMutableArray *listArray;
    
    BOOL isMove;
    
    NSInteger _index;
    
}
-(void)showHideBottom;
-(void)setData:(Magzine *)d;

@end


