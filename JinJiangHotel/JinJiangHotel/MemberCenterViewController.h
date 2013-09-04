//
//  MemberCenterViewController.h
//  JinJiangHotel
//
//  Created by 杨 栋栋 on 13-8-28.
//  Copyright (c) 2013年 jinjiang. All rights reserved.
//

#import "JJViewController.h"
#import "UserInfoParser.h"



@interface MemberCenterViewController : JJViewController

@property (nonatomic, weak) IBOutlet UIImageView *cardImageView;

@property (nonatomic, weak) IBOutlet UIView *integralBgView;

@property (nonatomic, weak) IBOutlet UIView *integralInnerBgView;

@property (nonatomic, weak) IBOutlet UIView *integralSplitView;

@property (nonatomic, weak) IBOutlet UIView *personalInfoBgView;

@property (nonatomic, weak) IBOutlet UIView *personalInfoInnerBgView;

@property (nonatomic, weak) IBOutlet UIView *personalInfoSplitView;

@property (nonatomic, weak) IBOutlet UILabel *memberIntegralLabel;

@property (nonatomic, weak) IBOutlet UILabel *memberIntegralExchangeLabel;

@property (nonatomic, weak) IBOutlet UILabel *showMemberRightLabel;

@property (nonatomic, weak) IBOutlet UILabel *personalInfoLabel;

@property (nonatomic, weak) IBOutlet UILabel *mySpecialneedLabel;

@property (nonatomic, weak) IBOutlet UILabel *memberIntegralValueLabel;

@property (nonatomic, weak) IBOutlet UILabel *memberNameLabel;

@property (nonatomic, weak) IBOutlet UILabel *cardNoLabel;

@property (nonatomic, weak) IBOutlet UIView *buyCardTabBgView;


@end
