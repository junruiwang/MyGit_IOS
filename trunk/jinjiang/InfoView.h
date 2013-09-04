//
//  InfoView.h
//  jinjiang
//
//  Created by Jeff.Yan on 11-11-8.
//  Copyright 2011年 W+K. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GlobalFunction.h"
#import "MainNC.h"
#import "NavigationView.h"
#import "jinjiangViewController.h"

@interface InfoView : UIView {
    NSMutableArray *menuList;
    NSInteger toIndex;
    BOOL isMove;
    
    UIScrollView *viewNext;
    ControlView *controlView;
}



-(void)setControlView:(ControlView *)cl;
-(void)showPage:(NSInteger)ii;
@end
