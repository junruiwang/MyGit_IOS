//
//  JJStarView.h
//  JinJiangTravelPlus
//
//  Created by Leon on 11/12/12.
//  Copyright (c) 2012 JinJiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JJStarView : UIView

@property (nonatomic, assign) int star;

@end

@interface JJStarViewStrong : UIView

@property (nonatomic, strong) UIImageView *starImageView1;
@property (nonatomic, strong) UIImageView *starImageView2;
@property (nonatomic, strong) UIImageView *starImageView3;
@property (nonatomic, strong) UIImageView *starImageView4;
@property (nonatomic, strong) UIImageView *starImageView5;

- (void)setStar:(int)starz;

@end
