//
//  OrderDetailController.m
//  JinJiangTravelPlus
//
//  Created by 吕 硕 on 12-12-26.
//  Copyright (c) 2012年 JinJiang. All rights reserved.
//

#import "OrderDetailController.h"
#import "OderDetail.h"
#import "JinJiangBillCell.h"
#import "HotelDetailsViewController.h"
#import "JJHotel.h"
#import "PaymentGatewayListViewController.h"
#import "UnionPaymentForm.h"
#import "BillListController.h"
#import "Constants.h"
#import <QuartzCore/QuartzCore.h>

#import "NSDate+Categories.h"
#import "NSCalendar+Categories.h"
#import "SVProgressHUD.h"

const unsigned int cancelAlert = 90908;
static BOOL isPass = YES;

unsigned int isCanGenerate = 1;
//const unsigned int payedLabelTag0 = 9900;

@interface OrderDetailController ()

@property (nonatomic, strong)JJHotel *hotelInfo;

@property (weak, nonatomic) IBOutlet UILabel *orderNoLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderPrepayLabel;
@property (weak, nonatomic) IBOutlet UIButton *payButton;
@property (weak, nonatomic) IBOutlet UILabel *payTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *managementStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *hotelLabel;
@property (weak, nonatomic) IBOutlet UILabel *roomLabel;
@property (weak, nonatomic) IBOutlet UILabel *roomsLabel;
@property (weak, nonatomic) IBOutlet UILabel *checkInLabel;
@property (weak, nonatomic) IBOutlet UILabel *checkOutLabel;
@property (weak, nonatomic) IBOutlet UILabel *guestLabel;
@property (weak, nonatomic) IBOutlet UILabel *contactPersonLabel;
@property (weak, nonatomic) IBOutlet UILabel *mobileLabel;
@property (weak, nonatomic) IBOutlet UILabel *cancelPolicyDesc;
@property (weak, nonatomic) IBOutlet JJNavigationButton *navigateBtn;
@property (weak, nonatomic) IBOutlet UILabel *daysLabel;



- (void)cancelOrder;
//- (void)showHotelDetail;
- (void)uiKeyboardWillShow:(NSNotification*)notification;
- (void)uiKeyboardWillHide:(NSNotification*)notification;
//- (void)payButtonClicked:(id)sender;
- (void)backBillList;

-(IBAction)clickAddToPassbook;

@end

@implementation OrderDetailController

@synthesize oderDetailParser;
@synthesize hotelOverviewParser;
@synthesize orderNo;
@synthesize orderId;

@synthesize statusImg;
//@synthesize orderNoLabel;
//@synthesize orderTimeLabel;
//@synthesize orderPriceLabel;
//@synthesize orderPrepayLabel;
//@synthesize managementStatusLabel;
//@synthesize payTypeLabel;
//
//@synthesize cityLabel;
//@synthesize hotelLabel;
//@synthesize roomLabel;
//@synthesize roomsLabel;
//@synthesize checkinLabel;
//@synthesize checkoutLabel;
//@synthesize daysLabel;

//@synthesize cancelPolicyDesc;
@synthesize guaranteePolicyDesc;

//@synthesize guestLabel;
//@synthesize contactPersonLabe;
//@synthesize mobileLabel;

@synthesize cancelBtn;
@synthesize cancelView;
@synthesize orderDetail;
@synthesize status;
@synthesize hotelName;
@synthesize coverImage;


static int PAY_CONTROLLER_TAG = 1;
dispatch_queue_t generatePassQueue;

#pragma mark - init

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([FROM_ORDER_TO_HOTEL isEqualToString:segue.identifier] && self.hotelInfo) {
        HotelDetailsViewController* detailVC = segue.destinationViewController;
        [detailVC setHotel:self.hotelInfo];
        [detailVC setIsFromOrder:YES];
        [detailVC downloadData];
    } else if([FROM_ORDER_TO_PAY isEqualToString:segue.identifier]) {
        
        PaymentGatewayListViewController *orderResultViewController = segue.destinationViewController;
        orderResultViewController.navigationItem.title = @"在线支付";
        orderResultViewController.paymentForm = [[UnionPaymentForm alloc] init];
        orderResultViewController.paymentForm.orderNo = self.orderNo;
        orderResultViewController.paymentForm.orderId = self.orderId;
        orderResultViewController.paymentForm.hotelName = self.hotelName;
        orderResultViewController.paymentForm.orderAmount = [NSString stringWithFormat:@"%.0f", self.orderDetail.price];
        orderResultViewController.paymentForm.contactPhoneNumber = self.mobileLabel.text;
        orderResultViewController.paymentForm.source = @"orderCenter";
        orderResultViewController.departureSegueId = FROM_ORDER_TO_PAY;
        orderResultViewController.cancelPolicyText = self.orderDetail.cancelPolicyDesc;
        orderResultViewController.isInActivity = self.isInActivity;
        orderResultViewController.payFeedBackDesc = self.payFeedBackDesc;
        
        HotelBookForm *bookForm = [[HotelBookForm alloc] init];
        bookForm.orderNo = self.orderNo;
        orderResultViewController.bookForm = bookForm;
        
    }
    
}

- (void) backHome: (id) sender
{
    if (self.view.tag == PAY_CONTROLLER_TAG) {
        [self backBillList];
    }else{
        [super backHome:sender];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    self.trackedViewName = @"用户订单详情页面";
    [super viewWillAppear:animated];
    [self downloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];    [self setTitle:@"订单详情"];
    

//    const float priceR = 233.0f / 255.0f;
//    const float priceG = 107.0f / 255.0f;
//    const float priceB = 50.00f / 255.0f;
//    const unsigned int x1 = 112;

//    UIImageView* con1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 1, 320, 128)];
//    [con1 setBackgroundColor:[UIColor clearColor]];
//    [con1 setImage:[UIImage imageNamed:@"content-1.png"]];
//    [self.view addSubview:con1];
//
//    UIImageView* con2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 124, 320, 165)];
//    [con2 setBackgroundColor:[UIColor clearColor]];
//    [con2 setImage:[UIImage imageNamed:@"content-2.png"]];
//    [self.view addSubview:con2];
//
//    UIImageView* con3 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 287, 320, 130)];
//    [con3 setBackgroundColor:[UIColor clearColor]];
//    [con3 setImage:[UIImage imageNamed:@"content-3.png"]];
//    [self.view addSubview:con3];

//    const unsigned int xx = 29;
//    UILabel* lab1 = [[UILabel alloc] init];
//    [lab1 setFrame:CGRectMake(xx, 12, 100, 18)];
//    [lab1 setFont:[UIFont systemFontOfSize:16]];
//    [lab1 setBackgroundColor:[UIColor clearColor]];
//    [lab1 setTextAlignment:NSTextAlignmentLeft];
//    [lab1 setTextColor:[UIColor blackColor]];
//    [lab1 setText:@"订 单 号："];
//    [self.view addSubview:lab1];

//    self.orderNoLabel = [[UILabel alloc] init];
//    [self.orderNoLabel setFrame:CGRectMake(x1, 12, 150, 18)];
//    [self.orderNoLabel setFont:[UIFont systemFontOfSize:16]];
//    [self.orderNoLabel setBackgroundColor:[UIColor clearColor]];
//    [self.orderNoLabel setTextAlignment:NSTextAlignmentLeft];
//    [self.orderNoLabel setTextColor:[UIColor blackColor]];
//    [self.orderNoLabel setText:@""];
//    [self.view addSubview:self.orderNoLabel];

//    UILabel* lab2 = [[UILabel alloc] init];
//    [lab2 setFrame:CGRectMake(xx, 39, 100, 18)];
//    [lab2 setFont:[UIFont systemFontOfSize:16]];
//    [lab2 setBackgroundColor:[UIColor clearColor]];
//    [lab2 setTextAlignment:NSTextAlignmentLeft];
//    [lab2 setTextColor:[UIColor blackColor]];
//    [lab2 setText:@"预定时间："];
//    [self.view addSubview:lab2];

//    self.orderTimeLabel = [[UILabel alloc] init];
//    [self.orderTimeLabel setFrame:CGRectMake(x1, 39, 160, 18)];
//    [self.orderTimeLabel setFont:[UIFont systemFontOfSize:16]];
//    [self.orderTimeLabel setBackgroundColor:[UIColor clearColor]];
//    [self.orderTimeLabel setTextAlignment:NSTextAlignmentLeft];
//    [self.orderTimeLabel setTextColor:[UIColor blackColor]];
//    [self.orderTimeLabel setText:@""];
//    [self.view addSubview:self.orderTimeLabel];

//    UILabel* lab3 = [[UILabel alloc] init];
//    [lab3 setFrame:CGRectMake(xx, 66, 100, 18)];
//    [lab3 setFont:[UIFont systemFontOfSize:16]];
//    [lab3 setBackgroundColor:[UIColor clearColor]];
//    [lab3 setTextAlignment:NSTextAlignmentLeft];
//    [lab3 setTextColor:[UIColor blackColor]];
//    [lab3 setText:@"订单金额："];
//    [self.view addSubview:lab3];

//    self.orderPriceLabel = [[UILabel alloc] init];
//    [self.orderPriceLabel setFrame:CGRectMake(x1, 66, 70, 18)];
//    [self.orderPriceLabel setFont:[UIFont boldSystemFontOfSize:16]];
//    [self.orderPriceLabel setBackgroundColor:[UIColor clearColor]];
//    [self.orderPriceLabel setTextAlignment:NSTextAlignmentLeft];
//    [self.orderPriceLabel setTextColor:[UIColor colorWithRed:priceR green:priceG blue:priceB alpha:1]];
//    [self.orderPriceLabel setText:@""];
//    [self.view addSubview:self.orderPriceLabel];

//    UILabel* lab4 = [[UILabel alloc] init];
//    [lab4 setFrame:CGRectMake(xx, 93, 100, 18)];
//    [lab4 setFont:[UIFont systemFontOfSize:16]];
//    [lab4 setBackgroundColor:[UIColor clearColor]];
//    [lab4 setTextAlignment:NSTextAlignmentLeft];
//    [lab4 setTextColor:[UIColor blackColor]];
//    [lab4 setText:@"支付金额："];
//    [lab4 setTag:payedLabelTag0];
//    [self.view addSubview:lab4];

//    const CGRect frame1 = CGRectMake(260, 88, 45, 23);
//    UIButton* payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [payBtn setFrame:frame1];[payBtn setTag:payBtnTag];[payBtn setHidden:YES];
//    [payBtn setBackgroundImage:[UIImage imageNamed:@"blueBtn.png"] forState:UIControlStateNormal];
//    [payBtn addTarget:self action:@selector(payButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//    [payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [payBtn setTitle:@"支付" forState:UIControlStateNormal];
//    [payBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
//    [self.view addSubview:payBtn];

//    self.orderPrepayLabel = [[UILabel alloc] init];
//    [self.orderPrepayLabel setFrame:CGRectMake(x1, 93, 70, 18)];
//    [self.orderPrepayLabel setFont:[UIFont boldSystemFontOfSize:16]];
//    [self.orderPrepayLabel setBackgroundColor:[UIColor clearColor]];
//    [self.orderPrepayLabel setTextAlignment:NSTextAlignmentLeft];
//    [self.orderPrepayLabel setTextColor:[UIColor colorWithRed:priceR green:priceG blue:priceB alpha:1]];
//    [self.orderPrepayLabel setText:@""];
//    [self.view addSubview:self.orderPrepayLabel];

    const unsigned int statusX = JinJiangBillCellWidth - StatusImgSize - 8;
    self.statusImg = [[UIImageView alloc] init];
    [self.statusImg setBackgroundColor:[UIColor clearColor]];
    [self.statusImg setFrame:CGRectMake(statusX + 16, 2, StatusImgSize, StatusImgSize)];
    //[self.statusImg setImage:[UIImage imageNamed:@"已确认.png"]];
    [self.view addSubview:self.statusImg];

//    const unsigned int xxx = self.orderPrepayLabel.frame.origin.x + self.orderPrepayLabel.frame.size.width;
//    self.managementStatusLabel = [[UILabel alloc] init];
//    [self.managementStatusLabel setFrame:CGRectMake(xxx, 66, 120, 18)];
//    [self.managementStatusLabel setFont:[UIFont systemFontOfSize:16]];
//    [self.managementStatusLabel setBackgroundColor:[UIColor clearColor]];
//    [self.managementStatusLabel setTextAlignment:NSTextAlignmentLeft];
//    [self.managementStatusLabel setTextColor:[UIColor blackColor]];
//    [self.managementStatusLabel setText:@""];
//    [self.view addSubview:self.managementStatusLabel];//payTypeLabel

//    self.payTypeLabel = [[UILabel alloc] init];
//    [self.payTypeLabel setFrame:CGRectMake(xxx, 93, 120, 18)];
//    [self.payTypeLabel setFont:[UIFont systemFontOfSize:16]];
//    [self.payTypeLabel setBackgroundColor:[UIColor clearColor]];
//    [self.payTypeLabel setTextAlignment:NSTextAlignmentLeft];
//    [self.payTypeLabel setTextColor:[UIColor blackColor]];
//    [self.payTypeLabel setText:@""];
//    [self.view addSubview:self.payTypeLabel];

//    UILabel* lab21 = [[UILabel alloc] init];
//    [lab21 setFrame:CGRectMake(xx, 130, 100, 18)];
//    [lab21 setFont:[UIFont systemFontOfSize:16]];
//    [lab21 setBackgroundColor:[UIColor clearColor]];
//    [lab21 setTextAlignment:NSTextAlignmentLeft];
//    [lab21 setTextColor:[UIColor blackColor]];
//    [lab21 setText:@"入住城市："];
//    [self.view addSubview:lab21];

//    self.cityLabel = [[UILabel alloc] init];
//    [self.cityLabel setFrame:CGRectMake(x1, 130, 150, 18)];
//    [self.cityLabel setFont:[UIFont systemFontOfSize:16]];
//    [self.cityLabel setBackgroundColor:[UIColor clearColor]];
//    [self.cityLabel setTextAlignment:NSTextAlignmentLeft];
//    [self.cityLabel setTextColor:[UIColor blackColor]];
//    [self.cityLabel setText:@""];
//    [self.view addSubview:self.cityLabel];

//    UILabel* lab22 = [[UILabel alloc] init];
//    [lab22 setFrame:CGRectMake(xx, 152, 100, 18)];
//    [lab22 setFont:[UIFont systemFontOfSize:16]];
//    [lab22 setBackgroundColor:[UIColor clearColor]];
//    [lab22 setTextAlignment:NSTextAlignmentLeft];
//    [lab22 setTextColor:[UIColor blackColor]];
//    [lab22 setText:@"酒 店 名："];
//    [self.view addSubview:lab22];

//    self.hotelLabel = [[UILabel alloc] init];
//    [self.hotelLabel setFrame:CGRectMake(x1, 150, 185, 18)];
//    [self.hotelLabel setFont:[UIFont systemFontOfSize:16]];
//    [self.hotelLabel setBackgroundColor:[UIColor clearColor]];
//    [self.hotelLabel setTextAlignment:NSTextAlignmentLeft];
//    [self.hotelLabel setTextColor:[UIColor blackColor]];
//    [self.hotelLabel setText:@""];
//    [self.view addSubview:self.hotelLabel];

//    const unsigned int x2 = x1 + 185 - 12;
//    UIImageView* arrow2Img = [[UIImageView alloc] init];
//    [arrow2Img setFrame:CGRectMake(x2, 150, 18, 18)];
//    [arrow2Img setImage:[UIImage imageNamed:@"arrow2.png"]];
//    [self.view addSubview:arrow2Img];

//    UIButton* hotelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [hotelBtn setFrame:CGRectMake(x1, 150, 320-x1-10, 18)];
//    [hotelBtn setBackgroundColor:[UIColor clearColor]];
//    [hotelBtn setBackgroundImage:nil forState:UIControlStateNormal];
//    [hotelBtn setBackgroundImage:nil forState:UIControlStateHighlighted];
//    [hotelBtn setTitle:@"" forState:UIControlStateNormal];
//    [hotelBtn setTitle:@"" forState:UIControlStateHighlighted];
//    [hotelBtn setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
//    [hotelBtn setTitleColor:[UIColor clearColor] forState:UIControlStateHighlighted];
//    [hotelBtn addTarget:self action:@selector(showHotelDetail) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:hotelBtn];

//    UILabel* lab23 = [[UILabel alloc] init];
//    [lab23 setFrame:CGRectMake(xx, 176, 100, 18)];
//    [lab23 setFont:[UIFont systemFontOfSize:16]];
//    [lab23 setBackgroundColor:[UIColor clearColor]];
//    [lab23 setTextAlignment:NSTextAlignmentLeft];
//    [lab23 setTextColor:[UIColor blackColor]];
//    [lab23 setText:@"房       型："];
//    [self.view addSubview:lab23];

//    self.roomLabel = [[UILabel alloc] init];
//    [self.roomLabel setFrame:CGRectMake(x1, 176, 160, 18)];
//    [self.roomLabel setFont:[UIFont systemFontOfSize:16]];
//    [self.roomLabel setBackgroundColor:[UIColor clearColor]];
//    [self.roomLabel setTextAlignment:NSTextAlignmentLeft];
//    [self.roomLabel setTextColor:[UIColor blackColor]];
//    [self.roomLabel setText:@""];
//    [self.view addSubview:self.roomLabel];

//    self.roomsLabel = [[UILabel alloc] init];
//    [self.roomsLabel setFrame:CGRectMake(x2-18, 176, 36, 18)];
//    [self.roomsLabel setFont:[UIFont systemFontOfSize:16]];
//    [self.roomsLabel setBackgroundColor:[UIColor clearColor]];
//    [self.roomsLabel setTextAlignment:NSTextAlignmentRight];
//    [self.roomsLabel setTextColor:[UIColor blackColor]];
//    [self.roomsLabel setText:@""];
//    [self.view addSubview:self.roomsLabel];

//    UILabel* lab24 = [[UILabel alloc] init];
//    [lab24 setFrame:CGRectMake(xx, 201, 100, 18)];
//    [lab24 setFont:[UIFont systemFontOfSize:16]];
//    [lab24 setBackgroundColor:[UIColor clearColor]];
//    [lab24 setTextAlignment:NSTextAlignmentLeft];
//    [lab24 setTextColor:[UIColor blackColor]];
//    [lab24 setText:@"入住时间："];
//    [self.view addSubview:lab24];

//    self.checkinLabel = [[UILabel alloc] init];
//    [self.checkinLabel setFrame:CGRectMake(x1, 201, 160, 18)];
//    [self.checkinLabel setFont:[UIFont systemFontOfSize:16]];
//    [self.checkinLabel setBackgroundColor:[UIColor clearColor]];
//    [self.checkinLabel setTextAlignment:NSTextAlignmentLeft];
//    [self.checkinLabel setTextColor:[UIColor blackColor]];
//    [self.checkinLabel setText:@""];
//    [self.view addSubview:self.checkinLabel];

//    UILabel* lab25 = [[UILabel alloc] init];
//    [lab25 setFrame:CGRectMake(xx, 228, 100, 18)];
//    [lab25 setFont:[UIFont systemFontOfSize:16]];
//    [lab25 setBackgroundColor:[UIColor clearColor]];
//    [lab25 setTextAlignment:NSTextAlignmentLeft];
//    [lab25 setTextColor:[UIColor blackColor]];
//    [lab25 setText:@"离店时间："];
//    [self.view addSubview:lab25];

//    self.checkoutLabel = [[UILabel alloc] init];
//    [self.checkoutLabel setFrame:CGRectMake(x1, 228, 160, 18)];
//    [self.checkoutLabel setFont:[UIFont systemFontOfSize:16]];
//    [self.checkoutLabel setBackgroundColor:[UIColor clearColor]];
//    [self.checkoutLabel setTextAlignment:NSTextAlignmentLeft];
//    [self.checkoutLabel setTextColor:[UIColor blackColor]];
//    [self.checkoutLabel setText:@""];
//    [self.view addSubview:self.checkoutLabel];

//    self.daysLabel = [[UILabel alloc] init];
//    [self.daysLabel setFrame:CGRectMake(x2-18, 228, 36, 18)];
//    [self.daysLabel setFont:[UIFont systemFontOfSize:16]];
//    [self.daysLabel setBackgroundColor:[UIColor clearColor]];
//    [self.daysLabel setTextAlignment:NSTextAlignmentRight];
//    [self.daysLabel setTextColor:[UIColor blackColor]];
//    [self.daysLabel setText:@""];
//    [self.view addSubview:self.daysLabel];
    
//    self.cancelPolicyDesc = [[UILabel alloc] init];
//    [self.cancelPolicyDesc setFrame:CGRectMake(32, 245, 260, 36)];
//    self.cancelPolicyDesc.numberOfLines = 0;
//    self.cancelPolicyDesc.lineBreakMode = UILineBreakModeCharacterWrap;
//    [self.cancelPolicyDesc setFont:[UIFont systemFontOfSize:12]];
//    [self.cancelPolicyDesc setBackgroundColor:[UIColor clearColor]];
//    [self.cancelPolicyDesc setTextAlignment:NSTextAlignmentLeft];
//    [self.cancelPolicyDesc setTextColor:[UIColor darkGrayColor]];
//    [self.cancelPolicyDesc setText:@""];
//    [self.view addSubview:self.cancelPolicyDesc];

//    UILabel* lab31 = [[UILabel alloc] init];
//    [lab31 setFrame:CGRectMake(xx, 299, 100, 18)];
//    [lab31 setFont:[UIFont systemFontOfSize:16]];
//    [lab31 setBackgroundColor:[UIColor clearColor]];
//    [lab31 setTextAlignment:NSTextAlignmentLeft];
//    [lab31 setTextColor:[UIColor blackColor]];
//    [lab31 setText:@"客户姓名："];
//    [self.view addSubview:lab31];

//    self.guestLabel = [[UILabel alloc] init];
//    [self.guestLabel setFrame:CGRectMake(x1, 299, 160, 18)];
//    [self.guestLabel setFont:[UIFont systemFontOfSize:16]];
//    [self.guestLabel setBackgroundColor:[UIColor clearColor]];
//    [self.guestLabel setTextAlignment:NSTextAlignmentLeft];
//    [self.guestLabel setTextColor:[UIColor blackColor]];
//    [self.guestLabel setText:@""];
//    [self.view addSubview:self.guestLabel];

//    UILabel* lab32 = [[UILabel alloc] init];
//    [lab32 setFrame:CGRectMake(xx, 324, 100, 18)];
//    [lab32 setFont:[UIFont systemFontOfSize:16]];
//    [lab32 setBackgroundColor:[UIColor clearColor]];
//    [lab32 setTextAlignment:NSTextAlignmentLeft];
//    [lab32 setTextColor:[UIColor blackColor]];
//    [lab32 setText:@"联 系 人："];
//    [self.view addSubview:lab32];

//    self.contactPersonLabe = [[UILabel alloc] init];
//    [self.contactPersonLabe setFrame:CGRectMake(x1, 324, 160, 18)];
//    [self.contactPersonLabe setFont:[UIFont systemFontOfSize:16]];
//    [self.contactPersonLabe setBackgroundColor:[UIColor clearColor]];
//    [self.contactPersonLabe setTextAlignment:NSTextAlignmentLeft];
//    [self.contactPersonLabe setTextColor:[UIColor blackColor]];
//    [self.contactPersonLabe setText:@""];
//    [self.view addSubview:self.contactPersonLabe];

//    UILabel* lab33 = [[UILabel alloc] init];
//    [lab33 setFrame:CGRectMake(xx, 349, 100, 18)];
//    [lab33 setFont:[UIFont systemFontOfSize:16]];
//    [lab33 setBackgroundColor:[UIColor clearColor]];
//    [lab33 setTextAlignment:NSTextAlignmentLeft];
//    [lab33 setTextColor:[UIColor blackColor]];
//    [lab33 setText:@"手 机 号："];
//    [self.view addSubview:lab33];

//    self.mobileLabel = [[UILabel alloc] init];
//    [self.mobileLabel setFrame:CGRectMake(x1, 349, 160, 18)];
//    [self.mobileLabel setFont:[UIFont systemFontOfSize:16]];
//    [self.mobileLabel setBackgroundColor:[UIColor clearColor]];
//    [self.mobileLabel setTextAlignment:NSTextAlignmentLeft];
//    [self.mobileLabel setTextColor:[UIColor blackColor]];
//    [self.mobileLabel setText:@""];
//    [self.view addSubview:self.mobileLabel];



    const unsigned int hhh = self.view.frame.size.height;
    self.coverImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, hhh)];
    [self.coverImage setImage:[UIImage imageNamed:@"cover_x.png"]];
    [self.coverImage setHidden:YES];
    [self.view addSubview:self.coverImage];


    NSNotificationCenter* notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(uiKeyboardWillShow:)
                               name:UIKeyboardWillShowNotification object:nil];
    [notificationCenter addObserver:self selector:@selector(uiKeyboardWillHide:)
                               name:UIKeyboardWillHideNotification object:nil];

    [self downloadData];
	// Do any additional setup after loading the view.
  
}

- (void)initCancelView
{
    const unsigned int centerY = (self.view.frame.size.height / 2) - 38;
    
    self.cancelView = [[OrderCancelView alloc] init];
    [self.cancelView setCenter:CGPointMake(160, centerY)];
    [self.cancelView setOrderNo:self.orderNo];
    [self.cancelView setOrderID:self.orderId];
    [self.cancelView setCancelPolicyText:self.orderDetail.cancelPolicyDesc];
    [self.cancelView setDelegate:self];
    [self.cancelView setHidden:YES];
    [self.view addSubview:self.cancelView];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:USER_DEVICE_5])
    {
        [self.cancelView setCenter:CGPointMake(self.cancelView.center.x, centerY - 22)];
    }
}

- (void)addRightBarButton
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 业务逻辑

- (void)downloadData
{
    if (!self.oderDetailParser)
    {
        self.oderDetailParser = [[OderDetailParser alloc] init];
        self.oderDetailParser.isHTTPGet = YES;
        self.oderDetailParser.serverAddress = kHotelOrderDetailURL;
    }

    [self.oderDetailParser setRequestString:[NSString stringWithFormat:@"orderNo=%@", self.orderNo]];
    [self.oderDetailParser setDelegate:self];   [self.oderDetailParser start]; [self showIndicatorView];
}

- (void)parser:(GDataXMLParser*)parser DidParsedData:(NSDictionary *)data
{
    if ([parser isKindOfClass:[OderDetailParser class]])
    {
        order = [data objectForKey:@"order"];
        [self setStatus:order.status];
        switch (order.status)
        {
            case CONFIRM:
            {   [self.statusImg setImage:[UIImage imageNamed:@"confirmed_corner.png"]];
                [self showPassbookBtn];
                break;
            }
            case CANCEL:
            {   [self.statusImg setImage:[UIImage imageNamed:@"canced_corner.png"]];
                [self hiddenPassbookRow];
                break;
            }
            case FAIL:
            {
                [self.statusImg setImage:[UIImage imageNamed:@"orderFailed_corner.png"]];
                [self hiddenPassbookRow];
                break;
            }
            case UNPAY:
            {   [self.statusImg setImage:[UIImage imageNamed:@"unpay_corner.png"]];
                [self showPassbookBtn];
                break;
            }
            case PAY_SUCCESS:
            {   [self.statusImg setImage:[UIImage imageNamed:@"pay_success_corner.png"]];
                [self showPassbookBtn];
                break;
            }
            case PAY_FAILURE:
            {   [self.statusImg setImage:[UIImage imageNamed:@"pay_failure_corner.png"]];
                [self hiddenPassbookRow];   
                break;
            }
            case REFUND_ALREADY:
            {   [self.statusImg setImage:[UIImage imageNamed:@"refund.png"]];
                [self hiddenPassbookRow];
                break;
            }
            case REFUND_SUCCESS:
            {   [self.statusImg setImage:[UIImage imageNamed:@"refund-success.png"]];
                [self hiddenPassbookRow];
                break;
            }
            default:
            {   break;  }
        }
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSDate* checkOutDate = [formatter dateFromString:order.checkOut];
        NSDate* today   = [NSDate date];
        
        if (order.status == CONFIRM || order.status == UNPAY ||
            order.status == PAY_SUCCESS || order.status == PAY_FAILURE)
        {
            if ([checkOutDate compare:today] == NSOrderedDescending)
            {
                self.cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
                [self.cancelBtn setBackgroundImage:[UIImage imageNamed:@"cancel.png"] forState:UIControlStateNormal];
                [self.cancelBtn addTarget:self action:@selector(cancelOrder) forControlEvents:UIControlEventTouchUpInside];
                 self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.cancelBtn];
                
                if (order.status == UNPAY || order.status == PAY_FAILURE)
                {
                    [self.payButton setHidden:NO];
                }
                else
                {
                    [self.payButton setHidden:YES];
                }
            }
            else
            {
                [self.payButton setHidden:YES];
            }
        }
        else
        {
            if (self.cancelBtn && self.cancelBtn.superview)
            {   [self.cancelBtn removeFromSuperview]; [self.navigationItem setRightBarButtonItem:nil];  }
            [self.payButton setHidden:YES];
        }
        
        NSString *guestNames = @"";
        for (NSString *guestName in order.guests) {
            guestNames = [guestNames stringByAppendingString:@","];
            guestNames = [guestNames stringByAppendingString:guestName];
        }
        
        [self.orderNoLabel      setText:order.orderNo];
        [self.orderTimeLabel    setText:order.entryDateTime];
        [self.orderPriceLabel   setText:[NSString stringWithFormat:@"￥%.0f", order.price]];
        [self.orderPrepayLabel  setText:[NSString stringWithFormat:@"￥%.0f", order.paymentAmount]];
        [self.hotelLabel        setText:order.hotelNm];
        [self.cityLabel         setText:order.cityNm];
        [self.checkInLabel      setText:order.checkin];
        [self.checkOutLabel     setText:order.checkOut];
        [self.roomLabel         setText:order.roomName];
        [self.roomsLabel        setText:[NSString stringWithFormat:@"%d间", order.rooms]];
        [self.guestLabel        setText:[guestNames substringFromIndex:1]];
        [self.contactPersonLabel setText:order.contactPersonName];
        [self.mobileLabel       setText:order.contactPersonMobile];
        [self.cancelPolicyDesc  setText:[NSString stringWithFormat:@"取消政策：%@", order.cancelPolicyDesc]];
        [self.guaranteePolicyDesc setText:order.guaranteePolicyDesc];
        [self setHotelName:order.hotelNm];
        [self setOrderDetail:order];
        TheAppDelegate.hotelSearchForm.cityName = [order.cityNm stringByReplacingOccurrencesOfString:@"市" withString:@""];
        
        [self initHotelDetail];
        [self initCancelView];
        
    }
    else if  ([parser isKindOfClass:([HotelOverviewParser class])])
    {
        self.hotelInfo = [data objectForKey:@"hotel"];
        kPrintfInfo;
        [self hideIndicatorView];
        if (![self isExistPassFromLocal] && [OrderPassbookViewController canUsePassbook] && isCanGenerate == 1) {
            [self generatePassbook];
        }
    }
}

- (void)cancelOrder
{
    
    [[GAI sharedInstance].defaultTracker sendEventWithCategory:@"订单"
                                                    withAction:@"取消"
                                                     withLabel:@"取消酒店订单按钮"
                                                     withValue:nil];
    [UMAnalyticManager eventCount:@"取消订单" label:@"酒店订单详情页面取消订单按钮"];
    
    [self.cancelView setHidden:NO];
    [self.coverImage setHidden:NO];
    self.passbookBtn.enabled = NO;
}

- (IBAction)payButtonClicked:(UIButton *)sender {
    
    [[GAI sharedInstance].defaultTracker sendEventWithCategory:@"订单"
                                                    withAction:@"在线支付"
                                                     withLabel:@"酒店订单详情页面在线支付按钮"
                                                     withValue:nil];
    [UMAnalyticManager eventCount:@"订单详情点击在线支付" label:@"酒店订单详情页面在线支付按钮"];
    
    [self performSegueWithIdentifier:FROM_ORDER_TO_PAY sender:self];

}

- (void)initHotelDetail
{
    if (!self.hotelOverviewParser)
    {
        self.hotelOverviewParser = [[HotelOverviewParser alloc] init];
        self.hotelOverviewParser.isHTTPGet = NO;
        self.hotelOverviewParser.serverAddress = [kHotelOverviewURL stringByAppendingPathComponent:
                                                  [NSString stringWithFormat:@"%d", order.hotelIdInt]];
    }
    
    self.hotelOverviewParser.delegate = self;
    [self.hotelOverviewParser start];
}
- (IBAction)showHotelDetail:(UIButton *)sender {
    [self performSegueWithIdentifier:FROM_ORDER_TO_HOTEL sender:self];
}


- (void)orderCancelView:(OrderCancelView*)orderCancelView didCancelOrder:(NSString*)message
{
    [self hideIndicatorView];[self.cancelView setHidden:YES];[self.coverImage setHidden:YES];[self downloadData];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:message
                                                       delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView setTag:cancelAlert]; [alertView show];
}

- (void)orderCancelView:(OrderCancelView*)orderCancelView didReturnToController:(NSString*)orderNo
{
    [self.cancelView setHidden:YES];[self.coverImage setHidden:YES];
    self.passbookBtn.enabled = YES;
}

- (void)orderCancelView:(OrderCancelView*)orderCancelView willCancelOrder:(NSString*)message
{
    [self showIndicatorView];
}

- (void)uiKeyboardWillShow:(NSNotification*)notification
{
    if(notification && self.cancelView.hidden == NO)
    {
        const unsigned int hh = [[[[UIApplication sharedApplication] windows] objectAtIndex:0] frame].size.height;
        const unsigned int yy = (hh / 2) - 38;
        if ([[NSUserDefaults standardUserDefaults] boolForKey:USER_DEVICE_5] == NO)
        {   [self.cancelView setCenter:CGPointMake(self.cancelView.center.x, yy - 74)];   }
    }
}

- (void)uiKeyboardWillHide:(NSNotification*)notification
{
    if(notification && self.cancelView.hidden == NO)
    {
        const unsigned int hh = [[[[UIApplication sharedApplication] windows] objectAtIndex:0] frame].size.height;
        const unsigned int yy = (hh / 2) - 38;
        if ([[NSUserDefaults standardUserDefaults] boolForKey:USER_DEVICE_5] == NO)
        {   [self.cancelView setCenter:CGPointMake(self.cancelView.center.x, yy)];    }
    }
}

- (void)backBillList
{
    
    HotelDetailsViewController* detailVC = (HotelDetailsViewController *) [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil]
                                                                           instantiateViewControllerWithIdentifier:@"BillListController"];
    [self.navigationController popToViewController:detailVC animated:YES];
    
}



- (IBAction)navigateToHotelAddress:(id)sender {
    if (self.hotelInfo){
        [[GAI sharedInstance].defaultTracker sendEventWithCategory:@"酒店订单现付单完成页面"
                                                        withAction:@"带我去酒店"
                                                         withLabel:@"带我去酒店按钮"
                                                         withValue:nil];
        [UMAnalyticManager eventCount:@"带我去酒店" label:[NSString stringWithFormat:@"带我去酒店按钮"]];
        [self.navigateBtn clickToNavigation:_hotelInfo];
    }
//    NSDateFormatter *format = [[NSDateFormatter alloc] init];
//    [format setDateFormat:@"yyyy-MM-dd"];
//    
//    NSString *dateString = [format stringFromDate:[NSDate date]];
//    if ([order.checkin isEqualToString:dateString])
//    {
//    }
}


-(void)buildPassbookForm
{
    if (!_passbookForm) {
        OrderPassbookForm *passbookForm = [[OrderPassbookForm alloc] init];
        passbookForm.orderNo = self.orderNo;
        _passbookForm = passbookForm;
    }
}

-(void)buildGeneratePassbookForm
{
    _passbookForm.roomType = self.orderDetail.roomName;
    _passbookForm.hotelName= self.hotelInfo.name;
    _passbookForm.checkInPerson = self.orderDetail.guestName;
    _passbookForm.checkInDate = self.orderDetail.checkin;
    _passbookForm.checkOutDate = self.orderDetail.checkOut;
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSDate *startDate = [df dateFromString:self.orderDetail.checkin];
    NSDate *endDate = [df dateFromString:self.orderDetail.checkOut];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSInteger days = [gregorian daysFromDate:startDate toDate:endDate];
    
    _passbookForm.nightsNum = [NSString stringWithFormat:@"%i",days];
    long priceInt = self.orderDetail.price;
    _passbookForm.orderAmount = [NSString stringWithFormat:@"%li",priceInt];
    _passbookForm.latitude = [NSString stringWithFormat:@"%f",self.hotelInfo.coordinate.latitude];
    _passbookForm.longitude = [NSString stringWithFormat:@"%f",self.hotelInfo.coordinate.longitude];
    _passbookForm.hotelAddress = self.hotelInfo.address;
    _passbookForm.hotelBrand = [JJHotel nameForBrand:self.hotelInfo.brand];
}

-(IBAction)clickAddToPassbook
{
    if (![OrderPassbookViewController canUsePassbook]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您的系统不支持passbook，请升级ios系统" delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    if (isPass) {
         [_showPassbookController addToPassbook];
    }else{
        [SVProgressHUD show];
        generatePassQueue = dispatch_queue_create("passQueue", NULL);
        dispatch_async(generatePassQueue, ^{
            [_showPassbookController addToPassbook];
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
            });
        });
        if (generatePassQueue != nil) {
            dispatch_release(generatePassQueue);
        }
    }
    
    [[GAI sharedInstance].defaultTracker sendEventWithCategory:@"用户订单详情页面"
                                                    withAction:@"passbook添加显示"
                                                     withLabel:@"passbook添加显示按钮"
                                                     withValue:nil];
    [UMAnalyticManager eventCount:@"passbook添加显示" label:@"passbook添加显示按钮"];
}

- (void)passbookInitController
{
    if(!_showPassbookController){
        _showPassbookController = [[OrderPassbookViewController alloc] init];
        [self buildPassbookForm];
        _showPassbookController.passbookForm = _passbookForm;
        _showPassbookController.showPassbookViewController = self;
    }
    if ([self isExistPassFromLocal]) {
        [_showPassbookController filterPassData];
        [self enablePassbook];
    }
}

-(BOOL)isExistPassFromLocal{
    return [_showPassbookController readPassUrlFromLocal] || [_showPassbookController readPassFromLocal];
}

-(void)generatePassbook
{
    [self buildGeneratePassbookForm];
    if([self isSuportHotelBrand]){
        [self disablePassbook];
        generatePassQueue = dispatch_queue_create("passQueue", NULL);
        dispatch_async(generatePassQueue, ^{
            [_showPassbookController generatePassbook];
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([self isExistPassFromLocal]) {
                    [self enablePassbook];
                }
            });
        });
    }
}

-(void)showPassbookBtn
{
    if ([OrderPassbookViewController canUsePassbook]) {
        [self passbookInitController];
        isCanGenerate = 1;
    }
}

-(void)showPassbookRow
{
    self.passbookBtn.enabled = YES;
    self.passbookBtn.hidden = NO;
}

-(void)hiddenPassbookRow
{
    self.passbookBtn.enabled = NO;
    self.passbookBtn.hidden = YES;
    isCanGenerate = 0;
}

-(BOOL)isSuportHotelBrand
{
    return ![[JJHotel nameForBrand:self.hotelInfo.brand ] caseInsensitiveCompare:@"JG"] == NSOrderedSame;
}

- (void)enablePassbook
{
    isPass = YES;
}

-(void)disablePassbook
{
    isPass = NO;
}

- (void)viewDidUnload {
    [self setOrderNoLabel:nil];
    [self setOrderTimeLabel:nil];
    [self setOrderPriceLabel:nil];
    [self setPayButton:nil];
    [self setOrderPrepayLabel:nil];
    [self setPayTypeLabel:nil];
    [self setManagementStatusLabel:nil];
    [self setCityLabel:nil];
    [self setHotelLabel:nil];
    [self setRoomLabel:nil];
    [self setRoomsLabel:nil];
    [self setCheckInLabel:nil];
    [self setCheckOutLabel:nil];
    [self setGuestLabel:nil];
    [self setContactPersonLabel:nil];
    [self setMobileLabel:nil];
    [self setCancelPolicyDesc:nil];
    [self setNavigateBtn:nil];
    [self setDaysLabel:nil];
    [super viewDidUnload];
}

//-(void)viewDidDisappear:(BOOL)animated{
//    [super viewDidDisappear:animated];
//    
//}

@end

