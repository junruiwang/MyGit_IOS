//
//  PromotionWebController.m
//  JinJiangTravelPlus
//
//  Created by 吕 硕 on 13-1-6.
//  Copyright (c) 2013年 JinJiang. All rights reserved.
//

#import "PromotionWebController.h"

@interface PromotionWebController ()

@end

@implementation PromotionWebController

@synthesize url;
@synthesize web;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
     self.trackedViewName = @"活动公告详情页面";
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];[self setTitle:@"活动详情"];
	// Do any additional setup after loading the view.

    const unsigned int hh = self.view.frame.size.height;
    self.web = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, hh)];
    [self.web loadRequest:[NSURLRequest requestWithURL:self.url]];
    [self.web setDelegate:self];[self.view addSubview:self.web];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self showIndicatorView];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self hideIndicatorView];
}

@end
