//
//  HomeVC.h
//  jinjiang
//
//  Created by Jeff.Yan on 11-10-27.
//  Copyright 2011年 W+K. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JJUIViewController.h"

#import "MenuItemVW.h"
@class TouchPointObj;
@interface HomeVC : JJUIViewController<UIScrollViewDelegate,MenuItemDelegate>{
    BOOL isMove;
    CGPoint cachePoint;
    TouchPointObj *cacheTouchPointObj;
    MenuItemVW *moveMi;
    UIScrollView *menuView;
    NSMutableArray *menuList;
    NSInteger toIndex;
    
    BOOL skipScoll;
    
    
    
}

@end
