//
//  LoadImageView.h
//  jinjiang
//
//  Created by Jeff.Yan on 11-11-9.
//  Copyright 2011年 W+K. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalFunction.h"
#import "PRTween.h"

@protocol LoadImageViewDelegate;
@interface LoadImageView : UIView {
    UIActivityIndicatorView *spinner;
    UIImageView *imageUV;
    LoadImageUrlConnection *cg;
    PRTweenOperation *tween;
    BOOL fadeIn;
    id <LoadImageViewDelegate> delegate;
    CGFloat cornerRadius;
}
@property (nonatomic, assign) CGFloat cornerRadius;
@property (nonatomic, assign) id <LoadImageViewDelegate> delegate;
-(void)loadImage:(NSString *)url;
-(void)loadImage:(NSString *)url fadeIn:(BOOL)fi;
-(void)clear;
-(void)reSet;
@end

@protocol LoadImageViewDelegate
-(void)loadComplete:(LoadImageView *)loadImage;
@end
