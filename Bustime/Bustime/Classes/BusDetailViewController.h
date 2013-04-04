//
//  BusDetailViewController.h
//  Bustime
//
//  Created by 汪君瑞 on 13-4-2.
//  Copyright (c) 2013年 Jerry Wang. All rights reserved.
//

#import "BannerViewController.h"

@interface BusDetailViewController : BannerViewController

@property(nonatomic, weak) IBOutlet UIView *topTitleView;
@property(nonatomic, strong) UIView *bottomView;
@property(nonatomic, strong) UIScrollView *subScrollView;

@end
