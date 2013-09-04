//
//  GlobalFunction.h
//  chengguo
//
//  Created by Jeff.Yan on 11-4-23.
//  Copyright 2011年 W+K. All rights reserved.
//


#include <QuartzCore/CoreAnimation.h>
#include <CoreGraphics/CoreGraphics.h>

#import <Foundation/Foundation.h>
#import <mach/mach.h>
#import <mach/mach_host.h>

#import <QuartzCore/CABase.h>




#import <MessageUI/MessageUI.h>


#import "NSString+SBJSON.h"


#import "JJ360VC.h"
#import "MovPlayerView.h"

#import "ControlView.h"
#import "MainNC.h"
#import "NavigationView.h"
#import "jinjiangViewController.h"
#import "WebTouchView.h"


#import "RootWindowUI.h"

#import "HTTPConnection.h"
#import "LoadImageUrlConnection.h"

#import "JJ360View.h"

#import "LoadImageView.h"

#import "ShareView.h"
#import "PopLeaderView.h"


#import "LeftViewCell.h"
#import "LeftScrollView.h"

#import "ControlLeftView.h"

#import "PRTween.h"



#define TOPHEIGHT 48
#define TOPFULLHEIGHT 56

@class LoadingView;

@interface GlobalFunction : NSObject {
    
}


+(void)getPropertyWithString:(id)object property:(NSString *)property value:(void *)value;
+(void)setPropertyWithString:(id)object property:(NSString *)property value:(void *)value;

+(void)addImage:(UIView *)view name:(NSString *)name;
+(void)addImage:(UIView *)view name:(NSString *)name rect:(CGRect)rect;
+(void)addImage:(UIView *)view name:(NSString *)name rect:(CGRect)rect  atIndex:(NSInteger)index;
+(void)addImage:(UIView *)view name:(NSString *)name point:(CGPoint)point;

+(void)removeSubviews:(UIView *)view;
+(void)removeViews:(NSArray *)arr;

+(void)logSubviews:(UIView *)view;


+(void)fadeInOut:(UIView *)view to:(CGFloat)alpha time:(CGFloat)time hide:(BOOL)hide;
+(void)fadeInOut:(UIView *)view to:(CGFloat)alpha time:(CGFloat)time target:(id)target action:(SEL)action;
+(void)fadeInOut:(UIView *)view to:(CGFloat)alpha time:(CGFloat)time delay:(CGFloat)delay hide:(BOOL)hide;

+(void)moveView:(UIView *)view to:(CGRect)frame time:(float)time;
+(void)moveView:(UIView *)view to:(CGRect)frame time:(float)time  target:(id)target action:(SEL)action;

+(void)scaleView:(UIView *)view to:(CGFloat)zoom time:(float)time;
+(void)scaleView:(UIView *)view to:(CGFloat)zoom time:(float)time target:(id)target action:(SEL)action;

+(void)rotateView:(UIView *)view to:(CGFloat)angle time:(float)time;
+(void)rotateView:(UIView *)view to:(CGFloat)angle time:(float)time target:(id)target action:(SEL)action;

+(void)rotateScaleView:(UIView *)view angle:(CGFloat)angle  zoom:(CGFloat)zoom time:(float)time  target:(id)target action:(SEL)action delay:(CGFloat)delay;

+(void)closeTouch;

+(NSArray *)checkArr:(id)str;
+(BOOL)checkIsNull:(NSString *)str;




+(UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize;
+(UIImage *)reScaleSizeImage:(UIImage *)image toSize:(CGSize)reSize;
+(UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize;
+ (UIImage *)shadowImage:(UIImage *)image;
+ (UIImage *)startDownloadImage:(UIImage *)image;
+ (UIImage *)pauseImage:(UIImage *)image;
+ (UIImage *)downloadImage:(UIImage *)image;
+ (UIImage *)failImage:(UIImage *)image;
+ (UIImage *)combineImage:(UIImage *)firstImage withImage:(UIImage *)secondImage inRect:(CGRect)rect;
+ (UIImage *)combineImage:(UIImage *)image withProgress:(UIImage *)progressImage;
+ (UIImage *)combineImage:(UIImage *)firstImage withText:(NSString *)text inRect:(CGRect)rect;
+ (UIImage *)combineImage:(UIImage *)image withText:(NSString *)text;

+(UIColor *)getColor:(int)type;



+(void)addLabelLeft:(UIView *)uv copy:(NSString *)copy frame:(CGRect)frame size:(CGFloat)size;
+(void)addLabelLeft:(UIView *)uv copy:(NSString *)copy frame:(CGRect)frame size:(CGFloat)size lines:(NSInteger) lines;
+(void)addLabelCenter:(UIView *)uv copy:(NSString *)copy frame:(CGRect)frame size:(CGFloat)size;


//+(id)initLabelLeft:(NSString *)copy frame:(CGRect)frame size:(CGFloat)size;

//+(id)initLabelLeft:(NSString *)copy frame:(CGRect)frame size:(CGFloat)size lines:(NSInteger) lines;



+(UIImage *)getImageFromImage:(UIImage*)superImage rect:(CGRect)rect;

+(UIImage*) createWireFrmaeImage:(CGFloat)wd ht:(CGFloat)ht r:(CGFloat)r  cr:(CGFloat)cr cg:(CGFloat)cg cb:(CGFloat)cb ca:(CGFloat)ca;


+(void)setTxtColor:(UIColor *)c;
+(UIColor *)getTxtColor;

+(void)randomArray:(NSArray *)arr;

+(UIImage *)glToUIImage:(UIView*)view;

+ (UIImage*)imageFromView:(UIView*)view;

+ (UIImage*)imageFromView:(UIView*)view frame:(CGRect)rect;

@end
