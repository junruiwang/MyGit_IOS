//
//  ModalWebVC.m
//  jinjiang
//
//  Created by Jeff.Yan on 11-10-31.
//  Copyright 2011年 W+K. All rights reserved.
//

#import "ModalWebVC.h"
//#import "WebTouchView.h"
#import "GlobalFunction.h"
#import "jinjiangViewController.h"

@implementation ModalWebVC

@synthesize delegate;

/*
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    UIView *hit=nil;
    hit=[super hitTest:point withEvent:event];
    if(hit!=nil){
        [GlobalFunction closeTouch];
    }
    return hit;
}
*/


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    
    if(interfaceOrientation==UIInterfaceOrientationPortrait || interfaceOrientation==UIInterfaceOrientationPortraitUpsideDown){
        
        return NO;
    }else{
        return YES;
    }
    
}


-(void)closeClickFun{
    
    [jinjiangViewController dismissUV];
}
-(void)initUi{
    if(webTouchView==nil){
        //UIWebView
        webTouchView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 50,1024, 718)];
        //webTouchView = [[WebTouchView alloc] initWithFrame:CGRectMake(0, 50,1024, 718)];
        webTouchView.backgroundColor=[UIColor grayColor];
        webTouchView.delegate=self;
        [self.view addSubview:webTouchView];
    }
    if(titleBg==nil){
        titleBg=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"6_t_bg.png"]];
        [self.view addSubview:titleBg];
    }
    if(titleTxt==nil){
        titleTxt=[[UITextField alloc] initWithFrame:CGRectMake(20, 12,1024-41-41, 22)];
        [self.view addSubview:titleTxt];
    }
    if(closeBtn==nil){
        closeBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        closeBtn.frame = CGRectMake(1024-9-32, 9, 32, 32);
        closeBtn.tag = 100;
        [closeBtn setImage:[UIImage imageNamed:@"6_close.png"] forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(closeClickFun) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:closeBtn];
    }
    
}
-(void)loadUrl:(NSString *)url{
    [self initUi];
    NSURL *nr=[NSURL URLWithString:url];
    NSURLRequest *ns=[[NSURLRequest alloc] initWithURL:nr];
    [webTouchView loadRequest:ns];
    [titleTxt setText:url];
    [ns release];
}
-(void)loadUrlNSURL:(NSURL *)url{
    [self initUi];
    NSURLRequest *ns=[[NSURLRequest alloc] initWithURL:url];
    [webTouchView loadRequest:ns];
    [titleTxt setText:@""];
    [ns release];
}
- (void)loadView
{
    [super loadView];
    [self initUi];
    
}



- (void)dealloc
{
    
    NSLog(@"modalView dealloc");
    if(webTouchView){
        webTouchView.delegate=nil;
        [webTouchView stopLoading];
    }
    RemoveRelease(webTouchView);
    RemoveRelease(titleBg);
    RemoveRelease(titleTxt);
    Remove2Nil(closeBtn);
    
    [super dealloc];
    
}
- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {

    if(delegate && [delegate respondsToSelector:@selector(webView:shouldStartLoadWithRequest:navigationType:)]){
        return [delegate webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
    }
    return YES;
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
}

@end
