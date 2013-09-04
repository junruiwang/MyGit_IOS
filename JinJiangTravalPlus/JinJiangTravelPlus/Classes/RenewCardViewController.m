//
//  RenewCardViewController.m
//  JinJiangTravelPlus
//
//  Created by 胡 桂祁 on 7/26/13.
//  Copyright (c) 2013 JinJiang. All rights reserved.
//

#import "RenewCardViewController.h"
#import "IPAddress.h"
#import "AlipayWapWebViewController.h"
#import "AccountInfoViewController.h"
#import "AlixPay.h"

@interface RenewCardViewController ()

@property(nonatomic,strong) UIActionSheet *paymentActionSheet;


@end

@implementation RenewCardViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //注册通知，支付宝安全支付成功接收通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushAccountInfoController:) name:@"ClientAlipayRenewCardFinished" object:nil];
    
    [self initDescView];
    if ([self isYueXiangCard]) {
        [self.reNewcardBgImg setImage:[UIImage imageNamed:@"renewCard_yue.png"]];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    self.trackedViewName = @"享卡续费页面";
    [super viewWillAppear:animated];
}

-(void)initDescView
{
    self.fullNameLabel.text = TheAppDelegate.userInfo.fullName;
    self.cardNoLabel.text = TheAppDelegate.userInfo.cardNo;
    NSString *dueDate = TheAppDelegate.userInfo.dueDate;
    NSInteger month = [[dueDate substringToIndex:2] integerValue];
    NSInteger year = [[dueDate substringFromIndex:3] integerValue];
    NSString *dueDateStr = [NSString stringWithFormat:@"20%i年%i月",year,month];
    NSString *buiedDueDateStr = [NSString stringWithFormat:@"20%i年%i月",year + 2,month];
    NSString *descStr1 = [NSString stringWithFormat:@"您的享卡(锦江之星9拆卡)将在%@",dueDateStr];
    if ([self isYueXiangCard]) {
        descStr1 = [NSString stringWithFormat:@"您的悦享卡(锦江之星9拆卡)将在%@",dueDateStr];
    }
    NSString *descStr3 = buiedDueDateStr;
    self.descLabel1.text = descStr1;
    self.descLabel3.text = descStr3;

}

-(BOOL)isYueXiangCard
{
    NSString *userCardType = TheAppDelegate.userInfo.cardType;
    if ([userCardType isEqualToString:(J2BENEFITCARD)]) {
        return YES;
    }
    return NO;
}

-(IBAction)createOrderForBuy:(id)sender
{
    [self showIndicatorView];
    [self.renewCardParser createOrder:TheAppDelegate.userInfo.cardNo];
}

- (void)pushAccountInfoController:(id) sender
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"享卡续费支付成功，系统将在1小时后续费生效，请1小时后重新登陆,如有疑问请致电客服电话1010-1666" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
    [self performSegueWithIdentifier:RENEW_CARD_SUCCESS sender:nil];
}

-(RenewCardParser *) renewCardParser
{
    if (!_renewCardParser) {
        _renewCardParser = [[RenewCardParser alloc] init];
        _renewCardParser.delegate = self;
    }
    return _renewCardParser;
}

-(RenewOrderPriceParser *)renewOrderPriceParser
{
    if (!_renewOrderPriceParser) {
        _renewOrderPriceParser = [[RenewOrderPriceParser alloc] init];
        _renewOrderPriceParser.delegate = self;
    }
    return _renewOrderPriceParser;
}

-(AlipayParser *) alipayParser{
    if (!_alipayParser) {
        _alipayParser = [[AlipayParser alloc] init];
        _alipayParser.delegate = self;
    }
    return _alipayParser;
}

-(UIActionSheet *)paymentActionSheet
{
    if (!_paymentActionSheet) {
        _paymentActionSheet = [[UIActionSheet alloc] initWithTitle:@"请选择支付方式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"支付宝网页支付", @"支付宝客户端支付", nil];
        [_paymentActionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    }
    return _paymentActionSheet;
}

-(AlipayForm *)alipayForm
{
    if (!_alipayForm) {
        _alipayForm = [[AlipayForm alloc] init];
    }
    _alipayForm.orderNo = self.orderNo;
    _alipayForm.bgUrl = self.bgUrl;
    _alipayForm.amount = self.amount;
    _alipayForm.businessPart = @"RECHARGE";
    _alipayForm.description = @"享卡会员手机续费";
    _alipayForm.subject = @"享卡续费";
    if([self isYueXiangCard]){
        _alipayForm.description = @"悦享卡会员手机续费";
        _alipayForm.subject = @"享卡续费";
    }
    _alipayForm.buyerIp = [IPAddress currentIPAddress];
    _alipayForm.buyerName = TheAppDelegate.userInfo.fullName;
    
    return _alipayForm;
}

//选择支付方式
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            [self performSegueWithIdentifier:FROM_RENEWCARD_TO_PAY_WEB sender:self];
            break;
        }
        case 1:
        {
            [self.alipayParser payment:self.alipayForm];
            break;
        }
        case 2:
        {
            [super actionSheet:actionSheet clickedButtonAtIndex:buttonIndex];
            break;
        }
            
        default:
            break;
    }
}

//跳转至网页支付
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([FROM_RENEWCARD_TO_PAY_WEB isEqualToString:segue.identifier]) {
        
        AlipayWapWebViewController *awwvc = segue.destinationViewController;
        [awwvc buildAlipayWapUrl:self.alipayForm];
        awwvc.sourceControlelr = @"renewCard";
    } else if ([BUY_CARD_SUCCESS isEqualToString:segue.identifier]) {
        ((AccountInfoViewController *)segue.destinationViewController).isNeedRefresh = YES;
    }
}



#pragma mark - GDataXMLParserDelegate DidFailedParseWithMsg
- (void)parser:(GDataXMLParser*)parser DidFailedParseWithMsg:(NSString*)msg errCode:(NSInteger)code
{
    [self hideIndicatorView];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示信息" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}

#pragma mark - GDataXMLParserDelegate DidParsedData
- (void)parser:(GDataXMLParser*)parser DidParsedData:(NSDictionary *)data
{
     [self hideIndicatorView];
    if ([parser isKindOfClass:[RenewCardParser class]]) {
        NSString *orderNo = [data objectForKey:kKeyOrderNo];
        self.orderNo = orderNo;
        [self.renewOrderPriceParser getOrderPayInfo:orderNo];
    }
    if ([parser isKindOfClass:[RenewOrderPriceParser class]]) {
        self.amount = [data objectForKey:kKeyAmount];
        self.bgUrl = [data objectForKey:kKeyBgUrl];
        
        [self.paymentActionSheet showInView:self.view];
    }
    
    if ([parser isKindOfClass:[AlipayParser class]]){
        //获取安全支付单例并调用安全支付接口
        AlixPay * alixpay = [AlixPay shared];
        int ret = [alixpay pay:[data valueForKey:@"payInfo"] applicationScheme:kAppScheme];
        
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
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
