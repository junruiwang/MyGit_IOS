//
//  UIImageView+Categories.m
//  JinJiangTravalPlus
//
//  Created by Leon on 10/29/12.
//  Copyright (c) 2012 Leon. All rights reserved.
//

#import "UIImageView+Categories.h"

@implementation UIImageView (Categories)

+ (UIImageView *)badgeImageView:(NSInteger)value
{    
    UIImage *badgeValueImage = [UIImage imageNamed:@"badgeValueBlue.png"];

    CGRect resizeRect;
    resizeRect.size = badgeValueImage.size;
    resizeRect.origin = (CGPoint){0.0f, 0.0f};
    CGSize newSize = resizeRect.size;
    if ([UIScreen instancesRespondToSelector:@selector(scale)] && [[UIScreen mainScreen] scale] == 2.0f)
    {   UIGraphicsBeginImageContextWithOptions(newSize, NO, 2.0f);  }
    else
    {   UIGraphicsBeginImageContext(newSize);   }

    // draw text on image and get the new image as price label
    [badgeValueImage drawInRect:resizeRect];
    CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(), [UIColor whiteColor].CGColor);

    CGRect textRect = resizeRect;
    float offsetX, offsetY;
    NSInteger fontSize;
    if (value < 10)
    {
        offsetX = 6.0f;
        offsetY = 1.0f;
        fontSize = 13;
    }
    else
    {
        offsetX = 3.0f;
        offsetY = 2.0f;
        fontSize = 12;
    }

    textRect.origin = (CGPoint){offsetX, offsetY};
    CGContextSetTextDrawingMode(UIGraphicsGetCurrentContext(), kCGTextFill);
    [[NSString stringWithFormat:@"%d", value] drawInRect:textRect withFont:[UIFont boldSystemFontOfSize:fontSize]];
    UIImage* resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    UIImageView *badgeValueImageView = [[UIImageView alloc ]initWithImage:resizedImage];

    return badgeValueImageView;
}

@end
