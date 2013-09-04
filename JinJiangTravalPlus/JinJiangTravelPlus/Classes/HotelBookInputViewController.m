
//  HotelBookInputViewController.m
//  JinJiangTravelPlus
//
//  Created by 胡 桂祁 on 12/5/12.
//  Copyright (c) 2012 JinJiang. All rights reserved.
//

#import "HotelBookInputViewController.h"
#import "HotelBookForm.h"
#import "CreateOrderParser.h"
#import "HotelBookResult.h"
#import "OrderPriceConfirmParser.h"
#import "HotelPriceConfirmForm.h"
#import "OrderPriceConfirm.h"
#import "PayTypeListViewController.h"
#import "SpecialNeedListViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "OrderSuccessNoPayViewController.h"
#import "NSDate+Categories.h"
#import "OrderCoupon.h"
#import "UsableCouponListViewController.h"
#import "CouponRule.h"
#import "CouponRuleListParser.h"
#import "TraceParse.h"
#import "UseCoupon.h"
#import "PaymentGatewayListViewController.h"
#import "LoginViewController.h"
#import "LoginForGuestOrderViewController.h"
#import "LocationInfo.h"
#import "BookingDescriptionParser.h"

#define MAX_ROOM_COUNT 3
#define MIN_ROOM_COUNT 1

@interface HotelBookInputViewController ()

@property(nonatomic, strong) PayTypeListViewController *payTypeListViewController;
@property(nonatomic, strong) SpecialNeedListViewController *specialNeedListViewController;
@property(nonatomic, strong) ConditionView *conditionView;
@property(nonatomic, strong) UIControl *leftView;

@property(nonatomic,strong) UsableCouponListViewController *usableCouponListViewController;
@property (nonatomic,strong) NSArray *couponList;
@property (nonatomic, strong) UIButton *tempButton;
@property (nonatomic,strong) UILabel *totalCouponAmountLabel;
@property (nonatomic,strong) CouponRuleListParser *couponRuleListParser;
@property (nonatomic, strong) TraceParse *traceParse;

@property (nonatomic,weak) OrderPriceConfirm *orderPriceConfirm;
@property (nonatomic,weak) PayType *currentPayType;
@property (nonatomic, strong) UIView *modeView;

@property (nonatomic, strong) LoginViewController *loginViewController;
@property (nonatomic, strong) NSString *cancelPolicyText;

@property (nonatomic, strong) NSMutableArray *scrollSubViewFrameArray;
@property (nonatomic, strong) NSMutableArray *formSubViewFrameArray;
@property (nonatomic, strong) NSMutableArray *bookingBodyFrameArray;
@property (nonatomic, strong) NSString *checkInPersonNames;
@property (nonatomic) CGSize screenSize;
@property (nonatomic) CGPoint fakeBottomPoint;
@property (nonatomic, strong) NSString *payFeedBackDesc;
@property (nonatomic) BOOL isInActivity;

- (BOOL) isMember;

@end

@interface HotelBookInputViewController (Private)
- (void) touchTotalPrice;
- (void) closeDayPriceDetailView;
- (IBAction)bookHotel;
-(IBAction)increaseRoomCount:(id)sender;
-(IBAction)decreaseRoomCount:(id)sender;

-(void)clickCouponShow:(id)sender;

- (void)queryDpaWhenChangeRoomCount:(NSInteger)currentRoomCount;

@end

@implementation HotelBookInputViewController

int prewTag, prewMoveY;

- (void)viewDidLoad
{
    [super viewDidLoad];
    //定义页面位置
    self.screenSize = CGSizeMake(self.scrollView.frame.size.width, self.scrollView.frame.size.height - 44);;
    self.scrollView.contentSize = self.screenSize;
    self.fakeBottomPoint = CGPointMake(self.bookBtn.frame.origin.x, self.bookBtn.frame.origin.y + self.bookBtn.frame.size.height + 20);
    
    //暂存各页面初始位置，供滚动
    self.scrollSubViewFrameArray = [NSMutableArray array];
    self.formSubViewFrameArray = [NSMutableArray array];
    self.bookingBodyFrameArray = [NSMutableArray array];
    
    for (UIView *subView in self.scrollView.subviews) {
        if (subView == self.topBackImage || subView == self.bookingBodyView) {
            [self.scrollSubViewFrameArray addObject:[NSNumber numberWithFloat:subView.frame.size.height]];
        } else {
            [self.scrollSubViewFrameArray addObject:[NSNumber numberWithFloat:subView.frame.origin.y ]];
        }
    }
    
    for (UIView *subView in self.viewForTwo.subviews) {
        [self.formSubViewFrameArray addObject:[NSNumber numberWithFloat:subView.frame.origin.y ]];
    }
    
    [self.bookingBodyFrameArray addObject:[NSNumber numberWithFloat:self.viewForTwo.frame.size.height]];
    [self.bookingBodyFrameArray addObject:[NSNumber numberWithFloat:self.controlForPay.frame.origin.y]];
    
    self.viewForTwo.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.viewForTwo.layer.borderWidth = 1;
    
    if (self.orderPriceConfirmForm)
    {
        [self checkGuestPrice];
        self.orderPriceConfirmForm.roomCount = 1;
        self.orderPriceConfirmParser = [[OrderPriceConfirmParser alloc] init];
        self.orderPriceConfirmParser.delegate = self;
        [self showConfirmPriceIndicatorView];
        [self initHotelBookForm];
        [self initBookInputView];
    }
    
    self.checkPersonFieldTop.delegate = self;
    self.checkPersonFieldMiddle.delegate = self;
    self.checkPersonFieldBottom.delegate = self;
    self.contactPersonField.delegate = self;
    self.contactPersonMobileField.delegate = self;
    self.bookingDescriptionLabel.text = @"";
    
    self.containerView = self.bookingBodyView;
    
    self.navigationItem.title = self.hotelBookForm.hotelName;
    
    if (self.roomNameLabel.text.length >= 8)
    {
        self.roomNameLabel.font = [UIFont systemFontOfSize:16];
    }
    
    [self couponBtnInit];
    [self checkBookingDescriptionByHotelBrand:self.orderPriceConfirmForm.hotelBrand];
    
    
    UITapGestureRecognizer *touchTotalPrice =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchTotalPrice)];
    [self.totalPriceContainerView addGestureRecognizer:touchTotalPrice];
    
}

- (void)checkBookingDescriptionByHotelBrand:(NSString *)hotelBrand
{
    BookingDescriptionParser *bdParser = [[BookingDescriptionParser alloc] init];
    bdParser.delegate = self;
    [bdParser sendRequest:hotelBrand];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect textFrame =  textField.frame;
    float textY = self.viewForTwo.frame.origin.y+textFrame.origin.y + textFrame.size.height;
    float bottomY = self.view.frame.size.height - textY;
    if(bottomY >= 242)  //判断当前的高度是否已经有216，如果超过了就不需要再移动主界面的View高度
    {
        prewTag = -1;
        return;
    }
    prewTag = textField.tag;
    float moveY = 242 - bottomY;
    prewMoveY = moveY;
    
    NSTimeInterval animationDuration = 0.2f;
    CGRect frame = self.view.frame;
    frame.origin.y -=moveY;//view的Y轴上移
    frame.size.height +=moveY; //View的高度增加
    [UIView beginAnimations:@"ResizeView" context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    self.view.frame = frame;
    [UIView commitAnimations];//设置调整界面的动画效果

}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if(prewTag == -1) //当编辑的View不是需要移动的View
    {
        return;
    }
    float moveY ;
    NSTimeInterval animationDuration = 0.2f;
    CGRect frame = self.view.frame;
    if(prewTag == textField.tag) //当结束编辑的View的TAG是上次的就移动
    {   //还原界面
        moveY =  prewMoveY;
        frame.origin.y +=moveY;
        frame.size. height -=moveY;
        self.view.frame = frame;
    }
    //self.view移回原位置
    [UIView beginAnimations:@"ResizeView" context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    self.view.frame = frame;
    [UIView commitAnimations];
    [textField resignFirstResponder];


}

-(BOOL)textFieldShouldReturn:(UITextField*)textField;
{
    NSInteger nextTag = textField.tag + 1;
    // Try to find next responder
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        // Not found, so remove keyboard.
        [textField resignFirstResponder];
    }
    return NO; // We do not want UITextField to insert line-breaks.
}

- (NSString *)getCheckInPersonNamesFromFields:(NSInteger)roomCount
{
    NSString *resultNames = @"";
    NSArray *names =   [[NSString stringWithFormat:@"%@,%@,%@", self.checkPersonFieldTop.text, self.checkPersonFieldMiddle.text, self.checkPersonFieldBottom.text] componentsSeparatedByString:@","];
    for (int i = 2; i >= 3 - roomCount; i--) {
        resultNames = [NSString stringWithFormat:@"%@%@%@", [names objectAtIndex:i], @",", resultNames];
    }
    return [resultNames substringToIndex:resultNames.length-1];
}

- (NSString *)getCheckInPersonNamesFromFields
{
    return [NSString stringWithFormat:@"%@,%@,%@", self.checkPersonFieldTop.text, self.checkPersonFieldMiddle.text, self.checkPersonFieldBottom.text];
}

-(void)viewWillAppear:(BOOL)animated
{
    self.trackedViewName = @"酒店订单录入页面";
    [super viewWillAppear:animated];
    
    self.isInActivity = NO;
}

- (void) touchTotalPrice
{
    self.dayPriceDetailContainerView = [[UIView alloc] initWithFrame:CGRectMake(10.0, 76.0, 300.0, 400.0)];
    self.modeView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    self.modeView.backgroundColor = [UIColor blackColor];
    self.modeView.alpha = 0.2;
    [self.navigationController.view.window addSubview:self.modeView];
    
    [self.dayPriceDetailContainerView addSubview:self.dayPriceDetailViewController.view];
    [self.navigationController.view.window addSubview:self.dayPriceDetailContainerView];
}

- (DayPriceDetailViewController *)dayPriceDetailViewController
{
    _dayPriceDetailViewController = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil]
                                     instantiateViewControllerWithIdentifier:@"DayPriceDetailViewController"];
    
    _dayPriceDetailViewController.orderPriceConfirm = self.hotelBookForm.orderPriceConfirm;
    _dayPriceDetailViewController.payType = self.hotelBookForm.orderType;
    
    if (_useCoupon.totalAmount <= 0) {
        _dayPriceDetailViewController.couponAmount = @"0";
    } else {
        _dayPriceDetailViewController.couponAmount = [NSString stringWithFormat:@"%d", _useCoupon.totalAmount];
    }
    
    _dayPriceDetailViewController.delegate = self;
    _dayPriceDetailViewController.roomCount = self.hotelBookForm.roomCount;
    _dayPriceDetailViewController.view.frame = CGRectMake(0.0, 0.0, 300.0, 400.0);
    
    return _dayPriceDetailViewController;
}

- (void) closeDayPriceDetailView;
{
    [self.dayPriceDetailContainerView removeFromSuperview];
    [self.modeView removeFromSuperview];
}

- (void)couponBtnInit
{
    NSLog(@"uid is : %@", TheAppDelegate.userInfo.uid);
    
    if (TheAppDelegate.userInfo.uid == nil ||TheAppDelegate.userInfo.isForGuestOrder || [TheAppDelegate.userInfo.uid isEqual:@"0"]) return;
    
    UIButton *couponBtn = [[UIButton alloc] initWithFrame:CGRectMake(192, 45, 113, 60)];
    couponBtn.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"discount_coupon.png" ]];
    [couponBtn addTarget:self action:@selector(clickCouponShow:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    [self.bookingBodyView addSubview:couponBtn];
    [couponBtn setHidden:YES];
    self.couponBtn = couponBtn;
}

#pragma mark --clickCouponshow
-(void)clickCouponShow:(id)sender
{
    [self showViewInSidebar:self.usableCouponListViewController.view title:@"优惠券列表"];
}

- (void)initHotelBookForm
{
    self.hotelBookForm = [[HotelBookForm alloc] init];
    self.hotelBookForm.hotelId = self.orderPriceConfirmForm.hotelId;
    self.hotelBookForm.hotelName = self.orderPriceConfirmForm.hotelName;
    self.hotelBookForm.planId = self.orderPriceConfirmForm.planId;
    self.hotelBookForm.roomName = self.orderPriceConfirmForm.roomName;
    self.hotelBookForm.roomCount = self.orderPriceConfirmForm.roomCount;
    self.hotelBookForm.numAdult = self.orderPriceConfirmForm.numAdult;
    self.hotelBookForm.latestArrivalTime = self.orderPriceConfirmForm.latestArrivalTime;
    self.hotelBookForm.checkInDate = self.orderPriceConfirmForm.checkInDate;
    self.hotelBookForm.checkOutDate = self.orderPriceConfirmForm.checkOutDate;
    NSString *isTempMember = TheAppDelegate.userInfo.isTempMember;
    if(isTempMember && [isTempMember caseInsensitiveCompare:@"true"] == NSOrderedSame)
    {
        self.hotelBookForm.checkInPersonName = TheAppDelegate.userInfo.loginName;
        self.hotelBookForm.contactPersonName = TheAppDelegate.userInfo.loginName;
    }
    else
    {
        self.hotelBookForm.checkInPersonName = TheAppDelegate.userInfo.fullName;
        self.hotelBookForm.contactPersonName = TheAppDelegate.userInfo.fullName;
    }
    self.hotelBookForm.contactPersonMobile = TheAppDelegate.userInfo.mobile;
    self.hotelBookForm.tempMemberFlag = isTempMember;
    self.hotelBookForm.nightNums = [NSString stringWithFormat:@"%d",TheAppDelegate.hotelSearchForm.nightNums];
    
    NSString *trimText = [TheAppDelegate.userInfo.email  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (trimText == nil || [trimText isEqualToString:@""])
    {
        self.hotelBookForm.contactPersonEmail  = kDefaultUserEmail;
    }else{
        self.hotelBookForm.contactPersonEmail = TheAppDelegate.userInfo.email;
    }
    
}

- (void)initBookInputView
{
    self.totalAmountLabel.lineBreakMode = UILineBreakModeTailTruncation;
    
    _roomNameLabel.text = _hotelBookForm.roomName;
    _roomCountLabel.text = [NSString stringWithFormat:@"%d",_hotelBookForm.roomCount];
    _checkInDateLabel.text = _hotelBookForm.checkInDate;
    _checkOutDateLabel.text = _hotelBookForm.checkOutDate;
    
    _checkPersonFieldBottom.text = _hotelBookForm.checkInPersonName;
    _contactPersonField.text = _hotelBookForm.contactPersonName;
    _contactPersonMobileField.text = _hotelBookForm.contactPersonMobile;
    
    
    [self checkRoomCount:_hotelBookForm.roomCount];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --bookHotel
- (IBAction)bookHotel
{
    [self countAnalytics];
    if (_useCoupon && _useCoupon.couponAmount>0 && [self canUseCoupon]) {
        self.hotelBookForm.bookingModule = [JJHotel nameForOrigin:self.orderPriceConfirmForm.origin];
        self.hotelBookForm.couponCodes = _useCoupon.codeList;
    }
    self.hotelBookForm.checkInPersonName = [self getCheckInPersonNamesFromFields:self.hotelBookForm.roomCount];
    self.hotelBookForm.contactPersonName = self.contactPersonField.text;
    self.hotelBookForm.contactPersonMobile = self.contactPersonMobileField.text;
    
    if(![self.hotelBookForm verify])
    {   return; }
    
    self.createOrderParser = [[CreateOrderParser alloc] init];
    self.createOrderParser.delegate = self;
    [self.createOrderParser bookRequest:self.hotelBookForm];
    
    [self showIndicatorView];
}

-(IBAction)backgroupTap:(id)sender
{
    [self.checkPersonFieldBottom resignFirstResponder];
    [self.checkPersonFieldMiddle resignFirstResponder];
    [self.checkPersonFieldTop resignFirstResponder];
    [self.contactPersonField resignFirstResponder];
    [self.contactPersonMobileField resignFirstResponder];
}

- (void)queryDpaWhenChangeRoomCount:(NSInteger)currentRoomCount
{
    self.hotelBookForm.roomCount = currentRoomCount;
    self.orderPriceConfirmForm.roomCount = currentRoomCount;
    [self.orderPriceConfirmParser priceConfirmRequest:self.orderPriceConfirmForm];
    [self showConfirmPriceIndicatorView];
}

//验证房间数量并更改订单信息
- (void)checkRoomCount:(NSInteger)currentRoomCount
{
    [self.roomCountPlusButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"add-%@.png", currentRoomCount - 2 > 0 ? @"disabled" : @"press"]] forState:UIControlStateNormal];
    [self.roomCountMinusButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"minus-%@.png", currentRoomCount - 2 < 0 ? @"disabled" : @"press"]] forState:UIControlStateNormal];
    
//    NSArray *personNames = [[self getCheckInPersonNamesFromFields] componentsSeparatedByString:@","];
    
    
    switch (currentRoomCount) {
        case 1:
            self.checkPersonLabelBottom.text = @"入住人1:";
            break;
        case 2:
            self.checkPersonLabelMiddle.text = @"入住人1:";
            self.checkPersonLabelBottom.text = @"入住人2:";
            break;
        case 3:

            self.checkPersonLabelTop.text = @"入住人1:";
            self.checkPersonLabelMiddle.text = @"入住人2:";
            self.checkPersonLabelBottom.text = @"入住人3:";
        default:
            break;
    }
    
    if ((currentRoomCount - 1) / MAX_ROOM_COUNT == 0) {
        int j = 0;
        for (int i = 0; i < self.viewForTwo.subviews.count; i++) {
            UIView *subView = [self.viewForTwo.subviews objectAtIndex:i];
            CGRect frame = subView.frame;
            subView.frame = CGRectMake(frame.origin.x, ((NSNumber *)[self.formSubViewFrameArray objectAtIndex:j++]).floatValue + (currentRoomCount - 1) * 35, frame.size.width, frame.size.height);
        }
        
        j = 0;
        for (int i = 0; i < self.scrollView.subviews.count; i++) {
            UIView *subView = [self.scrollView.subviews objectAtIndex:i];
            CGRect frame = subView.frame;
            float offset = ((NSNumber *)[self.scrollSubViewFrameArray objectAtIndex:j++]).floatValue ;
            if (subView == self.topBackImage || subView == self.bookingBodyView) {
                subView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, offset + (currentRoomCount -1) * 35);
            } else {
                subView.frame = CGRectMake(frame.origin.x, offset + (currentRoomCount -1) * 35, frame.size.width, frame.size.height);
            }
        }
        
        if (self.bookingBodyFrameArray.count == 2) {
            CGRect frame = self.viewForTwo.frame;
            self.viewForTwo.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, ((NSNumber *)[self.bookingBodyFrameArray objectAtIndex:0]).floatValue + (currentRoomCount -1) * 35);
            
            frame = self.controlForPay.frame;
            self.controlForPay.frame = CGRectMake(frame.origin.x, ((NSNumber *)[self.bookingBodyFrameArray objectAtIndex:1]).floatValue + (currentRoomCount -1) * 35, frame.size.width, frame.size.height);
        }
        
        if (!CGRectContainsRect(CGRectMake(0, 0, 320, self.scrollView.contentSize.height), self.bookBtn.frame)) {
            
            self.scrollView.contentSize = CGSizeMake(self.screenSize.width, self.screenSize.height + (currentRoomCount - 1) * 35);
            
        }
        
        
        self.roomCountLabel.text = [NSString stringWithFormat:@"%d", currentRoomCount];
        [self queryDpaWhenChangeRoomCount:currentRoomCount];
    }
}

-(IBAction)increaseRoomCount:(id)sender
{
    NSInteger currentRoomCount = self.roomCountLabel.text.integerValue;
    if (currentRoomCount >= MAX_ROOM_COUNT) {
        return;
    }
    currentRoomCount++;
    
    self.checkPersonFieldTop.text = self.checkPersonFieldMiddle.text;
    self.checkPersonFieldMiddle.text = self.checkPersonFieldBottom.text;
    self.checkPersonFieldBottom.text = @"";
    
    [self checkRoomCount:currentRoomCount];
//    if(currentRoomCount >= 3)
//    {
//        if (currentRoomCount == 3)
//        {
//            self.roomCountLabel.text = [NSString stringWithFormat:@"%d", currentRoomCount];
//            [self queryDpaWhenChangeRoomCount:currentRoomCount];
//        }
//        [self.roomCountPlusButton setImage:[UIImage imageNamed:@"add-disabled.png"] forState:UIControlStateNormal];
//        return;
//    }
//    
//    self.roomCountLabel.text = [NSString stringWithFormat:@"%d", currentRoomCount];
//    if (currentRoomCount == 2)
//    {
//        [self.roomCountMinusButton setImage:[UIImage imageNamed:@"minus-press.png"] forState:UIControlStateNormal];
//    }
//    [self queryDpaWhenChangeRoomCount:currentRoomCount];
    
}

- (void)processSpecialNeeds:(NSInteger)currentRoomCount
{

    
    
    
    
    if (currentRoomCount == 1 && ![self.hotelBookForm.specialNeeds isEqualToString:@""]) {
        
        NSString *replacedSpecialStr = [self.sepecialButton.titleLabel.text stringByReplacingOccurrencesOfString:@",相邻房" withString:@""];
        
        [self.sepecialButton setTitle:replacedSpecialStr forState:UIControlStateNormal];
        
        self.hotelBookForm.specialNeeds = replacedSpecialStr;
    }
}

-(IBAction)decreaseRoomCount:(id)sender
{
    NSInteger currentRoomCount = self.roomCountLabel.text.integerValue;
    if (currentRoomCount <= MIN_ROOM_COUNT) {
        return;
    }
    currentRoomCount--;
    
    self.checkPersonFieldBottom.text = self.checkPersonFieldMiddle.text;
    self.checkPersonFieldMiddle.text = self.checkPersonFieldTop.text;
    self.checkPersonFieldTop.text = @"";
    
    [self checkRoomCount:currentRoomCount];
    //    if(currentRoomCount <= 1)
    //    {
    //        if (currentRoomCount == 1)
    //        {
    //            self.roomCountLabel.text = [NSString stringWithFormat:@"%d", currentRoomCount];
    //            [self queryDpaWhenChangeRoomCount:currentRoomCount];
    //        }
    //        [self.roomCountMinusButton setImage:[UIImage imageNamed:@"minus-disabled.png"] forState:UIControlStateNormal];
    //        return;
    //    }
    //
    //    self.roomCountLabel.text = [NSString stringWithFormat:@"%d", currentRoomCount];
    //    if (currentRoomCount == 2)
    //    {
    //        [self.roomCountPlusButton setImage:[UIImage imageNamed:@"add-press.png"] forState:UIControlStateNormal];
    //    }
    //    [self queryDpaWhenChangeRoomCount:currentRoomCount];
    [self processSpecialNeeds:currentRoomCount];
    
    
    
}

- (void)showConfirmPriceIndicatorView
{
    if (self.loadingIndicatorView == nil) {
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        self.loadingIndicatorView = [board instantiateViewControllerWithIdentifier:@"LoadingIndicatorViewController"];
        self.loadingIndicatorView.view.center = CGPointMake(self.view.center.x, 190);
        [self.loadingIndicatorView startAnimating];
    }
    self.view.userInteractionEnabled = NO;
    [self.view addSubview:self.loadingIndicatorView.view];
}


#pragma mark - buildCodeList
- (void)buildCodeList
{
    CouponRule *couponRule = [_couponRuleList objectAtIndex:_useCoupon.couponIndex];
    NSString *codeList = @"";
    for (unsigned int i=0; i<_useCoupon.useCouponNum; i++)
    {
        if ([codeList isEqualToString:@""])
        {
            codeList = [couponRule.codeList objectAtIndex:i];
            continue;
        }
        codeList =[codeList stringByAppendingFormat:@",%@",[couponRule.codeList objectAtIndex:i]];
    }
    _useCoupon.codeList = codeList;
}

#pragma mark - UsaleCouponListViewController.SelectUsableCouponDelegate--buildUseCoupon
-(void)buildUseCoupon:(UseCoupon *)useCoupon
{
    _useCoupon = useCoupon;
    [self changeTotalPriceLabelAndAddoriginPrice];
    if(useCoupon.totalAmount >0){
        NSLog(@"couponIndex:%d,totalAmount:%d,useNum:%d",useCoupon.couponIndex,useCoupon.totalAmount,useCoupon.useCouponNum);
        [self changeTotalCouponAmountLabelAndStyle:useCoupon];
        [self changePayTypeForUseCoupon];
        [self buildCodeList];
        
    }else{
        [self showHaveCouponImgTag];
        self.originalPrice.hidden = YES;
    }
    [self hiddenRightView];
}

#pragma mark --useCoupon
#pragma mark --changePayTypeForUseCoupon
-(void)changePayTypeForUseCoupon
{
    if ([self hasUseCoupon]) {
        PayType *payType = nil;
        if (self.hotelBookForm.orderPriceConfirm && [self.hotelBookForm.orderPriceConfirm.payTypeList count] >1) {
            payType = [self.hotelBookForm.orderPriceConfirm.payTypeList objectAtIndex:1];
        }
        if(payType){
            [self selectedPayType:payType];
        }
    }
}

#pragma mark -hasUseCoupon
-(BOOL)hasUseCoupon
{
    return _useCoupon && _useCoupon.totalAmount >0;
}

#pragma mark --canUseCoupon
-(BOOL) canUseCoupon
{
    BOOL resultBool = NO;
    switch (self.orderPriceConfirmForm.origin) {
        case JJHotelOriginJJINN:
            resultBool = YES;
            break;
        case JJHotelOriginJREZ:
            resultBool = YES;
            break;
        default:
            resultBool = NO;
            break;
    }
    return resultBool;
}



#pragma mark --couponViewStyle
#pragma mark --hasCountAmountTotalAmountLabelStyle
- (void)hasCountAmountTotalAmountLabelStyle
{
    //    float amountX=22.0;
    //    float amountY = 350.0;
    //    float amountW = 139.0;
    //    float amountH = 40.0;
    //
    //    float amountLineX=0.0;
    //    float amountLineY = 23.0;
    //    float amountLineW = 110.0;
    //    float amountLineH = 1.0;
    //    if ([_totalAmountLabel.text length] >8) {
    //        amountX = 18.0;
    //        amountW = 145.0;
    //        amountLineW = 118.0;
    //    }
    //    self.totalAmountLabel.frame = CGRectMake(amountX, amountY, amountW, amountH);
    //    self.totalPriceLabelLine.frame = CGRectMake(amountLineX, amountLineY, amountLineW, amountLineH);

    //TODO
    self.originalPrice.hidden = NO;
}

#pragma mark --changeTotalAmountLabelAndTotalPriceLineStyle
- (void)changeTotalAmountLabelAndTotalPriceLineStyle
{
    if ([self hasUseCoupon]) {
        [self hasCountAmountTotalAmountLabelStyle];
    }else{
        [self noCouponAmountTotalAmountLabelStyle];
    }
    
}


#pragma mark --changeTotalPriceLabelAndAddoriginPrice
-(void)changeTotalPriceLabelAndAddoriginPrice
{
    NSUInteger totalPrice = [_orderPriceConfirm.totalPrice integerValue];
    NSUInteger couponAmount = _useCoupon.totalAmount;
    _totalAmountLabel.text = [NSString stringWithFormat:@"支付:%d元", totalPrice - couponAmount];
    [self changeTotalAmountLabelAndTotalPriceLineStyle];
    if ([self hasUseCoupon]) {
        self.originalPrice.text  = [NSString stringWithFormat:@"原价:%d元",totalPrice];

        //TODO
        self.originalPrice.hidden = NO;
        self.totalAmountLabel.frame = CGRectMake(self.totalAmountLabel.frame.origin.x, 0, self.totalAmountLabel.frame.size.width, self.totalAmountLabel.frame.size.height);
        self.totalPriceLabelLine.frame = CGRectMake(self.totalPriceLabelLine.frame.origin.x, 22, self.totalPriceLabelLine.frame.size.width, self.totalPriceLabelLine.frame.size.height);
        self.originalPrice.frame = CGRectMake(self.originalPrice.frame.origin.x, 18, self.originalPrice.frame.size.width, self.originalPrice.frame.size.height);

    }
}

#pragma mark --changeTotalCouponAmountLabelAndStyle
- (void)changeTotalCouponAmountLabelAndStyle:(UseCoupon *)useCoupon
{
    self.couponBtn.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"coupon_used.png"]];
    if (!_totalCouponAmountLabel) {
        _totalCouponAmountLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 26, 41, 19)];
        _totalCouponAmountLabel.backgroundColor = [UIColor clearColor];
        _totalCouponAmountLabel.textColor = RGBCOLOR(162, 44, 20);
        _totalCouponAmountLabel.font = [UIFont systemFontOfSize:14];
        [self.couponBtn addSubview:_totalCouponAmountLabel];
    }
    _totalCouponAmountLabel.text = [NSString stringWithFormat:@"￥%d" ,useCoupon.totalAmount];
    _totalCouponAmountLabel.hidden = NO;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    HotelBookResult *bookResult = (HotelBookResult *)sender;
    
    if ([segue.identifier isEqualToString:@"OrderBookSuccessNoPaySegue"])
    {
        [self noPaySegueHandle:bookResult segue:segue];
    } else if ([segue.identifier isEqualToString:FROM_BOOK_TO_PAYMENT])
    {
        [self onlinePaySegueHandle:segue with:bookResult];
    }
}

- (void)onlinePaySegueHandle:(UIStoryboardSegue *)segue with:(HotelBookResult *)bookResult
{
    if ([segue.destinationViewController isKindOfClass:[PaymentGatewayListViewController class]]) {
        PaymentGatewayListViewController *destinationController = segue.destinationViewController;
        destinationController.paymentForm= [[UnionPaymentForm alloc] init];
        destinationController.paymentForm.orderNo = bookResult.orderNo;
        destinationController.paymentForm.orderId = bookResult.orderId;
        destinationController.paymentForm.hotelName = self.hotelBookForm.hotelName;
        destinationController.paymentForm.orderAmount = self.hotelBookForm.orderPriceConfirm.totalPrice;
        destinationController.paymentForm.contactPhoneNumber = self.hotelBookForm.contactPersonMobile;
        destinationController.cancelPolicyText = _currentPayType.cancelPolicyDesc;
        destinationController.isInActivity = self.isInActivity;
        destinationController.payFeedBackDesc = self.payFeedBackDesc;
        
        _hotelBookForm.orderNo = bookResult.orderNo;
        _hotelBookForm.orderStatus = bookResult.orderStatus;
        
        destinationController.bookForm = _hotelBookForm;
        destinationController.hotelBrand = self.orderPriceConfirmForm.hotelBrand;
        destinationController.latitude = [NSString stringWithFormat:@"%f",self.orderPriceConfirmForm.coordinate.latitude];
        destinationController.longitude = [NSString stringWithFormat:@"%f",self.orderPriceConfirmForm.coordinate.longitude];
        destinationController.hotelAddress = self.orderPriceConfirmForm.hotelAddress;
    }
}

- (void)noPaySegueHandle:(HotelBookResult *)bookResult segue:(UIStoryboardSegue *)segue
{
    if ([segue.destinationViewController isKindOfClass:[OrderSuccessNoPayViewController class]]) {
        OrderSuccessNoPayViewController *orderResultViewController = segue.destinationViewController;
        orderResultViewController.navigationItem.title = @"预订成功";
        _hotelBookForm.orderNo = bookResult.orderNo;
        _hotelBookForm.orderStatus = bookResult.orderStatus;
        orderResultViewController.bookForm = _hotelBookForm;
        orderResultViewController.hotelBrand = self.orderPriceConfirmForm.hotelBrand;
        orderResultViewController.latitude = [NSString stringWithFormat:@"%f",self.orderPriceConfirmForm.coordinate.latitude];
        orderResultViewController.longitude = [NSString stringWithFormat:@"%f",self.orderPriceConfirmForm.coordinate.longitude];
        orderResultViewController.hotelAddress = self.orderPriceConfirmForm.hotelAddress;
    }
}


- (void)parser:(GDataXMLParser *)parser DidParsedData:(NSDictionary *)data {
    if ([parser isKindOfClass:[OrderPriceConfirmParser class]]) {
        self.bookBtn.enabled = YES;
        [self handleOrderPriceConfirmParser:data parser:parser];
    }
    if ([parser isKindOfClass:[CreateOrderParser class]])
    {
        [self handleCreateOrderParser:data parser:parser];
    }
    if ([parser isKindOfClass:[CouponRuleListParser class]]) {
        [self handleLoadCouponRuleListParser:data parser:parser];
    }
    if ([parser isKindOfClass:[MemberParser class]]) {
        [self handleMemberQueryParser:data parser:parser];
    }
    if ([parser isKindOfClass:[BookingDescriptionParser class]]) {
        [self handleBookingDescriptionParser:data];
    }
}

- (void)parser:(GDataXMLParser *)parser DidFailedParseWithMsg:(NSString *)msg errCode:(NSInteger)code {
    [self handleOrderPriceConfirmFailed:parser DidFailedParseWithMsg:msg errCode:code];
    [self handleCreateOrderFailed:parser DidFailedParseWithMsg:msg errCode:code];
    [self handleLoadCouponRuleListFailed:parser DidFailedParseWithMsg:msg errCode:code];
}


- (void)setTotalAmountLabelValueAndStyle {
    self.totalAmountLabel.text = [NSString stringWithFormat:@"支付:%@元",_orderPriceConfirm.totalPrice];
    self.totalPriceLabelLine.hidden = NO;
    if([self.totalAmountLabel.text length] >9){
        self.totalAmountLabel.font = [UIFont systemFontOfSize:18];
    }else{
        self.totalAmountLabel.font = [UIFont systemFontOfSize:20];
    }
    self.hotelBookForm.totalAmount = _orderPriceConfirm.totalPrice;
    
    
}

- (void)labelRollingHandle : (UILabel *) label {
    
    [label sizeToFit];
    CGFloat width = label.frame.size.width;
    CGFloat actualWidth = 182;
    if (width > actualWidth)
    {
        CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"position.x"];
        CGFloat totalTime = (width - actualWidth)/25 + 3;
        animation.duration = totalTime;
        animation.fillMode = kCAFillModeForwards;
        animation.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:width / 2],
                            [NSNumber numberWithFloat:width / 2],
                            [NSNumber numberWithFloat:actualWidth - width / 2],
                            [NSNumber numberWithFloat:actualWidth - width / 2],
                            [NSNumber numberWithFloat:width / 2], nil];
        animation.keyTimes = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0],
                              [NSNumber numberWithFloat:1/totalTime],
                              [NSNumber numberWithFloat:1/totalTime + ((totalTime - 2) / (totalTime * 2))],
                              [NSNumber numberWithFloat:2/totalTime + ((totalTime - 2) / (totalTime * 2))],
                              [NSNumber numberWithFloat:1.0], nil];
        animation.removedOnCompletion = NO;
        animation.repeatCount = HUGE_VALF;  //forever
        [label.layer addAnimation:animation forKey:nil];
    } else {
        [label.layer removeAllAnimations];
    }
}

- (void)handleBookingDescriptionParser:(NSDictionary *)data
{
    NSString *description = [data valueForKey:@"description"];
    NSString *activityArriveTime = [data valueForKey:@"activityArriveTime"];
    self.payFeedBackDesc = [data valueForKey:@"payFeedBackDesc"];
    self.isInActivity = YES;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *checkinDate = [formatter dateFromString:self.hotelBookForm.checkInDate];
    NSDate *activityLeaveTimeDate = [formatter dateFromString:activityArriveTime];
    
    NSDate *later = [checkinDate laterDate:activityLeaveTimeDate];
    
    if ([later isEqualToDate:activityLeaveTimeDate] && description != nil && description.length > 0) {
        CGRect rect = self.bookingBodyView.frame;
        self.bookingDescriptionLabel.text = description;
        self.bookingDescriptionLabel.hidden = NO;
        self.descriptionSeperateLine.hidden = NO;
        [UIView animateWithDuration:0.4 animations:^(void){
            self.bookingBodyView.frame = CGRectMake(rect.origin.x, rect.origin.y + 21, rect.size.width, rect.size.height);
            }];
    } else {
        self.bookingDescriptionLabel.text = @"";
    }
}

-(void)handleOrderPriceConfirmParser:(NSDictionary *)data parser:(GDataXMLParser *)parser {
    OrderPriceConfirm  *resultForm = [data valueForKey:kKeyOrderPriceConfirm];
    _orderPriceConfirm = resultForm;
    [self setTotalAmountLabelValueAndStyle];
    self.hotelBookForm.orderPriceConfirm = resultForm;
    if(resultForm && resultForm.payTypeList && [resultForm.payTypeList count] >0){
        _currentPayType = resultForm.payTypeList[0];
        
        if ([_currentPayType.name isEqualToString:@"GUARANTEE"] || [_currentPayType.name isEqualToString:@"PREPAYMENT"]) {
            self.payTypeNameLable.text = [NSString stringWithFormat:@"%@ (需在线支付)",_currentPayType.label];
            self.selectPayTypeLButton.frame = CGRectMake(218.0, -8.0, 73.0, 44.0);
            self.cancelPolicyLabel.textColor = [UIColor colorWithRed:243.0/255.0 green:152.0/255.0 blue:0.0 alpha:1.0];
            self.cancelPolicyDescLabel.textColor = [UIColor colorWithRed:243.0/255.0 green:152.0/255.0 blue:0.0 alpha:1.0];
        } else {
            self.payTypeNameLable.text = _currentPayType.label;
            self.selectPayTypeLButton.frame = CGRectMake(138.0, -8.0, 73.0, 44.0);
            self.cancelPolicyLabel.textColor = [UIColor colorWithRed:149.0/255.0 green:149.0/255.0 blue:149.0/255.0 alpha:1.0];
            self.cancelPolicyDescLabel.textColor = [UIColor colorWithRed:149.0/255.0 green:149.0/255.0 blue:149.0/255.0 alpha:1.0];
        }
        
        self.payTypeDescLable.text = [NSString stringWithFormat:@"%@",_currentPayType.description];
        [self labelRollingHandle : self.payTypeDescLable];
        self.cancelPolicyDescLabel.text = _currentPayType.cancelPolicyDesc;
        [self labelRollingHandle : self.cancelPolicyDescLabel];
        self.hotelBookForm.orderType = _currentPayType.name;
        self.hotelBookForm.payAmount = _currentPayType.amount;
    }
    
    [self changeTotalPriceLabelAndAddoriginPrice];
    [self changePayTypeForUseCoupon];
    
    if ([self canUseCoupon] && !TheAppDelegate.userInfo.isForGuestOrder) {
        [self loadCouponRuleList];
    } else {
        [self hideIndicatorView];
    }
}


-(void)handleLoadCouponRuleListParser:(NSDictionary *)data parser:(GDataXMLParser *)parser
{
    _couponRuleList = [self filterCouponRuleList:data];
    [self buildCouponList];
    [self hideIndicatorView];
}

-(NSArray *)filterCouponRuleList:(NSDictionary *)data
{
    NSMutableArray *couponRuleList =[data valueForKey:@"couponRuleList"];
    if ([couponRuleList count]==0) {
        return couponRuleList;
    }
    for (unsigned int i=0; i<[couponRuleList count]-1; i++)
    {
        for (unsigned int j =i+1; j<[couponRuleList count]; j++)
        {
            CouponRule *currentCouponRule = (CouponRule*)[couponRuleList objectAtIndex:i];
            CouponRule *nextCouponRule = (CouponRule*)[couponRuleList objectAtIndex:j];
            
            if ([currentCouponRule couponAmount] > [nextCouponRule couponAmount])
            {
                CouponRule *couponRule = [[CouponRule alloc] init];
                couponRule.couponAmount = currentCouponRule.couponAmount;
                couponRule.couponMaxNum = currentCouponRule.couponMaxNum;
                couponRule.couponRuleName = currentCouponRule.couponRuleName;
                couponRule.codeList = [[NSMutableArray alloc] initWithArray:currentCouponRule.codeList];
                [couponRuleList insertObject:couponRule atIndex:i];
                [couponRuleList removeObject:currentCouponRule];
            }
        }
    }
    return couponRuleList;
}

- (void)sendTraceInfoWithBookResult:(HotelBookResult *)bookResult
{
    self.traceParse = [[TraceParse alloc] init];
    
    ParameterManager *parameterManager = [[ParameterManager alloc] init];
    [parameterManager parserStringWithKey:@"mc" WithValue:TheAppDelegate.userInfo.uid];
    [parameterManager parserStringWithKey:@"oId" WithValue:bookResult.orderNo];
    [parameterManager parserIntegerWithKey:@"productId" WithValue:self.hotelBookForm.hotelId];
    [parameterManager parserStringWithKey:@"productRelaId" WithValue:@"1"];
    [parameterManager parserStringWithKey:@"category" WithValue:TRACE_CREATE_ORDER_LOCATION];
    [parameterManager parserStringWithKey:@"udp1" WithValue:[NSString stringWithFormat:@"%f, %f", TheAppDelegate.locationInfo.currentPoint.latitude, TheAppDelegate.locationInfo.currentPoint.longitude]];
    [parameterManager parserStringWithKey:@"udp2" WithValue:@"0"];
    [parameterManager parserStringWithKey:@"udp3" WithValue:@"0"];
    [parameterManager parserStringWithKey:@"p" WithValue:@"0"];
    [parameterManager parserStringWithKey:@"ref" WithValue:@"0"];
    [parameterManager parserStringWithKey:@"v" WithValue:@"1"];
    [parameterManager parserStringWithKey:@"u" WithValue:@"0"];
    self.traceParse.serverAddress = kUserTraceURL;
    self.traceParse.requestString = [parameterManager serialization];
    self.traceParse.delegate = self;
    
    [self.traceParse start];

}


- (void)handleCreateOrderParser:(NSDictionary *)data parser:(GDataXMLParser *)parser
{
    
    HotelBookResult *bookResult = [data valueForKey:kKeyHotelBookResult];
    
    [self sendTraceInfoWithBookResult:bookResult]; 
    
    if (bookResult.isMember && [bookResult.isMember isEqualToString:@"true"]) {
        [self initHotelBookForm];
        [self initBookInputView];
    }
    
    if (bookResult.orderNo != nil && [bookResult.code isEqualToString:@"0"])
    {
        if([@"UNPAY" isEqualToString:bookResult.orderStatus])
        {
            
            
            [self performSegueWithIdentifier:FROM_BOOK_TO_PAYMENT sender:bookResult];
        }
        else
        {
            [self performSegueWithIdentifier:@"OrderBookSuccessNoPaySegue" sender:bookResult];
            
        }
    }
    else if (![bookResult.code isEqualToString:@"10000"])
    {
        [self showAlertMessageWithOkButton:bookResult.message title:nil tag:0 delegate:nil];
    }
    else
    {
        [self showAlertMessageWithOkButton:kXMLParseFailAlertMessage title:nil tag:0 delegate:nil];
    }
}

-(void)handleOrderPriceConfirmFailed:(GDataXMLParser *)parser DidFailedParseWithMsg:(NSString *)msg errCode:(NSInteger)code
{
    [self hideIndicatorView];
    if ([parser isKindOfClass:[OrderPriceConfirmParser class]])
    {
        if(-1 == code)
        {
            [self showAlertMessageWithOkButton:@"因服务器繁忙,获取最新价格失败，请稍后再试" title:nil tag:0 delegate:nil];
        }
        else
        {
            [self showAlertMessageWithOkButton:msg title:nil tag:0 delegate:nil];
        }
        self.bookBtn.enabled = NO;
    }
}

-(void)handleCreateOrderFailed:(GDataXMLParser *)parser DidFailedParseWithMsg:(NSString *)msg errCode:(NSInteger)code
{
    if ([parser isKindOfClass:[CreateOrderParser class]])
    {
        [self showAlertMessageWithOkButton:msg title:nil tag:0 delegate:nil];
        [self hideIndicatorView];
        self.navigationItem.hidesBackButton = NO;
    }
}

-(void)handleLoadCouponRuleListFailed:(GDataXMLParser *)parser DidFailedParseWithMsg:(NSString *)msg errCode:(NSInteger)code
{
    [self hideIndicatorView];
}

- (IBAction)showPayTypeList:(id)sender
{
    [self showViewInSidebar:self.payTypeListViewController.view title:@"请选择支付方式"];
}

- (IBAction)showSpecialNeedList:(id)sender
{
    
    [self.checkPersonFieldTop resignFirstResponder];
    [self.checkPersonFieldMiddle resignFirstResponder];
    [self.checkPersonFieldBottom resignFirstResponder];

    [self.contactPersonField resignFirstResponder];
    [self.contactPersonMobileField resignFirstResponder];
    
    _specialNeedListViewController.roomCount = self.hotelBookForm.roomCount;
    [self showViewInSidebar:self.specialNeedListViewController.view title:@"特殊需求"];
}

- (ConditionView *)conditionView
{
    if (!_conditionView) {
        CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
        _conditionView = [[ConditionView alloc] initWithFrame:CGRectMake(320, 20, 285.0, screenRect.size.height + 20)];
        [self.navigationController.view.window addSubview:_conditionView];
        UISwipeGestureRecognizer *tapGR = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenRightView)];
        tapGR.direction = UISwipeGestureRecognizerDirectionRight;
        [_conditionView addGestureRecognizer:tapGR];
    }
    return _conditionView;
}

- (void)showViewInSidebar:(UIView *)view title:(NSString *)title {
    [self.conditionView addContentView:view];
    self.conditionView.title = title;
    
    self.view.userInteractionEnabled = NO;
    self.navigationController.navigationBar.userInteractionEnabled = NO;
    
    CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.conditionView.frame = CGRectMake(35, 20.0, 285.0, screenRect.size.height + 20);
    }                completion:^(BOOL finished) {
        self.conditionView.hidden = NO;
    }];
}

- (PayTypeListViewController *) payTypeListViewController
{
    if (!_payTypeListViewController)
    {
        _payTypeListViewController = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil]
                                      instantiateViewControllerWithIdentifier:@"PayTypeListViewController"];
        _payTypeListViewController.payTypeList = self.hotelBookForm.orderPriceConfirm.payTypeList;
        _payTypeListViewController.delegate = self;
    }
    return _payTypeListViewController;
}

- (SpecialNeedListViewController *) specialNeedListViewController
{
    if (!_specialNeedListViewController)
    {
    _specialNeedListViewController = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil]
                                      instantiateViewControllerWithIdentifier:@"SpecialNeedListViewController"];
    _specialNeedListViewController.delegate = self;
    _specialNeedListViewController.roomCount = self.hotelBookForm.roomCount;
    }
    return _specialNeedListViewController;
}

#pragma mark --useCoupon--resetUseCoupon
- (void)resetUseCoupon
{
    if([self hasUseCoupon]){
        _useCoupon.useCouponNum = 0;
        _useCoupon.couponAmount = 0;
        _useCoupon.totalAmount = 0;
    }
}

#pragma mark --useCouponAmountLabelStyle
- (void)noCouponAmountTotalAmountLabelStyle
{
    //    float amountX=22.0;
    //    float amountY = 360.0;
    //    float amountW = 139.0;
    //
    //    float amountLineW = 110.0;
    //    if ([_totalAmountLabel.text length] >8)
    //    {
    //        amountX = 18.0;
    //        amountW = 145.0;
    //        amountLineW = 120.0;
    //    }
    //    self.totalAmountLabel.frame = CGRectMake(amountX, amountY, amountW, 40.0);
    //    self.totalPriceLabelLine.frame = CGRectMake(0.0, 38.0, amountLineW, 1.0);

    self.originalPrice.hidden = YES;
    self.totalAmountLabel.frame = CGRectMake(self.totalAmountLabel.frame.origin.x, 10, self.totalAmountLabel.frame.size.width, self.totalAmountLabel.frame.size.height);
    self.totalPriceLabelLine.frame = CGRectMake(self.totalPriceLabelLine.frame.origin.x, 35, self.totalPriceLabelLine.frame.size.width, self.totalPriceLabelLine.frame.size.height);
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
        {
            break;
        }
        case 1:
        {
            [self buildSelectedPayTypeValue];
            [self setTotalAmountLabelValueAndStyle];
            self.originalPrice.hidden = YES;
            [self showHaveCouponImgTag];
            [self resetUseCoupon];
            if (self.usableCouponListViewController) {
                [self.usableCouponListViewController viewDidLoad];
                [self.usableCouponListViewController.couponListTableView reloadData];
            }
            break;
        }
        default:
        {
            break;
        }
    }
}


#pragma mark --loadCouponList--showHaveCouponImgTag
-(void)showHaveCouponImgTag
{
    _couponBtn.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"discount_coupon.png" ]];
    _totalCouponAmountLabel.hidden = YES;
    [self noCouponAmountTotalAmountLabelStyle];
}

#pragma mark --loadCouponList--hiddenNoCouponImgTag
-(void)hiddenNoCouponImgTag
{
    self.originalPrice.hidden = YES;
    [self.couponBtn setHidden:YES];
    _totalCouponAmountLabel.hidden = YES;
    [self noCouponAmountTotalAmountLabelStyle];
}

- (void)buildSelectedPayTypeValue
{
//    self.payTypeButton.titleLabel.text = _currentPayType.label;
    
    if ([_currentPayType.name isEqualToString:@"GUARANTEE"] || [_currentPayType.name isEqualToString:@"PREPAYMENT"]) {
        self.payTypeNameLable.text = [NSString stringWithFormat:@"%@ (需在线支付)",_currentPayType.label];
        self.selectPayTypeLButton.frame = CGRectMake(218.0, -8.0, 73.0, 44.0);
        self.cancelPolicyLabel.textColor = [UIColor colorWithRed:243.0/255.0 green:152.0/255.0 blue:0.0 alpha:1.0];
        self.cancelPolicyDescLabel.textColor = [UIColor colorWithRed:243.0/255.0 green:152.0/255.0 blue:0.0 alpha:1.0];
    }
    else
    {
        self.payTypeNameLable.text = _currentPayType.label;
        self.selectPayTypeLButton.frame = CGRectMake(138.0, -8.0, 73.0, 44.0);
        
        self.cancelPolicyLabel.textColor = [UIColor colorWithRed:149.0/255.0 green:149.0/255.0 blue:149.0/255.0 alpha:1.0];
        self.cancelPolicyDescLabel.textColor = [UIColor colorWithRed:149.0/255.0 green:149.0/255.0 blue:149.0/255.0 alpha:1.0];
    }
    
    NSString *payTypeDesc = [NSString stringWithFormat:@"%@", _currentPayType.description];
    
    self.payTypeDescLable.text = payTypeDesc;
    
    [self labelRollingHandle:self.payTypeDescLable];
    
    self.cancelPolicyDescLabel.text = _currentPayType.cancelPolicyDesc;
    
    [self labelRollingHandle:self.cancelPolicyDescLabel];
    
    self.hotelBookForm.orderType = _currentPayType.name;
    self.hotelBookForm.payAmount = _currentPayType.amount;
}

- (void) selectedPayType : (PayType *) payType
{
    _currentPayType = payType;
    if ([payType.name isEqualToString:@"PAYMENTING"] &&[self hasUseCoupon]) {
        UIAlertView *selectNoticeView = [[UIAlertView alloc] initWithTitle:@"提示信息" message:@"若要选择门店支付，您将无法使用优惠券"
                                                                  delegate:self cancelButtonTitle:@"取消" otherButtonTitles: nil];
        [selectNoticeView addButtonWithTitle:@"确定"];
        [selectNoticeView show];
    }else{
        [self buildSelectedPayTypeValue];
    }
    [self.bookingBodyView resignFirstResponder];
    [self hiddenRightView];
}

- (void)hiddenRightView
{
    CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.conditionView.frame = CGRectMake(320.0, 20.0, 285.0, screenRect.size.height + 20);
    }                completion:^(BOOL finished) {
        
        self.view.userInteractionEnabled = YES;
        self.navigationController.navigationBar.userInteractionEnabled = YES;
    }];
}

#pragma mark --usableCouponListViewController
- (UsableCouponListViewController *) usableCouponListViewController
{
    if (!_usableCouponListViewController)
    {
        _usableCouponListViewController = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil]
                                           instantiateViewControllerWithIdentifier:@"UsableCouponListViewController"];
        _usableCouponListViewController.couponList = self.couponList;
        _usableCouponListViewController.delegate = self;
    }
    return _usableCouponListViewController;
}

#pragma mark --loadCouponList--
-(void)loadCouponRuleList
{
    if (!_couponRuleListParser)
    {
        _couponRuleListParser = [[CouponRuleListParser alloc] init];
        _couponRuleListParser.delegate = self;
    }
    CouponRuleForm *couponRuleForm = [[CouponRuleForm alloc] init];
    couponRuleForm.orderAmount = [self.hotelBookForm.totalAmount intValue];
    couponRuleForm.numRoomNights = [self.hotelBookForm.nightNums intValue];
    couponRuleForm.dateCheckIn = self.hotelBookForm.checkInDate;
    couponRuleForm.payAmount = [self calculatePayAmount];
    couponRuleForm.bookModule = [JJHotel nameForOrigin:self.orderPriceConfirmForm.origin];
    [_couponRuleListParser couponRuleListRequest: couponRuleForm];
}


-(const unsigned int) calculatePayAmount
{
    return [self.hotelBookForm.totalAmount intValue];
}

#pragma mark --loadCouponList-- buildCouponList when couponRuleList not empty then show couponBtn
- (void)buildCouponList
{
    if(!_couponRuleList || [_couponRuleList count] ==0)
    {
        self.couponList = nil;
        [self setTotalAmountLabelValueAndStyle];
        [self hiddenNoCouponImgTag];
        [self resetUseCoupon];
        return;
    }
    NSMutableArray *orderCouponList = [[NSMutableArray alloc] initWithCapacity:100];
    for (CouponRule *couponRule in _couponRuleList)
    {
        OrderCoupon *orderCoupon = [[OrderCoupon alloc] init];
        orderCoupon.couponAmount = couponRule.couponAmount;
        orderCoupon.maxUseSize = couponRule.couponMaxNum;
        orderCoupon.canUseCoupon = [couponRule.codeList count];
        [orderCouponList addObject:orderCoupon];
    }
    self.couponList = orderCouponList;
    
    if(_couponList && [_couponList count] >0)
    {
        [self.couponBtn setHidden:NO];
    }
}

- (void)countAnalytics
{
    [[GAI sharedInstance].defaultTracker sendEventWithCategory:@"订单"
                                                    withAction:@"酒店订单录入页面提交订单"
                                                     withLabel:@"酒店订单提交订单按钮"
                                                     withValue:nil];
    
    [[GAI sharedInstance].defaultTracker sendEventWithCategory:@"订单"
                                                    withAction:@"酒店订单录入页面预订与所在城市"
                                                     withLabel:[NSString stringWithFormat: @"%@入住在%@预订%@的酒店",self.hotelBookForm.checkInDate,TheAppDelegate.locationInfo.cityName,TheAppDelegate.hotelSearchForm.cityName]
                                                     withValue:nil];
    [UMAnalyticManager eventCount:@"酒店订单录入页面提交订单" label:@"酒店订单录入页面提交订单按钮"];
    [UMAnalyticManager eventCount:@"酒店订单预订与所在城市" label:[NSString stringWithFormat: @"%@入住在%@预订%@的酒店",self.hotelBookForm.checkInDate,TheAppDelegate.locationInfo.cityName,TheAppDelegate.hotelSearchForm.cityName]];
}


- (IBAction) checkIsExistMember : (id)sender
{
    if (TheAppDelegate.userInfo.checkIsLogin) {
        
        return;
        
    }
    
    self.memberParser = [[MemberParser alloc] init];
    self.memberParser.delegate = self;
    [self.memberParser search:self.contactPersonMobileField.text];
}

-(void)handleMemberQueryParser:(NSDictionary *)data parser:(GDataXMLParser *)parser
{
    
    NSString *isMember = [data valueForKey:@"isMember"];
    
    if (isMember != nil && [isMember isEqualToString:@"true"]) {
        
        self.loginForGuestOrderContainerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 300.0, 400.0)];
        self.modeView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
        self.modeView.backgroundColor = [UIColor blackColor];
        self.modeView.alpha = 0.2;
        [self.navigationController.view.window addSubview:self.modeView];
        
        [self.loginForGuestOrderContainerView addSubview:self.loginForGuestOrderViewController.view];
        [self.navigationController.view.window addSubview:self.loginForGuestOrderContainerView];
    } else {
    }
}

- (LoginForGuestOrderViewController *)loginForGuestOrderViewController
{
    _loginForGuestOrderViewController = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil]
                                         instantiateViewControllerWithIdentifier:@"LoginForGuestOrderViewController"];
    _loginForGuestOrderViewController.delegate = self;
    _loginForGuestOrderViewController.view.frame = CGRectMake(0.0, 0.0, 300.0, 400.0);
    _loginForGuestOrderViewController.userName.text = self.contactPersonMobileField.text;
    return _loginForGuestOrderViewController;
}

- (void) guestLoginClose
{
    [self.loginForGuestOrderContainerView removeFromSuperview];
    [self.modeView removeFromSuperview];
    [self.contactPersonMobileField becomeFirstResponder];
}

- (void) guestLoginAfterProcess : (UserInfo *) userInfo
{
    [self.loginForGuestOrderContainerView removeFromSuperview];
    
    [self.modeView removeFromSuperview];
    
    self.checkPersonFieldBottom.text = userInfo.fullName;
    
    self.contactPersonField.text = userInfo.fullName;
    
    self.contactPersonMobileField.text = userInfo.mobile;
    
    userInfo.loginName = self.contactPersonMobileField.text;
    
    userInfo.flag = @"true";
    
    userInfo.isForGuestOrder = NO;
    
    TheAppDelegate.userInfo = userInfo;
    
    NSString *userCardType = TheAppDelegate.userInfo.cardType;
    
    if ([userCardType isEqualToString:(JBENEFITCARD)]  ||          //xiang
        [userCardType isEqualToString:(J2BENEFITCARD)] ||          //xiang-month
        [userCardType isEqualToString:(J8BENEFITCARD)]) {
        self.orderPriceConfirmForm = self.orderPriceConfirmForm == nil ? self.orderPriceConfirmForm : self.rcardPriceConfirmForm;
    }
    self.orderPriceConfirmForm.cardType = userCardType;
    
    if (self.orderPriceConfirmForm)
    {
        [self checkGuestPrice];
        self.orderPriceConfirmParser = [[OrderPriceConfirmParser alloc] init];
        self.orderPriceConfirmParser.delegate = self;
        [self.orderPriceConfirmParser priceConfirmRequest:self.orderPriceConfirmForm];
        [self showConfirmPriceIndicatorView];
        [self initHotelBookForm];
        [self initBookInputView];
        [self couponBtnInit];
    }
}

//修改UID供游客获取订单价格
- (void)checkGuestPrice
{
    if (TheAppDelegate.userInfo.isForGuestOrder) {
        TheAppDelegate.userInfo.uid = @"b34f9e36316b289c002c7c2e5b4c4c77";
    }
}

//游客UID更改回0
- (void)resetGuestUid
{
    if (TheAppDelegate.userInfo.isForGuestOrder) {
        TheAppDelegate.userInfo.uid = @"0";
        TheAppDelegate.userInfo.isForGuestOrder = NO;
    }
}

//当用户选择特殊要求选项
- (void) didDeterminSpecialNeeds : (NSString *) specialNeeds
{
    [self.sepecialButton setTitle:specialNeeds forState:UIControlStateNormal];

    self.hotelBookForm.specialNeeds = specialNeeds;
    [self hiddenRightView];    
}

//退出界面前，重置UID，重置游客识别字段
- (void)viewWillDisappear:(BOOL)animated
{
    [self resetGuestUid];
    [super viewWillDisappear:animated];
}

- (void)viewDidUnload {
    [self setCancelPolicyLabel:nil];
    [self setCancelPolicyDescLabel:nil];
    [self setTotalAmountLabel:nil];
    [self setView:nil];
    [self setCheckPersonLabelTop:nil];
    [self setCheckPersonLabelMiddle:nil];
    [self setCheckPersonLabelBottom:nil];
    [self setCheckPersonFieldTop:nil];
    [self setCheckPersonFieldMiddle:nil];
    [self setCheckPersonFieldBottom:nil];
    [self setScrollView:nil];
    [self setTopBackImage:nil];
    [self setViewForTwo:nil];
    [self setControlForPay:nil];
    [self setBookingDescriptionLabel:nil];
    [self setDescriptionSeperateLine:nil];
    [super viewDidUnload];
}
@end
