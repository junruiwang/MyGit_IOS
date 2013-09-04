//
//  JJ360View.h
//  jinjiang
//
//  Created by Jeff.Yan on 11-11-6.
//  Copyright 2011年 W+K. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>

@interface JJ360View : UIView <UIAccelerometerDelegate,UIWebViewDelegate> {
    UIWebView *webView;
    UIWebView *temWebView;
    BOOL openXY;
    CGFloat yy;
    CMMotionManager *motionManager;
    CGFloat d3dR;
}
-(void)clearMotion;
-(void)toScene:(NSString *)name;
@end
