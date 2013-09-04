//
//  JJSlashLine.m
//  JinJiangTravelPlus
//
//  Created by Rong Hao on 13-6-5.
//  Copyright (c) 2013年 JinJiang. All rights reserved.
//

#import "JJSlashLine.h"

@implementation JJSlashLine
//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//    
//    
//    UIImageView *slash = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 50, 30)];
//    lineOne.backgroundColor = [UIColor colorWithPatternImage:[[UIImage imageNamed:@"dashed.png"]
//                                                              stretchableImageWithLeftCapWidth:20 topCapHeight:0]];
//    [self addSubview:lineOne];
//    
//    
//}
//
- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setNeedsDisplay];
    }
    return self;
}

- (void) drawRect:(CGRect)rect
{
    self.backgroundColor = [UIColor clearColor];
    CGRect slashRect = self.frame;
    // need to put the line at top of descenders (negative value)
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(contextRef, 2);
    CGContextSetStrokeColorWithColor(contextRef, [UIColor grayColor].CGColor);
    CGContextMoveToPoint(contextRef, 0, slashRect.size.height);
    CGContextAddLineToPoint(contextRef, slashRect.size.width, 0);
    CGContextClosePath(contextRef);
    CGContextDrawPath(contextRef, kCGPathStroke);
}
@end
