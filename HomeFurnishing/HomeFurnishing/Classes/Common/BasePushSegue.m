//
//  BasePushSegue.m
//  HomeFurnishing
//
//  Created by jrwang on 14-12-13.
//  Copyright (c) 2014年 handpay. All rights reserved.
//

#import "BasePushSegue.h"

@implementation BasePushSegue

- (void)perform
{
    UIViewController *current = [self sourceViewController];
    UIViewController *next = [self destinationViewController];
    
    [UIView
     transitionWithView:current.navigationController.view
     duration:0.5
     options:UIViewAnimationOptionTransitionCurlUp
     animations:^{
         [current.navigationController pushViewController:next animated:NO];
     } completion:NULL];
}

@end
