//
//  JJUnderlineButton.m
//  JinJiang
//
//  Created by Leon on 5/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "JJUnderlineButton.h"

@implementation JJUnderlineButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) drawRect:(CGRect)rect 
{
    CGRect textRect = self.titleLabel.frame;
    // need to put the line at top of descenders (negative value)
    CGFloat descender = self.titleLabel.font.descender + 2;
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    // set to same colour as text
    CGContextSetStrokeColorWithColor(contextRef, self.titleLabel.textColor.CGColor);
    CGContextMoveToPoint(contextRef, textRect.origin.x, textRect.origin.y + textRect.size.height + descender);
    CGContextAddLineToPoint(contextRef, textRect.origin.x + textRect.size.width, textRect.origin.y + textRect.size.height + descender);
    CGContextClosePath(contextRef);
    CGContextDrawPath(contextRef, kCGPathStroke);
}

@end
