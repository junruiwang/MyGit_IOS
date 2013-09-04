//
//  LoginSwitchView.h
//  JinJiangHotel
//
//  Created by jerry on 13-8-19.
//  Copyright (c) 2013年 jinjiang. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SwithAnimateDuration 0.1f

@class LoginSwitchView;

@protocol LoginSwitchViewDelegate <NSObject>

- (void)switchViewDidEndSetting:(LoginSwitchView *)switchView;

@end

@interface LoginSwitchView : UIView

@property(nonatomic)BOOL on;
@property(nonatomic, weak)id<LoginSwitchViewDelegate> delegate;

- (void)transformToLogin;

@end
