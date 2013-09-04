//
//  JJStarView.m
//  JinJiangHotel
//
//  Created by Rong Hao on 13-8-21.
//  Copyright (c) 2013年 jinjiang. All rights reserved.
//

#import "JJStarView.h"

@interface JJStarView()

@property (nonatomic, strong) NSArray *starImageArray;

@end

@implementation JJStarView

- (id)initWithStar:(int)star
{
    if (star < 0 || star >5) {
        return nil;
    }
    
    if (self = [super initWithFrame:CGRectMake(0, 0, 70, 11)]) {
        self.starImageArray = [NSArray arrayWithObjects:
                               [self createImageViewByImage:@"star_img.png"],
                               [self createImageViewByImage:@"star_img.png"],
                               [self createImageViewByImage:@"star_img.png"],
                               [self createImageViewByImage:@"star_img.png"],
                               [self createImageViewByImage:@"star_img.png"],
                               nil];
        
        for (int i = 0; i < self.starImageArray.count; i++) {
            CGRect starFrame = CGRectMake(i * 13, 0, 12, 11);
            if (i < star) {
                UIImageView *starView = [self.starImageArray objectAtIndex:i];
                starView.frame = starFrame;
                [self addSubview:starView];
            } else {
                UIImageView *starView = [self createImageViewByImage:@"star_gray.png"];
                starView.frame = starFrame;
                [self addSubview:starView];
            }
        }
    }
    return self;
}

- (UIImageView *)createImageViewByImage:(NSString *)imageName
{
    return [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
}

@end
