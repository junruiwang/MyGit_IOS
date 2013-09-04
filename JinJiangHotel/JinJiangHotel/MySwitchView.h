//
//  MySwitchView.h
//  JinJiangTravelPlus
//
//  Created by 吕 硕 on 13-1-4.
//  Copyright (c) 2013年 JinJiang. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SwithAnimateDuration 0.1f

@class MySwitchView;

@protocol MySwitchViewDelegate <NSObject>

- (void)switchViewDidEndSetting:(MySwitchView*)switchView;

@end

@interface MySwitchView : UIView

@property(nonatomic)BOOL on;
@property(nonatomic, weak)id<MySwitchViewDelegate> delegate;
@property(nonatomic, strong) NSString *backImageName;
@property(nonatomic, strong) NSString *secondImageName;
@property(nonatomic, strong) NSString *firstImageName;

- (void)switchOn:(id)sender;
- (void)switchOff:(id)sender;
- (void)transformToSearch;

@end
