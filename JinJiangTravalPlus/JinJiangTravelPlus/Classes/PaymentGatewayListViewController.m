//
//  PaymentListViewController.m
//  JinJiangTravelPlus
//
//  Created by 胡 桂祁 on 3/8/13.
//  Copyright (c) 2013 JinJiang. All rights reserved.
//

#import "PaymentGatewayListViewController.h"
#import "PaymentType.h"
#import "TableSelectButton.h"
#import "NSDataAES.h"
#import "ParameterManager.h"
#import "OrderDetailController.h"
#import "BillListController.h"
#import "IPAddress.h"
#import <QuartzCore/QuartzCore.h>
#import "AlipayParser.h"
#import "AlixPay.h"
#import "ClientAlipaySuccessViewController.h"

static int LOADOK_BACKALERTVIEW_TAG=1;
static int LOADFAIL_BACKALERTVIEW_TAG=2;

@interface PaymentGatewayListViewController ()

@property (nonatomic, strong) AlipayParser *alipayParser;
@property (nonatomic, copy) NSString *payingInfo;

-(void)clickSelectBtn:(id)sender;

-(void)toPayment:(id)sender;

- (void)loadOrderPaymentAmount;

- (void) backHome: (id) sender;

- (NSString *)buildAlipayWapUrl;

@end

@implementation PaymentGatewayListViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        //注册通知，支付宝安全支付成功接收通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushOrderListController:) name:@"ClientAlipayFinished" object:nil];
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.userInteractionEnabled = YES;
    self.navigationController.title = @"在线支付";
    
    self.orderNoLabel.text = self.paymentForm.orderNo;
    
    self.orderInfoView.frame=CGRectMake(8, 0, 304, 140);
    self.orderInfoView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_order_top.png"]];
    
    self.splitImgView.frame = CGRectMake(15, 70, 275, 1);
    self.splitImgView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"order_split.png"]];
    
    self.bgOrderInfoWaveView.frame=CGRectMake(8, 140, 304, 10);
	self.bgOrderInfoWaveView.backgroundColor =  [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_top_wave.png"]];
    self.bookAmountLabel.textColor = RGBCOLOR(233.0f, 107.0f, 50.00f);
    self.paymentAmountLabel.textColor = RGBCOLOR(233.0f, 107.0f, 50.00f);
    self.payTypeLabel.textColor = RGBCOLOR(67, 67, 67);
    self.orderAmountTextLabel.textColor = RGBCOLOR(112, 112, 112);
    self.paymentAmountTextLabel.textColor = RGBCOLOR(112, 112, 112);
    
    [self initPaymentList];
    [self initCancelPolicyLabel];
    [self loadOrderPaymentAmount];
    [self generatePassbook];
    
}

- (void)pushOrderListController:(id) sender
{
    [UMAnalyticManager eventCount:@"支付宝客户端支付完成" label:@"支付宝客户端支付完成回调"];
    [self performSegueWithIdentifier:@"clientAlipaySuccess" sender:nil];
}

- (void)getAlipayInfoAction
{
    self.alipayParser = [[AlipayParser alloc] init];
    self.alipayParser.serverAddress = KAliPayClientURL;
    
    ParameterManager *parameterManager = [[ParameterManager alloc] init];
    [parameterManager parserStringWithKey:@"orderNo" WithValue:self.paymentForm.orderNo];
    [parameterManager parserStringWithKey:@"subject" WithValue:self.paymentForm.hotelName];
    [parameterManager parserStringWithKey:@"description" WithValue:self.paymentForm.hotelName];
    [parameterManager parserStringWithKey:@"payAmount" WithValue:self.paymentForm.amount];
    [parameterManager parserStringWithKey:@"businessPart" WithValue:@"HOTEL"];
    [parameterManager parserStringWithKey:@"buyerName" WithValue:self.paymentForm.userName];
    [parameterManager parserStringWithKey:@"buyerIp" WithValue:[IPAddress currentIPAddress]];

    self.alipayParser.requestString = [parameterManager serialization];
    self.alipayParser.delegate = self;
    [self.alipayParser start];
}

-(void)viewWillAppear:(BOOL)animated
{
    self.trackedViewName = @"订单在线支付选择页面";
    [super viewWillAppear:animated];
}

- (void)initPaymentList
{
    NSMutableArray *paymentListArray = [[NSMutableArray alloc] initWithCapacity:5];
    
    if ([self isExistSafepay]) {
        PaymentType *alipayApp = [PaymentType initPaymentType:@"支付宝客户端支付" paymentBusiness:ALIPAY_APP];
        [alipayApp.paymentSelectButton addTarget:self action:@selector(clickSelectBtn:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside ];
        [paymentListArray addObject:alipayApp];
    }
    
    PaymentType *alipayWap = [PaymentType initPaymentType:@"支付宝网页支付" paymentBusiness:ALIPAY_WAP];
    [alipayWap.paymentSelectButton addTarget:self action:@selector(clickSelectBtn:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside ];
    
    PaymentType *yiLianPay = [PaymentType initPaymentType:@"易联支付" paymentBusiness:YILIANPAY];
    [yiLianPay.paymentSelectButton addTarget:self action:@selector(clickSelectBtn:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside ];
    
    [paymentListArray addObject:alipayWap];
    [paymentListArray addObject:yiLianPay];
    _paymentGatewayList=paymentListArray;
    
    [self buildOKBackNoticeView];
}

//根据支付方式数量初始化取消政策标签位置
- (void)initCancelPolicyLabel
{
    int payTypeNum = [self.paymentGatewayList count];
    self.cancelPolicyLabel.text = [NSString stringWithFormat:@"取消政策:%@", self.cancelPolicyText];
    CGRect frame = self.cancelPolicyLabel.frame;
    frame.origin.y = 190 + 40 + payTypeNum * 40;
    
    float iconHeight = 310;
    if (payTypeNum == 3) {
        iconHeight = 360;
        frame.origin.y += 10;
    }
    UIImageView *cancelIconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(40, iconHeight, 12, 12)];
    cancelIconImageView.backgroundColor = [UIColor clearColor];
    cancelIconImageView.image = [UIImage imageNamed:@"cancel_icon.png"];
    [self.view addSubview:cancelIconImageView];
    
    
    
    self.cancelPolicyLabel.frame = frame;
    
}


- (void) backHome: (id) sender
{   if(_confirmAlertView.tag == LOADFAIL_BACKALERTVIEW_TAG){
    [self cancelToBillListController];
}else{
    [_confirmAlertView show];
}
    
}

- (BOOL)isExistSafepay
{
    NSURL *alipayUrl = [NSURL URLWithString:@"alipay://alipayclient/"];
    NSURL *safepayUrl = [NSURL URLWithString:@"safepay://alipayclient/"];
    
    BOOL isSafePay = NO;
    if ([[UIApplication sharedApplication] canOpenURL:alipayUrl]) {
        isSafePay = YES;
    } else if ([[UIApplication sharedApplication] canOpenURL:safepayUrl]) {
        isSafePay = YES;
    }
    
    return isSafePay;
}

-(void)clickSelectBtn:(id)sender
{
    UIButton *currentBtn = (UIButton *)sender;
    PaymentType *tempPaymentType = [_paymentGatewayList objectAtIndex:currentBtn.tag];
    self.paymentForm.paymentBusiness = tempPaymentType.paymentBusiness;
    [self toPayment:nil];
}

-(void)toPayment:(id)sender
{
    if (ALIPAY_APP == self.paymentForm.paymentBusiness) {
        [UMAnalyticManager eventCount:@"支付宝客户端支付" label:@"选择支付宝客户端支付"];
        NSString *appScheme = @"jinjiangtravelplus";
        //获取安全支付单例并调用安全支付接口
        AlixPay * alixpay = [AlixPay shared];
        int ret = [alixpay pay:self.payingInfo applicationScheme:appScheme];
        
        if (ret == kSPErrorAlipayClientNotInstalled) {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                 message:@"您还没有安装支付宝钱包，请先安装。"
                                                                delegate:nil
                                                       cancelButtonTitle:@"确定"
                                                       otherButtonTitles:nil];
            [alertView show];
        } else if (ret == kSPErrorSignError) {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                 message:@"支付宝客户端支付异常，请使用其他支付方式。"
                                                                delegate:nil
                                                       cancelButtonTitle:@"确定"
                                                       otherButtonTitles:nil];
            [alertView show];
        }
        
    } else if (ALIPAY_WAP == self.paymentForm.paymentBusiness) {
        [UMAnalyticManager eventCount:@"支付宝wap支付" label:@"在线支付选择页面点击支付宝wap支付"];
        [self performSegueWithIdentifier:@"ALipayWap_sugue" sender:self];
    } else if(YILIANPAY == self.paymentForm.paymentBusiness){
        [UMAnalyticManager eventCount:@"易联支付" label:@"在线支付选择页面点击易联支付"];
        [self performSegueWithIdentifier:@"YiLianPayViewControllerSegue" sender:nil];
    }
}


- (NSString *)buildAlipayWapUrl
{
    ParameterManager *parameterManager = [[ParameterManager alloc] init];
    [parameterManager parserStringWithKey:@"orderNo" WithValue:self.paymentForm.orderNo];
    [parameterManager parserStringWithKey:@"buyerName" WithValue:self.paymentForm.userName];
    [parameterManager parserStringWithKey:@"buyerIp" WithValue:[IPAddress currentIPAddress]];
    [parameterManager parserStringWithKey:@"amount" WithValue:self.paymentForm.amount];
    [parameterManager parserStringWithKey:@"businessPart" WithValue:@"HOTEL"];
    [parameterManager parserStringWithKey:@"description" WithValue:self.paymentForm.hotelName];
    
    NSString* httpBodyString = [KAliPayWapURL stringByAppendingFormat:@"?%@",[parameterManager serialization]];
    NSString* uid = TheAppDelegate.userInfo.uid;
    httpBodyString = [httpBodyString stringByAppendingFormat:@"&clientVersion=%@&userId=%@", kClientVersion, uid];
    httpBodyString = [httpBodyString stringByAppendingFormat:@"&sign=%@", [[uid stringByAppendingFormat:kSecurityKey] MD5String]];
    return httpBodyString;
}

#pragma mark - load order payment amount
- (void)loadOrderPaymentAmount
{
    if (!_loadPaymentAmountParser) {
        self.loadPaymentAmountParser = [[LoadPaymentAmountParser alloc] init];
        self.loadPaymentAmountParser.delegate = self;
    }
    [self.loadPaymentAmountParser loadPaymentAmount:self.paymentForm.orderNo];
    [self showIndicatorView];
    //10秒后判断是否有响应 todo
}

- (void)cancelToBillListController
{
    if ([FROM_ORDER_TO_PAY isEqualToString:self.departureSegueId]) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self performSegueWithIdentifier:FROM_PAY_TO_BILL_LIST sender:self];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSUInteger tag = alertView.tag;
    
    switch (buttonIndex)
    {
        case 0:
            if (tag == LOADFAIL_BACKALERTVIEW_TAG) {
                [self loadOrderPaymentAmount];
            }
            break;
        case 1:
            [self cancelToBillListController];
            break;
        default:
            break;
    }
}

- (void)buildOKBackNoticeView
{
    UIAlertView *backNoticeView = [[UIAlertView alloc] initWithTitle:@"提示信息" message:@"当前订单需在预订成功后的30分钟内完成支付，否则将被取消" delegate:self cancelButtonTitle:@"继续支付" otherButtonTitles: nil];
    [backNoticeView addButtonWithTitle:@"暂不支付"];
    _confirmAlertView = backNoticeView;
    _confirmAlertView.tag = LOADOK_BACKALERTVIEW_TAG;
}

-(void)loadPaymentAmountOkAfterProsess:(NSDictionary *) data
{
    NSString *paymentAmount = [data valueForKey:@"paymentAmount"];
    
    [paymentAmount trim];
//    if ([paymentAmount isEqualToString:@""] || [paymentAmount intValue] <= 0 ) {
//        [self loadPaymentAmountFailAfterProsess:nil errCode:-1];
//    }else{
//        self.confirmAlertView.tag = LOADOK_BACKALERTVIEW_TAG;
//    }
    
    self.paymentForm.amount = paymentAmount;
    
    self.bookAmountLabel.text = [NSString stringWithFormat:@"￥%@" ,  self.paymentForm.orderAmount];
    self.paymentAmountLabel.text = [NSString stringWithFormat:@"￥%@" , paymentAmount];
    [self getAlipayInfoAction];
}

-(void)loadPaymentAmountFailAfterProsess:(NSString *)msg errCode:(NSInteger)code
{
    if(-1 == code){
        [self showAlertMessageWithOkButton:@"因服务器繁忙,请稍后重试或者电话支付" title:nil tag:10001 delegate:nil];
    }else{
        [self showAlertMessageWithOkButton:msg title:nil tag:10001 delegate:nil];
    }
    self.confirmAlertView.tag = LOADFAIL_BACKALERTVIEW_TAG;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"YiLianPayViewControllerSegue"])
        [self yiLianPaySegueHandle:segue];
    if ([segue.identifier isEqualToString:FROM_PAY_TO_BILL_LIST]) {
//        [self billListSegueHandle:segue];
    }
    if ([segue.identifier isEqualToString:@"ALipayWap_sugue"]) {
        AlipayWapWebViewController *awwvc = segue.destinationViewController;
        awwvc.orderNo = self.paymentForm.orderNo;
        awwvc.htmlBody = [self buildAlipayWapUrl];
    }
    
    if ([segue.identifier isEqualToString:@"clientAlipaySuccess"]) {
        ClientAlipaySuccessViewController *clientAlipaySuccessViewController = segue.destinationViewController;
        clientAlipaySuccessViewController.paymentForm = self.paymentForm;
    }
}
               
- (void)yiLianPaySegueHandle:(UIStoryboardSegue *)segue
{
    {
        if ([segue.destinationViewController isKindOfClass:[YiLianPayViewController class]])
        {
            YiLianPayViewController *yiLianPayViewController = segue.destinationViewController;
            yiLianPayViewController.navigationItem.title = @"银联语音支付";
            yiLianPayViewController.paymentForm = self.paymentForm;
        }
    }
}


-(void)generatePassbook
{
    if(!_showPassbookController){
        _showPassbookController = [[OrderPassbookViewController alloc] init];
        _showPassbookController.passbookForm = [self buildPassbookForm];
    }
    if (![_showPassbookController readPassUrlFromLocal] && ![_showPassbookController readPassFromLocal]) {
         [_showPassbookController generatePassbook];
    }
   
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

- (void)parser:(GDataXMLParser *)parser DidParsedData:(NSDictionary *)data
{
    if ([parser isKindOfClass:[LoadPaymentAmountParser class]]) {
        [self loadPaymentAmountOkAfterProsess:data];
    } else if ([parser isKindOfClass:[AlipayParser class]]) {
        self.payingInfo = [data valueForKey:@"payInfo"];
        [self hideIndicatorView];
    }
}

- (void)parser:(GDataXMLParser *)parser DidFailedParseWithMsg:(NSString *)msg errCode:(NSInteger)code
{
    if ([parser isKindOfClass:[LoadPaymentAmountParser class]]) {
        [self loadPaymentAmountFailAfterProsess:msg errCode:code];
        [self hideIndicatorView];
    }
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
   return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
    return [self.paymentGatewayList count];
}

- (void)buildCellContentView:(UITableViewCell *)cell row:(NSInteger)row
{
    PaymentType *currentPaymentType = [self.paymentGatewayList objectAtIndex:row];
    currentPaymentType.paymentSelectButton.tag = row;
    cell.textLabel.text =currentPaymentType.name;
    [cell.contentView addSubview:currentPaymentType.paymentSelectButton];
    cell.backgroundColor = [UIColor whiteColor];
    
    NSInteger tempCount = [_paymentGatewayList count] - 1;
    if (row != tempCount) {
        UIImage *tableSplitImg = [UIImage imageNamed:@"order_split.png"];
        UIView *tableSplitView = [[UIView alloc] initWithFrame:CGRectMake(5, 49, 295, 1)];
        tableSplitView.backgroundColor = [UIColor colorWithPatternImage:tableSplitImg];
        [cell.contentView addSubview:tableSplitView];
    }
    
    if (self.isInActivity) {
        PaymentType *type = [self.paymentGatewayList objectAtIndex:row];
        if (type.paymentBusiness == ALIPAY_APP || type.paymentBusiness == ALIPAY_WAP) {
            UILabel *recommendLabel = [[UILabel alloc] initWithFrame:CGRectMake(140, 5, 140, 40)];
            recommendLabel.text = self.payFeedBackDesc;
            recommendLabel.textColor = RGBCOLOR(255, 138, 0);
            recommendLabel.font = [UIFont systemFontOfSize:13];
            [cell.contentView addSubview:recommendLabel];
        }
    } else {
        if (row == 0) {
            float xpoint = 120;
            if ([self.paymentGatewayList count] == 3) {
                xpoint = 140;
            }
            UILabel *recommendLabel = [[UILabel alloc] initWithFrame:CGRectMake(xpoint, 5, 120, 40)];
            recommendLabel.text = @"(推荐)";
            recommendLabel.textColor = RGBCOLOR(255, 138, 0);
            recommendLabel.font = [UIFont systemFontOfSize:15];
            [cell.contentView addSubview:recommendLabel];
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.paymentGatewayList count] <= 0)
    {
        return nil;
    }
    NSInteger row = [indexPath row];
    
    static NSString *CellIdentifier = @"paymentCell";
    UITableViewCell *cell = [self.paymentTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.font = [UIFont systemFontOfSize: 15];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    [self buildCellContentView:cell row:row];
    
    return cell;
}


#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    const unsigned int currentRow = [indexPath row];
    
    PaymentType *currentPaymentType = [self.paymentGatewayList objectAtIndex:currentRow];
    [self clickSelectBtn:currentPaymentType.paymentSelectButton];
}


- (void)viewDidUnload {
    [self setCancelPolicyLabel:nil];
    [super viewDidUnload];
}
@end
