//
//  AccountInfoViewController.m
//  JinJiangTravelPlus
//
//  Created by jerry on 12-12-17.
//  Copyright (c) 2012年 JinJiang. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "AccountInfoViewController.h"
#import "HotelDetailsViewController.h"
#import "ParameterManager.h"
#import "JJCoupon.h"
#import "JJCouponAmount.h"
#import "CouponListViewController.h"
#import "BillListController.h"
#import "IdentityTypeViewController.h"
#import "SVProgressHUD.h"
#import "CompleteRegistParser.h"
#import "ValidateInputUtil.h"
#import "UserInfoParser.h"
#import "FaverateCell.h"
#import "JJHotel.h"
#import "FaverateHotelManager.h"
#import "UIImage+MemberCard.h"
#import "AccelerometerFilter.h"
#import "CardPassbookViewController.h"

#define kLogoutAlertMessage NSLocalizedString(@"您确定要注销吗？", nil)
#define kLogoutAlertMessageTag 55
#define kUpdatePhoneAndEmailAlertMessage NSLocalizedString(@"亲，该功能暂时只对礼会员开放，是否立即升级为礼会员？", nil)
#define kUpdatePhoneAndEmailAlertMessageTag 66
#define IDENTITY_TYPE_TAG 99
#define IDENTITY_CARD_TAG 88

#define NORMARL_X 13;
#define GOLDEN_X 96;
#define PLATINUM_X 216;

const unsigned int faverateTableViewTag = 271;


@interface AccountInfoViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *backgroundMiddleImage;

@property (weak, nonatomic) IBOutlet UIImageView *backgroundHeadImg;
@property (nonatomic, strong) NSMutableDictionary* couponDict;
@property (nonatomic, strong) NSMutableArray* couponAmountList;
@property (nonatomic, strong) UIControl* leftView;
@property (nonatomic, strong) UIView* modeView;
@property (nonatomic, strong) UIControl* registInfoView;
@property (nonatomic, strong) UITextField* nameField;
@property (nonatomic, strong) UITextField* idTypeField;
@property (nonatomic, strong) UITextField* idCardField;
@property (nonatomic, strong) UILabel* tipLabel;
@property (nonatomic, strong) UIImageView *dashView;
@property (nonatomic, strong) CouponListParser* couponListParser;
@property (nonatomic, strong) CompleteRegistParser* completeRegistParser;
@property (nonatomic, strong) UserInfoParser* userInfoParser;
@property (nonatomic, strong) IdentityType* currentIdentityType;
@property (nonatomic, strong) ConditionView* conditionView;
@property (nonatomic, strong) CouponListViewController* couponListViewController;
@property (nonatomic, strong) IdentityTypeViewController* identityTypeViewController;
@property (nonatomic, strong) FaverateHotelManager *faverateHotelManager;
@property(nonatomic,strong) CardPassbookViewController *showPassbookController;

//会员卡动画效果卡关，关闭为NO，开启为YES。默认关闭。零时会员关闭。
@property (nonatomic) BOOL cardAnimationSwitch;
//当前会员卡种实卡图名称
@property (nonatomic, strong) NSString *cardImageName;
//小卡闪耀效果计时器
@property (nonatomic, strong) NSTimer *shinningTimer;
//会员卡状态，实卡为YES，小卡为NO
@property (nonatomic) BOOL isRealCard;
//会员卡状态，正面为NO，反面为YES
@property (nonatomic) BOOL isFlipped;
//会员卡实卡正面图
@property (nonatomic, strong) UIImage *realCardImage;
//会员卡实卡反面图
@property (nonatomic, strong) UIImage *realCardFlippedImage;
//会员卡缩略图
@property (nonatomic, strong) UIImage *smallCardImage;
//会员信息
@property (nonatomic, strong) UserInfo *userInfo;
//展现卡背面信息按钮
@property (nonatomic, strong) UIButton *flipButton;
//会员卡背面权益信息
@property (nonatomic, strong) NSDictionary *memberRightsDictionary;


//陀螺仪偏差过滤
@property (nonatomic, strong) AccelerometerFilter *accerlerometerFilter;
@property (weak, nonatomic) IBOutlet UIView *rightShinningMask;
@property (weak, nonatomic) IBOutlet UIView *rightSideShinningMask;

@property (nonatomic,strong) UIButton *passbookBtn;


@end

@implementation AccountInfoViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        _couponArray = [[NSMutableArray alloc] init];
        _couponDict = [[NSMutableDictionary alloc] initWithCapacity:5];
        _couponAmountList = [[NSMutableArray alloc] initWithCapacity:5];
        _currentIdentityType = [[IdentityType alloc] initWithName:@"ID" cnName:@"身份证"];
        _faverateHotelList = [[NSMutableArray alloc] initWithCapacity:10];
        _faverateCityList  = [[NSMutableArray alloc] initWithCapacity:10];
        _faverateHotelManager = [[FaverateHotelManager alloc] init];
    }
    return self;
}

- (ConditionView *)conditionView
{
    if (!_conditionView)
    {
        CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
        _conditionView = [[ConditionView alloc] initWithFrame:CGRectMake(320, 20, 285.0, screenRect.size.height + 20)];
        [self.navigationController.view.window addSubview:_conditionView];
        UISwipeGestureRecognizer *tapGR = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap)];
        [tapGR setDirection:UISwipeGestureRecognizerDirectionRight];
        [_conditionView addGestureRecognizer:tapGR];
    }
    return _conditionView;
}

- (CouponListViewController *)couponListViewController
{
    if (!_couponListViewController)
    {
        _couponListViewController = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil]
                                     instantiateViewControllerWithIdentifier:@"CouponListViewController"];
    }
    return _couponListViewController;
}

- (UIControl *)leftView
{
    if (!_leftView)
    {
        CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
        _leftView = [[UIControl alloc] initWithFrame:CGRectMake(0, 20.0, 50.0, screenRect.size.height + 20)];
        [_leftView addTarget:self action:@selector(handleTap) forControlEvents:UIControlEventTouchUpInside];
        [_leftView setBackgroundColor:[UIColor clearColor]];
        [_leftView setHidden:YES];
        [self.navigationController.view.window addSubview:_leftView];
    }
    return _leftView;
}

- (IdentityTypeViewController *)identityTypeViewController
{
    if (!_identityTypeViewController) {
        _identityTypeViewController = [[IdentityTypeViewController alloc] init];
        _identityTypeViewController.delegate = self;
    }   
    
    return _identityTypeViewController;
}

- (void)handleTap
{
    CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        [self.conditionView setFrame:CGRectMake(320.0, 20.0, 285.0, screenRect.size.height + 20)];
    }   completion:^(BOOL finished) {
        [self.leftView setHidden:YES];
        [self.view setUserInteractionEnabled:YES];
        [self.navigationController.navigationBar setUserInteractionEnabled:YES];
    }];
}

- (void)showViewInSidebar:(UIView *)view title:(NSString *)title
{
    [self.conditionView addContentView:view];
    [self.conditionView setTitle:title];
    
    self.view.userInteractionEnabled = NO;
    self.navigationController.navigationBar.userInteractionEnabled = NO;
    
    CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        [self.conditionView setFrame:CGRectMake(35, 20.0, 285.0, screenRect.size.height + 20)];
    }   completion:^(BOOL finished) {
        [self.leftView setHidden:NO];
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"会员中心"];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:USER_DEVICE_5]) {
        self.backgroundMiddleImage.hidden = NO;
    }
    
    if (![self canRenewCard]) {
        [self hiddenRenewCardBtn];
    }
    //add right logout button
    UIButton* targetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [targetBtn setBackgroundImage:[UIImage imageNamed:@"hotel-topbar-btn.png"] forState:UIControlStateNormal];
    [targetBtn setBackgroundImage:[UIImage imageNamed:@"hotel-topbar-btn_press.png"] forState:UIControlStateHighlighted];
    [targetBtn addTarget:self action:@selector(logout:) forControlEvents:UIControlEventTouchUpInside];
    targetBtn.frame = CGRectMake(0, 0, 42, 29);
    UILabel *subLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 42, 29)];
    subLabel.backgroundColor = [UIColor clearColor];
    subLabel.text = @"注销";
    subLabel.textColor = [UIColor whiteColor];
    subLabel.textAlignment = NSTextAlignmentCenter;
    subLabel.font = [UIFont boldSystemFontOfSize:14];
    [targetBtn addSubview:subLabel];
    
    UIBarButtonItem *fullBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:targetBtn];
    self.navigationItem.rightBarButtonItem = fullBarButtonItem;
    

    //load main views
    [self loadMainViews];
    //load phone view
    [self loadPhoneButton];
    //show complete regist
    [self addRegulaModeView];
    
    if([CardPassbookViewController canUsePassbook] && ![self isTempMember]){
        dispatch_queue_t generatePassQueue = dispatch_queue_create("cardPassQueue", NULL);
        dispatch_async(generatePassQueue, ^{
            [self initGeneratePassbook];
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([_showPassbookController readPassUrlFromLocal] || [_showPassbookController readPassFromLocal]) {
                    [self initPassbookBtn];
                }
            });
        });
        dispatch_release(generatePassQueue);
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    self.trackedViewName = @"会员中心基本信息页面";
    [super viewWillAppear:animated];
    
    if (self.isNeedRefresh) {
        [self getUserinfoAction:@"true"];
        self.isNeedRefresh = NO;
    }
}


- (void)loadMainViews
{
    //add user point
    if ( TheAppDelegate.userInfo.point == nil ||
        [TheAppDelegate.userInfo.point isEqualToString:@""] ||
        [TheAppDelegate.userInfo.point isEqualToString:@"0"] )
    {
        self.userPointLabel.text = @"暂无积分";
    }
    else
    {
        NSString* point = [NSString stringWithFormat:@"%@分",TheAppDelegate.userInfo.point];
        [self.userPointLabel setText:point];
    }
    //load coupon list
    [self downloadData];
    //set animation
//    [self monInAnimation];
    //set member card
    
    [self loadMemberInfo];
    
    
}

- (void)loadMemberInfo
{
    //set member card
    [self setMemberCard];
    [self setMemberInfoInInfoView];
    [self addBaseInfoTabContent];
    
}

- (void)dealloc
{
    [self.conditionView removeFromSuperview];
    [self.leftView removeFromSuperview];
}

- (void) backHome: (id) sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)downloadData
{    
    if (!self.couponListParser)
    {
        NSString* component = [NSString stringWithFormat:@"%@", TheAppDelegate.userInfo.uid];
        NSString* address = [kCouponListURL stringByAppendingPathComponent:component];
        self.couponListParser = [[CouponListParser alloc] init];
        self.couponListParser.serverAddress = address;
    }
    [self.couponListParser setDelegate:self];
    [self.couponListParser start];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) logout:(id) sender
{
    [self showAlertMessageWithOkCancelButton:kLogoutAlertMessage tag:kLogoutAlertMessageTag
                                 cancelTitle:NSLocalizedString(@"点错了", nil)
                                     okTitle:NSLocalizedString(@"确认注销", nil)  delegate:self];
}


- (void)resignAllTextFiled
{
    [self.nameField resignFirstResponder];
    [self.idTypeField resignFirstResponder];
    [self.idCardField resignFirstResponder];
}



- (IBAction)personalInfoPressed:(id)sender {
}

#pragma mark - Member Card Start
- (void)setMemberCard
{
    self.cardAnimationSwitch = NO;
    self.userInfo = TheAppDelegate.userInfo;
    NSString *userCardType = _userInfo.cardType;
    CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
    
    self.memberRightsDictionary = [[NSUserDefaults standardUserDefaults] objectForKey:@"memberCardRight"];
    
    //判断是否是临时会员
    if ([TheAppDelegate.userInfo.isTempMember caseInsensitiveCompare:@"true"] == NSOrderedSame)
    {
        self.scoreExchangeButton.hidden = YES;
        TheAppDelegate.userInfo.cardLevel = 0;
        [self.memberCard setImage:[UIImage imageNamed:@"button_buycard.png"]];
        //隐藏闪耀效果
        self.cardShinningEffectRight.hidden = YES;
    }
    else {
        self.scoreExchangeButton.hidden = NO;
        //加载陀螺仪
        if (!self.accerlerometerFilter) {
            self.accerlerometerFilter = [[AccelerometerFilter alloc] initWithCutoffFrequency:5.0];
        }
        [[UIAccelerometer sharedAccelerometer] setUpdateInterval:1.0 / kAccelerometerInterval];
        [[UIAccelerometer sharedAccelerometer] setDelegate:self];
        
        
        
        if ([userCardType isEqualToString:(JJCARD)]) //classic
        {
            self.smallCardImage = [UIImage imageNamed:@"button_buycard.png"];
        }else if ([self checkIsBenifitMember])
        {
            self.smallCardImage = [UIImage imageNamed:@"card-xiang.png"];
        }
//        userCardType = J8BENEFITCARD;
        
        //添加信息按钮
        self.flipButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.flipButton.frame = CGRectMake(30, screenRect.size.height * 0.5 + 175, 35, 35);
        self.flipButton.alpha = 0.0;
        [self.flipButton addTarget:self action:@selector(flipButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.flipButton];
        [self.view bringSubviewToFront:self.flipButton];
        
        //打开卡片效果
        self.cardAnimationSwitch = YES;
        
        //设置小卡缩略图
        [self.memberCard setImage:self.smallCardImage];
        
        //确定会员卡大卡样式
        NSString *cardImageName =
        [userCardType isEqualToString:JBENEFITCARD] ? @"real-card-xiang.png" :
        [userCardType isEqualToString:J2BENEFITCARD] ? @"real-card-xiang-yue.png" :
        [userCardType isEqualToString:J8BENEFITCARD] ? @"real-card-xiang-infinity.png" :
        [userCardType isEqualToString:(JJCARD)] ? @"real-card-li-classic.png" : nil;
        
        
        NSString *cardBackImageName =
        [userCardType isEqualToString:JBENEFITCARD] ? @"real-card-xiang-back.png" :
        [userCardType isEqualToString:J2BENEFITCARD] ? @"real-card-xiang-yue-back.png" :
        [userCardType isEqualToString:J8BENEFITCARD] ? @"real-card-xiang-infinity-back.png" :
        [userCardType isEqualToString:(JJCARD)] ? @"real-card-li-classic-back.png" : nil;
        
        //组合卡片文字与卡片图片
        UIImage *originalImage = [UIImage imageNamed:cardImageName];
        UIImage *originalBackImage = [UIImage imageNamed:cardBackImageName];
        self.isFlipped = NO;
        self.realCardImage = [originalImage drawCardNum:self.userInfo.cardNo memberName:self.userInfo.fullName valiDate:self.userInfo.dueDate withType:userCardType];
        self.realCardFlippedImage = [originalBackImage drawMemberRight:_memberRightsDictionary withType:userCardType];
        
        //展现小卡闪耀效果
        if (_cardAnimationSwitch) {
            [self shinningTimerTick:nil];
            self.shinningTimer = [NSTimer scheduledTimerWithTimeInterval:4.5
                                                                  target:self
                                                                selector:@selector(shinningTimerTick:)
                                                                userInfo:nil
                                                                 repeats:YES];
        }

    }
}

- (void)flipButtonPressed:(id)sender
{
    //获取当前屏幕中心位置
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGPoint center = CGPointMake(screenRect.size.width * 0.5, screenRect.size.height * 0.5);
    center.y -= 10;
    
    //翻转
    [UIView animateWithDuration:0.35
                          delay:0.0
                        options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         self.memberCard .frame = CGRectMake(0, center.y, 320, 10);
                         
                     } completion:^(BOOL finished){
                         [self.memberCard setImage: _isFlipped ? self.realCardImage : self.realCardFlippedImage];
                         [UIView animateWithDuration:0.35
                                               delay:0.0
                                             options:UIViewAnimationOptionTransitionNone
                                          animations:^{
                                              self.memberCard.frame = CGRectMake(0, 0, 320, 460);
                                              self.memberCard.center = center;
                                          } completion:^(BOOL finished){
                                              self.isFlipped = !_isFlipped;
//                                              [self.flipButton setImage:_isFlipped ? [UIImage imageNamed:@"btn_flip_back.png"] : [UIImage imageNamed:@"btn_flip_info.png"] forState:UIControlStateNormal];
                                              
                                          }];
                     }];
}

- (void)flipAndScale:(id)sender
{
    NSLog(@"startFlip");
    //获取当前屏幕中心位置
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGPoint center = CGPointMake(screenRect.size.width * 0.5, screenRect.size.height * 0.5);
    center.y -= 10;
    
    //翻转并缩小
    [UIView animateWithDuration:0.35
                          delay:0.0
                        options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         self.memberCard .frame = CGRectMake(0, center.y, 320, 10);
                         
                     } completion:^(BOOL finished){
                         [self.memberCard setImage: _isFlipped ? self.realCardImage : self.realCardFlippedImage];
                         [UIView animateWithDuration:0.35
                                               delay:0.0
                                             options:UIViewAnimationOptionTransitionNone
                                          animations:^{
                                              self.memberCard.frame = CGRectMake(0, 0, 320, 460);
                                              self.memberCard.center = center;
                                          } completion:^(BOOL finished){
                                              self.isFlipped = !_isFlipped;
                                              [self scaleSmallView:nil delay:0.2];
                                              self.isRealCard = !self.isRealCard;
//                                              [self.flipButton setImage:[UIImage imageNamed:@"btn_flip_info.png"] forState:UIControlStateNormal];
                                          }];
                     }];
}

- (void)shinningTimerTick:(NSTimer *)timer{
    //显示各遮罩层
    self.cardShinningEffectRight.hidden = NO;
    self.rightShinningMask.hidden = NO;
    self.rightSideShinningMask.hidden = NO;
    self.cardShinningEffectRight.frame = CGRectMake(160, 12, 40, 64);
    [UIView animateWithDuration:1.0
                          delay:0.5
                        options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         self.cardShinningEffectRight.frame = CGRectMake(288, 12, 40, 64);
                     }
                     completion:^(BOOL finished){
                         //关闭各遮罩层
                         self.cardShinningEffectRight.hidden = YES;
                         self.rightShinningMask.hidden = YES;
                         self.rightSideShinningMask.hidden = YES;
                     }
     ];
}

- (void)scaleSmallView:(id)cardImageView delay:(float)delaySecond
{
//    float cc = _isRealCard ? 320 / self.viewMask.frame.size.width : 300 / self.viewMask.frame.size.width;
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    //获取当前屏幕中心位置
    CGPoint center = CGPointMake(screenRect.size.width * 0.5, screenRect.size.height * 0.5);
    center.y -= 10;
    
    //设定旋转角度
    float i = _isRealCard ? M_PI * 0.5 : -M_PI * 0.5;
    
    [[self navigationController] setNavigationBarHidden:!_isRealCard animated:YES];
    
    //隐藏闪耀效果遮罩层
    self.cardShinningEffectRight.hidden = YES;
    self.rightShinningMask.hidden = YES;
    self.rightSideShinningMask.hidden = YES;
    
    //旋转缩小并放大
    [UIView animateWithDuration:0.35
                          delay:delaySecond
                        options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         self.memberCard.transform = CGAffineTransformRotate(self.memberCard .transform,i);
                         self.memberCard .frame = CGRectMake(center.x, center.y, 10, 10);
//                         self.view.transform = CGAffineTransformScale(self.view.transform, cc, cc);
                         self.viewMask.alpha = 0.35;
                         
                     } completion:^(BOOL finished){
                         [self.memberCard setImage: _isRealCard ? self.realCardImage : self.smallCardImage];
                         [UIView animateWithDuration:0.35
                                               delay:0.0
                                             options:UIViewAnimationOptionTransitionNone
                                          animations:^{
                                              self.viewMask.alpha = _isRealCard ? 0.7 : 0.0;
                                              self.memberCard.frame = _isRealCard ? CGRectMake(0, 0, 320, 460) : CGRectMake(180, 0, 125, 90);
                                              if (_isRealCard) {
                                                  self.memberCard.center = center;
                                              }
                                          } completion:^(BOOL finished){
                                              self.flipButton.alpha = _isRealCard ? 1.0 : 0.0;
                                          }];
                     }];
    
}

//陀螺仪delegate
- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{
    [self.accerlerometerFilter addAcceleration:acceleration];
//    NSLog(@"x = %f", self.accerlerometerFilter.x);
//    NSLog(@"y = %f", self.accerlerometerFilter.y);
    self.realCardHighlightEffect.center =CGPointMake(50 + (self.accerlerometerFilter.x - 0.2) * 310, 160 - (self.accerlerometerFilter.y - 0.3) * 300);
    
    
}

- (void)showRealCardHighlightEffect:(id)sender
{
    self.realCardHighlightEffect.alpha = 1.0;
}

-(void) shinningSwitch{
    if (self.shinningTimer == nil) {
        
        if (self.realCardHighlightEffect.alpha > 0) {
            self.realCardHighlightEffect.alpha = 0.0;
        }
        
        self.shinningTimer = [NSTimer scheduledTimerWithTimeInterval:5.0
                                                              target:self
                                                            selector:@selector(shinningTimerTick:)
                                                            userInfo:nil
                                                             repeats:YES];
    }else{
        [self.shinningTimer invalidate];
        self.shinningTimer = nil;
        
        [self performSelector:@selector(showRealCardHighlightEffect:) withObject:nil afterDelay:0.7];
        
    }
}

//判断是否为享卡会员
- (BOOL)checkIsBenifitMember
{
    NSString *userCardType = TheAppDelegate.userInfo.cardType;
    return ([userCardType isEqualToString:(JBENEFITCARD)]  ||          //xiang
            [userCardType isEqualToString:(J2BENEFITCARD)] ||          //xiang-month
            [userCardType isEqualToString:(J8BENEFITCARD)]);           //xiang-infinity
}

//判断是否为礼卡会员
- (BOOL)checkIsLiMember
{
    NSString *userCardType = TheAppDelegate.userInfo.cardType;
    return [userCardType isEqualToString:(JJCARD)];           //xiang-infinity
}

//获取礼卡会员级别
- (NSString *)getMemberLevel
{
    int cardLevel = self.userInfo.cardLevel.intValue;
    
    switch (cardLevel) {
        case 1:
            [self isShowActiveButton:NO];
            [self.liCardIcon setImage:[UIImage imageNamed:@"li_card_nr.png"]];
            [self.backgroundHeadImg setImage:[UIImage imageNamed:@"background_head_nr.png"]];
            return @"经典卡";
            break;
        
        case 3:
            [self isShowActiveButton:NO];
            [self.liCardIcon setImage:[UIImage imageNamed:@"li_card_gd.png"]];
            [self.backgroundHeadImg setImage:[UIImage imageNamed:@"background_head_gd.png"]];
            return @"金卡";
            break;
        
        case 4:
            [self isShowActiveButton:NO];
            [self.liCardIcon setImage:[UIImage imageNamed:@"li_card_pt.png"]];
            [self.backgroundHeadImg setImage:[UIImage imageNamed:@"background_head_pt.png"]];
            return @"铂金卡";
            break;
        
        default:
            break   ;
    }
    
    [self isShowActiveButton:YES];
    self.upgradeTimesLabel.text = @"";
    self.upgradePointsLabel.text = @"";
    return @"普通会员";
    
}


-(void)isShowActiveButton:(BOOL)isShow
{
    self.activeButton.hidden = !isShow;
    self.activeButtonArrayIcon.hidden = !isShow;
    self.liCardIcon.hidden = isShow;
}

//隐藏所有信息页面
- (void)hideAllInfoView
{
    self.memberInfoView.hidden = YES;
    self.couponInfoView.hidden = YES;
    self.personalInfoView.hidden = YES;
}


- (IBAction)memberCardTapped:(UITapGestureRecognizer *)sender {
    
    if (![self checkIsBenifitMember]) {
        [[GAI sharedInstance].defaultTracker sendEventWithCategory:@"购买享卡"
                                                        withAction:@"查看购买享卡价格"
                                                         withLabel:@"查看购买享卡价格"
                                                         withValue:nil];
        [UMAnalyticManager eventCount:@"查看购买享卡价格" label:[NSString stringWithFormat:@"查看购买享卡价格"]];
        [self performSegueWithIdentifier:TO_BUY_CARD sender:self];
        return;
    }
    if (_isRealCard) {
        
        self.cardNoLabel.hidden = NO;
        if (_passbookBtn) {
            _passbookBtn.enabled = NO;
        }
    }else{
        self.cardNoLabel.hidden = YES;
        if (_passbookBtn) {
            _passbookBtn.enabled = YES;
        }
    }
    
    if (self.cardAnimationSwitch) {
        [self shinningSwitch];
        if (_isFlipped)
            [self flipAndScale:nil];
        else {
            [self scaleSmallView:nil delay:0.0];
            self.isRealCard = !self.isRealCard;
        }
    } else {
    }
}

- (void)memberUpgrade:(id)sender
{
    [self showRegisterView];
}

- (void)getUserinfoAction:(NSString *)flag
{
    [self showIndicatorView];
    if (!self.userInfoParser)
    {
        self.userInfoParser = [[UserInfoParser alloc] init];
        self.userInfoParser.serverAddress = kUserInfoURL;
    }
    ParameterManager *parameterManager = [[ParameterManager alloc] init];
    [parameterManager parserStringWithKey:@"flag" WithValue:flag];
    
    self.userInfoParser.requestString = [parameterManager serialization];
    self.userInfoParser.delegate = self;
    [self.userInfoParser start];
}

- (IBAction)orderTapped:(UIButton *) button
{
    [self performSegueWithIdentifier:FROM_MEMBER_TO_BILL_LIST sender:self];
}


#pragma mark - MemberInfoStart
- (IBAction)memberInfoCardTapped:(id)sender {
    [self hideAllInfoView];
    self.memberInfoView.hidden = NO;
    [self.infoBackGroundImageView setImage:[UIImage imageNamed:@"member_info_bg.png"]];
    [self setMemberInfoInInfoView];
}

-(void)setMemberInfoInInfoView
{
    UserInfo *ui = TheAppDelegate.userInfo;
    
    if ( TheAppDelegate.userInfo.point == nil ||
        [TheAppDelegate.userInfo.point isEqualToString:@""] ||
        [TheAppDelegate.userInfo.point isEqualToString:@"0"] )
    {
        self.pointsLabel.text = @"暂无积分";
    } else {
        self.pointsLabel.text = ui.point;
    }
    
    NSString *upgradeScore = [NSString stringWithFormat:@"%@%@%@", ui.rankScore, ui.splashChar, ui.rankLevelScore];
    NSString *upgradeTimes = [NSString stringWithFormat:@"%@%@%@", ui.rankTimeSize, ui.splashChar, ui.rankLevelTimeSize];
    self.upgradeTimesLabel.text = upgradeTimes;
    self.upgradePointsLabel.text = upgradeScore;
    
    self.memberTypeLabel.text = [self getMemberLevel];
}

- (IBAction)memberActivatePressed:(UIButton *)sender {
    [self memberUpgrade:nil];
}


#pragma mark - CouponInfoStart
- (IBAction)couponInfoCardTapped:(id)sender {
    [self hideAllInfoView];
    self.couponInfoView.hidden = NO;
    [self.infoBackGroundImageView setImage:[UIImage imageNamed:@"coupon_info_bg.png"]];
    [self setCouponInfoInInfoVIew];
}

- (void)setCouponInfoInInfoVIew
{
    //load coupon list
    [self downloadData];
}


#pragma mark - PersonalInfoStart
- (IBAction)personalInfoCardTapped:(id)sender {
    [self hideAllInfoView];
    self.personalInfoView.hidden = NO;
    [self.infoBackGroundImageView setImage:[UIImage imageNamed:@"personal_info_bg.png"]];
}
- (IBAction)changePasswordPressed:(UIButton *)sender {
    [self performSegueWithIdentifier:@"passwordManage" sender:nil];
}
- (IBAction)changeInfoPressed:(UIButton *)sender {
    
    NSString *isTemp = TheAppDelegate.userInfo.isTempMember;
    if ([isTemp caseInsensitiveCompare:@"true"] == NSOrderedSame)
    {
        [self showAlertMessageWithOkCancelButton:kUpdatePhoneAndEmailAlertMessage tag:kUpdatePhoneAndEmailAlertMessageTag
                                     cancelTitle:NSLocalizedString(@"Cancel", nil) okTitle:NSLocalizedString(@"免费升级", nil)  delegate:self];
    }
    else
    {
        [self performSegueWithIdentifier:@"basicinfoManage" sender:nil];
    }
}





- (void)addBaseInfoTabContent
{
    NSString *oriCardNo = TheAppDelegate.userInfo.cardNo;
//    NSString *cardLevel = TheAppDelegate.userInfo.cardLevel;
    self.cardNoLabel.text = [NSString stringWithFormat:@"%@ %@ %@", [oriCardNo substringToIndex:4], [oriCardNo substringWithRange:NSMakeRange(4, 4)], [oriCardNo substringFromIndex:8]];

    
    self.fullNameLabel.text = TheAppDelegate.userInfo.fullName;
    self.mobileNumberLabel.text = TheAppDelegate.userInfo.mobile;
    self.mailLabel.text = TheAppDelegate.userInfo.email;


}

//- (void)monInAnimation
//{
//    NSString *userName = @"";
//    if ([TheAppDelegate.userInfo.isTempMember caseInsensitiveCompare:@"true"] == NSOrderedSame)
//    {
//        userName = @"用户";
//    }
//    else
//    {
//        NSString *userCardType = TheAppDelegate.userInfo.cardType;
//        if ([userCardType isEqualToString:(JJCARD)])
//        {
//            userName = @"礼会员";
//        }
//        else if ([userCardType isEqualToString:(JBENEFITCARD)] ||
//                 [userCardType isEqualToString:(J2BENEFITCARD)] ||
//                 [userCardType isEqualToString:(J8BENEFITCARD)])
//        {
//            userName = @"享会员";
//        }
//    }
//    [self.animationLabel setText:[NSString stringWithFormat:@"尊敬的%@，欢迎您回来！",userName]];
//    [self.animationLabel sizeToFit];
//    CGFloat width = self.animationLabel.frame.size.width;
//    CGFloat actualWidth = 186;
//    if (width > actualWidth)
//    {
//        CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"position.x"];
//        CGFloat totalTime = (width - actualWidth)/25 + 3;
//        animation.duration = totalTime;
//        animation.fillMode = kCAFillModeForwards;
//
//        animation.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:width / 2],
//                            [NSNumber numberWithFloat:width / 2],
//                            [NSNumber numberWithFloat:actualWidth - width / 2],
//                            [NSNumber numberWithFloat:actualWidth - width / 2],
//                            [NSNumber numberWithFloat:width / 2], nil];
//        animation.keyTimes = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0],
//                              [NSNumber numberWithFloat:1/totalTime],
//                              [NSNumber numberWithFloat:1/totalTime + ((totalTime - 2) / (totalTime * 2))],
//                              [NSNumber numberWithFloat:2/totalTime + ((totalTime - 2) / (totalTime * 2))],
//                              [NSNumber numberWithFloat:1.0], nil];
//
//        animation.removedOnCompletion = NO;
//        animation.repeatCount = HUGE_VALF;  //forever
//        [self.animationLabel.layer addAnimation:animation forKey:nil];
//    }
//}

- (void)showCouponView:(UIButton *) couponBtn
{
    JJCouponAmountType amountType = couponBtn.tag;
    NSMutableArray* coupons = [self.couponDict objectForKey:[JJCouponAmount nameForCouponAmount:amountType]];
    [self.couponListViewController setCouponArray:[coupons mutableCopy]];
    [self showViewInSidebar:self.couponListViewController.view
                      title:[NSString stringWithFormat:@"%d元优惠券",amountType]];
}

- (void)addCouponInfoTabContent
{
    [self.tipLabel removeFromSuperview];
    [self.dashView removeFromSuperview];
    self.tipLabel = nil;
    self.dashView = nil;
    if (self.couponArray.count > 0)
    {
        for (unsigned int i = 0; i< self.couponAmountList.count; i++)
        {
            JJCouponAmount *couponAmount = self.couponAmountList[i];
            UIButton *couponBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [couponBtn setTag:couponAmount.amountType];
            [couponBtn addTarget:self action:@selector(showCouponView:) forControlEvents:UIControlEventTouchUpInside];
            unsigned int pointY = 0;
            if (i==0)
            {   pointY = 7;   }
            else
            {   pointY = 57 + (50 * (i-1)); }

            [couponBtn setFrame:CGRectMake(19, pointY, 259, 46)];
            [couponBtn setBackgroundImage:[[UIImage imageNamed:@"common_btn_press.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:0]
                                 forState:(UIControlStateHighlighted)];

            UIImageView* couponImage = [[UIImageView alloc] initWithFrame:CGRectMake(20, 4, 81, 40)];
            [couponImage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"coupon-%d.png",couponAmount.amountType]]];

            UILabel *couponCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(116, 21, 42, 21)];
            [couponCountLabel setBackgroundColor:[UIColor clearColor]];
            [couponCountLabel setTextColor:RGBCOLOR(60, 60, 60)];
            [couponCountLabel setFont:[UIFont systemFontOfSize:14]];
            [couponCountLabel setText:[NSString stringWithFormat:@"%d张",couponAmount.couponCount]];

            UIImageView* arrow = [[UIImageView alloc] initWithFrame:CGRectMake(235, 21, 20, 20)];
            [arrow setImage:[UIImage imageNamed:@"arrow-red.png"]];

            [couponBtn addSubview:couponImage];
            [couponBtn addSubview:couponCountLabel];
            [couponBtn addSubview:arrow];
            [self.couponInfoView addSubview:couponBtn];

            UIImageView* dashView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 50*i+53, 260, 1)];
            [dashView setImage:[UIImage imageNamed:@"hotel-dashes.png"]];
            [self.couponInfoView addSubview:dashView];
        }
    }
    else
    {
        self.tipLabel= [[UILabel alloc] initWithFrame:CGRectMake(70, 25, 170, 21)];
        self.tipLabel.backgroundColor = [UIColor clearColor];
        self.tipLabel.textColor = RGBCOLOR(60, 60, 60);
        self.tipLabel.font = [UIFont systemFontOfSize:15];
        self.tipLabel.text = @"无任何可使用的优惠券";
        self.dashView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 53, 260, 1)];
        self.dashView.image = [UIImage imageNamed:@"hotel-dashes.png"];

        [self.couponInfoView addSubview:self.tipLabel];
        [self.couponInfoView addSubview:self.dashView];
    }
}

- (void)groupingCouponList
{
    //移除缓存中的优惠券信息
    [self.couponDict removeAllObjects];
    [self.couponAmountList removeAllObjects];
    //对优惠券进行分组计算
    NSMutableArray* amountTenAry    =   [[NSMutableArray alloc] initWithCapacity:10];
    NSMutableArray* amountTwentyAry =   [[NSMutableArray alloc] initWithCapacity:10];
    NSMutableArray* amountThirtyAry =   [[NSMutableArray alloc] initWithCapacity:10];
    NSMutableArray* amountFiftyAry  =   [[NSMutableArray alloc] initWithCapacity:10];
    NSMutableArray* amountHundredAry =  [[NSMutableArray alloc] initWithCapacity:10];

    for (JJCoupon *coupon in self.couponArray)
    {
        switch (coupon.amount)
        {
            case JJCouponAmountTen:
            { [amountTenAry addObject:coupon]; break; }
            case JJCouponAmountTwenty:
            { [amountTwentyAry addObject:coupon]; break; }
            case JJCouponAmountThirty:
            { [amountThirtyAry addObject:coupon]; break; }
            case JJCouponAmountFifty:
            { [amountFiftyAry addObject:coupon]; break; }
            case JJCouponAmountHundred:
            { [amountHundredAry addObject:coupon]; break; }
            default:
            { break; }
        }
    }
    if (amountTenAry.count > 0)
    {
        [self.couponDict setObject:amountTenAry
                            forKey:[JJCouponAmount nameForCouponAmount:JJCouponAmountTen]];
        JJCouponAmount *couponAmount = [[JJCouponAmount alloc] init];
        couponAmount.amountType = JJCouponAmountTen;
        couponAmount.couponCount = amountTenAry.count;
        [self.couponAmountList addObject:couponAmount];
    }
    if (amountTwentyAry.count > 0)
    {
        [self.couponDict setObject:amountTwentyAry
                            forKey:[JJCouponAmount nameForCouponAmount:JJCouponAmountTwenty]];
        JJCouponAmount *couponAmount = [[JJCouponAmount alloc] init];
        couponAmount.amountType = JJCouponAmountTwenty;
        couponAmount.couponCount = amountTwentyAry.count;
        [self.couponAmountList addObject:couponAmount];
    }
    if (amountThirtyAry.count > 0)
    {
        [self.couponDict setObject:amountThirtyAry forKey:[JJCouponAmount nameForCouponAmount:JJCouponAmountThirty]];
        JJCouponAmount *couponAmount = [[JJCouponAmount alloc] init];
        couponAmount.amountType = JJCouponAmountThirty;
        couponAmount.couponCount = amountThirtyAry.count;
        [self.couponAmountList addObject:couponAmount];
    }
    if (amountFiftyAry.count > 0)
    {
        [self.couponDict setObject:amountFiftyAry forKey:[JJCouponAmount nameForCouponAmount:JJCouponAmountFifty]];
        JJCouponAmount *couponAmount = [[JJCouponAmount alloc] init];
        couponAmount.amountType = JJCouponAmountFifty;
        couponAmount.couponCount = amountFiftyAry.count;
        [self.couponAmountList addObject:couponAmount];
    }
    if (amountHundredAry.count > 0)
    {
        [self.couponDict setObject:amountHundredAry forKey:[JJCouponAmount nameForCouponAmount:JJCouponAmountHundred]];
        JJCouponAmount *couponAmount = [[JJCouponAmount alloc] init];
        couponAmount.amountType = JJCouponAmountHundred;
        couponAmount.couponCount = amountHundredAry.count;
        [self.couponAmountList addObject:couponAmount];
    }
    //show coupon info
    [self addCouponInfoTabContent];
}

- (void)addRegulaModeView
{
    self.modeView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    self.modeView.backgroundColor = [UIColor blackColor];
    self.modeView.alpha = 0.2;
    [self.navigationController.view.window addSubview:self.modeView];

    self.registInfoView = [[UIControl alloc] initWithFrame:CGRectMake(320, 100, 300, 300)];
    self.registInfoView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"pop-bg.png"]];

    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(272, 2, 25, 25);
    [closeBtn setBackgroundImage:[UIImage imageNamed:@"button-close.png"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(hideRegisterView) forControlEvents:UIControlEventTouchUpInside];
    [self.registInfoView addSubview:closeBtn];

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, 127, 22)];
    titleLabel.text = @"升级为礼卡会员";
    titleLabel.textColor = RGBCOLOR(0, 141, 205);
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.backgroundColor = [UIColor clearColor];
    [self.registInfoView addSubview:titleLabel];

    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 40, 270, 40)];
    tipLabel.lineBreakMode = UILineBreakModeWordWrap;
    tipLabel.numberOfLines = 0;
    tipLabel.text = @"成为礼卡会员后，预定可享受积分，更有其他专属优惠";
    tipLabel.textColor = RGBCOLOR(175, 175, 175);
    tipLabel.font = [UIFont systemFontOfSize:14];
    tipLabel.backgroundColor = [UIColor clearColor];
    [self.registInfoView addSubview:tipLabel];

    UIImageView *dashesView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 80, 300, 1)];
    dashesView.image = [UIImage imageNamed:@"hotel-dashes.png"];
    [self.registInfoView addSubview:dashesView];

    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 97, 68, 21)];
    nameLabel.text = @"姓       名";
    nameLabel.textColor = RGBCOLOR(52, 52, 52);
    nameLabel.font = [UIFont systemFontOfSize:17];
    nameLabel.backgroundColor = [UIColor clearColor];
    [self.registInfoView addSubview:nameLabel];

    UILabel *idTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 137, 85, 21)];
    idTypeLabel.text = @"证件类型";
    idTypeLabel.textColor = RGBCOLOR(52, 52, 52);
    idTypeLabel.font = [UIFont systemFontOfSize:17];
    idTypeLabel.backgroundColor = [UIColor clearColor];
    [self.registInfoView addSubview:idTypeLabel];

    UILabel *idCardLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 179, 85, 21)];
    idCardLabel.text = @"证件号码";
    idCardLabel.textColor = RGBCOLOR(52, 52, 52);
    idCardLabel.font = [UIFont systemFontOfSize:17];
    idCardLabel.backgroundColor = [UIColor clearColor];
    [self.registInfoView addSubview:idCardLabel];

    self.nameField = [[UITextField alloc] initWithFrame:CGRectMake(116, 90, 164, 30)];
    self.nameField.borderStyle = UITextBorderStyleRoundedRect;
    self.nameField.keyboardType = UIKeyboardTypeNamePhonePad;
    self.nameField.returnKeyType = UIReturnKeyDone;
    self.nameField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.nameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.nameField addTarget:self action:@selector(editingDidDone:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.registInfoView addSubview:self.nameField];

    self.idTypeField = [[UITextField alloc] initWithFrame:CGRectMake(116, 132, 164, 30)];
    self.idTypeField.borderStyle = UITextBorderStyleRoundedRect;
    self.idTypeField.keyboardType = UIKeyboardTypeDefault;
    self.idTypeField.delegate = self;
    self.idTypeField.tag = IDENTITY_TYPE_TAG;
    self.idTypeField.text = self.currentIdentityType.identityTypeCnName;
    [self.registInfoView addSubview:self.idTypeField];

    self.idCardField = [[UITextField alloc] initWithFrame:CGRectMake(116, 174, 164, 30)];
    self.idCardField.borderStyle = UITextBorderStyleRoundedRect;
    self.idCardField.keyboardType = UIKeyboardTypeNamePhonePad;
    self.idCardField.returnKeyType = UIReturnKeyDone;
    self.idCardField.delegate = self;
    self.idCardField.tag = IDENTITY_CARD_TAG;
    self.idCardField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.idCardField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.idCardField addTarget:self action:@selector(editingDidDone:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.registInfoView addSubview:self.idCardField];

    UIButton *upButton = [UIButton buttonWithType:UIButtonTypeCustom];
    upButton.frame = CGRectMake(11, 232, 278, 39);
    [upButton setImage:[UIImage imageNamed:@"upgrade.png"] forState:UIControlStateNormal];
    [upButton setImage:[UIImage imageNamed:@"upgrade-press.png"] forState:UIControlStateHighlighted];
    [upButton addTarget:self action:@selector(completeRegistButtonClicked) forControlEvents:(UIControlEventTouchUpInside)];
    [self.registInfoView addSubview:upButton];

    self.containerView = self.registInfoView;
    [self.registInfoView addTarget:self action:@selector(resignAllTextFiled) forControlEvents:UIControlEventTouchUpInside];

    [self.navigationController.view.window addSubview:self.registInfoView];
    [self.modeView setHidden:YES];
}

- (void)showRegisterView
{
    self.modeView.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.modeView.hidden = NO;
        self.registInfoView.frame = CGRectMake(10, 100, 300, 300);
    }   completion:NULL];
}

- (void)hideRegisterView
{
    [self resignAllTextFiled];
    [UIView animateWithDuration:0.3 animations:^{
        self.registInfoView.frame = CGRectMake(320, 100, 300, 300);
    }completion:^(BOOL finished) {
        self.modeView.hidden = YES;
    }];
}

- (void)completeRegistButtonClicked
{
    if ([self verifyRegist])
    {
        if (!self.completeRegistParser)
        {
            self.completeRegistParser = [[CompleteRegistParser alloc] init];
            self.completeRegistParser.serverAddress = kMemberUpgradeURL;
        }
        [[GAI sharedInstance].defaultTracker sendEventWithCategory:@"会员中心基本信息页面"
                                                        withAction:@"免费升级为礼会员"
                                                         withLabel:@"免费升级为礼会员按钮"
                                                         withValue:nil];
        
        [UMAnalyticManager eventCount:@"免费升级为礼会员" label:@"免费升级为礼会员按钮"];
        
        ParameterManager *parameterManager = [[ParameterManager alloc] init];
        [parameterManager parserStringWithKey:@"name" WithValue:self.nameField.text];
        [parameterManager parserStringWithKey:@"certificateType" WithValue:self.currentIdentityType.identityTypeName];
        [parameterManager parserStringWithKey:@"certificateNo" WithValue:self.idCardField.text];

        self.completeRegistParser.requestString = [parameterManager serialization];
        self.completeRegistParser.delegate = self;
        [self.completeRegistParser start];
        [SVProgressHUD showWithStatus:@"正在提交" maskType:SVProgressHUDMaskTypeClear];
    }
}

- (BOOL)verifyRegist
{
    //姓名校验
    if (![ValidateInputUtil isNotEmpty:self.nameField.text fieldCName:@"姓名"])
    {   return NO;  }

    //证件类型校验
    if (![ValidateInputUtil isNotEmpty:self.idTypeField.text fieldCName:@"证件类型"])
    {   return NO;  }

    //证件号码校验
    if ([@"身份证" isEqualToString:self.idTypeField.text]) {
        
        if (![ValidateInputUtil isIdentifyNumber:self.idCardField.text])
        {   return NO;  }
        
    }  else {
        if (![ValidateInputUtil isNotEmpty:self.idCardField.text fieldCName:@"证件号码"])
        {   return NO;  }
    }

    return YES;
}

- (void)editingDidDone:(UITextField *)textField
{
    [self resignAllTextFiled];
}

- (void)loadPhoneButton
{
    UIImage* img = [[UIImage imageNamed:@"common_btn_press.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:0];
    [self.phoneButton setBackgroundImage:img forState:(UIControlStateHighlighted)];

    UIImageView *telIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 18, 18)];
    [telIcon setImage:[UIImage imageNamed:@"member-down-phone.png"]];

    UILabel* numLabel = [[UILabel alloc] initWithFrame:CGRectMake(28, 5, 70, 18)];
    [numLabel setBackgroundColor:[UIColor clearColor]];
    [numLabel setTextColor:RGBCOLOR(87, 87, 87)];
    [numLabel setFont:[UIFont boldSystemFontOfSize:14]];
    [numLabel setText:@"1010-1666"];

    [self.phoneButton addSubview:telIcon];
    [self.phoneButton addSubview:numLabel];
    [self.phoneButton addTarget:self action:@selector(callPhone:)
               forControlEvents:UIControlEventTouchUpInside];
}

- (void) callPhone:(id)sender
{
    [[GAI sharedInstance].defaultTracker sendEventWithCategory:@"电话预订"
                                                    withAction:@"电话预订"
                                                     withLabel:@"电话预订按钮"
                                                     withValue:nil];
    [UMAnalyticManager eventCount:@"电话预订" label:@"电话预订按钮"];
    
    UIActionSheet *menu = [[UIActionSheet alloc] initWithTitle:@"电话预订" delegate:self cancelButtonTitle:@"取消"
                                        destructiveButtonTitle:nil otherButtonTitles:@"1010-1666", nil];
    [menu setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    [menu setAlpha:1];
    [menu showInView:self.view];
}

//- (void)getUserinfoAction:(NSString *)flag
//{
//    if (!self.userInfoParser)
//    {
//        self.userInfoParser = [[UserInfoParser alloc] init];
//        self.userInfoParser.serverAddress = kUserInfoURL;
//    }
//    ParameterManager *parameterManager = [[ParameterManager alloc] init];
//    [parameterManager parserStringWithKey:@"flag" WithValue:flag];
//
//    self.userInfoParser.requestString = [parameterManager serialization];
//    self.userInfoParser.delegate = self;
//    [self.userInfoParser start];
//}

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

- (void) activeModelView
{
    self.modeView.hidden = NO;
    self.registInfoView.hidden = NO;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"basicinfoManage"])
    {
        BasicInfoManageViewController *baseInfoViewController = (BasicInfoManageViewController *)(segue.destinationViewController);
        baseInfoViewController.delegate = self;
    } else if ([segue.identifier isEqualToString:@"passwordManage"]) {
        PasswordManageViewController *passwordViewController = (PasswordManageViewController *)(segue.destinationViewController);
        passwordViewController.delegate = self;
    }
}

#pragma mark - GDataXMLParserDelegate

- (void)parser:(GDataXMLParser *)parser DidParsedData:(NSDictionary *)data
{
    
    if ([parser isKindOfClass:[CouponListParser class]])
    {
        self.couponArray = data[@"couponList"];
        [self groupingCouponList];
    }
    else if ([parser isKindOfClass:[CompleteRegistParser class]])
    {
        //完善会员信息后续操作
        [self getUserinfoAction:@"false"];
    }
    else if ([parser isKindOfClass:[UserInfoParser class]])
    {
        [self hideIndicatorView];

        //重设登录用户信息
        NSString *loginName = TheAppDelegate.userInfo.loginName;
        TheAppDelegate.userInfo = data[@"userInfo"];
        TheAppDelegate.userInfo.loginName = loginName;
        TheAppDelegate.userInfo.flag = @"true";
        [self loadMemberInfo];
        [SVProgressHUD dismiss];
        [self hideRegisterView];
    }
}

- (void)parser:(GDataXMLParser *)parser DidFailedParseWithMsg:(NSString *)msg errCode:(NSInteger)code
{
    if ([parser isKindOfClass:[CompleteRegistParser class]])
    {   [SVProgressHUD dismiss];[self hideRegisterView];    }

    if ([parser isKindOfClass:[UserInfoParser class]])
    {   [SVProgressHUD dismiss];[self hideRegisterView];    }

    if(code == -1 || code == 10000)
    {   [self showAlertMessageWithOkCancelButton:kNetworkProblemAlertMessage title:nil tag:0 delegate:self];    }
    else
    {   [self showAlertMessageWithOkButton:msg title:nil tag:0 delegate:nil];   }
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
    if (alertView.tag == kUpdatePhoneAndEmailAlertMessageTag && buttonIndex == 1)
    {
        [self memberUpgrade:nil];
    }
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://1010-1666"]];
    }
}

#pragma mark - IdentityTypeViewControllerDelegate

- (void) pickIdentityDone:(IdentityType *) identityType
{
    if (identityType != nil)
    {
        self.currentIdentityType = identityType;
        self.idTypeField.text = identityType.identityTypeCnName;
    }
    [self.identityTypeViewController dismissModalViewControllerAnimated:YES];
    [self performSelector:@selector(activeModelView) withObject:nil afterDelay:0.2];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField.tag == IDENTITY_TYPE_TAG)
    {
        self.modeView.hidden = YES;
        self.registInfoView.hidden = YES;
        UINavigationController *nav = [[UINavigationController alloc]
                                       initWithRootViewController:self.identityTypeViewController];
        [self presentModalViewController:nav animated:YES];

        return NO;
    }

    return YES;
}

#pragma mark - BasicInfoManageViewControllerDelegate
- (void)updateSuccessAfterHandle
{
    [self getUserinfoAction:@"false"];
}

#pragma mark - PasswordManageViewControllerDelegate
- (void)changedPasswordAfterHandle
{
    [self getUserinfoAction:TheAppDelegate.userInfo.isTempMember];
}


-(void)hiddenRenewCardBtn
{
    _renewCardBtn.hidden = YES;
    _contentView.frame = CGRectMake(0, 0, _contentView.frame.size.width, _contentView.frame.size.height);
}

-(BOOL)canRenewCard
{
//    return YES;
    BOOL result = YES;
    NSString *userCardType = TheAppDelegate.userInfo.cardType;
    if (![userCardType isEqualToString:(JBENEFITCARD)]  &&          //xiang
        ![userCardType isEqualToString:(J2BENEFITCARD)]) {
        return NO;
    }
    
    NSString *dueDate = TheAppDelegate.userInfo.dueDate;
    NSInteger month = [[dueDate substringToIndex:2] integerValue];

    NSInteger year = [[dueDate substringFromIndex:3] integerValue];
    
    KalDate *kDate = [KalDate dateFromNSDate:[NSDate date]];
    NSInteger currentYear = [[[NSString stringWithFormat:@"%i",kDate.year] substringFromIndex:1] integerValue];
    NSInteger currentMonth = kDate.month;
    
    if (year == currentYear) {
        if (month - currentMonth >2) {
            result = NO;
        }else if(month - currentMonth < 0){
            result = NO;
        }
    }else if(year - currentYear==1){
        month+= 12;
        if (month - currentMonth >2) {
            result = NO;
        }
    }else if(year - currentYear<0 || year - currentYear>0){
        result = NO;
    }
    return result;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[UIAccelerometer sharedAccelerometer] setDelegate:nil];
}

- (void)viewDidUnload {
    [self setMemberCard:nil];
    [self setViewMask:nil];
    [self setRealCardHighlightEffect:nil];
    [self setRightShinningMask:nil];
    [self setCardShinningEffectRight:nil];
    [self setRightSideShinningMask:nil];
    [self setInfoBackGroundImageView:nil];
    [self setCouponInfoView:nil];
    [self setPersonalInfoView:nil];
    [self setPointsLabel:nil];
    [self setMobileNumberLabel:nil];
    [self setMailLabel:nil];
    [self setMemberTypeLabel:nil];
    [self setUpgradeTimesLabel:nil];
    [self setUpgradePointsLabel:nil];
    [self setActiveButton:nil];
    [self setActiveButtonArrayIcon:nil];
    [self setLiCardIcon:nil];
    [self setBackgroundHeadImg:nil];
    [self setBackgroundMiddleImage:nil];
    [super viewDidUnload];
}

-(void)clickAddToPassbook:(id)sender
{
    [[GAI sharedInstance].defaultTracker sendEventWithCategory:@"会员中心基本信息页面"
                                                    withAction:@"会员卡添加至passbook"
                                                     withLabel:@"会员卡添加至passbook按钮"
                                                     withValue:nil];
    
    [UMAnalyticManager eventCount:@"会员卡添加至passbook" label:@"会员卡添加至passbook按钮"];
    
    [_showPassbookController addToPassbook];
}

- (void)initGeneratePassbook
{
    if(!_showPassbookController){
        _showPassbookController = [[CardPassbookViewController alloc] init];
        _showPassbookController.passbookForm = [self buildPassbookForm];
        _showPassbookController.showPassbookViewController = self;
    }
    if (!([_showPassbookController readPassUrlFromLocal] || [_showPassbookController readPassFromLocal])) {
            [_showPassbookController generatePassbook];
    }

}

-(void)initPassbookBtn
{
    if (!_passbookBtn) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.frame = CGRectMake(35, 185, 22, 117);
        button.alpha = 0.02;
        [button setEnabled:NO];
        
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clickAddToPassbook:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchDown];
        self.passbookBtn = button;
    }
    [self.view addSubview:_passbookBtn];
    self.realCardImage = [self.realCardImage addPassBookButton:@"btn-passbook-add.png"];


}

-(BOOL)isTempMember{
    return [TheAppDelegate.userInfo.isTempMember caseInsensitiveCompare:@"true"] == NSOrderedSame;
}

-(CardPassbookForm *)buildPassbookForm
{
    CardPassbookForm *passbookForm = [[CardPassbookForm alloc] init];
    passbookForm.cardNo = self.userInfo.cardNo;
    passbookForm.cardType = self.userInfo.cardType;
    passbookForm.userName = self.userInfo.fullName;
    passbookForm.score = TheAppDelegate.userInfo.point == nil?0:TheAppDelegate.userInfo.point;
    return passbookForm;
}

- (IBAction)memberRightDetailButtonPress:(id)sender {
    [self performSegueWithIdentifier:@"toMemberDetailSegue" sender:self];
}

int prewTag ;  //编辑上一个UITextField的TAG,需要在XIB文件中定义或者程序中添加，不能让两个控件的TAG相同
float prewMoveY; //编辑的时候移动的高度
// 下面两个方法是为了防止TextFiled让键盘挡住的方法
/**
 开始编辑UITextField的方法
 */
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.tag == IDENTITY_CARD_TAG)
    {
        CGRect textFrame =  textField.frame;
        float textY = self.containerView.frame.origin.y + textFrame.origin.y+textFrame.size.height;
        float bottomY = self.view.frame.size.height - textY + 44;
        if(bottomY >= 216)  //判断当前的高度是否已经有216，如果超过了就不需要再移动主界面的View高度
        {
            prewTag = -1;
            return;
        }
        prewTag = textField.tag;
        float moveY = 216 - bottomY;
        prewMoveY = moveY;
        
        NSTimeInterval animationDuration = 0.2f;
        CGRect frame = self.containerView.frame;
        frame.origin.y -=moveY;//view的Y轴上移
        [UIView beginAnimations:@"ResizeView" context:nil];
        [UIView setAnimationDuration:animationDuration];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        self.containerView.frame = frame;
        [UIView commitAnimations];//设置调整界面的动画效果
    }
}

//
/**
 结束编辑UITextField的方法，让原来的界面还原高度
 */
-(void) textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag == IDENTITY_CARD_TAG) {
        if(prewTag == -1) //当编辑的View不是需要移动的View
        {
            return;
        }
        float moveY ;
        NSTimeInterval animationDuration = 0.2f;
        CGRect frame = self.containerView.frame;
        if(prewTag == textField.tag) //当结束编辑的View的TAG是上次的就移动
        {   //还原界面
            moveY =  prewMoveY;
            frame.origin.y +=moveY;
            self.containerView.frame = frame;
        }
        //self.view移回原位置
        [UIView beginAnimations:@"ResizeView" context:nil];
        [UIView setAnimationDuration:animationDuration];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        self.containerView.frame = frame;
        [UIView commitAnimations];
    }
}


@end
