//
//  SearchLeftScrollView.m
//  jinjiang
//
//  Created by Jeff.Yan on 11-11-17.
//  Copyright 2011年 W+K. All rights reserved.
//

#import "SearchLeftScrollView.h"
#import "GlobalFunction.h"

@implementation SearchLeftScrollView
- (id)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    if (self) {
        RemoveRelease(bgView);
        self.backgroundColor=[UIColor clearColor];
        [GlobalFunction addImage:self name:@"5_seach_bg.png" rect:CGRectMake(0, 0, 357, 768-TOPHEIGHT) atIndex:0];
    }
    return self;
}

@end
