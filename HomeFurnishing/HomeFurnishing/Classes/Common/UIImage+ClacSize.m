//
//  UIImage+ClacSize.m
//  HomeFurnishing
//
//  Created by jrwang on 15-1-21.
//  Copyright (c) 2015年 jerry.wang. All rights reserved.
//

#import "UIImage+ClacSize.h"

@implementation UIImage (ClacSize)

-(CGSize)realSize{
    return CGSizeMake(self.size.width / 2, self.size.height / 2);
}

// 重新设置图片大小
- (UIImage *) reSize: (CGSize) size {
    UIGraphicsBeginImageContext(size);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return reSizeImage;
}

// 根据颜色生成图片
+ (UIImage *) imageWithColor:(UIColor *)color size:(CGSize)size
{
    UIImage *img = [[UIImage alloc] init];
    return [img maskImage:color size:size];
}

+ (UIImage *)getImage:(NSString *)srcImageName
{
    UIImage *image = [UIImage imageNamed:srcImageName];
    if (!image)
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *imagePath = [documentsDirectory stringByAppendingPathComponent:srcImageName];
        image = [UIImage imageWithContentsOfFile:imagePath];
    }
    
    return image;
}

-(UIImage*)getSubImage:(CGRect)rect
{
    CGImageRef subImageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
    UIGraphicsBeginImageContext(smallBounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, smallBounds, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    CFRelease(subImageRef);
    UIGraphicsEndImageContext();
    return smallImage;
}
- (UIImage *)maskImage:(UIColor *)maskColor size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextClipToMask(context, rect, self.CGImage);
    CGContextSetFillColorWithColor(context, maskColor.CGColor);
    CGContextFillRect(context, rect);
    
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return smallImage;
}

@end
