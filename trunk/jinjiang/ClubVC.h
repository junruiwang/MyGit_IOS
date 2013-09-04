//
//  ClubVC.h
//  jinjiang
//
//  Created by Jeff.Yan on 11-10-27.
//  Copyright 2011年 W+K. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JJUIViewController.h"
#import "ControlView.h"
#import "MagzineView.h"

#import "VipView.h"


@interface ClubVC : JJUIViewController {
    MagzineView *magzineView;
    VipView *vipView;
    NSInteger index;
    ControlTopView *ctv;

}

@end
