//
//  OrderListViewController.m
//  JinJiangHotel
//
//  Created by Rong Hao on 13-8-29.
//  Copyright (c) 2013年 jinjiang. All rights reserved.
//

#import "OrderListViewController.h"
#import "OrderDetailViewController.h"
#import "JJHotel.h"
#import "OrderDetail.h"
#import "HotelOrder.h"

const unsigned int emptyAlertTag = 87;
@interface OrderListViewController ()

@property (nonatomic, strong)NSMutableArray *hotelInfoArray;
@property (nonatomic, strong)OrderDetail *orderDetail;
@property (nonatomic, strong)HotelOrder *hotelOrder;

@end

@implementation OrderListViewController

BOOL ordersIn3Months;

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([FROM_BILL_LIST_TO_DETAIL isEqualToString:segue.identifier]) {
        OrderDetailViewController* odv = segue.destinationViewController;
        odv.orderNo = self.hotelOrder.orderNo;
        odv.orderId = self.hotelOrder.orderId;
//        odv.isInActivity = self.isInActivity;
//        con.payFeedBackDesc = self.payFeedBackDesc;
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
    
    
    self.navigationBar.mainLabel.text = NSLocalizedStringFromTable(@"myOrder", @"OrderList", @"");
    
    self.orderListTable.delegate = self;
    self.orderListTable.dataSource = self;
    
    
    ordersIn3Months = YES;
    
	// Do any additional setup after loading the view.
    self.billArray = [NSMutableArray array];
    self.showArray = [NSMutableArray array];
    self.hotelInfoArray = [NSMutableArray array];
    
    [self.switchView transformToSearch];
    [self.switchView setDelegate:self];
    isEctive = !self.switchView.on;
    
    [self downloadData];
    
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
    [self.orderListParser setDelegate:self];
    [self.orderListParser start];
    [self showIndicatorView];
}

- (void)parser:(GDataXMLParser*)parser DidParsedData:(NSDictionary *)data
{
    if ([parser isKindOfClass:[OrderListParser class]]) {
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
                [self.orderListTable reloadData];
                [self hideIndicatorView];
            }
        }
    } else if ([parser isKindOfClass:[HotelOverviewParser class]]) {
        JJHotel *hotelInfo = [data objectForKey:@"hotel"];
        [self.hotelInfoArray addObject:hotelInfo];
        if (self.hotelInfoArray.count >= self.showArray.count) {
            [self.orderListTable reloadData];
            [self hideIndicatorView];
        } else {
            [self searchHotelInfoByOrder];
        }
        
    } else if ([parser isKindOfClass:[OderDetailParser class]]) {
        
        self.orderDetail = [data objectForKey:@"order"];
        [self hideIndicatorView];
//        [self performSegueWithIdentifier:FROM_BILL_LIST_TO_PAYMENT sender:self];
        NSLog(@"to pay with orderdetail No:%@", self.orderDetail.orderNo);
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
        
        OrderListCell *cell = (OrderListCell *)[tableView1 dequeueReusableCellWithIdentifier:OrderEffectiveCellID];
        
        if (cell == nil)
        {
            cell = [[OrderListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:OrderEffectiveCellID];
            cell.delegate = self;
        }
        
        HotelOrder* order = [self.showArray objectAtIndex:indexPath.row];
        
        for (JJHotel *hotel in self.hotelInfoArray) {
            if (hotel.hotelId == order.hotelId) {
                [cell.addressLabel setText:[NSString stringWithFormat:@"%@%@", NSLocalizedStringFromTable(@"address", @"OrderList", @""), hotel.address]];
                cell.hotelInfo = hotel;
            }
        }
        cell.orderNo = order.orderNo;
        [cell.hotelName setText:order.hotelName]; //order.price = 898989;
        [cell.priceLabel setText:[NSString stringWithFormat:@"￥ %.0f", order.price]];
        [cell.contactPersonLabel setText:[NSString stringWithFormat:@"%@%@", NSLocalizedStringFromTable(@"contactperson", @"OrderList", @""), TheAppDelegate.userInfo.fullName]];
        [cell.dateLabel setText:[NSString stringWithFormat:@"%@%@    %@%@", NSLocalizedStringFromTable(@"arrive", @"OrderList", @""), order.checkin, NSLocalizedStringFromTable(@"leave", @"OrderList", @""), order.checkout]];
        //    [cell.addressLabel setText:]
        
        if (order.status == UNPAY || order.status == PAY_FAILURE) {
            cell.isPayButton = YES;
        } else {
            cell.isPayButton = NO;
        }
        
        switch (order.status)
        {
            case CONFIRM:
            {
                cell.orderStatus.text = NSLocalizedStringFromTable(@"confirm", @"OrderList", @"");
                break;
            }
            case CANCEL:
            {
                
                cell.orderStatus.text = NSLocalizedStringFromTable(@"cancel", @"OrderList", @"");
                break;
            }
            case FAIL:
            {
                cell.orderStatus.text = NSLocalizedStringFromTable(@"fail", @"OrderList", @"");
                break;
            }
            case UNPAY:
            {
                
                cell.orderStatus.text = NSLocalizedStringFromTable(@"unpay", @"OrderList", @"");
                break;
            }
            case PAY_SUCCESS:
            {
                
                cell.orderStatus.text = NSLocalizedStringFromTable(@"paysuccess", @"OrderList", @"");
                break;
            }
            case PAY_FAILURE:
            {
                
                cell.orderStatus.text = NSLocalizedStringFromTable(@"payfailure", @"OrderList", @"");
                break;
            }
            case REFUND_ALREADY:
            {
                cell.orderStatus.text = NSLocalizedStringFromTable(@"refundalready", @"OrderList", @"");
                break;
            }
            case REFUND_SUCCESS:
            {
                cell.orderStatus.text = NSLocalizedStringFromTable(@"refundsuccess", @"OrderList", @"");
                break;
            }
            default:
            {   break;  }
        }
        return cell;
        
    } else {
        
        OrderListCell *cell = (OrderListCell *)[tableView1 dequeueReusableCellWithIdentifier:OrderHistoryCellID];
        
        if (cell == nil)
        {
            cell = [[OrderListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:OrderHistoryCellID];
        }
        
        
        HotelOrder* order = [self.billArray objectAtIndex:indexPath.row]; ;
        
        [cell.hotelName setText:order.hotelName]; //order.price = 898989;
        [cell.priceLabel setText:[NSString stringWithFormat:@"￥ %.0f", order.price]];
        [cell.contactPersonLabel setText:[NSString stringWithFormat:@"%@%@", NSLocalizedStringFromTable(@"contactperson", @"OrderList", @""), TheAppDelegate.userInfo.fullName]];
        [cell.dateLabel setText:[NSString stringWithFormat:@"%@%@    %@%@", NSLocalizedStringFromTable(@"arrive", @"OrderList", @""), order.checkin, NSLocalizedStringFromTable(@"leave", @"OrderList", @""), order.checkout]];
        
        
        switch (order.status)
        {
            case CONFIRM:
            {
                cell.orderStatus.text = NSLocalizedStringFromTable(@"confirm", @"OrderList", @"");
                break;
            }
            case CANCEL:
            {
                
                cell.orderStatus.text = NSLocalizedStringFromTable(@"cancel", @"OrderList", @"");
                break;
            }
            case FAIL:
            {
                cell.orderStatus.text = NSLocalizedStringFromTable(@"fail", @"OrderList", @"");
                break;
            }
            case UNPAY:
            {
                
                cell.orderStatus.text = NSLocalizedStringFromTable(@"unpay", @"OrderList", @"");
                break;
            }
            case PAY_SUCCESS:
            {
                
                cell.orderStatus.text = NSLocalizedStringFromTable(@"paysuccess", @"OrderList", @"");
                break;
            }
            case PAY_FAILURE:
            {
                
                cell.orderStatus.text = NSLocalizedStringFromTable(@"payfailure", @"OrderList", @"");
                break;
            }
            case REFUND_ALREADY:
            {
                cell.orderStatus.text = NSLocalizedStringFromTable(@"refundalready", @"OrderList", @"");
                break;
            }
            case REFUND_SUCCESS:
            {
                cell.orderStatus.text = NSLocalizedStringFromTable(@"refundsuccess", @"OrderList", @"");
                break;
            }
            default:
            {   break;  }
        }
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return isEctive ? 163 : 139;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (isEctive == NO)
    {   self.hotelOrder = [self.billArray objectAtIndex:indexPath.row];   }
    else
    {   self.hotelOrder = [self.showArray objectAtIndex:indexPath.row];   }
    
    [self performSegueWithIdentifier:FROM_BILL_LIST_TO_DETAIL sender:self];
//    NSLog(@"to detail with order id: %@", self.hotelOrder.orderId);
}


#pragma mark - MySwitchViewDelegate

- (void)switchViewDidEndSetting:(MySwitchView*)switchView
{
    isEctive = !switchView.on;
    [self.orderListTable reloadData];
    
    if (!isEctive) {
        self.threeMonthsInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, (162 + 6) * self.billArray.count + 10, 200, 16)];
        [self.threeMonthsInfoLabel setFont:[UIFont systemFontOfSize:12]];
        [self.threeMonthsInfoLabel setBackgroundColor:[UIColor clearColor]];
        [self.threeMonthsInfoLabel setTextAlignment:NSTextAlignmentLeft];
        [self.threeMonthsInfoLabel setTextColor:[UIColor colorWithRed:68.0/255.0 green:138.0/255.0 blue:202.0/255.0 alpha:1.0]];
        [self.threeMonthsInfoLabel setText:NSLocalizedStringFromTable(@"onlyThreeMonths", @"OrderList", @"")];
        [self.orderListTable addSubview:self.threeMonthsInfoLabel];
    } else {
        if (self.threeMonthsInfoLabel) {
            [self.threeMonthsInfoLabel removeFromSuperview];
        }
    }
    
    if (switchView.on) {
        self.allLabel.textColor = RGBCOLOR(160, 140, 25);
        self.effectiveLabel.textColor = [UIColor blackColor];
    } else {
        self.effectiveLabel.textColor = RGBCOLOR(160, 140, 25);
        self.allLabel.textColor = [UIColor blackColor];
    }
}

#pragma mark - JJEffectiveBillCellDelegate

- (void)clickToPay:(OrderListCell *)sender
{
    CGPoint point = [sender center];
    UITableView *table = self.orderListTable;
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
    [self.switchView switchOn:nil];
    
}



- (void)viewDidUnload {
    [self setSwitchView:nil];
    [self setOrderListTable:nil];
    [self setNoOrderLabel:nil];
    [self setEffectiveLabel:nil];
    [self setAllLabel:nil];
    [super viewDidUnload];
}
@end
