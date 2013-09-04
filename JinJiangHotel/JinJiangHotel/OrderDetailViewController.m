//
//  OrderDetailViewController.m
//  JinJiangHotel
//
//  Created by Rong Hao on 13-8-29.
//  Copyright (c) 2013年 jinjiang. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "HotelDetailViewController.h"
#import "JJHotel.h"
#import "JJNavigationButton.h"

@interface OrderDetailViewController ()

@property (nonatomic, strong)JJHotel *hotelInfo;

@end

@implementation OrderDetailViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:FROM_DETAIL_TO_HOTEL_DETAIL]) {
        HotelDetailViewController *hdv = segue.destinationViewController;
        hdv.hotel = self.hotelInfo;
        hdv.isFromOrder = YES;
    }
}

- (void)addCancelOrderBtnOnNavigationBar
{
    UIButton *cancelOrderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelOrderBtn.frame = CGRectMake(240, 12, 60, 24);
    [cancelOrderBtn setTitle:NSLocalizedStringFromTable(@"cancelOrder", @"OrderDetail", @"") forState:UIControlStateNormal];
    cancelOrderBtn.titleLabel.textColor = [UIColor whiteColor];
    cancelOrderBtn.titleLabel.font = [UIFont boldSystemFontOfSize: 12.0f];
    cancelOrderBtn.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"submit.png"]];
    [cancelOrderBtn addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationBar addSubview:cancelOrderBtn];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationBar.mainLabel.text = NSLocalizedStringFromTable(@"orderdetail", @"OrderDetail", @"");
    
    [self addCancelOrderBtnOnNavigationBar];

    [self downloadData];
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
    [self.oderDetailParser setDelegate:self];
    [self.oderDetailParser start];
    [self showIndicatorView];
}

- (void)parser:(GDataXMLParser*)parser DidParsedData:(NSDictionary *)data
{
    if ([parser isKindOfClass:[OderDetailParser class]])
    {
        order = [data objectForKey:@"order"];
        self.status = order.status;
        switch (order.status)
        {
            case CONFIRM:
            {
                self.orderStatusLabel.text = NSLocalizedStringFromTable(@"confirm", @"OrderList", @"");
                break;
            }
            case CANCEL:
            {
                
                self.orderStatusLabel.text = NSLocalizedStringFromTable(@"cancel", @"OrderList", @"");
                break;
            }
            case FAIL:
            {
                self.orderStatusLabel.text = NSLocalizedStringFromTable(@"fail", @"OrderList", @"");
                break;
            }
            case UNPAY:
            {
                
                self.orderStatusLabel.text = NSLocalizedStringFromTable(@"unpay", @"OrderList", @"");
                break;
            }
            case PAY_SUCCESS:
            {
                
                self.orderStatusLabel.text = NSLocalizedStringFromTable(@"paysuccess", @"OrderList", @"");
                break;
            }
            case PAY_FAILURE:
            {
                
                self.orderStatusLabel.text = NSLocalizedStringFromTable(@"payfailure", @"OrderList", @"");
                break;
            }
            case REFUND_ALREADY:
            {
                self.orderStatusLabel.text = NSLocalizedStringFromTable(@"refundalready", @"OrderList", @"");
                break;
            }
            case REFUND_SUCCESS:
            {
                self.orderStatusLabel.text = NSLocalizedStringFromTable(@"refundsuccess", @"OrderList", @"");
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
                //to-do
                //check is cancel enable
            }
            else
            {
            }
        }
        else
        {
        }
        
        NSString *guestNames = @"";
        for (NSString *guestName in order.guests) {
            guestNames = [guestNames stringByAppendingString:@","];
            guestNames = [guestNames stringByAppendingString:guestName];
        }
        
        self.orderNoLabel.text = [NSString stringWithFormat:@"%@%@", NSLocalizedStringFromTable(@"orderno", @"OrderDetail", @""), order.orderNo];
        self.orderTimeLabel.text = [NSString stringWithFormat:@"%@%@", NSLocalizedStringFromTable(@"ordertime", @"OrderDetail", @""), order.entryDateTime];
        self.orderAmountLabel.text = NSLocalizedStringFromTable(@"orderamount", @"OrderDetail", @"");
        self.payedLabel.text = NSLocalizedStringFromTable(@"payedamount", @"OrderDetail", @"");
        self.orderAmountInPriceLabel.text = [NSString stringWithFormat:@"￥%.0f", order.price];
        self.payedAmountInPriceLabel.text = [NSString stringWithFormat:@"￥%.0f", order.paymentAmount];
        self.hotelNamelabel.text = [NSString stringWithFormat:@"%@%@", NSLocalizedStringFromTable(@"hotelname", @"OrderDetail", @""), order.hotelNm];
        self.livingCityLabel.text = [NSString stringWithFormat:@"%@%@", NSLocalizedStringFromTable(@"livingcity", @"OrderDetail", @""), order.cityNm];
        self.arriveTimeLabel.text = [NSString stringWithFormat:@"%@%@%@", NSLocalizedStringFromTable(@"arrivetime", @"OrderDetail", @""), order.checkin, NSLocalizedStringFromTable(@"arrive", @"OrderDetail", @"")];
        self.leaveTimeLabel.text = [NSString stringWithFormat:@"%@%@", NSLocalizedStringFromTable(@"leavetime", @"OrderDetail", @""), order.checkOut];
        self.roomStyleLabel.text = [NSString stringWithFormat:@"%@%@ %@",NSLocalizedStringFromTable(@"roomstyle", @"OrderDetail", @""), order.roomName, [NSString stringWithFormat:@"%d间", order.rooms]];
        self.guestNameLabel.text = [NSString stringWithFormat:@"%@%@", NSLocalizedStringFromTable(@"guestname", @"OrderDetail", @""), [guestNames substringFromIndex:1]];
        self.livingPersonNameLabel.text = [NSString stringWithFormat:@"%@%@", NSLocalizedStringFromTable(@"contactname", @"OrderDetail", @""), order.contactPersonName];
        self.mobileNumberLabel.text = [NSString stringWithFormat:@"%@%@", NSLocalizedStringFromTable(@"mobilenum", @"OrderDetail", @""), order.contactPersonMobile];
        self.cancelPolicyTextView.text = [NSString stringWithFormat:@"%@%@", NSLocalizedStringFromTable(@"cancelpolicy", @"OrderDetail", @""), order.cancelPolicyDesc];
        
        self.orderDetail = order;
        TheAppDelegate.hotelSearchForm.cityName = [order.cityNm stringByReplacingOccurrencesOfString:@"市" withString:@""];
        
        [self initHotelDetail];
        
    }
    else if  ([parser isKindOfClass:([HotelOverviewParser class])])
    {
        self.hotelInfo = [data objectForKey:@"hotel"];
        kPrintfInfo;
        [self hideIndicatorView];
//        if (![self isExistPassFromLocal] && [OrderPassbookViewController canUsePassbook] && isCanGenerate == 1) {
//            [self generatePassbook];
//        }
    }
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


- (IBAction)payButtonPressed:(UIButton *)sender {
}
- (IBAction)addToPassbookPressed:(UIButton *)sender {
}
- (IBAction)navigationPressed:(JJNavigationButton *)sender {
    [sender clickToNavigation:self.hotelInfo];
}
- (IBAction)hotelInfoPressed:(id)sender {
    [self performSegueWithIdentifier:FROM_DETAIL_TO_HOTEL_DETAIL sender:self];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setOrderTimeLabel:nil];
    [self setOrderAmountLabel:nil];
    [self setOrderAmountInPriceLabel:nil];
    [self setPayedLabel:nil];
    [self setPayedAmountInPriceLabel:nil];
    [self setLivingCityLabel:nil];
    [self setRoomStyleLabel:nil];
    [self setArriveTimeLabel:nil];
    [self setLeaveTimeLabel:nil];
    [self setGuestNameLabel:nil];
    [self setLivingPersonNameLabel:nil];
    [self setMobileNumberLabel:nil];
    [self setCancelPolicyTextView:nil];
    [self setOrderNoLabel:nil];
    [self setOrderStatusLabel:nil];
    [super viewDidUnload];
}
@end
