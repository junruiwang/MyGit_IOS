//
//  HotelBookInputViewController.h
//  JinJiangTravelPlus
//
//  Created by 胡 桂祁 on 12/5/12.
//  Copyright (c) 2012 JinJiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@class HotelBookForm;
@class CreateOrderParser;
@class OrderPriceConfirmParser;
@class HotelPriceConfirmForm;
@class UseCoupon;

#import "MemberParser.h"
#import "ConditionView.h"
#import "PayTypeListViewController.h"
#import "UsableCouponListViewController.h"
#import "DayPriceDetailViewController.h"
#import "LoginForGuestOrderViewController.h"
#import "SpecialNeedListViewController.h"

@interface HotelBookInputViewController : JJViewController <PayTypeListDelegate, GDataXMLParserDelegate, SelectUsableCouponDelegate, DayPriceDetailViewControllerDelegate, LoginForGuestOrderViewControllerDelegate, SpecialNeedListViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UIControl *view;
@property (nonatomic, weak) IBOutlet UILabel *hotelNameLabel;
@property (nonatomic, weak) IBOutlet UIButton *bookBtn;
@property (nonatomic, weak) IBOutlet UIControl *bookingBodyView;
@property (nonatomic, weak) IBOutlet UILabel *roomNameLabel;
@property (nonatomic, weak) IBOutlet UIButton *roomCountMinusButton;
@property (nonatomic, weak) IBOutlet UIButton *realRoomCountMinusButton;
@property (weak, nonatomic) IBOutlet UILabel *originalPrice;

@property (nonatomic, weak) IBOutlet UILabel *roomCountLabel;
@property (nonatomic, weak) IBOutlet UIButton *roomCountPlusButton;
@property (nonatomic, weak) IBOutlet UIButton *realRoomCountPlusButton;
@property (nonatomic, weak) IBOutlet UILabel *checkInDateLabel;
@property (nonatomic, weak) IBOutlet UILabel *checkOutDateLabel;
@property (nonatomic, weak) IBOutlet UITextField *contactPersonField;
@property (weak, nonatomic) IBOutlet UILabel *totalAmountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *topBackImage;

@property (weak, nonatomic) IBOutlet UIView *descriptionSeperateLine;
@property (nonatomic, weak) IBOutlet UITextField *contactPersonMobileField;

@property (nonatomic, weak) IBOutlet UILabel *payTypeNameLable;
@property (nonatomic, weak) IBOutlet UILabel *payTypeDescLable;
@property (nonatomic, weak) IBOutlet UIButton *selectPayTypeLButton;
@property (nonatomic, weak) IBOutlet UIButton *sepecialButton;

@property (weak, nonatomic) IBOutlet UILabel *checkPersonLabelTop;
@property (weak, nonatomic) IBOutlet UILabel *checkPersonLabelMiddle;
@property (weak, nonatomic) IBOutlet UILabel *checkPersonLabelBottom;
@property (weak, nonatomic) IBOutlet UITextField *checkPersonFieldTop;
@property (weak, nonatomic) IBOutlet UITextField *checkPersonFieldMiddle;
@property (weak, nonatomic) IBOutlet UITextField *checkPersonFieldBottom;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *viewForTwo;
@property (weak, nonatomic) IBOutlet UIControl *controlForPay;
@property (weak, nonatomic) IBOutlet UILabel *bookingDescriptionLabel;

@property (nonatomic, strong) HotelBookForm *hotelBookForm;
@property (nonatomic, strong) HotelPriceConfirmForm *orderPriceConfirmForm;
@property (nonatomic, strong) HotelPriceConfirmForm *rcardPriceConfirmForm;

@property (nonatomic, strong) CreateOrderParser *createOrderParser;
@property (nonatomic, strong) OrderPriceConfirmParser *orderPriceConfirmParser;

@property (nonatomic, strong) NSArray *couponRuleList;
@property (nonatomic, strong) UseCoupon *useCoupon;

@property (nonatomic, strong) MemberParser *memberParser;

@property (nonatomic, weak) UIButton *couponBtn;

@property (nonatomic, weak) IBOutlet UIView *totalPriceContainerView;

@property (nonatomic, strong) UIView *dayPriceDetailContainerView;

@property (nonatomic, strong) UIView *loginForGuestOrderContainerView;

@property (nonatomic, strong) DayPriceDetailViewController *dayPriceDetailViewController;

@property (nonatomic, strong) LoginForGuestOrderViewController *loginForGuestOrderViewController;

@property (nonatomic, weak) IBOutlet UIView *totalPriceLabelLine;

@property (nonatomic, weak) IBOutlet UILabel *cancelPolicyLabel;
@property (weak, nonatomic) IBOutlet UILabel *cancelPolicyDescLabel;

- (IBAction)bookHotel;

- (IBAction)backgroupTap:(id)sender;

- (IBAction)showPayTypeList:(id)sender;

- (IBAction)showSpecialNeedList:(id)sender;

- (IBAction)increaseRoomCount:(id)sender;

- (IBAction)decreaseRoomCount:(id)sender;

- (IBAction) checkIsExistMember : (id)sender;

@end
