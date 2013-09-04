//
//  AboutUsViewController.m
//  JinJiangHotel
//
//  Created by Rong Hao on 13-8-13.
//  Copyright (c) 2013年 jinjiang. All rights reserved.
//

#import "AboutUsViewController.h"
#import "ShareToSNSManager.h"

@interface AboutUsViewController ()
@property(nonatomic, strong) ShareToSNSManager *shareToSNSManager;

@end

@implementation AboutUsViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [self initNavigationBarWithStyle:JJTwoLineTilteBarStyle];
    
    self.navigationBar.mainLabel.text = NSLocalizedStringFromTable(@"about us", @"AboutUs", @"");
    self.navigationBar.subTitleLabel.text = NSLocalizedStringFromTable(@"version:", @"AboutUs", @"");

    self.shareToSNSManager = [[ShareToSNSManager alloc] init];
    [self.navigationBar addRightBarButton:@"about_share.png"];
    
    self.textScrollView.contentSize = CGSizeMake(290, 670);
    
//    [self.navigationItem.titleView addSubview:title];
//    [self.navigationItem.titleView addSubview:version];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)share
{
    
    [[GAI sharedInstance].defaultTracker sendEventWithCategory:@"关于我们"
                                                    withAction:@"点击分享"
                                                     withLabel:@"关于页面分享按钮"
                                                     withValue:nil];
    [UMAnalyticManager eventCount:@"点击分享" label:@"关于页面用户反馈按钮"];
    
    [self.shareToSNSManager shareWithActionSheet:self shareImage:[UIImage imageNamed:@"icon.png"] shareText:[NSString stringWithFormat:@"哇塞，这个软件是商旅必备神器啊--锦江旅行家，订酒店超快超方便，下个试试吧！%@", kAppStoreUrl]];
}
- (IBAction)rankButtonPress:(UIButton *)sender {
    
    [[GAI sharedInstance].defaultTracker sendEventWithCategory:@"关于我们"
                                                    withAction:@"点击评分"
                                                     withLabel:@"关于页面我要评分按钮"
                                                     withValue:nil];
    [UMAnalyticManager eventCount:@"点击评分" label:@"关于页面我要评分按钮"];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kCommentUrl]];
}

- (void)rightButtonPressed
{
    [self share];
}
- (void)viewDidUnload {
    [self setTextScrollView:nil];
    [self setBrandTitleLabel:nil];
    [self setGroupTitleLabel:nil];
    [self setBrandDetailText:nil];
    [self setGroupDetailText:nil];
    [super viewDidUnload];
}
@end
