//
//  MagzineView.h
//  jinjiang
//
//  Created by Jeff.Yan on 11-11-7.
//  Copyright 2011年 W+K. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlowCoverView.h"
#import "PhotoWallView.h"
#import "ControlView.h"
#import "ControlTopView.h"
#import "AFOpenFlowView.h"
#import "HTTPConnection.h"
#import "Magzine.h"

@class ClubVC;

@interface MagzineView : UIView <AFOpenFlowViewDelegate, HTTPConnectionDelegate, JJFileDownloadDelegate>{
    //    FlowCoverView *flowCoverView;
    PhotoWallView *photoWallView;
    ControlView *controlView;
    ControlTopView *ctv;
    UISlider *flowSider;
    AFOpenFlowView *flowCoverView;
    HTTPConnection *_hTTPConnection;
}

@property (nonatomic ,assign) ClubVC *clubVC;

-(void)setCTView:(ControlView *)cv ctv:(ControlTopView *)_ctv;
-(void)showPage:(NSInteger)i index:(NSInteger)_i;
-(void)showHideBottom;
- (void)getMagzines;

@end
