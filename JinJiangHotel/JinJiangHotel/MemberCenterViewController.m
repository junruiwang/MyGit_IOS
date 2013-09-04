//
//  MemberCenterViewController.m
//  JinJiangHotel
//
//  Created by 杨 栋栋 on 13-8-28.
//  Copyright (c) 2013年 jinjiang. All rights reserved.
//

#define kLogoutAlertMessage NSLocalizedString(@"您确定要注销吗？", nil)
#define kLogoutAlertMessageTag 55

#import "MemberCenterViewController.h"
#import "ParameterManager.h"
#import <QuartzCore/QuartzCore.h>

@interface MemberCenterViewController ()

@end

@implementation MemberCenterViewController

- (void)viewDidLoad
{
   [super viewDidLoad];

    NSString *userCardType = TheAppDelegate.userInfo.cardType;

    if ([userCardType isEqualToString:JJCARD] || [userCardType isEqualToString:@""] || userCardType == nil) {
        self.buyCardTabBgView.hidden = NO;
    } else {
        self.buyCardTabBgView.hidden = YES;
    }

    NSString *cardImageName =
    [userCardType isEqualToString:JBENEFITCARD] ? @"membercard_xiang.png" :
    [userCardType isEqualToString:J2BENEFITCARD] ? @"membercard_yuexiang.png" :
    [userCardType isEqualToString:J8BENEFITCARD] ? @"membercard_wuxianxiang.png" :
    [userCardType isEqualToString:(JJCARD)] ? @"membercard_li.png" : nil;

    self.cardImageView.image = [UIImage imageNamed:cardImageName];

    self.integralBgView.layer.cornerRadius = 4;

    self.integralBgView.layer.masksToBounds = YES;

    self.integralInnerBgView.layer.cornerRadius = 3;

    self.integralInnerBgView.layer.masksToBounds = YES;
    
    self.integralBgView.backgroundColor = RGBCOLOR(240.0, 210.0, 150.0);
    
    self.integralSplitView.backgroundColor = RGBCOLOR(240.0, 210.0, 150.0);
    
    self.personalInfoBgView.layer.cornerRadius = 4;
    
    self.personalInfoBgView.layer.masksToBounds = YES;
    
    self.personalInfoInnerBgView.layer.cornerRadius = 3;
    
    self.personalInfoInnerBgView.layer.masksToBounds = YES;
    
    self.personalInfoBgView.backgroundColor = RGBCOLOR(240.0, 210.0, 150.0);
    
    self.personalInfoSplitView.backgroundColor = RGBCOLOR(240.0, 210.0, 150.0);
    
    self.memberIntegralLabel.textColor = RGBCOLOR(160.0, 140.0, 25.0);
    
    self.showMemberRightLabel.textColor = RGBCOLOR(160.0, 140.0, 25.0);

    self.personalInfoLabel.textColor = RGBCOLOR(160.0, 140.0, 25.0);

    self.mySpecialneedLabel.textColor = RGBCOLOR(160.0, 140.0, 25.0);

    self.memberIntegralValueLabel.textColor = RGBCOLOR(160.0, 140.0, 25.0);

    self.memberIntegralExchangeLabel.textColor = RGBCOLOR(235.0, 97.0, 0.0);
    
    self.memberIntegralValueLabel.text = TheAppDelegate.userInfo.point;
    
    self.memberNameLabel.text = TheAppDelegate.userInfo.fullName;
    
    self.cardNoLabel.text = TheAppDelegate.userInfo.cardNo;

    NSString *cardNo = TheAppDelegate.userInfo.cardNo;

    self.cardNoLabel.text = [NSString stringWithFormat:@"%@ %@ %@", [cardNo substringToIndex:4], [cardNo substringWithRange:NSMakeRange(4, 4)], [cardNo substringFromIndex:8]];
    
    self.navigationBar.mainLabel.text = NSLocalizedStringFromTable(@"member_center", @"MemberCenter", @"");
    
    UIButton *loginOutBut = [UIButton buttonWithType:UIButtonTypeCustom];
    
    loginOutBut.frame = CGRectMake(240, 12, 60, 24);
    
    [loginOutBut setTitle:NSLocalizedStringFromTable(@"login_out", @"MemberCenter", @"") forState:UIControlStateNormal];
    
    loginOutBut.titleLabel.textColor = [UIColor whiteColor];
    loginOutBut.titleLabel.font = [UIFont boldSystemFontOfSize: 12.0f];
    loginOutBut.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"submit.png"]];
    
    [loginOutBut addTarget:self action:@selector(logout:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.navigationBar addSubview:loginOutBut];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void) logout:(id) sender
{
    [self showAlertMessageWithOkCancelButton:kLogoutAlertMessage tag:kLogoutAlertMessageTag
                                 cancelTitle:NSLocalizedString(@"点错了", nil)
                                     okTitle:NSLocalizedString(@"确认注销", nil)  delegate:self];
}

- (void)showAlertMessageWithOkCancelButton:(NSString *)msg tag:(NSInteger)tag
                               cancelTitle:(NSString *) cancelTitle
                                   okTitle:(NSString *) okTitle delegate:(id)delegate
{
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:NSLocalizedString(@"信息提示", nil)
                              message:msg delegate:delegate
                              cancelButtonTitle:cancelTitle
                              otherButtonTitles:okTitle, nil];
    [alertView setTag:tag]; [alertView show];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == kLogoutAlertMessageTag && buttonIndex == 1)
    {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kRestoreAutoLogin];
        [[NSUserDefaults standardUserDefaults] synchronize];
        TheAppDelegate.userInfo = nil;
        TheAppDelegate.userInfo = [[UserInfo alloc] init];
        [self backHome:nil];
    }
}
@end
