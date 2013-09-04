//
//  OrderResultViewController.m
//  JinJiangTravelPlus
//
//  Created by huguiqi on 12-12-18.
//  Copyright (c) 2012年 JinJiang. All rights reserved.
//


#import "OrderSuccessNoPayViewController.h"
#import "OrderPassbookForm.h"
#import "JJNavigationButton.h"
#import "JJHotel.h"
#import "SVProgressHUD.h"


@interface OrderSuccessNoPayViewController ()

@property (nonatomic, strong) NSTimer* timer;

@end

@implementation OrderSuccessNoPayViewController

static BOOL isPass = NO;
dispatch_queue_t generatePassQueue;

- (void)backToIndex:(id)sender
{
    [UMAnalyticManager eventCount:@"现付单预订成功页点击回首页" label:@"现付单预订成功页点击回首页按扭"];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.trackedViewName = @"酒店订单现付单完成页面";
    [super viewWillAppear:animated];
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if([OrderPassbookViewController canUsePassbook] && [self isSuportHotelBrand]){
        generatePassQueue = dispatch_queue_create("passQueue", NULL);
        dispatch_async(generatePassQueue, ^{
            [self initGeneratePassbook];
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([_showPassbookController readPassUrlFromLocal] || [_showPassbookController readPassFromLocal]) {
                    [self enablePassbookBtn];
                }
            });
        });
    }
}

-(BOOL)isSuportHotelBrand
{
    return ![self.hotelBrand caseInsensitiveCompare:@"JG"] == NSOrderedSame;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = nil;
    self.splitLine1.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dashed.png"]];
    self.splitLine2.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dashed.png"]];
//    self.bgView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"orderSuccess_bg.png"]];
    
    if(_bookForm)
    {
        [self initOrderSuccessView];
    }

    [self initBackToIndexBtn];
}


- (void)initOrderSuccessView
{
    NSString *isTempMember = TheAppDelegate.userInfo.isTempMember;
    if(isTempMember && [isTempMember caseInsensitiveCompare:@"true"] == NSOrderedSame){
        _fullNameLabel.text = TheAppDelegate.userInfo.loginName;
    }else{
        _fullNameLabel.text = TheAppDelegate.userInfo.fullName;
    }
    _fullNameLabel.textColor = [UIColor colorWithRed:0.25 green:0.54 blue:0.95 alpha:1.0];
    _hotelNameLabel.text = _bookForm.hotelName;
    _hotelNameLabel.textColor = [UIColor colorWithRed:0.25 green:0.54 blue:0.95 alpha:1.0];
    _roomNameLabel.text = _bookForm.roomName;
//    [self handleFontTooLongStyle];
    _roomNameLabel.textColor = [UIColor colorWithRed:0.25 green:0.54 blue:0.95 alpha:1.0];
    _roomCountLabel.text = [NSString stringWithFormat:@"%d",_bookForm.roomCount];
    _roomCountLabel.textColor = [UIColor colorWithRed:0.25 green:0.54 blue:0.95 alpha:1.0];
    _checkInDateLabel.text = _bookForm.checkInDate;
    _checkInDateLabel.textColor = [UIColor colorWithRed:0.25 green:0.54 blue:0.95 alpha:1.0];
    _checkOutDateLabel.text = _bookForm.checkOutDate;
    _checkOutDateLabel.textColor = [UIColor colorWithRed:0.25 green:0.54 blue:0.95 alpha:1.0];
    _nightsNumLabel.text = _bookForm.nightNums;
    _nightsNumLabel.textColor = [UIColor colorWithRed:0.25 green:0.54 blue:0.95 alpha:1.0];
    _contactMobileLabel.text = _bookForm.contactPersonMobile;
    _totalAmountLabel.text = [NSString stringWithFormat:@"%@元",_bookForm.totalAmount];
}


//- (void)handleLongHotelNameLabel
//{
//    _roomNameLabel.frame = CGRectMake(45.00, 115.00, 170.00, 20.00);
//    _roomCountLabel.frame = CGRectMake(234.00, 115.00, 15.00, 20.00);
//    _roomPerLabel.frame = CGRectMake(246, 115.00, 20.00, 20.00);
//}
//
//- (void)handleFontTooLongStyle
//{
//    if([_roomNameLabel.text length]>5 &&[_roomNameLabel.text length]<8){
//        _roomCountLabel.frame = CGRectMake(190.00, 115.00, 15.00, 20.00);
//        _roomPerLabel.frame = CGRectMake(203, 115.00, 20.00, 20.00);
//    }
//    if([_roomNameLabel.text length]>8 && [_roomNameLabel.text length]<12){
//        [self handleLongHotelNameLabel];
//    }
//    if([_roomNameLabel.text length]>=12){
//        _roomNameLabel.font = [UIFont systemFontOfSize:14];
//        [self handleLongHotelNameLabel];
//    }
//    if([_fullNameLabel.text length]>=8){
//        _fullNameLabel.font = [UIFont systemFontOfSize:14];
//    }
//}

- (void)enablePassbookBtn
{
    isPass = YES;
}

- (void)initGeneratePassbook
{
    if(!_showPassbookController){
        _showPassbookController = [[OrderPassbookViewController alloc] init];
        _showPassbookController.passbookForm = [self buildPassbookForm];
        _showPassbookController.showPassbookViewController = self;
    }
    [_showPassbookController generatePassbook];
}

- (OrderPassbookForm *)buildPassbookForm
{
    OrderPassbookForm *passbookForm = [[OrderPassbookForm alloc] init];
    passbookForm.orderNo=_bookForm.orderNo;
    passbookForm.roomType=_bookForm.roomName;
    passbookForm.hotelName=_bookForm.hotelName;
    passbookForm.checkInPerson = _bookForm.contactPersonName;
    passbookForm.nightsNum = _bookForm.nightNums;
    passbookForm.orderAmount = _bookForm.totalAmount;
    passbookForm.hotelBrand = self.hotelBrand;
    passbookForm.checkInDate = _bookForm.checkInDate;
    passbookForm.checkOutDate = _bookForm.checkOutDate;
    passbookForm.latitude = self.latitude;
    passbookForm.longitude = self.longitude;
    passbookForm.hotelAddress = self.hotelAddress;
    return passbookForm;
}

-(IBAction)clickAddToPassbook:(id)sender
{
    if (![OrderPassbookViewController canUsePassbook]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您的系统不支持passbook，请升级ios系统" delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    [SVProgressHUD show];
    dispatch_async(generatePassQueue, ^{
        [_showPassbookController addToPassbook];
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
    });
    
  
    [[GAI sharedInstance].defaultTracker sendEventWithCategory:@"酒店订单现付单完成页面"
                                                    withAction:@"passbook添加显示"
                                                     withLabel:@"passbook添加显示按钮"
                                                     withValue:nil];
    [UMAnalyticManager eventCount:@"酒店订单现付单passbook添加显示" label:@"酒店订单现付单passbook添加显示按钮"];
}

- (IBAction)navigateButtonPressed:(JJNavigationButton *)sender {
    JJHotel *hotelInfo = [[JJHotel alloc] init];
    hotelInfo.name = _bookForm.hotelName;
    hotelInfo.telphone = @"1010-1666";
    hotelInfo.coordinate = CLLocationCoordinate2DMake(self.latitude.floatValue, self.longitude.floatValue);
    
    if (hotelInfo){
        [[GAI sharedInstance].defaultTracker sendEventWithCategory:@"酒店订单现付单完成页面"
                                                        withAction:@"带我去酒店"
                                                         withLabel:[NSString stringWithFormat:@"带我去酒店，入住日期%@",_bookForm.checkInDate]
                                                         withValue:nil];
        [UMAnalyticManager eventCount:@"带我去酒店" label:[NSString stringWithFormat:@"带我去酒店按钮"]];
        [sender clickToNavigation:hotelInfo];
    }
}

-(void)initBackToIndexBtn
{
    self.navigationController.navigationBar.userInteractionEnabled = YES;
    self.navigationItem.leftBarButtonItem = nil;
    if (self.backToHomeBtn && self.backToHomeBtn.superview)
    {   [self.backToHomeBtn removeFromSuperview];
        [self.navigationItem setRightBarButtonItem:nil];
    }
    self.backToHomeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 42, 30)];
    [self.backToHomeBtn setBackgroundImage:[UIImage imageNamed:@"topbar_btn.png"] forState:UIControlStateNormal];
    [self.backToHomeBtn setTitle:@"确定" forState:UIControlStateNormal];
    [self.backToHomeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    self.backToHomeBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
    [self.backToHomeBtn addTarget:self action:@selector(backToIndex:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchDown];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.backToHomeBtn];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidDisappear:(BOOL)animated
{
    if ([OrderPassbookViewController canUsePassbook]) {
        dispatch_release(generatePassQueue);
    }
    [super viewDidDisappear:animated];
}

@end
