//
//  JJNavigationBar.h
//  JinJiangHotel
//
//  Created by Rong Hao on 13-8-14.
//  Copyright (c) 2013年 jinjiang. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, JJNavigationBarStyle) {
    JJDefaultBarStyle,
    JJTwoLineTilteBarStyle,
    JJComplexBarStyle
};

@protocol JJNavigationBarDelegate <NSObject>

- (void)backButtonPressed;

@optional
- (void)rightButtonPressed;
- (void)otherButtonPressed;

@end

@interface JJNavigationBar : UIView

@property (nonatomic, weak) id<JJNavigationBarDelegate> delegate;
@property (nonatomic) JJNavigationBarStyle barStyle;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) UIButton *otherButton;
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UILabel *mainLabel;
@property (nonatomic, strong) UIView *subTitleView;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) UIImageView *subTitleImage;

- (id)initNavigationBarWithStyle:(JJNavigationBarStyle)barStyle;

- (void)addRightBarButton:(NSString *)imageName;

- (void)addOtherBarButton:(NSString *)imageName;

@end
