//
//  ShakeSugue.m
//  JinJiangTravelPlus
//
//  Created by 胡 桂祁 on 5/21/13.
//  Copyright (c) 2013 JinJiang. All rights reserved.
//

#import "ShakeSugue.h"
#import "IndexViewController.h"
#import "Constants.h"

@implementation ShakeSugue

-(void)perform
{
    if([FROM_INDEX_TOSHAKE isEqualToString:self.identifier]){
        IndexViewController *indexViewController = (IndexViewController *)self.sourceViewController;
        UIView *destinationView = [self.destinationViewController view];
        CGRect sourceFrame =indexViewController.shakeBgView.frame = CGRectMake(0, -460, 320, 550);
        [indexViewController.shakeBgView addSubview:destinationView];
        
        [UIView animateWithDuration:0.8
                              delay:0.0
                            options:UIViewAnimationOptionTransitionCurlUp
                         animations:^{
                             indexViewController.shakeBgView.frame = CGRectMake(0, 0, 320, 550);
                         }
                         completion:^(BOOL finish){
                             [[self.sourceViewController navigationController] pushViewController:self.destinationViewController animated:NO];
                             indexViewController.shakeBgView.frame = sourceFrame;
//                             [[indexViewController.shakeBgView subviews][1] removeFromSuperview];
         
                         }];
    }else if([FROM_LOGIN_TO_SHAKE isEqualToString:self.identifier]){
        [[self.sourceViewController navigationController] pushViewController:self.destinationViewController animated:YES];
    }
    

}
@end
