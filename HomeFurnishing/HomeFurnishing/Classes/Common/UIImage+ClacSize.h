//
//  UIImage+ClacSize.h
//  HomeFurnishing
//
//  Created by jrwang on 15-1-21.
//  Copyright (c) 2015年 jerry.wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ClacSize)

// 根据颜色生成图片
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

+ (UIImage *)getImage:(NSString *)srcImageName;

-(CGSize)realSize;  //根据 iphone 手机返回实际的大小

// 重新设置图片大小
- (UIImage *) reSize: (CGSize) size;

//从大图按rect截取小图
-(UIImage*)getSubImage:(CGRect)rect;

@end
