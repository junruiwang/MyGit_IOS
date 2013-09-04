//
//  ModalWebVC.h
//  jinjiang
//
//  Created by Jeff.Yan on 11-10-31.
//  Copyright 2011年 W+K. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JJUIViewController.h"
@protocol ModalWebVCDelegate <NSObject>

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType;

@end

//@class WebTouchView;

@interface ModalWebVC : UIViewController <UIWebViewDelegate> {
    UIWebView *webTouchView;
    //   WebTouchView *webTouchView;
    UITextField *titleTxt;
    UIButton *closeBtn;
    UIImageView *titleBg;
    id<ModalWebVCDelegate> delegate;
}
-(void)loadUrl:(NSString *)url;
-(void)loadUrlNSURL:(NSURL *)url;
@property (nonatomic,assign) id<ModalWebVCDelegate> delegate;
@end


