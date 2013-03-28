//
//  LoginReplaceSegue.m
//  ChoiceCourse
//
//  Created by 汪君瑞 on 12-11-16.
//
//

#import "LoginReplaceSegue.h"

@implementation LoginReplaceSegue

- (void)perform
{
    UIViewController *current = [self sourceViewController];
    UIViewController *next = [self destinationViewController];
    
    [UIView
     transitionWithView:current.navigationController.view
     duration:0.8
     options:UIViewAnimationOptionTransitionCurlUp
     animations:^{
         [current.navigationController pushViewController:next animated:NO];
     } completion:NULL];
}

@end
