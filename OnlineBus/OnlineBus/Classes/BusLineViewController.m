//
//  BusLineViewController.m
//  OnlineBus
//
//  Created by jerry on 13-12-5.
//  Copyright (c) 2013年 jerry.wang. All rights reserved.
//

#import "BusLineViewController.h"

@interface BusLineViewController ()

@end

@implementation BusLineViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.screenName = @"线路查询页面测试";
    self.parentViewController.navigationItem.title = @"线路查询";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self loadCustomBanner];
}

@end
