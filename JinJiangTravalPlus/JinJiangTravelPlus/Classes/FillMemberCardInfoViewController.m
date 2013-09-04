//
//  FillMemberCardInfoViewController.m
//  JinJiangTravelPlus
//
//  Created by Raphael.rong on 13-5-22.
//  Copyright (c) 2013年 JinJiang. All rights reserved.
//

#import "AccountInfoViewController.h"
#import "RegistViewController.h"
#import "FillMemberCardInfoViewController.h"
#import "JJSlashLine.h"
#import "ValidateInputUtil.h"
#import "PrepareBuyCardParser.h"
#import "PrepareBuyCardForm.h"
#import "AlipayWapWebViewController.h"
#import "AccountInfoViewController.h"
#import "ParameterManager.h"
#import "IPAddress.h"
#import "NSDataAES.h"
#import "AlixPay.h"
#import "AlipayParser.h"
#import <QuartzCore/QuartzCore.h>
#import "ParameterManager.h"
#import "UserInfoParser.h"

@interface FillMemberCardInfoViewController ()
{
    int provinceRow, cityRow, districtRow, certiRow, keyBoardLength, currentPickerTag;
}

@property (nonatomic, strong) UserInfo *userInfo;
@property (nonatomic, strong) UIActionSheet *paymentActionSheet;
@property (nonatomic, strong) UIActionSheet *actionSheet;
@property (nonatomic, strong) UIPickerView *certiTypePicker;
@property (nonatomic, strong) UIPickerView *locationCodePicker;
@property (nonatomic, strong) NSArray *provinceArray;
@property (nonatomic, strong) NSArray *certiTypeArray;
@property (nonatomic, strong) NSString *certiTypeCode;
@property (nonatomic, strong) PrepareBuyCardForm *pbcForm;
@property (nonatomic, strong) AlipayParser *aliPayParser;
@property (nonatomic, strong) NSString *payingInfo;


@property (nonatomic, strong) UIView* modeView;
@property (nonatomic, strong) UIView* regulaView;
@property (nonatomic, strong) UITextView* textView;
@property (nonatomic, strong) UserInfoParser* userInfoParser;

@end

@implementation FillMemberCardInfoViewController

const int certiTag = 100;
const int locTag = 101;

- (IBAction)didEndOnExit:(id)sender {
    [sender resignFirstResponder];
}
- (IBAction)didNameEndOnExit:(id)sender {
    [sender resignFirstResponder];
}
- (IBAction)didCertiEndOnExit:(id)sender {
    [sender resignFirstResponder];
}
- (IBAction)didPostEndOnExit:(id)sender {
    [sender resignFirstResponder];
}

- (IBAction)tapToExitField:(id)sender {
    [self resignAll];
}

- (void)resignAll
{
    [self.userNameFiled resignFirstResponder];
    [self.idNumberField resignFirstResponder];
    [self.addressField resignFirstResponder];
    [self.postCodeLabel resignFirstResponder];
}

//确认购买按钮点击
- (IBAction)startPreBuyCard:(id)sender {
    self.buyCardForm.userName = self.userNameFiled.text;
    self.buyCardForm.certificateNo = self.idNumberField.text;
    self.buyCardForm.address = self.addressField.text;
    self.buyCardForm.postCode = self.postCodeLabel.text;
    [self createSelectSheet];
}

//键盘退出
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [self setViewMovedUp:NO];
}

//键盘推出
-(void)textFieldDidBeginEditing:(UITextField *)sender
{
    keyBoardLength = sender.tag;
    if  (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
}

//屏幕上下滑动
-(void)setViewMovedUp:(BOOL)movedUp
{
    CGRect rect = self.view.frame;
    if (movedUp)
    {
        rect.origin.y -= keyBoardLength;
        rect.size.height += keyBoardLength;
    }
    else
    {
        rect.origin.y += keyBoardLength;
        rect.size.height -= keyBoardLength;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame = rect;
    }];
}

- (void)pushAccountInfoController:(id) sender
{
//    [UMAnalyticManager eventCount:@"支付宝客户端支付完成" label:@"支付宝客户端支付完成回调"];
    [self performSegueWithIdentifier:BUY_CARD_SUCCESS sender:nil];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"购买享卡"];
    
    //注册通知，支付宝安全支付成功接收通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushAccountInfoController:) name:@"ClientBuyCardFinished" object:nil];
    
    //购买享卡表单
    self.buyCardForm = [[BuyCardForm alloc] init];
    self.buyCardForm.amount = @"158.0";
    
    self.userNameFiled.delegate = self;
    self.idNumberField.delegate = self;
    self.addressField.delegate = self;
    self.postCodeLabel.delegate = self;
    self.userNameFiled.tag = 0;
    self.idNumberField.tag = 0;
    self.addressField.tag = 120;
    self.postCodeLabel.tag = 160;
    
    //获取用户信息
    self.userInfo = TheAppDelegate.userInfo;
    self.userNameFiled.text = self.userInfo.fullName;
    self.idNumberField.text = self.userInfo.identityNo;
    
    //初始化省市名与省市code
    NSString* provincePath = [[NSBundle mainBundle] pathForResource:@"province" ofType:@"plist"];
    self.provinceArray = [NSArray arrayWithContentsOfFile:provincePath];
    
    //初始化证件类型
    NSString* certificateTypePath = [[NSBundle mainBundle] pathForResource:@"certificateType" ofType:@"plist"];
    self.certiTypeArray = [NSArray arrayWithContentsOfFile:certificateTypePath];
    NSString *certiTyp = @"";
    for (NSDictionary *dict in self.certiTypeArray) {
        //取出已存在的证件名称
        if ([(NSString *)[dict objectForKey:@"code"] isEqualToString:self.userInfo.identityType])
        {
            certiTyp = [dict objectForKey:@"name"];
            self.buyCardForm.certificateType = [dict objectForKey:@"code"];
            break;
        }
    }
    self.certiTypeLabel.text = certiTyp;
    
    //所有选框默认选项调至第一行
    [self initSelectRowNum];
    
    [self addRegulaModeView];
}

- (void)viewWillAppear:(BOOL)animated
{
    //显示享卡价格，如非158元，示意取消原价格
    if (self.price.floatValue < 158.0) {
        self.priceLabel.textColor = [UIColor grayColor];
        CGRect frame = self.priceLabel.frame;
        JJSlashLine *slashLine = [[JJSlashLine alloc] initWithFrame:frame];
        slashLine.contentMode = UIViewContentModeRedraw;
        slashLine.backgroundColor = [UIColor clearColor];
        [self.view addSubview:slashLine];
        self.truePriceLabel.text = [NSString stringWithFormat:@"%@元", self.price];
        self.buyCardForm.amount = self.price;
        self.truePriceLabel.hidden = NO;
    }
}

//初始化省市选择框选项
- (void)initSelectRowNum
{
    provinceRow = 0;
    cityRow = 0;
    districtRow = 0;
}

- (void)initRowIsCity:(BOOL)isCity
{
    if (isCity) {
        districtRow = 0;
    } else {
        cityRow = 0;
        districtRow = 0;
    }
}

//验证信息并提交购买享卡请求
- (void)createSelectSheet
{
    if ([self.buyCardForm checkValueNotNull]) {
        [self showIndicatorView];
        PrepareBuyCardParser *pbcParser = [[PrepareBuyCardParser alloc] init];
        pbcParser.delegate = self;
        [pbcParser buyCardRequest:self.buyCardForm];

    }
}

//选择支付方式
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            [self performSegueWithIdentifier:FROM_PREBUY_TO_PAY_WEB sender:self];
            break;
        }
        case 1:
        {
            
            self.aliPayParser = [[AlipayParser alloc] init];
            self.aliPayParser.serverAddress = KAliPayClientURL;
            
            ParameterManager *parameterManager = [[ParameterManager alloc] init];
            [parameterManager parserStringWithKey:@"orderNo" WithValue:self.pbcForm.orderNo];
            [parameterManager parserStringWithKey:@"subject" WithValue:@"购买享卡"];
            [parameterManager parserStringWithKey:@"description" WithValue:@"IOS用户购买享卡"];
            [parameterManager parserStringWithKey:@"bgUrl" WithValue:self.pbcForm.bgUrl];
            [parameterManager parserStringWithKey:@"payAmount" WithValue:self.buyCardForm.amount];
//            [parameterManager parserStringWithKey:@"payAmount" WithValue:@"0.01"];
            [parameterManager parserStringWithKey:@"businessPart" WithValue:@"MEMCARD"];
            [parameterManager parserStringWithKey:@"buyerName" WithValue:self.buyCardForm.userName];
            [parameterManager parserStringWithKey:@"buyerIp" WithValue:[IPAddress currentIPAddress]];
            
            self.aliPayParser.requestString = [parameterManager serialization];
            self.aliPayParser.delegate = self;
            [self.aliPayParser start];
            break;
        }
        case 2:
        {
            [self setViewMovedUp:NO];
            break;
        }
            
        default:
            break;
    }
}

//跳转至网页支付
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([FROM_PREBUY_TO_PAY_WEB isEqualToString:segue.identifier]) {
        
        AlipayWapWebViewController *awwvc = segue.destinationViewController;
        awwvc.orderNo = self.pbcForm.orderNo;
        awwvc.htmlBody = [self buildAlipayWapUrl];
        awwvc.sourceControlelr = @"buyCard";
    } else if ([BUY_CARD_SUCCESS isEqualToString:segue.identifier]) {
        ((AccountInfoViewController *)segue.destinationViewController).isNeedRefresh = YES;
    }
}

//拼接支付宝客户端支付报文
- (NSString *)buildAlipayWapUrl
{
    ParameterManager *parameterManager = [[ParameterManager alloc] init];
    [parameterManager parserStringWithKey:@"orderNo" WithValue:self.pbcForm.orderNo];
    [parameterManager parserStringWithKey:@"buyerName" WithValue:self.buyCardForm.userName];
    [parameterManager parserStringWithKey:@"buyerIp" WithValue:[IPAddress currentIPAddress]];
    [parameterManager parserStringWithKey:@"amount" WithValue:self.buyCardForm.amount];
    [parameterManager parserStringWithKey:@"bgUrl" WithValue:self.pbcForm.bgUrl];
    [parameterManager parserStringWithKey:@"businessPart" WithValue:@"MEMCARD"];
    
    [parameterManager parserStringWithKey:@"description" WithValue:@"app 用户购买享卡"];
    
    NSString* httpBodyString = [KAliPayWapURL stringByAppendingFormat:@"?%@",[parameterManager serialization]];
    NSString* uid = TheAppDelegate.userInfo.uid;
    httpBodyString = [httpBodyString stringByAppendingFormat:@"&clientVersion=%@&userId=%@", kClientVersion, uid];
    httpBodyString = [httpBodyString stringByAppendingFormat:@"&sign=%@", [[uid stringByAppendingFormat:kSecurityKey] MD5String]];
    return httpBodyString;
}

//创建选择框,YES为身份类型选择框,NO为省份选择框
- (void)createActionSheet:(BOOL)isID
{
    self.actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:nil
                                                    cancelButtonTitle:nil
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:nil];
    
    [self.actionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    self.actionSheet.backgroundColor = [UIColor blackColor];
    
    CGRect pickerFrame = CGRectMake(0, 40, 0, 0);
    if (isID) {
        self.certiTypePicker = [[UIPickerView alloc] initWithFrame:pickerFrame];
        self.certiTypePicker.tag = certiTag;
        self.certiTypePicker.showsSelectionIndicator = YES;
        self.certiTypePicker.dataSource = self;
        self.certiTypePicker.delegate = self;
        currentPickerTag = certiTag;
        
        [self.actionSheet addSubview:self.certiTypePicker];
    } else {
        self.locationCodePicker = [[UIPickerView alloc] initWithFrame:pickerFrame];
        self.locationCodePicker.tag =locTag;
        self.locationCodePicker.showsSelectionIndicator = YES;
        self.locationCodePicker.dataSource = self;
        self.locationCodePicker.delegate = self;
        currentPickerTag = locTag;
        
        [self.actionSheet addSubview:self.locationCodePicker];
    }
    //关闭选择框按钮
    UISegmentedControl *closeButton = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:@"关闭"]];
    closeButton.momentary = YES;
    closeButton.frame = CGRectMake(10, 7, 50, 30);
    closeButton.segmentedControlStyle = UISegmentedControlStyleBar;
    closeButton.tintColor = [UIColor blackColor];
    [closeButton addTarget:self action:@selector(dismissActionSheet:) forControlEvents:UIControlEventValueChanged];
    [self.actionSheet addSubview:closeButton];
    
    //确定选择结果按钮
    UISegmentedControl *doneButton = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:@"确认"]];
    doneButton.momentary = YES;
    doneButton.frame = CGRectMake(260, 7, 50, 30);
    doneButton.segmentedControlStyle = UISegmentedControlStyleBar;
    doneButton.tintColor = [UIColor blackColor];
    [doneButton addTarget:self action:@selector(donelocationCodePick:) forControlEvents:UIControlEventValueChanged];
    [self.actionSheet addSubview:doneButton];
    
    [self.actionSheet showInView:[[UIApplication sharedApplication] keyWindow]];
    
    [self.actionSheet setBounds:CGRectMake(0, 0, 320, 485)];
   
}

- (BOOL)checkRow:(int)row isAvalibleForArray:(NSArray *)array
{
    return array.count > row;
}

//确认选择结果
- (void)donelocationCodePick:(id)sender
{
    [self.actionSheet dismissWithClickedButtonIndex:0 animated:YES];
    
    
    if (currentPickerTag == certiTag) {
        
        NSDictionary *certiTypeDict = [self.certiTypeArray objectAtIndex:certiRow];
        self.buyCardForm.certificateType = [certiTypeDict objectForKey:@"code"];
        self.certiTypeLabel.text = [certiTypeDict objectForKey:@"name"];
    } else {
        NSString *buttonTitle = @"";
        @try {
            NSDictionary *selectedProvinceDict = [self.provinceArray objectAtIndex:provinceRow];
            
            NSDictionary *selectedCityDict = [(NSArray *)[selectedProvinceDict objectForKey:@"city"] objectAtIndex:cityRow];
            
            NSDictionary *selectedDistrictDict = [(NSArray *)[selectedCityDict objectForKey:@"district"] objectAtIndex:districtRow];
            
            self.buyCardForm.provinceId = [selectedProvinceDict objectForKey:@"code"];
            self.buyCardForm.cityId = [selectedCityDict objectForKey:@"code"];
            self.buyCardForm.districtId = [selectedDistrictDict objectForKey:@"code"];
            
            buttonTitle = [NSString stringWithFormat:@"%@ %@ %@", [selectedProvinceDict objectForKey:@"name"], [selectedCityDict objectForKey:@"name"], [selectedDistrictDict objectForKey:@"name"]];
            self.locationLabel.text = buttonTitle;
        }
        @catch (NSException *exception) {
            buttonTitle = @"";
        }
        @finally {
            
            self.locationLabel.text = buttonTitle;
        }
        NSDictionary *selectedProvinceDict = [self.provinceArray objectAtIndex:provinceRow];
        
        NSDictionary *selectedCityDict = [(NSArray *)[selectedProvinceDict objectForKey:@"city"] objectAtIndex:cityRow];
        
        NSDictionary *selectedDistrictDict = [(NSArray *)[selectedCityDict objectForKey:@"district"] objectAtIndex:districtRow];
        
        self.buyCardForm.provinceId = [selectedProvinceDict objectForKey:@"code"];
        self.buyCardForm.cityId = [selectedCityDict objectForKey:@"code"];
        self.buyCardForm.districtId = [selectedDistrictDict objectForKey:@"code"];
        
        
    }
}

- (void) backHome: (id) sender
{
    [self backToController:[AccountInfoViewController class]];
}

- (void)backToController:(Class)className
{
    
    NSArray *viewControlelrs = self.navigationController.viewControllers;
    for (JJViewController *jjvc in viewControlelrs) {
        if ([jjvc isKindOfClass:AccountInfoViewController.class]) {
            ((AccountInfoViewController *)jjvc).isNeedRefresh = YES;
            [self.navigationController popToViewController:jjvc animated:YES];
            break;
        }
    }
}

//关闭选择框
- (void)dismissActionSheet:(id)sender
{
    [self.actionSheet dismissWithClickedButtonIndex:0 animated:YES];
}

- (IBAction)idTypePressed:(id)sender {
    
    [self createActionSheet:YES];
}

- (IBAction)locationCodePressed:(id)sender {
    [self initSelectRowNum];
    [self createActionSheet:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - pickerView datasource start

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
    if (pickerView.tag == certiTag) {
        return [self.certiTypeArray count];
    }
    
    int num = 0;
    //三级菜单行数更新
    switch (component) {
        case 0:
            num = self.provinceArray.count;
            break;
            
        case 1:
        {
            provinceRow = self.provinceArray.count <= provinceRow ? 0 : provinceRow;
            NSArray *cityList = [(NSDictionary *)[self.provinceArray objectAtIndex:provinceRow] objectForKey:@"city"];
            num = cityList.count;
            break;
        }
        case 2:
        {
            provinceRow = self.provinceArray.count <= provinceRow ? 0 : provinceRow;
            NSArray *cityList = [(NSDictionary *)[self.provinceArray objectAtIndex:provinceRow] objectForKey:@"city"];
            cityRow = cityList.count <= cityRow ? 0 : cityRow;
            NSArray *districtList = [(NSDictionary *)[cityList objectAtIndex:cityRow] objectForKey:@"district"];
            num = districtList.count;
            break;
        }
        default:
            num = 0;
            break;
    }
    return num;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return pickerView.tag == certiTag ? 1 : 3;
}


#pragma mark - pickerView delegate start
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pickerView.tag == certiTag) {
        certiRow = row;
        return;
    }
    //根据选择项，更新三级菜单内容
    switch (component) {
        case 0:
            
            provinceRow = row;
            [self initRowIsCity:NO];
            [pickerView reloadAllComponents];
            
            break;
        case 1:
            cityRow = row;
            [self initRowIsCity:YES];
            [pickerView reloadAllComponents];
            break;
        case 2:
            districtRow = row;
            break;
        default:
            break;
    }
    
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView.tag == certiTag) {
        NSDictionary *certiDict = [self.certiTypeArray objectAtIndex:row];
        return [certiDict objectForKey:@"name"];
    }
    
    NSString *title = @"";
    //生成各选择框内容
    switch (component) {
        case 0:
        {
            NSDictionary *provinceDict = [self.provinceArray objectAtIndex:row];
            title = [provinceDict objectForKey:@"name"];
            break;
        }
        case 1:
        {
            NSDictionary *provinceDict = [self.provinceArray objectAtIndex:provinceRow];
            NSDictionary *cityDict = [(NSArray *)[provinceDict objectForKey:@"city"] objectAtIndex:row];
            title = [cityDict objectForKey:@"name"];
            break;
        }
        case 2:
        {
            NSDictionary *provinceDict = [self.provinceArray objectAtIndex:provinceRow];
            NSDictionary *cityDict = [(NSArray *)[provinceDict objectForKey:@"city"] objectAtIndex:cityRow];
            NSDictionary *districtDict = [(NSArray *)[cityDict objectForKey:@"district"] objectAtIndex:row];

            title = [districtDict objectForKey:@"name"];
            break;
        }
        default:
            break;
    }
    return title;
}

#pragma mark - GDataXMLParserDelegate

- (void)parser:(GDataXMLParser *)parser DidParsedData:(NSDictionary *)data
{
    if ([parser isKindOfClass:[PrepareBuyCardParser class]])
    {
        [self hideIndicatorView];
        
        self.pbcForm = (PrepareBuyCardForm *)[data objectForKey:@"pbcForm"];
        if (![self.pbcForm.code isEqualToString:@"1000"]) {
            return;
        }
        
        
        self.paymentActionSheet = [[UIActionSheet alloc] initWithTitle:@"请选择支付方式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"支付宝网页支付", @"支付宝客户端支付", nil];
        [self.paymentActionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
        [self.paymentActionSheet showInView:[[UIApplication sharedApplication] keyWindow]];
        
        
        [[GAI sharedInstance].defaultTracker sendEventWithCategory:@"购买享卡"
                                                        withAction:@"购买享卡订单生成"
                                                         withLabel:@"购买享卡订单生成"
                                                         withValue:nil];
        [UMAnalyticManager eventCount:@"购买享卡订单生成" label:[NSString stringWithFormat:@"购买享卡订单生成"]];
        
        self.actionSheet.backgroundColor = [UIColor blackColor];
        keyBoardLength = 0;
        if  (self.view.frame.origin.y >= 0)
        {
            [self setViewMovedUp:YES];
        }
    } else if ([parser isKindOfClass:[AlipayParser class]])
    {
        
        self.payingInfo = [data valueForKey:@"payInfo"];
        [self hideIndicatorView];
        
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
    }

}
- (IBAction)registConfirmButtonPress:(UIButton *)sender {
    [self showRegisterRegulations];
}

- (void)showRegisterRegulations
{
    [self resignAll];
    self.modeView.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.modeView.hidden = NO;
        self.textView.text = JJ_MEMBER_PROTOCOL;
        self.regulaView.frame = CGRectMake(20, 80, 280, 370);
    }completion:NULL];
}

- (void)addRegulaModeView
{
    self.modeView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    self.modeView.backgroundColor = [UIColor blackColor];
    self.modeView.alpha = 0.5;
    [self.navigationController.view.window addSubview:self.modeView];
    
    self.regulaView = [[UIView alloc] initWithFrame:CGRectMake(20, 600, 280, 370)];
    self.regulaView.backgroundColor = [UIColor clearColor];
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(245, 0, 35, 35);
    [closeBtn setBackgroundImage:[UIImage imageNamed:@"button-close.png"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(hideRegisterRegulations) forControlEvents:UIControlEventTouchUpInside];
    
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 25, 280, 335)];
    self.textView.editable = NO;
    
    CALayer *subLayer = [CALayer layer];
    subLayer.backgroundColor = [UIColor whiteColor].CGColor;
    subLayer.shadowOffset = CGSizeMake(0, 1);
    subLayer.shadowRadius = 5.0;
    subLayer.shadowColor = [UIColor blackColor].CGColor;
    subLayer.shadowOpacity = 0.8;
    subLayer.frame = CGRectMake(0, 0, 280, 370);
    subLayer.cornerRadius = 10;
    subLayer.borderWidth = 0;
    [self.regulaView.layer addSublayer:subLayer];
    [self.regulaView addSubview:self.textView];
    [self.regulaView addSubview:closeBtn];
    
    [self.navigationController.view.window addSubview:self.regulaView];
    [self.modeView setHidden:YES];
}

- (void)hideRegisterRegulations
{
    [UIView animateWithDuration:0.3 animations:^{
        self.regulaView.frame = CGRectMake(20, 600, 280, 370);
    }completion:^(BOOL finished) {
        self.modeView.hidden = YES;
    }];
}

- (void)viewDidUnload {
    [self setUserNameFiled:nil];
    [self setIdNumberField:nil];
    [self setAddressField:nil];
    [self setIdTypeButton:nil];
    [self setLocationCodeButton:nil];
    [self setLocationLabel:nil];
    [self setCertiTypeLabel:nil];
    [self setPriceLabel:nil];
    [self setTruePriceLabel:nil];
    [self setPostCodeLabel:nil];
    [super viewDidUnload];
}
@end
