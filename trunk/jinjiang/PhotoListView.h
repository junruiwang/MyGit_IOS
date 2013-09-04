//
//  PhotoListView.h
//  jinjiang
//
//  Created by zi cheng on 11-12-22.
//  Copyright (c) 2011年 W+K. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoWallOneUC.h"
#import "Magzine.h"

@protocol PhotoListViewDelegate;
@interface PhotoListView : UIView<UIScrollViewDelegate,PhotoWallOneUCDelegate>{
    UIScrollView *listView;
    Magzine *data;
    NSMutableArray *listArray;
    NSInteger aNum;
    id <PhotoListViewDelegate> delegate;
    
    UILabel *titleTxt;
    
    BOOL isShow;
    
    BOOL isClick;
    
    NSInteger _index;
}
@property (nonatomic, assign) id <PhotoListViewDelegate> delegate;
-(void)setData:(Magzine *)d;
-(void)setShow:(NSInteger)i;
-(void)showHideBottom;
-(void)showBottom;
@end

@protocol PhotoListViewDelegate
-(void)selectPo:(NSInteger)index;
-(void)back;

@end