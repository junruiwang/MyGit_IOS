//
//  AlipayWapWebViewViewController.m
//  JinJiangTravelPlus
//
//  Created by 胡 桂祁 on 3/15/13.
//  Copyright (c) 2013 JinJiang. All rights reserved.
//

#import "AlipayWapWebViewController.h"
#import "AccountInfoViewController.h"
#import "OrderDetailController.h"
#import <QuartzCore/QuartzCore.h>
#import "ParameterManager.h"
#import "NSDataAES.h"

@interface AlipayWapWebViewController ()

@end

@implementation AlipayWapWebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.loadWebView = [[UIWebView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.loadWebView.scalesPageToFit = YES;
    self.loadWebView.delegate = self;
    self.url = self.htmlBody;
    [self loadRequest];
}

-(void)viewWillAppear:(BOOL)animated
{
    self.trackedViewName = @"支付宝网页支付页面";
    [super viewWillAppear:animated];
}

- (void)backToController:(Class)className
{
    
    NSArray *viewControlelrs = self.navigationController.viewControllers;
    for (JJViewController *jjvc in viewControlelrs) {
        if ([jjvc isKindOfClass:AccountInfoViewController.class]) {
            ((AccountInfoViewController *)jjvc).isNeedRefresh = YES;
            [self.navigationController popToViewController:jjvc animated:YES];
            break;
        }
    }
}

- (void)pushOrderDetailController:(id) sender
{
    if (self.sourceControlelr != nil && [self.sourceControlelr isEqualToString:@"buyCard"]) {
        [UMAnalyticManager eventCount:@"支付宝wap购买享卡支付完成" label:@"支付宝wap购买享卡支付完成"];
        [[GAI sharedInstance].defaultTracker sendEventWithCategory:@"购买享卡"
                                                        withAction:@"在线支付"
                                                         withLabel:@"支付宝wap支付完成"
                                                         withValue:nil];
        [self backToController:AccountInfoViewController.class];
    } else if(self.sourceControlelr != nil && [self.sourceControlelr isEqualToString:@"renewCard"]){
        [UMAnalyticManager eventCount:@"享卡续费支付完成" label:@"支付宝wap续费享卡支付完成"];
        [[GAI sharedInstance].defaultTracker sendEventWithCategory:@"享卡续费支付完成"
                                                        withAction:@"支付宝wap支付"
                                                         withLabel:@"支付宝wap续费享卡支付完成"
                                                         withValue:nil];

         [self backToController:AccountInfoViewController.class];
    }else {
        
        [UMAnalyticManager eventCount:@"支付宝wap支付完成" label:@"支付宝wap支付完成按钮"];
        [[GAI sharedInstance].defaultTracker sendEventWithCategory:@"订单"
                                                        withAction:@"在线支付"
                                                         withLabel:@"支付宝wap支付完成"
                                                         withValue:nil];
        [self performSegueWithIdentifier:@"paySuccessToBillListSegue" sender:self];
    }
}

-(void)buildAlipayWapUrl:(AlipayForm *)form
{
    ParameterManager *parameterManager = [[ParameterManager alloc] init];
    [parameterManager parserStringWithKey:@"orderNo" WithValue:form.orderNo];
    [parameterManager parserStringWithKey:@"buyerName" WithValue:form.buyerName];
    [parameterManager parserStringWithKey:@"buyerIp" WithValue:form.buyerIp];
    [parameterManager parserStringWithKey:@"amount" WithValue:form.amount];
    [parameterManager parserStringWithKey:@"bgUrl" WithValue:form.bgUrl];
    [parameterManager parserStringWithKey:@"businessPart" WithValue:form.businessPart];
    
    [parameterManager parserStringWithKey:@"description" WithValue:form.description];
    
    NSString* httpBodyString = [KAliPayWapURL stringByAppendingFormat:@"?%@",[parameterManager serialization]];
    NSString* uid = TheAppDelegate.userInfo.uid;
    httpBodyString = [httpBodyString stringByAppendingFormat:@"&clientVersion=%@&userId=%@", kClientVersion, uid];
    httpBodyString = [httpBodyString stringByAppendingFormat:@"&sign=%@", [[uid stringByAppendingFormat:kSecurityKey] MD5String]];
    self.htmlBody = httpBodyString;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) generateCompleteButton
{
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 25)];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"back_complete.png"] forState:UIControlStateNormal];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"back_complete_press.png"] forState:UIControlStateHighlighted];
    [rightBtn addTarget:self action:@selector(pushOrderDetailController:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = barButtonItem;
}


-(id)initWithUrl:(NSString *) urlStr
{
    self = [super init];
    self.loadWebView = [[UIWebView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.loadWebView.scalesPageToFit = YES;
    self.loadWebView.delegate = self;
    self.url = urlStr;
    return self;
}

-(void)loadRequest
{
    NSURL *URL = [NSURL URLWithString:[self.url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL cachePolicy:NSURLCacheStorageAllowedInMemoryOnly timeoutInterval:8];
    [self.loadWebView loadRequest:request];
    self.view = self.loadWebView;
    
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *theTitle=[webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.title = theTitle;
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *theTitle=[webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.title = theTitle;
    
    NSString *theURL=[webView stringByEvaluatingJavaScriptFromString:@"document.URL"];
    NSLog(@"--------callBackUrl:%@ -----theURL:%@",callBackUrl,theURL);
    if ([theURL hasPrefix:callBackUrl]) {
        [self generateCompleteButton];
        self.navigationItem.leftBarButtonItem= nil;
        self.navigationItem.hidesBackButton= YES;
        if(self.sourceControlelr != nil && [self.sourceControlelr isEqualToString:@"renewCard"]){
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"享卡续费支付成功，系统将在1小时后续费生效，请1小时后重新登陆,如有疑问请致电客服电话1010-1666" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }
    }
    
    [self hideIndicatorView];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{

    [super webView:webView didFailLoadWithError:error];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
