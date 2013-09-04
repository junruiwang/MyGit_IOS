//
//  AccountInfoViewController.h
//  JinJiangTravelPlus
//
//  Created by jerry on 12-12-17.
//  Copyright (c) 2012年 JinJiang. All rights reserved.
//

#import "JJViewController.h"
#import "CouponListParser.h"
#import "ConditionView.h"
#import "IdentityTypeViewController.h"
#import "BasicInfoManageViewController.h"
#import "PasswordManageViewController.h"

@interface AccountInfoViewController : JJViewController<UIActionSheetDelegate, IdentityTypeViewControllerDelegate, BasicInfoManageViewControllerDelegate, PasswordManageViewControllerDelegate, UIAccelerometerDelegate>

@property (nonatomic, strong) NSMutableArray* couponArray;
@property (nonatomic, strong) NSMutableArray* faverateCityList;
@property (nonatomic, strong) NSMutableArray* faverateHotelList;
@property (nonatomic, strong) UITableView*  faverateTableView;
@property (nonatomic) BOOL isNeedRefresh;

@property (nonatomic, weak) IBOutlet UIButton* personalInfoBtn;
@property (nonatomic, weak) IBOutlet UIButton* couponBtn;
@property (nonatomic, weak) IBOutlet UIButton* memberInfoBtn;

@property (nonatomic, weak) IBOutlet UIView* memberInfoView;
@property (weak, nonatomic) IBOutlet UIView *couponInfoView;
@property (weak, nonatomic) IBOutlet UIView *personalInfoView;
@property (weak, nonatomic) IBOutlet UIImageView *infoBackGroundImageView;
@property (weak, nonatomic) IBOutlet UILabel *pointsLabel;

@property (nonatomic, weak) IBOutlet UILabel* fullNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *mailLabel;
@property (weak, nonatomic) IBOutlet UILabel *mobileNumberLabel;
@property (nonatomic, weak) IBOutlet UILabel* cardNoLabel;
@property (nonatomic, weak) IBOutlet UILabel* userPointLabel;

@property (nonatomic, weak) IBOutlet UIButton* phoneButton;

@property (weak, nonatomic) IBOutlet UIImageView *memberCard;
@property (weak, nonatomic) IBOutlet UIImageView *cardShinningEffectRight;
@property (weak, nonatomic) IBOutlet UIView *viewMask;
@property (weak, nonatomic) IBOutlet UIImageView *realCardHighlightEffect;

@property (weak, nonatomic) IBOutlet UILabel *memberTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *upgradeTimesLabel;
@property (weak, nonatomic) IBOutlet UILabel *upgradePointsLabel;

@property (weak, nonatomic) IBOutlet UIImageView *liCardIcon;
@property (weak, nonatomic) IBOutlet UIButton *activeButton;
@property (weak, nonatomic) IBOutlet UIImageView *activeButtonArrayIcon;

@property (nonatomic, weak) IBOutlet UIButton *scoreExchangeButton;
@property (nonatomic,weak) IBOutlet UIButton *renewCardBtn;
@property (nonatomic,weak) IBOutlet UIView *contentView;

- (IBAction)orderTapped:(UIButton *) button;

@end
