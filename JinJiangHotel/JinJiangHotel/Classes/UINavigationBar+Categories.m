//
//  UINavigationBar+Categories.m
//  JinJiangTravalPlus
//
//  Created by Leon on 10/29/12.
//  Copyright (c) 2012 Leon. All rights reserved.
//

#define _USE_CUSTOM_NAV_
#define __NAVBAR_USE_IMAGE__

#import <QuartzCore/QuartzCore.h>
#import "UINavigationBar+Categories.h"

@implementation UINavigationBar (Categories)

/*
 In iOS 5, the UINavigationBar, UIToolbar, and UITabBar implementations have changed so that the drawRect: method is not called unless it is implemented in a subclass. Apps that have re-implemented drawRect: in a category on any of these classes will find that the drawRect: method isn't called. UIKit does link-checking to keep the method from being called in apps linked before iOS 5 but does not support this design on iOS 5 or later. Apps can either:
 Use the customization API for bars in iOS 5 and later, which is the preferred way.
 //原文地址 http://blog.csdn.net/diyagoanyhacker/article/details/6876543
 Subclass UINavigationBar (or the other bar classes) and override drawRect: in the subclass.
 */


// only effective in iOS5.x
- (void)setBackgroundImage:(UIImage*)image
{    
    if ([self respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
    {   [self setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];  }
}

- (void)setBackButtonTitle:(NSString *)title target:(UIViewController *)target
{
    [self setBackButtonTitle:title target:target action:@selector(backAction:)];
}

- (void)setBackButtonTitle:(NSString *)title target:(UIViewController *)target action:(SEL)action
{
#ifdef _USE_CUSTOM_NAV_
    UIButton *BackBtn = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 65.0, 30.0)];
    [BackBtn setBackgroundImage:[UIImage imageNamed:@"blueBackBtn.png"] forState:UIControlStateNormal];
    [BackBtn setBackgroundImage:[UIImage imageNamed:@"blueBackBtnPressed.png"] forState:UIControlStateHighlighted];
    //[BackBtn.titleLabel setFont:[UIFont systemFontOfSize: 14]];
    //[BackBtn setTitle:[NSString stringWithFormat:@" %@", title] forState:UIControlStateNormal];
    [BackBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *BackBarBtn = [[UIBarButtonItem alloc] initWithCustomView:BackBtn];
    target.navigationItem.leftBarButtonItem = BackBarBtn;
#endif
    
}

- (void)setCancelButtonTitle:(NSString *)title target:(UIViewController *)target action:(SEL)action
{
#ifdef _USE_CUSTOM_NAV_
    UIButton *BackBtn = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 60.0, 30.0)];
    [BackBtn setBackgroundImage:[UIImage imageNamed:@"blueBtn.png"] forState:UIControlStateNormal];
    [BackBtn setBackgroundImage:[UIImage imageNamed:@"blueBtnPressed.png"] forState:UIControlStateHighlighted];
    BackBtn.titleLabel.font = [UIFont systemFontOfSize: 14];
    [BackBtn setTitle:title forState:UIControlStateNormal];
    [BackBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *BackBarBtn = [[UIBarButtonItem alloc] initWithCustomView:BackBtn];
    target.navigationItem.leftBarButtonItem = BackBarBtn;
#else
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStyleBordered target:target action:action];
    target.navigationItem.leftBarButtonItem = cancelButton;
    [cancelButton release];
#endif
}

- (void)setRightButtonTitle:(NSString *)title target:(UIViewController *)target action:(SEL)action
{
#ifdef _USE_CUSTOM_NAV_
    UIButton *BackBtn = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 60.0, 30.0)];
    [BackBtn setBackgroundImage:[UIImage imageNamed:@"blueBtn.png"] forState:UIControlStateNormal];
    [BackBtn setBackgroundImage:[UIImage imageNamed:@"blueBtnPressed.png"] forState:UIControlStateHighlighted];
    BackBtn.titleLabel.font = [UIFont systemFontOfSize: 14];
    [BackBtn setTitle:title forState:UIControlStateNormal];
    [BackBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *BackBarBtn = [[UIBarButtonItem alloc] initWithCustomView:BackBtn];
    target.navigationItem.rightBarButtonItem = BackBarBtn;
#else
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle :title style:UIBarButtonItemStyleBordered target:target action:action];
    target.navigationItem.rightBarButtonItem = rightButton;
    [rightButton release];
#endif
}

- (void)setTitle:(NSString*)title forTarget:(UIViewController *)target
{
    [self setTitle:title forTarget:target hasTwoButtons:YES];
}

- (void)setTitle:(NSString*)title forTarget:(UIViewController *)target hasTwoButtons:(BOOL)hasTwoButtons
{
    const float titleWidth = (hasTwoButtons && _ISIPHONE_) ? 140 : 320;
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, titleWidth, 44)];
    view.backgroundColor = [UIColor clearColor];
    view.clipsToBounds = YES;
    target.navigationItem.titleView = view;
    [view layoutIfNeeded];

    UILabel* titleLabel = [[UILabel alloc] init];
    titleLabel.text = title;
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    [titleLabel sizeToFit];
    CGFloat width = titleLabel.frame.size.width;
    titleLabel.frame = CGRectMake(0, 0, width, 44);
    titleLabel.layer.anchorPoint = CGPointMake(0.5, 0.5);
    [view addSubview:titleLabel];

    CGFloat actualWidth = view.frame.size.width;
    if(width > actualWidth)
    {
        if(width - actualWidth <= 15)
        {
            titleLabel.font = [UIFont boldSystemFontOfSize:18];
            return;
        }

        CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"position.x"];
        CGFloat totalTime = (width - actualWidth)/25 + 2;
        animation.duration = totalTime;
        animation.fillMode = kCAFillModeForwards;
        animation.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:width / 2],
                            [NSNumber numberWithFloat:width / 2],
                            [NSNumber numberWithFloat:actualWidth - width / 2],
                            [NSNumber numberWithFloat:actualWidth - width / 2],
                            [NSNumber numberWithFloat:width / 2], nil];
        animation.keyTimes = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0],
                              [NSNumber numberWithFloat:1/totalTime],
                              [NSNumber numberWithFloat:1/totalTime + ((totalTime - 2) / (totalTime * 2))],
                              [NSNumber numberWithFloat:2/totalTime + ((totalTime - 2) / (totalTime * 2))],
                              [NSNumber numberWithFloat:1.0], nil];
        // NSLog(@"%s %@", __FUNCTION, [animation.keyTimes description]);
        animation.removedOnCompletion = NO;
        animation.repeatCount = HUGE_VALF;  //forever
        [titleLabel.layer addAnimation:animation forKey:nil];
    }
    else
    {
        target.navigationItem.titleView = nil;
        target.title = title;
    }
}

@end
