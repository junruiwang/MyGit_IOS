//
//  CustomPageControl.m
//  
//
//  Created by shaka on 12-2-9.
//  Copyright (c) 2012年 JinJiang. All rights reserved.
//

#import "CustomPageControl.h"

@implementation CustomPageControl

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _activeImage = [UIImage imageNamed:@"dot_black.png"];
        _inactiveImage = [UIImage imageNamed:@"dot_gray.png"];
    }
    return self;
}

- (void)setCurrentPage:(NSInteger)page
{
    [super setCurrentPage:page];
    [self updateDots];
}

- (void)updateDots
{
    for (unsigned int i = 0; i < [self.subviews count]; i++)
    {
        UIImageView* dot = [self.subviews objectAtIndex:i];
        if (i == self.currentPage)
        {   dot.image = _activeImage;   }
        else
        {   dot.image = _inactiveImage; }
    }
}

@end
