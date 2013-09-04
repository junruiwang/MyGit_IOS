//
//  WebViewController.m
//  JinJiangTravelPlus
//
//  Created by 杨 栋栋 on 12-12-24.
//  Copyright (c) 2012年 JinJiang. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController


- (void)viewDidLoad
{
    [super viewDidLoad];

    if (self.url != nil) {
        [self.webView setDelegate:self];
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]
                                                   cachePolicy:NSURLRequestUseProtocolCachePolicy
                                               timeoutInterval:8]];
    }
   
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self showIndicatorView];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self hideIndicatorView];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self hideIndicatorView];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"内容加载发生错误"
                                                   delegate:self cancelButtonTitle:nil
                                          otherButtonTitles:@"确定", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
}

     
@end
