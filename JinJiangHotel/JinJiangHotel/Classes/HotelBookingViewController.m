//
//  HotelBookingViewController.m
//  JinJiangHotel
//
//  Created by jerry on 13-8-21.
//  Copyright (c) 2013年 jinjiang. All rights reserved.
//

#import "HotelBookingViewController.h"
#import "HotelDetailViewController.h"
#import "CreateOrderParser.h"
#import "OrderPriceConfirmParser.h"
#import "OrderPriceConfirm.h"
#import "UseCoupon.h"
#import "NSDateAdditions.h"
#import "HotelBookResult.h"
#import "TraceParse.h"
#import "CouponRuleListParser.h"
#import "CouponRule.h"

#define MAX_ROOM_COUNT 3
#define MIN_ROOM_COUNT 1

#define CHECK_PERSON_TWO_LABEL_TAG 201
#define CHECK_PERSON_TWO_IMAGE_TAG 202

#define CHECK_PERSON_THREE_LABEL_TAG 301
#define CHECK_PERSON_THREE_IMAGE_TAG 302


@interface HotelBookingViewController ()

@property (nonatomic, strong) NSDate *locationTime;
@property (nonatomic, strong) UIButton *doneInKeyboardButton;
@property (nonatomic, strong) TraceParse *traceParse;
@property (nonatomic, strong) OrderPriceConfirm *orderPriceConfirm;
@property (nonatomic, strong) PayType *currentPayType;
@property (nonatomic, strong) UseCoupon *useCoupon;
@property (nonatomic, strong) NSMutableArray *couponRuleList;
@property (nonatomic, strong) UIView *conditionView;
@property (nonatomic, strong) DayPriceDetailViewController *dayPriceDetailViewController;
@property (nonatomic,strong) UsableCouponListViewController *usableCouponListViewController;
@property (nonatomic, strong) PayTypeListViewController *payTypeListViewController;
@property (nonatomic, strong) CreateOrderParser *createOrderParser;
@property (nonatomic, strong) OrderPriceConfirmParser *orderPriceConfirmParser;
@property (nonatomic,strong) CouponRuleListParser *couponRuleListParser;

- (void) touchTotalPrice;

@end

@implementation HotelBookingViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {        
        //注册通知        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initNavigationBarWithStyle:JJTwoLineTilteBarStyle];
    
    self.navigationBar.mainLabel.text = NSLocalizedStringFromTable(@"hotel booking", @"HotelBooking", @"");
    self.navigationBar.subTitleLabel.frame = CGRectMake(0, 0, 250, 12);
    if (self.orderPriceConfirmForm)
    {
        self.orderPriceConfirmForm.roomCount = 1;
        self.orderPriceConfirmParser = [[OrderPriceConfirmParser alloc] init];
        self.orderPriceConfirmParser.delegate = self;
        [self initHotelBookForm];
        self.navigationBar.subTitleLabel.text = [NSString stringWithFormat:@"%@ %@", self.hotelBookForm.hotelName, self.hotelBookForm.roomName];
        NSURL* url = [NSURL URLWithString:self.orderPriceConfirmForm.imageUrl];
        NSData* imgData = [NSData dataWithContentsOfURL:url];
//        self.faceHotelImage.layer.cornerRadius = 3;
//        self.faceHotelImage.clipsToBounds = YES;
        self.faceHotelImage.image = [UIImage imageWithData:imgData];
        [self initBookInputView];
    }
    //加载视图内容信息
    [self loadScrollView];
	//隐藏优惠券选择视图
    [self hideConponViewFirst];
    //初始化日期控件
    self.kalManager = [[KalManager alloc] initWithViewController:self];
    self.kalManager.delegate = self;
    //每日价格明细
    UITapGestureRecognizer *touchTotalPrice =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchTotalPrice)];
    [self.totalPriceContainerView addGestureRecognizer:touchTotalPrice];
}

- (void)loadScrollView
{
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.bounces = NO;
    self.scrollView.contentSize=CGSizeMake(self.view.frame.size.width,746);
}

- (void)hideConponViewFirst
{
    self.couponView.hidden = YES;
    self.payTypeView.center = CGPointMake(self.payTypeView.center.x, self.payTypeView.center.y - 56);
    self.policyView.center = CGPointMake(self.policyView.center.x, self.policyView.center.y - 56);
}

//初始化 HotelBookForm
- (void)initHotelBookForm
{
    //初始化预定表单
    self.hotelBookForm = [[HotelBookForm alloc] init];
    self.hotelBookForm.hotelId = self.orderPriceConfirmForm.hotelId;
    self.hotelBookForm.hotelName = self.orderPriceConfirmForm.hotelName;
    self.hotelBookForm.planId = self.orderPriceConfirmForm.planId;
    self.hotelBookForm.roomName = self.orderPriceConfirmForm.roomName;
    self.hotelBookForm.roomCount = self.orderPriceConfirmForm.roomCount;
    self.hotelBookForm.numAdult = self.orderPriceConfirmForm.numAdult;
    self.hotelBookForm.checkInDate = self.orderPriceConfirmForm.checkInDate;
    self.hotelBookForm.checkOutDate = self.orderPriceConfirmForm.checkOutDate;
    NSString *isTempMember = TheAppDelegate.userInfo.isTempMember;
    if ([isTempMember isEqualToString:@"false"]) {
        self.hotelBookForm.checkInPersonName = TheAppDelegate.userInfo.fullName;
        self.hotelBookForm.contactPersonName = TheAppDelegate.userInfo.fullName;
    }
    self.hotelBookForm.contactPersonMobile = TheAppDelegate.userInfo.mobile;
    self.hotelBookForm.tempMemberFlag = isTempMember;
    self.hotelBookForm.nightNums = [NSString stringWithFormat:@"%d",TheAppDelegate.hotelSearchForm.nightNums];
    self.hotelBookForm.contactPersonEmail = TheAppDelegate.userInfo.email;
}

//初始化页面表单元素显示值
- (void)initBookInputView
{
    self.checkInDateLabel.text = self.hotelBookForm.checkInDate;
    self.checkOutDateLabel.text = self.hotelBookForm.checkOutDate;
    
    self.checkInWeekDayLabel.text = [self getCNWeek:[TheAppDelegate.hotelSearchForm.checkinDate NSDate]];
    self.checkOutWeekDayLabel.text = [self getCNWeek:[TheAppDelegate.hotelSearchForm.checkoutDate NSDate]];
    
    self.checkPersonNameOne.text = self.hotelBookForm.checkInPersonName;
    self.contactPersonName.text = self.hotelBookForm.contactPersonName;
    self.contactPersonPhone.text = self.hotelBookForm.contactPersonMobile;
    [self checkRoomCount:self.hotelBookForm.roomCount];
}

//价格明细
- (void) touchTotalPrice
{
    [self showViewInSidebar:self.dayPriceDetailViewController.view];
}

//条件视图组件
- (UIView *)conditionView
{
    if (!_conditionView) {
        CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
        _conditionView = [[UIView alloc] initWithFrame:CGRectMake(0, screenRect.size.height, self.view.frame.size.width, self.view.frame.size.height)];
        [self.view addSubview:_conditionView];
    }
    return _conditionView;
}

//每日价格明细视图
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
    
    return _dayPriceDetailViewController;
}

- (PayTypeListViewController *) payTypeListViewController
{
    _payTypeListViewController = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil]
                                  instantiateViewControllerWithIdentifier:@"PayTypeListViewController"];
    _payTypeListViewController.payTypeList = self.hotelBookForm.orderPriceConfirm.payTypeList;
    _payTypeListViewController.selectedPayType = self.currentPayType;
    _payTypeListViewController.delegate = self;
    return _payTypeListViewController;
}

- (UsableCouponListViewController *) usableCouponListViewController
{
    _usableCouponListViewController = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil]
                                       instantiateViewControllerWithIdentifier:@"UsableCouponListViewController"];
    _usableCouponListViewController.couponList = self.couponRuleList;
    _usableCouponListViewController.useCoupon = self.useCoupon;
    _usableCouponListViewController.delegate = self;
    return _usableCouponListViewController;
}

- (void)showViewInSidebar:(UIView *)view {
    [self.conditionView addSubview:view];
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.conditionView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }                completion:^(BOOL finished) {
        self.conditionView.hidden = NO;
    }];
}

- (void)hiddenConditionView
{
    CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.conditionView.frame = CGRectMake(0, screenRect.size.height, self.view.frame.size.width, self.view.frame.size.height);
    }                completion:NULL];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)datePickerClicked:(id)sender
{
    [self.kalManager pickDate];
}

- (IBAction)roomCountSubBtnClicked:(id)sender
{
    NSInteger currentRoomCount = self.roomCountLabel.text.integerValue;
    if (currentRoomCount <= MIN_ROOM_COUNT) {
        return;
    }
    currentRoomCount--;
    
    [self checkRoomCount:currentRoomCount];
    [self compressPersonInfoView:currentRoomCount];
}

- (IBAction)roomCountAddBtnClicked:(id)sender
{
    NSInteger currentRoomCount = self.roomCountLabel.text.integerValue;
    if (currentRoomCount >= MAX_ROOM_COUNT) {
        return;
    }
    currentRoomCount++;
    
    [self checkRoomCount:currentRoomCount];
    [self drawPersonInfoView:currentRoomCount];
}

//验证房间数量并更改订单信息
- (void)checkRoomCount:(NSInteger)currentRoomCount
{
    self.roomCountAddBtn.enabled = currentRoomCount - 2 > 0 ? NO : YES;
    self.roomCountSubBtn.enabled = currentRoomCount - 2 < 0 ? NO : YES;
    
    self.roomCountLabel.text = [NSString stringWithFormat:@"%d", currentRoomCount];
    
    self.hotelBookForm.roomCount = currentRoomCount;
    self.orderPriceConfirmForm.roomCount = currentRoomCount;
    
    [self loadRealTimeDapPrice];
}

- (void)loadRealTimeDapPrice
{
    [self.orderPriceConfirmParser priceConfirmRequest:self.orderPriceConfirmForm];
    [self showIndicatorView];
}

//拉伸视图，添加入住人信息
- (void)drawPersonInfoView:(NSInteger)currentRoomCount
{
    int pointY = 40;
    self.personInfoView.frame = CGRectMake(self.personInfoView.frame.origin.x, self.personInfoView.frame.origin.y, self.personInfoView.frame.size.width, self.personInfoView.frame.size.height + pointY);
    self.bottomView.center = CGPointMake(self.bottomView.center.x, self.bottomView.center.y + pointY);
    self.scrollView.contentSize=CGSizeMake(self.scrollView.contentSize.width, self.scrollView.contentSize.height + pointY);
    
    switch (currentRoomCount) {
        case 2:
        {
            UILabel *checkPersonLabel = [[UILabel alloc] initWithFrame:CGRectMake(32, 48, 63, 33)];
            checkPersonLabel.textColor = RGBCOLOR(160, 140, 25);
            checkPersonLabel.font = [UIFont systemFontOfSize:12];
            checkPersonLabel.text = NSLocalizedStringFromTable(@"check person two", @"HotelBooking", @"");
            checkPersonLabel.backgroundColor = [UIColor clearColor];
            checkPersonLabel.tag = CHECK_PERSON_TWO_LABEL_TAG;
            [self.personInfoView addSubview:checkPersonLabel];
            
            UIImageView *checkImageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 43, 304, 1)];
            checkImageView.image = [UIImage imageNamed:@"booking_arrow_cell"];
            checkImageView.tag = CHECK_PERSON_TWO_IMAGE_TAG;
            [self.personInfoView addSubview:checkImageView];
            
            self.checkPersonNameTwo.hidden = NO;
            break;
        }
        case 3:
        {
            UILabel *checkPersonLabel = [[UILabel alloc] initWithFrame:CGRectMake(32, 88, 63, 33)];
            checkPersonLabel.textColor = RGBCOLOR(160, 140, 25);
            checkPersonLabel.font = [UIFont systemFontOfSize:12];
            checkPersonLabel.text = NSLocalizedStringFromTable(@"check person three", @"HotelBooking", @"");
            checkPersonLabel.backgroundColor = [UIColor clearColor];
            checkPersonLabel.tag = CHECK_PERSON_THREE_LABEL_TAG;
            [self.personInfoView addSubview:checkPersonLabel];
            
            UIImageView *checkImageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 83, 304, 1)];
            checkImageView.image = [UIImage imageNamed:@"booking_arrow_cell"];
            checkImageView.tag = CHECK_PERSON_THREE_IMAGE_TAG;
            [self.personInfoView addSubview:checkImageView];
            
            self.checkPersonNameThree.hidden = NO;
            break;
        }
    }
    
}

//压缩视图，减少入住人信息
- (void)compressPersonInfoView:(NSInteger)currentRoomCount
{
    int pointY = 40;
    self.personInfoView.frame = CGRectMake(self.personInfoView.frame.origin.x, self.personInfoView.frame.origin.y, self.personInfoView.frame.size.width, self.personInfoView.frame.size.height - pointY);
    self.bottomView.center = CGPointMake(self.bottomView.center.x, self.bottomView.center.y - pointY);
    self.scrollView.contentSize=CGSizeMake(self.scrollView.contentSize.width, self.scrollView.contentSize.height - pointY);
    
    switch (currentRoomCount) {
        case 2:
        {
            [[self.personInfoView viewWithTag:CHECK_PERSON_THREE_LABEL_TAG] removeFromSuperview];
            [[self.personInfoView viewWithTag:CHECK_PERSON_THREE_IMAGE_TAG] removeFromSuperview];
            self.checkPersonNameThree.hidden = YES;
            break;
        }
        case 1:
        {
            [[self.personInfoView viewWithTag:CHECK_PERSON_TWO_LABEL_TAG] removeFromSuperview];
            [[self.personInfoView viewWithTag:CHECK_PERSON_TWO_IMAGE_TAG] removeFromSuperview];
            self.checkPersonNameTwo.hidden = YES;
            break;
        }
    }
}

//键盘NEXT事件处理
- (IBAction)keyboardNextPress:(UITextField *)textField
{
    [textField resignFirstResponder];
    NSInteger currentRoomCount = self.roomCountLabel.text.integerValue;
    
    if ([textField isEqual:self.checkPersonNameOne]) {
        
        if (currentRoomCount > 1) {
            [self.checkPersonNameTwo becomeFirstResponder];
        } else {
            [self.contactPersonName becomeFirstResponder];
        }
    } else if ([textField isEqual:self.checkPersonNameTwo]) {
        
        if (currentRoomCount > 2) {
            [self.checkPersonNameThree becomeFirstResponder];
        } else {
            [self.contactPersonName becomeFirstResponder];
        }
    } else if ([textField isEqual:self.checkPersonNameThree]) {
        [self.contactPersonName becomeFirstResponder];
    } else if ([textField isEqual:self.contactPersonName]) {
        [self.contactPersonPhone becomeFirstResponder];
    }
}

//输入获得焦点时，划动视图
- (IBAction)keyboardEditingDidBegin:(UITextField *)textField
{    
    if (self.doneInKeyboardButton && self.doneInKeyboardButton.superview)
    {
        [self.doneInKeyboardButton removeFromSuperview];
    }
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    float yMove = 321;
    if (rect.size.height > 480) {
        yMove = 290;
    }
    if (self.scrollView.contentOffset.y < yMove) {
        [UIView animateWithDuration:0.5
                              delay:0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             [self.scrollView setContentOffset:CGPointMake(0, yMove)];
                         } completion:NULL];
    }
    
    if ([textField isEqual:self.contactPersonPhone]) {
        [self performSelector:@selector(handleKeyboardDidShow) withObject:nil afterDelay:0.1];
    }
}


//控制是否显示优惠券视图
- (IBAction)couponButtonClicked:(id)sender
{
    NSTimeInterval intCurrentTime = [[NSDate date] timeIntervalSince1970];    
    if (self.locationTime == nil || (intCurrentTime - [self.locationTime timeIntervalSince1970]) > 1) {
        self.locationTime = [NSDate date];
        BOOL imageStatus = !self.couponView.hidden;
        if (imageStatus) {
            self.couponImageView.image = [UIImage imageNamed:@"room_arrow_close"];
            
            [UIView animateWithDuration:0.5
                                  delay:0
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                                 self.payTypeView.center = CGPointMake(self.payTypeView.center.x, self.payTypeView.center.y - 56);
                                 self.policyView.center = CGPointMake(self.policyView.center.x, self.policyView.center.y - 56);
                                 self.scrollView.contentSize=CGSizeMake(self.scrollView.contentSize.width, self.scrollView.contentSize.height - 56);
                             } completion:^(BOOL finished) {
                                 self.couponView.hidden = imageStatus;
                             }];
        } else {
            self.couponImageView.image = [UIImage imageNamed:@"room_arrow_open"];
            self.couponView.hidden = imageStatus;
            [UIView animateWithDuration:0.5
                                  delay:0
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                                 self.payTypeView.center = CGPointMake(self.payTypeView.center.x, self.payTypeView.center.y + 56);
                                 self.policyView.center = CGPointMake(self.policyView.center.x, self.policyView.center.y + 56);
                                 self.scrollView.contentSize=CGSizeMake(self.scrollView.contentSize.width, self.scrollView.contentSize.height + 56);
                             } completion:NULL];
        }
    }
}

//支付类型选择操作
- (IBAction)payTypeButtonClicked:(id)sender
{
    [self closeFirstResponderKeyboard];
    [self showViewInSidebar:self.payTypeListViewController.view];
}

//酒店下订单操作
- (IBAction)bookingHotelClicked:(id)sender
{
    if (self.useCoupon && self.useCoupon.couponAmount>0) {
        self.hotelBookForm.bookingModule = [JJHotel nameForOrigin:self.orderPriceConfirmForm.origin];
        self.hotelBookForm.couponCodes = self.useCoupon.codeList;
    }
    self.hotelBookForm.checkInPersonName = [self getCheckInPersonNamesFromFields:self.hotelBookForm.roomCount];
    self.hotelBookForm.contactPersonName = self.contactPersonName.text;
    self.hotelBookForm.contactPersonMobile = self.contactPersonPhone.text;
    
    if(![self.hotelBookForm verify])
    {   return; }
    
    self.createOrderParser = [[CreateOrderParser alloc] init];
    self.createOrderParser.delegate = self;
    [self.createOrderParser bookRequest:self.hotelBookForm];
    
    [self showIndicatorView];
}

//选择优惠券
- (IBAction)selectedCouponClicked:(id)sender
{
    [self closeFirstResponderKeyboard];
    [self showViewInSidebar:self.usableCouponListViewController.view];
}

- (void)closeFirstResponderKeyboard
{
    if ([self.checkPersonNameOne isFirstResponder]) {
        [self.checkPersonNameOne resignFirstResponder];
    }
    
    if ([self.checkPersonNameTwo isFirstResponder]) {
        [self.checkPersonNameTwo resignFirstResponder];
    }
    
    if ([self.checkPersonNameThree isFirstResponder]) {
        [self.checkPersonNameThree resignFirstResponder];
    }
    
    if ([self.contactPersonName isFirstResponder]) {
        [self.contactPersonName resignFirstResponder];
    }
    
    if ([self.contactPersonPhone isFirstResponder]) {
        [self.contactPersonPhone resignFirstResponder];
    }
}

- (NSString *)getCheckInPersonNamesFromFields:(NSInteger)roomCount
{
    NSString *resultNames = @"";
    
    switch (roomCount) {
        case 1:
        {
            resultNames = self.checkPersonNameOne.text;
            break;
        }
        case 2:
        {
            resultNames = [NSString stringWithFormat:@"%@,%@", self.checkPersonNameOne.text, self.checkPersonNameTwo.text];
            break;
        }
        case 3:
        {
            resultNames = [NSString stringWithFormat:@"%@,%@,%@", self.checkPersonNameOne.text, self.checkPersonNameTwo.text, self.checkPersonNameThree.text];
            break;
        }
        default:
            break;
    }
    
    return resultNames;
}

#pragma mark -loadCouponList
- (void)loadCouponRuleList
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

- (const unsigned int) calculatePayAmount
{
    return [self.hotelBookForm.totalAmount intValue];
}

#pragma mark - GDataXMLParserDelegate

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
}

-(void)handleOrderPriceConfirmParser:(NSDictionary *)data parser:(GDataXMLParser *)parser {
    OrderPriceConfirm  *resultForm = [data valueForKey:kKeyOrderPriceConfirm];
    self.orderPriceConfirm = resultForm;
    [self setTotalAmountLabelValueAndStyle];
    self.hotelBookForm.orderPriceConfirm = resultForm;
    
    if(resultForm && resultForm.payTypeList && [resultForm.payTypeList count] >0){
        self.currentPayType = resultForm.payTypeList[0];
        if ([self.currentPayType.name isEqualToString:@"GUARANTEE"] || [self.currentPayType.name isEqualToString:@"PREPAYMENT"]) {
            self.payTypeLabel.text = [NSString stringWithFormat:@"%@ (需在线支付)",self.currentPayType.label];
        } else {
            self.payTypeLabel.text = self.currentPayType.label;
        }
        
        self.payTypeDescLable.text = [NSString stringWithFormat:@"%@",self.currentPayType.description];
        self.cancelPolicyDescLabel.text = self.currentPayType.cancelPolicyDesc;
        self.hotelBookForm.orderType = self.currentPayType.name;
        self.hotelBookForm.payAmount = self.currentPayType.amount;
    }
    
    [self changePayTypeForUseCoupon];
    [self hideIndicatorView];
    //加载优惠券
    [self loadCouponRuleList];
}

//冒泡排序
-(void)handleLoadCouponRuleListParser:(NSDictionary *)data parser:(GDataXMLParser *)parser
{
    self.couponRuleList = [data valueForKey:@"couponRuleList"];
    int arraylength = self.couponRuleList.count;
    
    if (arraylength > 0) {
        for (int i=0; i < (arraylength - 1); i++) {
            for (int m=0; m < (arraylength-i-1); m++) {
                CouponRule *currentRule = self.couponRuleList[m];
                CouponRule *nextRule = self.couponRuleList[m+1];
                if (currentRule.couponAmount < nextRule.couponAmount) {
                    [self.couponRuleList replaceObjectAtIndex:m withObject:nextRule];
                    [self.couponRuleList replaceObjectAtIndex:(m+1) withObject:currentRule];
                }
            }
        }
    }
    
    [self buildCouponList];
}

- (void)buildCouponList
{
    if(!self.couponRuleList || [self.couponRuleList count] ==0)
    {
        [self resetUseCoupon];
        [self setTotalAmountLabelValueAndStyle];
        return;
    }
}

- (void)handleCreateOrderParser:(NSDictionary *)data parser:(GDataXMLParser *)parser
{
    
    HotelBookResult *bookResult = [data valueForKey:kKeyHotelBookResult];
    
    [self sendTraceInfoWithBookResult:bookResult];
    
    if (bookResult.orderNo != nil && [bookResult.code isEqualToString:@"0"])
    {
        [self showAlertMessage:@"预订酒店成功！"];
        
        if([@"UNPAY" isEqualToString:bookResult.orderStatus])
        {
            //跳转到支付页面
            //[self performSegueWithIdentifier:FROM_BOOK_TO_PAYMENT sender:bookResult];
        }
        else
        {
            //跳转到预定成功页面
            //[self performSegueWithIdentifier:@"OrderBookSuccessNoPaySegue" sender:bookResult];
            
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
    [self hideIndicatorView];
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

#pragma mark --changePayTypeForUseCoupon
-(void)changePayTypeForUseCoupon
{
    if ([self hasUseCoupon]) {
        NSMutableArray *payTypeList = self.hotelBookForm.orderPriceConfirm.payTypeList;
        for (PayType *tempPayType in payTypeList) {
            if ([tempPayType.name isEqualToString:@"GUARANTEE"]) {
                [self selectedPayType:tempPayType];
            }
        }
    }
}

#pragma mark - SelectUsableCouponDelegate
-(void)buildUseCoupon:(UseCoupon *)useCoupon
{
    if (useCoupon && useCoupon.totalAmount >0) {
        self.useCoupon = useCoupon;
        [self changePayTypeForUseCoupon];
        [self setTotalAmountLabelValueAndStyle];
        self.couponInfoLabel.text = [NSString stringWithFormat:@"%d元优惠券",self.useCoupon.totalAmount];
    } else {
        self.couponInfoLabel.text = @"";
        [self resetUseCoupon];
        [self setTotalAmountLabelValueAndStyle];
    }
    [self.usableCouponListViewController.view removeFromSuperview];
    [self hiddenConditionView];
}


#pragma mark - PayTypeListDelegate
- (void) selectedPayType : (PayType *) payType
{
    if (payType) {
        _currentPayType = payType;
        if ([payType.name isEqualToString:@"PAYMENTING"] &&[self hasUseCoupon]) {
            UIAlertView *selectNoticeView = [[UIAlertView alloc] initWithTitle:@"提示信息" message:@"若要选择门店支付，您将无法使用优惠券"
                                                                      delegate:self cancelButtonTitle:@"取消" otherButtonTitles: nil];
            [selectNoticeView addButtonWithTitle:@"确定"];
            [selectNoticeView show];
        }else{
            [self buildSelectedPayTypeValue];
        }
    }
    
    [self.payTypeListViewController.view removeFromSuperview];
    [self hiddenConditionView];
}

- (void)buildSelectedPayTypeValue
{
    if ([self.currentPayType.name isEqualToString:@"GUARANTEE"] || [self.currentPayType.name isEqualToString:@"PREPAYMENT"]) {
        self.payTypeLabel.text = [NSString stringWithFormat:@"%@ (需在线支付)",_currentPayType.label];
    }
    else
    {
        self.payTypeLabel.text = _currentPayType.label;
    }
    
    NSString *payTypeDesc = [NSString stringWithFormat:@"%@", _currentPayType.description];
    
    self.payTypeDescLable.text = payTypeDesc;
    self.cancelPolicyDescLabel.text = _currentPayType.cancelPolicyDesc;
    self.hotelBookForm.orderType = _currentPayType.name;
    self.hotelBookForm.payAmount = _currentPayType.amount;
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
            [self resetUseCoupon];
            self.couponInfoLabel.text = @"";
            [self buildSelectedPayTypeValue];
            [self setTotalAmountLabelValueAndStyle];
            break;
        }
        default:
        {
            break;
        }
    }
}

#pragma mark -hasUseCoupon
-(BOOL)hasUseCoupon
{
    return self.useCoupon && self.useCoupon.totalAmount >0;
}

#pragma mark --useCoupon--resetUseCoupon
- (void)resetUseCoupon
{
    if([self hasUseCoupon]){
        self.useCoupon.useCouponNum = 0;
        self.useCoupon.couponAmount = 0;
        self.useCoupon.totalAmount = 0;
        self.useCoupon.codeList = nil;
    }
}

- (void)setTotalAmountLabelValueAndStyle {
    
    NSUInteger totalPrice = [self.orderPriceConfirm.totalPrice integerValue];
    NSUInteger couponAmount = self.useCoupon.totalAmount;
    
    self.totalAmountLabel.text = [NSString stringWithFormat:@"￥%@",self.orderPriceConfirm.totalPrice];
    self.payAmountLabel.text = [NSString stringWithFormat:@"￥%d",totalPrice - couponAmount];
    self.hotelBookForm.totalAmount = self.orderPriceConfirm.totalPrice;
}

- (void)parser:(GDataXMLParser *)parser DidFailedParseWithMsg:(NSString *)msg errCode:(NSInteger)code {
    [self handleOrderPriceConfirmFailed:parser DidFailedParseWithMsg:msg errCode:code];
    [self handleCreateOrderFailed:parser DidFailedParseWithMsg:msg errCode:code];
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
    }
}

#pragma mark - KalManagerDelegate
- (void)manager:(KalManager *)manager didSelectMinDate:(NSDate *)minDate maxDate:(NSDate *)maxDate
{
    TheAppDelegate.hotelSearchForm.checkinDate = [KalDate dateFromNSDate:minDate];
    TheAppDelegate.hotelSearchForm.checkoutDate = [KalDate dateFromNSDate:maxDate];
    TheAppDelegate.hotelSearchForm.nightNums = self.kalManager.nightNums;
    [self fillCheckDate];
    [self loadRealTimeDapPrice];
}

#pragma mark - DayPriceDetailViewControllerDelegate
- (void) closeDayPriceDetailView;
{
    [self.dayPriceDetailViewController.view removeFromSuperview];
    [self hiddenConditionView];
}

- (void)fillCheckDate
{
    self.checkInDateLabel.text = [TheAppDelegate.hotelSearchForm.checkinDate chineseDescription];
    self.checkOutDateLabel.text = [TheAppDelegate.hotelSearchForm.checkoutDate chineseDescription];
    self.checkInWeekDayLabel.text = [self getCNWeek:[TheAppDelegate.hotelSearchForm.checkinDate NSDate]];
    self.checkOutWeekDayLabel.text = [self getCNWeek:[TheAppDelegate.hotelSearchForm.checkoutDate NSDate]];
    
    self.orderPriceConfirmForm.checkInDate = [TheAppDelegate.hotelSearchForm.checkinDate chineseDescription];
    self.orderPriceConfirmForm.checkOutDate = [TheAppDelegate.hotelSearchForm.checkoutDate chineseDescription];
    self.hotelBookForm.checkInDate = self.orderPriceConfirmForm.checkInDate;
    self.hotelBookForm.checkOutDate = self.orderPriceConfirmForm.checkOutDate;
    self.hotelBookForm.nightNums = [NSString stringWithFormat:@"%d",TheAppDelegate.hotelSearchForm.nightNums];
}

- (NSString *)getCNWeek:(NSDate *)nsDate
{
    const unsigned int weekday = [nsDate cc_weekday];
    NSString *cnWeek = @"";
    switch (weekday)
    {
        case 1:
        {   cnWeek = @"周日"; break;  }
        case 2:
        {   cnWeek = @"周一"; break;  }
        case 3:
        {   cnWeek = @"周二"; break;  }
        case 4:
        {   cnWeek = @"周三"; break;  }
        case 5:
        {   cnWeek = @"周四"; break;  }
        case 6:
        {   cnWeek = @"周五"; break;  }
        case 7:
        {   cnWeek = @"周六"; break;  }
    }
    
    return cnWeek;
}

#pragma mark keyboard finished button
- (void)handleKeyboardWillHide:(NSNotification *)notification
{
    if (self.doneInKeyboardButton.superview)
    {
        [self.doneInKeyboardButton removeFromSuperview];
    }
}

- (void)handleKeyboardDidShow
{
    if (self.doneInKeyboardButton == nil)
    {
        self.doneInKeyboardButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
        self.doneInKeyboardButton.frame = CGRectMake(0, screenHeight - 53, 106, 53);
        self.doneInKeyboardButton.adjustsImageWhenHighlighted = NO;
        [self.doneInKeyboardButton setImage:[UIImage imageNamed:@"btn_done_up"] forState:UIControlStateNormal];
        [self.doneInKeyboardButton setImage:[UIImage imageNamed:@"btn_done_down"] forState:UIControlStateHighlighted];
        [self.doneInKeyboardButton addTarget:self action:@selector(finishAction) forControlEvents:UIControlEventTouchUpInside];
    }
    if ([[[UIApplication sharedApplication] windows] count] > 1) {
        UIWindow* tempWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:1];
        if (self.doneInKeyboardButton.superview == nil)
        {
            [tempWindow addSubview:self.doneInKeyboardButton];
        }
    }
}

//关闭键盘
-(void)finishAction{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

- (IBAction)addContact:(UIButton *)sender
{
    ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc] init];
    picker.displayedProperties = [NSArray arrayWithObject:[NSNumber numberWithInt:kABPersonPhoneProperty]];
    picker.peoplePickerDelegate = self;
    [self presentModalViewController:picker animated:YES];
}

#pragma mark - ABPeoplePickerNavigationControllerDelegate
- (void) peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker {
    [self dismissModalViewControllerAnimated:YES];
}

- (BOOL) peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person {
    
    ABMutableMultiValueRef phoneMulti = ABRecordCopyValue(person, kABPersonPhoneProperty);
    NSMutableArray *phones = [[NSMutableArray alloc] init];
    
    for (int i=0; i<ABMultiValueGetCount(phoneMulti); i++) {
        NSString *aPhone = (__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(phoneMulti, i);
        NSString *aLabel = (__bridge_transfer NSString *)ABMultiValueCopyLabelAtIndex(phoneMulti, i);
        if([aLabel isEqualToString:@"_$!<Mobile>!$_"]){
            [phones addObject:aPhone];
        }
    }
    if([phones count]>0) {
        NSString *currentPhone = phones[0];
        self.contactPersonPhone.text = [currentPhone stringByReplacingOccurrencesOfString:@"-" withString:@""];
    }
    
    [self dismissModalViewControllerAnimated:YES];
    
    return NO;
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    return NO;
}

- (void)backButtonPressed
{
    [self backToController:HotelDetailViewController.class];
}

@end
