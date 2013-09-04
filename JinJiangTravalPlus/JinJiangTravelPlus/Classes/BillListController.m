//
//  BillListController.m
//  JinJiangTravelPlus
//
//  Created by 吕 硕 on 12-12-26.
//  Copyright (c) 2012年 JinJiang. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>

#import "BillListController.h"
#import "JinJiangBillCell.h"
#import "OrderDetailController.h"
#import "PaymentGatewayListViewController.h"
#import "NSDataAES.h"
#import "HotelOrder.h"
#import "BookingDescriptionParser.h"

BOOL ordersIn3Months;
const unsigned int switchViewTg = 988;
const unsigned int emptyAlertTag = 87;

@interface BillListController ()

@property (nonatomic, strong)NSMutableArray *hotelInfoArray;
@property (nonatomic, strong)OderDetail *orderDetail;
@property (nonatomic, strong)HotelOrder *hotelOrder;
@property (nonatomic, strong)UILabel *threeMonthsInfoLabel;
@property (nonatomic) BOOL isInActivity;
@property (nonatomic, strong) NSString *payFeedBackDesc;

- (void)buildShowArray;
- (void)illustratorClicked:(id)sander;

@end

@implementation BillListController

@synthesize billArray;
@synthesize showArray;
@synthesize orderListParser;

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([FROM_BILL_LIST_TO_PAYMENT isEqualToString:segue.identifier]) {
        
        PaymentGatewayListViewController *orderResultViewController = segue.destinationViewController;
        orderResultViewController.navigationItem.title = @"在线支付";
        orderResultViewController.paymentForm = [[UnionPaymentForm alloc] init];
        orderResultViewController.paymentForm.orderNo = self.orderDetail.orderNo;
        orderResultViewController.paymentForm.orderId = self.hotelOrder.orderId;
        orderResultViewController.paymentForm.hotelName = self.hotelOrder.hotelName;
        orderResultViewController.paymentForm.orderAmount = [NSString stringWithFormat:@"%.0f", self.orderDetail.price];
        orderResultViewController.paymentForm.contactPhoneNumber = self.orderDetail.contactPersonMobile;
        orderResultViewController.cancelPolicyText = self.orderDetail.cancelPolicyDesc;
        orderResultViewController.isInActivity = self.isInActivity;
        orderResultViewController.payFeedBackDesc = self.payFeedBackDesc;
        
        HotelBookForm *bookForm = [[HotelBookForm alloc] init];
        bookForm.orderNo = self.orderDetail.orderNo;
        orderResultViewController.bookForm = bookForm;
    } else if ([@"toOrderDetail" isEqualToString:segue.identifier]) {
        OrderDetailController* con = segue.destinationViewController;
        [con setOrderNo:self.hotelOrder.orderNo];
        [con setOrderId:self.hotelOrder.orderId];
        con.isInActivity = self.isInActivity;
        con.payFeedBackDesc = self.payFeedBackDesc;
    }
}

- (void)checkBookingDescriptionByHotelBrand:(NSString *)hotelBrand
{
    BookingDescriptionParser *bdParser = [[BookingDescriptionParser alloc] init];
    bdParser.delegate = self;
    [bdParser sendRequest:hotelBrand];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.trackedViewName = @"用户订单中心酒店订单列表页面";
    [super viewWillAppear:animated];
    self.hotelInfoArray = [NSMutableArray array];
    
    if ([TheAppDelegate.userInfo checkIsLogin] == YES &&
        self.tableView != nil)
    {
        [self downloadData];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self setTrackedViewName:@"用户订单中心订单列表页面"];
    [super viewDidDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"订单中心"];
    ordersIn3Months = YES;

	// Do any additional setup after loading the view.
    self.billArray = [[NSMutableArray alloc] initWithCapacity:10];
    [self.billArray removeAllObjects];

    self.showArray = [[NSMutableArray alloc] initWithCapacity:10];
    [self.showArray removeAllObjects];
    [self.switchView transformToBillList];
    [self.switchView setDelegate:self];
    isEctive = !self.switchView.on;

    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    
    [self checkBookingDescriptionByHotelBrand:NULL];
    
    [self downloadData];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backHome:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - 业务逻辑

- (void)downloadData
{
    NSString* entryDateFrom;
    NSString* entryDateTo;

    NSDate *time = [NSDate date];
    int entryDateFromTimeInterval = time.timeIntervalSince1970 - kSecondsPerDay * 90;
    
    entryDateFrom = [[KalDate dateFromNSDate:[NSDate dateWithTimeIntervalSince1970:entryDateFromTimeInterval]] chineseDescription];
    entryDateTo = [[KalDate dateFromNSDate:[NSDate date]] chineseDescription];

    if (!self.orderListParser)
    {
        self.orderListParser = [[OrderListParser alloc] init];
        self.orderListParser.isHTTPGet = YES;
        self.orderListParser.serverAddress = kUserOrderListURL;
    }

    NSString* format = @"entryDateFrom=%@&entryDateTo=%@";
    [self.orderListParser setRequestString:[NSString stringWithFormat:format, entryDateFrom, entryDateTo]];
    [self.orderListParser setDelegate:self];   [self.orderListParser start]; [self showIndicatorView];
}

- (void)parser:(GDataXMLParser*)parser DidParsedData:(NSDictionary *)data
{
    if ([parser isKindOfClass:[orderListParser class]]) {
        NSMutableArray* orderList = [[NSMutableArray alloc] initWithArray:[data objectForKey:@"orderList"]];
        NSMutableArray* showListA = [[NSMutableArray alloc] initWithArray:[data objectForKey:@"showArray"]];
        [self setBillArray:[[NSMutableArray alloc] initWithArray:orderList]];//[self buildShowArray];
        [self setShowArray:[[NSMutableArray alloc] initWithArray:showListA]];
        
        
        if (self.billArray.count <= 0)
        {
            [self.noOrderLabel setHidden:NO];
            [self hideIndicatorView];
        } else {
            if(self.billArray.count >= 1 && isEctive == YES && [TheAppDelegate.userInfo checkIsLogin] &&
               [[NSUserDefaults standardUserDefaults] boolForKey:USER_ORDER_ALL] == NO && self.showArray.count <= 0)
            {
                UIImage* img = [UIImage imageNamed:@"illustrator@2x.png"];
                
                UIButton* illu = [UIButton buttonWithType:UIButtonTypeCustom];
                [illu setFrame:CGRectMake(0, -62, img.size.width / 2, img.size.height / 2)];
                [illu setBackgroundImage:img forState:UIControlStateNormal];
                [illu setBackgroundImage:img forState:UIControlStateHighlighted];
                [illu addTarget:self action:@selector(illustratorClicked:)
               forControlEvents:UIControlEventTouchUpInside];
                [self.view addSubview:illu];
            }
            
            if (self.showArray.count >= 1) {
                [self searchHotelInfoByOrder];
            } else {
                [self.tableView reloadData];
                [self hideIndicatorView];
            }
        }
    } else if ([parser isKindOfClass:[HotelOverviewParser class]]) {
        JJHotel *hotelInfo = [data objectForKey:@"hotel"];
        [self.hotelInfoArray addObject:hotelInfo];
        if (self.hotelInfoArray.count >= self.showArray.count) {
            [self.tableView reloadData];
            [self hideIndicatorView];
        } else {
            [self searchHotelInfoByOrder];
        }
        
    } else if ([parser isKindOfClass:[OderDetailParser class]]) {
        
        self.orderDetail = [data objectForKey:@"order"];
        [self hideIndicatorView];
        [self performSegueWithIdentifier:FROM_BILL_LIST_TO_PAYMENT sender:self];
    } else if ([parser isKindOfClass:[BookingDescriptionParser class]]) {
        self.isInActivity = YES;
        self.payFeedBackDesc = [data valueForKey:@"payFeedBackDesc"];

    }
}

- (void)searchHotelInfoByOrder
{
    HotelOrder *order = [self.showArray objectAtIndex:self.hotelInfoArray.count];
    
    self.hotelOverviewParser = [[HotelOverviewParser alloc] init];
    self.hotelOverviewParser.isHTTPGet = NO;
    
    self.hotelOverviewParser.serverAddress = [kHotelOverviewURL stringByAppendingPathComponent:
                                              [NSString stringWithFormat:@"%ld", order.hotelId]];
    
    self.hotelOverviewParser.delegate = self;
    [self.hotelOverviewParser start];
}

- (void)buildShowArray
{
    if (self.billArray == nil || [self.billArray count] <= 0)
    {   return; }

    for (HotelOrder* order in self.billArray)
    {
        if (order.status == CONFIRM || order.status == UNPAY || order.status == PAY_SUCCESS)
        {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
            [formatter setDateFormat:@"yyyy-MM-dd"];
            NSDate* checkin = [formatter dateFromString:order.checkin];
            NSDate* today   = [NSDate date];

            if ([checkin compare:today] == NSOrderedDescending)
            {
                [self.showArray addObject:order];
            }
        }
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (isEctive == YES) {  return self.showArray.count;    }

    return self.billArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView1 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (isEctive) {
        
        JJEffectiveBillCell *cell = (JJEffectiveBillCell *)[tableView1 dequeueReusableCellWithIdentifier:JinJiangBillEffectiveCellIdentifier];
        
        if (cell == nil)
        {
            cell = [[JJEffectiveBillCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:JinJiangBillEffectiveCellIdentifier];
            cell.delegate = self;
        }
        
        HotelOrder* order = [self.showArray objectAtIndex:indexPath.row];
        
        for (JJHotel *hotel in self.hotelInfoArray) {
            if (hotel.hotelId == order.hotelId) {
                [cell.addressLabel setText:hotel.address];
                cell.hotelInfo = hotel;
            }
        }
        cell.orderNo = order.orderNo;
        [cell.hotelNameLabel setText:order.hotelName]; //order.price = 898989;
        [cell.hotelPriceLabel setText:[NSString stringWithFormat:@"￥ %.0f", order.price]];
        [cell.contactLabel setText:TheAppDelegate.userInfo.fullName];
        [cell.inDateLabel setText:order.checkin];
        [cell.outDateLabel setText:order.checkout];
        //    [cell.addressLabel setText:]
        
        if (order.status == UNPAY || order.status == PAY_FAILURE) {
            cell.isPayButton = YES;
        } else {
            cell.isPayButton = NO;
        }
        
        switch (order.status)
        {
            case CONFIRM:
            {   [cell.statusImg setImage:[UIImage imageNamed:@"confirmed_corner.png"]];  break;  }
            case CANCEL:
            {   [cell.statusImg setImage:[UIImage imageNamed:@"canced_corner.png"]];  break;  }
            case FAIL:
            {   [cell.statusImg setImage:[UIImage imageNamed:@"orderFailed_corner.png"]];  break; }
            case UNPAY:
            {   [cell.statusImg setImage:[UIImage imageNamed:@"unpay_corner.png"]];  break;  }
            case PAY_SUCCESS:
            {   [cell.statusImg setImage:[UIImage imageNamed:@"pay_success_corner.png"]];  break;  }
            case PAY_FAILURE:
            {   [cell.statusImg setImage:[UIImage imageNamed:@"pay_failure_corner.png"]];  break;  }
            case REFUND_ALREADY:
            {   [cell.statusImg setImage:[UIImage imageNamed:@"refund.png"]];  break;  }
            case REFUND_SUCCESS:
            {   [cell.statusImg setImage:[UIImage imageNamed:@"refund-success.png"]];  break;  }
            default:
            {   break;  }
        }
        return cell;

    } else {
        
        JinJiangBillCell *cell = (JinJiangBillCell *)[tableView1 dequeueReusableCellWithIdentifier:JinJiangBillCellIdentifier];
        
        if (cell == nil)
        {
            cell = [[JinJiangBillCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:JinJiangBillCellIdentifier];
        }
        
        
        HotelOrder* order = [self.billArray objectAtIndex:indexPath.row]; ;
        
        [cell.hotelNameLabel setText:order.hotelName]; //order.price = 898989;
        [cell.hotelPriceLabel setText:[NSString stringWithFormat:@"￥ %.0f", order.price]];
        [cell.contactLabel setText:TheAppDelegate.userInfo.fullName];
        [cell.inDateLabel setText:order.checkin];
        [cell.outDateLabel setText:order.checkout];
        
        switch (order.status)
        {
            case CONFIRM:
            {   [cell.statusImg setImage:[UIImage imageNamed:@"confirmed_corner.png"]];  break;  }
            case CANCEL:
            {   [cell.statusImg setImage:[UIImage imageNamed:@"canced_corner.png"]];  break;  }
            case FAIL:
            {   [cell.statusImg setImage:[UIImage imageNamed:@"orderFailed_corner.png"]];  break; }
            case UNPAY:
            {   [cell.statusImg setImage:[UIImage imageNamed:@"unpay_corner.png"]];  break;  }
            case PAY_SUCCESS:
            {   [cell.statusImg setImage:[UIImage imageNamed:@"pay_success_corner.png"]];  break;  }
            case PAY_FAILURE:
            {   [cell.statusImg setImage:[UIImage imageNamed:@"pay_failure_corner.png"]];  break;  }
            case REFUND_ALREADY:
            {   [cell.statusImg setImage:[UIImage imageNamed:@"refund.png"]];  break;  }
            case REFUND_SUCCESS:
            {   [cell.statusImg setImage:[UIImage imageNamed:@"refund-success.png"]];  break;  }
            default:
            {   break;  }
        }
        
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return isEctive ? JinJiangEffectiveBillCellHeight + 6 :JinJiangBillCellHeight + 6;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (isEctive == NO)
    {   self.hotelOrder = [self.billArray objectAtIndex:indexPath.row];   }
    else
    {   self.hotelOrder = [self.showArray objectAtIndex:indexPath.row];   }

    [self performSegueWithIdentifier:@"toOrderDetail" sender:self];
}


#pragma mark - MySwitchViewDelegate

- (void)switchViewDidEndSetting:(MySwitchView*)switchView
{
    isEctive = !switchView.on;
    [self.tableView reloadData];
    
    if (!isEctive) {
        self.threeMonthsInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, (JinJiangBillCellHeight + 6) * self.billArray.count + 10, 200, 16)];
        [self.threeMonthsInfoLabel setFont:[UIFont systemFontOfSize:12]];
        [self.threeMonthsInfoLabel setBackgroundColor:[UIColor clearColor]];
        [self.threeMonthsInfoLabel setTextAlignment:NSTextAlignmentLeft];
        [self.threeMonthsInfoLabel setTextColor:[UIColor colorWithRed:68.0/255.0 green:138.0/255.0 blue:202.0/255.0 alpha:1.0]];
        [self.threeMonthsInfoLabel setText:@"仅显示最近三月订单信息"];
        [self.tableView addSubview:self.threeMonthsInfoLabel];
    } else {
        if (self.threeMonthsInfoLabel) {
            [self.threeMonthsInfoLabel removeFromSuperview];
        }
    }
}

#pragma mark - JJEffectiveBillCellDelegate

- (void)clickToPay:(JJEffectiveBillCell *)sender
{
    CGPoint point = [sender center];
    UITableView *table = self.tableView;
    NSIndexPath *indexPath = [table indexPathForRowAtPoint:point];
    self.hotelOrder = [self.showArray objectAtIndex:indexPath.row];
    if (!self.orderDetailParse)
    {
        self.orderDetailParse = [[OderDetailParser alloc] init];
        self.orderDetailParse.isHTTPGet = YES;
        self.orderDetailParse.serverAddress = kHotelOrderDetailURL;
    }
    
    [self.orderDetailParse setRequestString:[NSString stringWithFormat:@"orderNo=%@", sender.orderNo]];
    [self.orderDetailParse setDelegate:self];
    [self.orderDetailParse start];
    [self showIndicatorView];

}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == emptyAlertTag && buttonIndex == 1)
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void)illustratorClicked:(id)sander
{
    [(UIView*)sander removeFromSuperview];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:USER_ORDER_ALL];
    MySwitchView* switchView = (MySwitchView*)[self.view viewWithTag:switchViewTg];
    [switchView switchOn:nil];
}

- (void)viewDidUnload {
    [self setSwitchView:nil];
    [self setTableView:nil];
    [self setNoOrderLabel:nil];
    [super viewDidUnload];
}
@end
