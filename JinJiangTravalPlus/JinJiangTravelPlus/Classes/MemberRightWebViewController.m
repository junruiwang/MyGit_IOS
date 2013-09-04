//
//  MemberRightWebViewController.m
//  JinJiangTravelPlus
//
//  Created by Rong Hao on 13-6-27.
//  Copyright (c) 2013年 JinJiang. All rights reserved.
//

#import "MemberRightWebViewController.h"

@interface MemberRightWebViewController ()

@end

@implementation MemberRightWebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"会员权益";
    self.aboutWebView.scalesPageToFit = YES;
    self.aboutWebView.delegate = self;
    self.url = @"http://www.jinjiang.com/membercenter/aboutplan";
    [self.aboutWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]
                                               cachePolicy:NSURLRequestUseProtocolCachePolicy
                                           timeoutInterval:8]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setAboutWebView:nil];
    [super viewDidUnload];
}
@end
