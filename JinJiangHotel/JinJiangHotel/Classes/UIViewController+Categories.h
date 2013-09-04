//
//  UIViewController+Categories.h
//  JinJiangTravalPlus
//
//  Created by Leon on 10/29/12.
//  Copyright (c) 2012 Leon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Categories)

- (void)backAction:(id)sender;

- (void)showAlertMessage:(NSString *)msg;
- (void)showAlertMessage:(NSString *)msg dismissAfterDelay:(NSTimeInterval)delay;
- (void)showAlertMessageWithOkCancelButton:(NSString *)msg title:(NSString *)title tag:(NSInteger)tag delegate:(id)delegate;
- (void)showAlertMessageWithOkButton:(NSString *)msg title:(NSString *)title tag:(NSInteger)tag delegate:(id)delegate;
- (void)showTextFieldAlertWithOkCancelButton:(NSString *)title tag:(NSInteger)tag
                                    delegate:(id)delegate defaultValue:(NSString *)defaultValue
                                 placeHolder:(NSString *)placeHolder;

@end
