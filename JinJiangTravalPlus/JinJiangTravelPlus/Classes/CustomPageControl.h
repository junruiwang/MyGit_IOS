//
//  CustomPageControl.h
//  
//
//  Created by shaka on 12-2-9.
//  Copyright (c) 2012年 JinJiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomPageControl : UIPageControl
{
    UIImage* _activeImage;
    UIImage* _inactiveImage;
}

- (void)setCurrentPage:(NSInteger)page;
- (void)updateDots;

@end
