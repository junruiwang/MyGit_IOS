//
//  UINavigationBar+Categories.h
//  JinJiangTravalPlus
//
//  Created by Leon on 10/29/12.
//  Copyright (c) 2012 Leon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationBar (Categories)

- (void)setBackgroundImage:(UIImage*)image;
- (void)setBackButtonTitle:(NSString *)title target:(UIViewController *)target;
- (void)setBackButtonTitle:(NSString *)title target:(UIViewController *)target action:(SEL)action;
- (void)setCancelButtonTitle:(NSString *)title target:(UIViewController *)target action:(SEL)action;
- (void)setRightButtonTitle:(NSString *)title target:(UIViewController *)target action:(SEL)action;
- (void)setTitle:(NSString *)title forTarget:(UIViewController *)target;
- (void)setTitle:(NSString *)title forTarget:(UIViewController *)target hasTwoButtons:(BOOL)hasTwoButtons;

@end
