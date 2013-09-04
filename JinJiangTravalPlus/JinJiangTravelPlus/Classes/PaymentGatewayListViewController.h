//
//  PaymentListViewController.h
//  JinJiangTravelPlus
//
//  Created by 胡 桂祁 on 3/8/13.
//  Copyright (c) 2013 JinJiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UnionPaymentForm.h"
#import "LoadPaymentAmountParser.h"
#import "AlipayWapWebViewController.h"
#import "YiLianPayViewController.h"
#import "OrderPassbookViewController.h"
#import "HotelBookForm.h"

@interface PaymentGatewayListViewController : JJViewController<UITableViewDelegate, UITableViewDataSource,UIAlertViewDelegate, GDataXMLParserDelegate>

@property(nonatomic,weak) IBOutlet UIView *orderInfoView;
@property(nonatomic,weak) IBOutlet UIImageView *splitImgView;
@property(nonatomic,weak) IBOutlet UIView *bgOrderInfoWaveView;
@property(nonatomic,weak) IBOutlet UITableView *paymentTableView;
@property(nonatomic,weak) IBOutlet UILabel *orderNoLabel;
@property(nonatomic,weak) IBOutlet UILabel *payTypeLabel;
@property(nonatomic,weak) IBOutlet UILabel *orderAmountTextLabel;
@property(nonatomic,weak) IBOutlet UILabel *paymentAmountTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *cancelPolicyLabel;


@property(nonatomic,strong) NSArray *paymentGatewayList;
@property (nonatomic,strong) UnionPaymentForm *paymentForm;

@property (nonatomic,weak) IBOutlet UILabel *bookAmountLabel;
@property (nonatomic,weak) IBOutlet UILabel *paymentAmountLabel;
@property (nonatomic,strong) LoadPaymentAmountParser *loadPaymentAmountParser;
@property (nonatomic,strong) AlipayWapWebViewController *alipayWapWebView;
@property (nonatomic,strong) YiLianPayViewController *yiLianPayViewController;
@property (nonatomic,strong) UIAlertView *confirmAlertView;

@property (nonatomic,strong) OrderPassbookViewController *showPassbookController;
@property (nonatomic, strong) HotelBookForm *bookForm;
@property (nonatomic, copy) NSString *latitude;
@property (nonatomic, copy) NSString *longitude;
@property (nonatomic, copy) NSString *hotelAddress;
@property (nonatomic, copy) NSString *hotelBrand;
@property (nonatomic, strong) NSString *cancelPolicyText;

@property (nonatomic) BOOL isInActivity;
@property (nonatomic, strong) NSString *payFeedBackDesc;

@property(nonatomic, strong)NSString *departureSegueId;

-(IBAction)toPayment:(id)sender;

@end
