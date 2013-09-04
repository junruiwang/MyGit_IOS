//
//  JJBackwardSegue.m
//  JinJiangTravelPlus
//
//  Created by Raphael.rong on 13-4-26.
//  Copyright (c) 2013年 JinJiang. All rights reserved.
//

#import "JJBackwardSegue.h"
#import <QuartzCore/QuartzCore.h>

@implementation JJBackwardSegue

- (void)perform
{
    CATransition* transition = [CATransition animation];
    transition.duration = 0.4;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    
    [[self.sourceViewController navigationController].view.layer addAnimation:transition forKey:nil];
    [[self.sourceViewController navigationController] pushViewController:self.destinationViewController animated:NO];
}
@end
