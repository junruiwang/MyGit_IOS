//
//  OrderBookSuccessNeedPayViewController.m
//  JinJiangTravelPlus
//
//  Created by 胡 桂祁 on 12/26/12.
//  Copyright (c) 2012 JinJiang. All rights reserved.
//

#import "YiLianPayViewController.h"
#import "PayerVerifyForm.h"
#import "PayerVerifyResult.h"
#import "ValidateInputUtil.h"
#import "SVProgressHUD.h"
#import "OrderDetailController.h"
#import <QuartzCore/QuartzCore.h>

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone3gs ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(320, 480), [[UIScreen mainScreen] currentMode].size) : NO)

#define TAG_FOR_CREDITCARD_BUTTON 100
#define TAG_FOR_DEBITCARD_BUTTON 101

#define ORDER_DETAIL_TAG 1
#define ALERT_TAG 0

#define CREDITCARD @"CREDITCARD"
#define DEBITCARD @"DEBITCARD"
#define TEXTFILED_PLACEHOLDER @"必填"

const unsigned int openingBankCityNameField_tag = 9090;
const unsigned int openingBankPhoneField_tag = 9099;

@interface YiLianPayViewController ()

@property float upHeight;
@property BOOL isNewOrGrayPanel;
@property (nonatomic, strong) UIButton *doneInKeyboardButton;
@property (nonatomic, copy) NSString *currentTextFieldTag;
@property (nonatomic, copy) NSString *oldMoileValue;
@property (nonatomic, copy) NSString *oldCardNoValue;
@property (nonatomic,strong) UIAlertView *confirmAlertView;

- (void)callPhone:(id)sender;
- (void) backHome: (id) sender;
- (void)initWhenVerifyResultIsNewOrGay;
- (void)showSideCity:(id)sender;
- (void)registKeyBoardNotification;
- (void) initCallPayButton;
-(void)applySuccessProcess;

@end

static float KEYBORAD_Y = 216.0;
static float ADJUSTMENT_Y = 35.0;


@implementation YiLianPayViewController

//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//
//}

- (void)viewWillAppear:(BOOL)animated
{
    self.trackedViewName = @"易联支付录入页面";
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.view removeGestureRecognizer:singleTap];
}

- (void) backHome: (id) sender
{
    if (_confirmAlertView.tag == ALERT_TAG) {
        [_confirmAlertView show];
    }else{
        [self performSegueWithIdentifier:FROM_PAY_SUCCESS_TO_BILL sender:self];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
                [self.navigationController popViewControllerAnimated:YES];
            break;
        case 1:
            break;
        default:
            break;
    }
}

- (void)initWhenVerifyResultIsNewOrGay
{
    self.openingBankNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(27.0, 198.0, 76.0, 21.0)];
    self.openingBankNameLabel.text = @"开户姓名:";
    self.openingBankNameLabel.font = [UIFont systemFontOfSize:14.0];
    self.openingBankNameLabel.backgroundColor = [UIColor clearColor];
    self.openingBankNameLabel.hidden = YES;
    [self.inputViewForWihte addSubview:self.openingBankNameLabel];
    
    self.openingBankNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(109.0, 198.0, 175.0, 30.0)];
    [self.openingBankNameTextField setBorderStyle:UITextBorderStyleRoundedRect];
    [self.openingBankNameTextField setHidden:YES];
    [self.openingBankNameTextField setDelegate:self];
    self.openingBankNameTextField.placeholder = TEXTFILED_PLACEHOLDER;
    
    self.openingBankNameTextField.tag = 3;
    self.openingBankNameTextField.delegate = self;
    self.openingBankNameTextField.returnKeyType = UIReturnKeyNext;
    [self.openingBankNameTextField addTarget:self action:@selector(editingDidNext:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.inputViewForWihte addSubview:self.openingBankNameTextField];
    
    self.openingBankIdNoLabel = [[UILabel alloc] initWithFrame:CGRectMake(27.0, 243.0, 76.0, 21.0)];
    self.openingBankIdNoLabel.text = @"身份证号:";
    self.openingBankIdNoLabel.font = [UIFont systemFontOfSize:14.0];
    self.openingBankIdNoLabel.backgroundColor = [UIColor clearColor];
    self.openingBankIdNoLabel.hidden = YES;
    [self.inputViewForWihte addSubview:self.openingBankIdNoLabel];
    
    self.openingBankIdNoField = [[UITextField alloc] initWithFrame:CGRectMake(109.0, 243.0, 175.0, 30.0)];
    [self.openingBankIdNoField setBorderStyle:UITextBorderStyleRoundedRect];
    self.openingBankIdNoField.hidden = YES;
    self.openingBankIdNoField.keyboardType=UIKeyboardAppearanceDefault;
    self.openingBankIdNoField.returnKeyType = UIReturnKeyNext;
    self.openingBankIdNoField.tag = 4;
    self.openingBankIdNoField.delegate = self;
    [self.openingBankIdNoField setDelegate:self];
    [self.inputViewForWihte addSubview:self.openingBankIdNoField];
    [self.openingBankIdNoField addTarget:self action:@selector(editingDidNext:) forControlEvents:UIControlEventEditingDidEndOnExit];
    self.openingBankIdNoField.placeholder = TEXTFILED_PLACEHOLDER;
    
    self.openingBankPhoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(27.0, 288.0, 76.0, 21.0)];
    self.openingBankPhoneLabel.text = @"开户电话:";
    self.openingBankPhoneLabel.font = [UIFont systemFontOfSize:14.0];
    self.openingBankPhoneLabel.backgroundColor = [UIColor clearColor];
    self.openingBankPhoneLabel.hidden = YES;
    [self.inputViewForWihte addSubview:self.openingBankPhoneLabel];
    
    self.openingBankPhoneField = [[UITextField alloc] initWithFrame:CGRectMake(109.0, 288.0, 175.0, 30.0)];
    [self.openingBankPhoneField setBorderStyle:UITextBorderStyleRoundedRect];
    self.openingBankPhoneField.hidden = YES;
    self.openingBankPhoneField.keyboardType= UIKeyboardTypeNumberPad;
    self.openingBankPhoneField.returnKeyType = UIReturnKeyNext;
    [self.openingBankPhoneField setDelegate:self];
    [self.openingBankPhoneField addTarget:self action:@selector(editingDidNext:) forControlEvents:UIControlEventEditingDidEndOnExit];
    self.openingBankPhoneField.placeholder = TEXTFILED_PLACEHOLDER;
    
    self.openingBankPhoneField.tag = openingBankPhoneField_tag;
    self.openingBankPhoneField.delegate = self;
    [self.inputViewForWihte addSubview:self.openingBankPhoneField];
    
    self.openingBankCityNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(27.0, 333.0, 76.0, 21.0)];
    self.openingBankCityNameLabel.text = @"开户行城市:";
    self.openingBankCityNameLabel.font = [UIFont systemFontOfSize:14.0];
    self.openingBankCityNameLabel.backgroundColor = [UIColor clearColor];
    self.openingBankCityNameLabel.hidden = YES;
    [self.inputViewForWihte addSubview:self.openingBankCityNameLabel];
    
    self.openingBankCityNameField = [[UITextField alloc] initWithFrame:CGRectMake(109.0, 333.0, 175.0, 30.0)];
    [self.openingBankCityNameField setBorderStyle:UITextBorderStyleRoundedRect];
    [self.openingBankCityNameField setHidden:YES];
    [self.openingBankCityNameField setKeyboardType:UIKeyboardTypeDefault];
    [self.openingBankCityNameField setReturnKeyType:UIReturnKeyDone];
    [self.openingBankCityNameField addTarget:self action:@selector(editingDidNext:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.openingBankCityNameField setTag:openingBankCityNameField_tag];
    [self.openingBankCityNameField setDelegate:self];
    [self.inputViewForWihte addSubview:self.openingBankCityNameField];
    self.openingBankCityNameField.placeholder = TEXTFILED_PLACEHOLDER;

    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:self.openingBankCityNameField.frame];
    [btn setBackgroundColor:[UIColor clearColor]];
    [btn addTarget:self action:@selector(showSideCity:) forControlEvents:UIControlEventTouchUpInside];
    [self.inputViewForWihte addSubview:btn];
}

- (void)showSideCity:(id)sender
{
    [self.openingBankPhoneField resignFirstResponder];
    [self showBankCityListView];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField.tag == 2)
    {
        if([[textField.text stringByReplacingOccurrencesOfString:@" " withString:@""] length]%4 == 0)
        {
            textField.text = [NSString stringWithFormat:@"%@ ", textField.text];
        }
    }

    return YES;
}

- (void)registKeyBoardNotification
{
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)buildOKBackNoticeView
{
    UIAlertView *backNoticeView = [[UIAlertView alloc] initWithTitle:@"提示信息" message:@"当前订单需在预订成功后的30分钟内完成支付，否则将被取消" delegate:self cancelButtonTitle:@"选择其它支付方式" otherButtonTitles: nil];
    [backNoticeView addButtonWithTitle:@"继续支付"];
    _confirmAlertView = backNoticeView;
    _confirmAlertView.tag = ALERT_TAG;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.bookAmountLabel.textColor = RGBCOLOR(233.0f, 107.0f, 50.00f);
    self.paymentAmountLabel.textColor = RGBCOLOR(233.0f, 107.0f, 50.00f);

    self.orderInfoView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"orderSuccess_bg_top.png"]];
    self.splitLine1.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dashed.png"]];
    self.splitLine2.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dashed.png"]];
    self.applyPayResultView.hidden = YES;

    self.progressBarView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"unionPay_middle_bg.png"]];

    self.inputViewForWihte.scrollEnabled = NO;
    [self.inputViewForWihte setContentSize:CGSizeMake(286, 420)];
    self.mobileTextField.tag = 1;
    self.mobileTextField.delegate = self;
    self.mobileTextField.placeholder = TEXTFILED_PLACEHOLDER;

    self.cardNoTextField.tag = 2;
    self.cardNoTextField.delegate = self;
    self.cardNoTextField.placeholder = TEXTFILED_PLACEHOLDER;
    
    self.confirmPayButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.confirmPayButton.frame = CGRectMake(34, 198.0, 251.0, 37.0);
    [self.confirmPayButton setBackgroundImage:[UIImage imageNamed:@"common_btn_blue.png"] forState:UIControlStateNormal];
    [self.confirmPayButton setBackgroundImage:[UIImage imageNamed:@"common_btn_blue_press.png"] forState:UIControlStateHighlighted];
    
    self.confirmPayButton.hidden = YES;
    [self.confirmPayButton addTarget:self action:@selector(payment:) forControlEvents:UIControlEventTouchUpInside |UIControlEventTouchUpOutside];
    [self.inputViewForWihte addSubview:self.confirmPayButton];

    [self initWhenVerifyResultIsNewOrGay];
    self.verifyAndPaymentParser = [[PayerVerifyParser alloc] init];
    self.verifyAndPaymentParser.delegate = self;

    self.payerVerifyForm = [[PayerVerifyForm alloc] init];
    self.payController = [[PayController alloc] init];
    self.payController.delegate = self;


    singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backgroudTap:)];
    [self.view addGestureRecognizer:singleTap];
    [self.inputViewForWihte addGestureRecognizer:singleTap];
    [self.orderInfoView addGestureRecognizer:singleTap];
    [self.progressBarView addGestureRecognizer:singleTap];

    [self registKeyBoardNotification];
    self.isNewOrGrayPanel = NO;
    _creditCardBtn.tag = TAG_FOR_CREDITCARD_BUTTON;
    _debitCardBtn.tag = TAG_FOR_DEBITCARD_BUTTON;

    [self.creditCardBtn setBackgroundImage:[UIImage imageNamed:@"button_select.png"] forState:UIControlStateNormal];
    [self.debitCardBtn setBackgroundImage:[UIImage imageNamed:@"button_unSelect.png"] forState:UIControlStateNormal];

    [self initCallPayButton];

    self.bookAmountLabel.text = self.paymentForm.orderAmount;
    self.paymentAmountLabel.text = self.paymentForm.amount;
    self.mobileTextField.text = self.paymentForm.contactPhoneNumber;

    if ([self.paymentForm.source isEqualToString:@"orderCenter"]) {
        self.title1.text = [NSString stringWithFormat:@"%@", self.paymentForm.orderNo];
    }
    
    [self buildOKBackNoticeView];
    
    
    float topHeight = 200;
    if ([[NSUserDefaults standardUserDefaults] boolForKey:USER_DEVICE_5]) {
        topHeight += 88;
    }
    //支付录入背景色
    UIImageView *topPayImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, topHeight)];
    topPayImageView.backgroundColor = [UIColor clearColor];
    topPayImageView.image = [UIImage imageNamed:@"yilian_content_bg.png"];
    [self.inputViewBlackBgView addSubview:topPayImageView];
    
    UIImageView *bottomPayImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, topHeight, 320, 40)];
    bottomPayImageView.backgroundColor = [UIColor clearColor];
    bottomPayImageView.image = [UIImage imageNamed:@"yilian_bottom_bg.png"];
    [self.inputViewBlackBgView addSubview:bottomPayImageView];
    
    //支付结果背景色
    topHeight -= 40;
    UIImageView *topResultImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, topHeight)];
    topResultImageView.backgroundColor = [UIColor clearColor];
    topResultImageView.image = [UIImage imageNamed:@"client_pay_success_bg.png"];
    [self.applyPayResultView addSubview:topResultImageView];
    
    UIImageView *bottomResultImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, topHeight, 320, 90)];
    bottomResultImageView.backgroundColor = [UIColor clearColor];
    bottomResultImageView.image = [UIImage imageNamed:@"client_pay_success_bottom.png"];
    [self.applyPayResultView addSubview:bottomResultImageView];
    
}

- (void) initCallPayButton
{
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 25)];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"callpaybut.png"] forState:UIControlStateNormal];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"callpaybut-press.png"] forState:UIControlStateHighlighted];
    [rightBtn addTarget:self action:@selector(callPhone :) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = barButtonItem;
}

- (void) handleKeyboardDidShow :(UITextField *)textField
{
    
    if (textField.keyboardType == UIKeyboardTypeNumberPad ) {

        self.doneInKeyboardButton = [UIButton buttonWithType:UIButtonTypeCustom];

        if ([[NSUserDefaults standardUserDefaults] boolForKey:USER_DEVICE_5] == YES)
        {
            self.doneInKeyboardButton.frame = CGRectMake(0, 568 - 53, 106, 53);
        } else {
            self.doneInKeyboardButton.frame = CGRectMake(0, 480 - 53, 106, 53);
        }

        self.doneInKeyboardButton.adjustsImageWhenHighlighted = NO;
        [self.doneInKeyboardButton setImage:[UIImage imageNamed:@"btn_done_up.png"] forState:UIControlStateNormal];
        [self.doneInKeyboardButton setImage:[UIImage imageNamed:@"btn_done_down.png"] forState:UIControlStateHighlighted];
        [self.doneInKeyboardButton addTarget:self action:@selector(finishAction) forControlEvents:UIControlEventTouchUpInside];
        
        if([[UIApplication sharedApplication] windows] && [[[UIApplication sharedApplication] windows] count] >1){
            UIWindow*currentWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:1];
            if (self.doneInKeyboardButton.superview == nil)
            {
                [currentWindow addSubview:self.doneInKeyboardButton];
            }
        }
        
    }
}

- (void)handleKeyboardWillHide : (NSNotification *) notification
{
    if (self.doneInKeyboardButton.superview)
    {
       [self.doneInKeyboardButton removeFromSuperview];
    }
}

-(void)finishAction
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];//关闭键盘
}

-(IBAction)backgroudTap:(id)sender
{
    [self.mobileTextField resignFirstResponder];
    [self.cardNoTextField resignFirstResponder];
    [self.openingBankNameTextField resignFirstResponder];
    [self.openingBankIdNoField resignFirstResponder];
    [self.openingBankPhoneField resignFirstResponder];
    [self.openingBankCityNameField resignFirstResponder];
    [self.openingBankIdNoField resignFirstResponder];
}


- (void)editingDidNext:(id)sender
{
    if (sender == self.openingBankNameTextField)
    {
        [self.openingBankNameTextField resignFirstResponder];
        [self.openingBankIdNoField becomeFirstResponder];
    } else if (sender == self.openingBankIdNoField) {
        [self.openingBankIdNoField resignFirstResponder];
        [self.openingBankPhoneField becomeFirstResponder];
    } else if (sender == self.openingBankPhoneField) {
        [self.openingBankPhoneField resignFirstResponder];
    }
}

- (void)editingDidDoneForOpenCity:(id)sender
{
    [self payment:nil];
}


- (IBAction) pressCardTypeButton:(id)sender
{
    UIButton *button = (UIButton *) sender;
    const int tag = [button tag];
    if (tag == TAG_FOR_CREDITCARD_BUTTON)
    {
        [self.creditCardBtn setBackgroundImage:[UIImage imageNamed:@"button_select.png"] forState:UIControlStateNormal];
        [self.debitCardBtn setBackgroundImage:[UIImage imageNamed:@"button_unSelect.png"] forState:UIControlStateNormal];
    }
    else if (tag == TAG_FOR_DEBITCARD_BUTTON)
    {
        [self.creditCardBtn setBackgroundImage:[UIImage imageNamed:@"button_unSelect.png"] forState:UIControlStateNormal];
        [self.debitCardBtn setBackgroundImage:[UIImage imageNamed:@"button_select.png"] forState:UIControlStateNormal];
    }
}

-(IBAction)showBankListView:(id)sender
{
    [self showRightView:self.supportedBankListController.view title:@"银行列表"];
}

-(void)showBankCityListView
{
    [self finishAction];
    [self.openingBankPhoneField resignFirstResponder];
    [self.openingBankCityNameField resignFirstResponder];
    [self showRightView:self.depositBankCityListController.view title:@"开户城市选择"];
}

- (void)showRightView:(UIView *)view title:(NSString *)title
{
    [self.conditionView addContentView:view];
    self.conditionView.title = title;

    [self disableNavigationItemBar];

    CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        float sizeHeight = screenRect.size.height;
        self.conditionView.frame = CGRectMake(35, 20.0, 285.0, sizeHeight +20);
    }                completion:^(BOOL finished) {
        self.conditionView.hidden = NO;
    }];
}

-(void)disableNavigationItemBar
{
    self.view.userInteractionEnabled = NO;
    self.navigationController.navigationBar.userInteractionEnabled = NO;
}

- (ConditionView *)conditionView
{
    if (!_conditionView)
    {
        CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
        float sizeHeight = screenRect.size.height;
        _conditionView = [[ConditionView alloc] initWithFrame:CGRectMake(320, 20, 285.0, sizeHeight + 20)];
        [self.navigationController.view.window addSubview:_conditionView];
        UISwipeGestureRecognizer *tapGR = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenConditionView)];
        tapGR.direction = UISwipeGestureRecognizerDirectionRight;
        [_conditionView addGestureRecognizer:tapGR];
    }

    return _conditionView;
}

-(SupportedBankListViewController *) supportedBankListController
{
    if(!_supportedBankListController){
        _supportedBankListController = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil]
                                        instantiateViewControllerWithIdentifier:@"supportedBandListView"];
    }
    return _supportedBankListController;
}

-(DepositBankCityListViewController *) depositBankCityListController
{
    if(!_depositBankCityListController)
    {
        _depositBankCityListController = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil]
                                          instantiateViewControllerWithIdentifier:@"depositBankCityListView"];
        _depositBankCityListController.delegate = self;
    }
    return _depositBankCityListController;
}

#pragma mark - hiddenCondFitionView window
- (void)hiddenConditionView
{
    CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.conditionView.frame = CGRectMake(320.0, 20.0, 285.0, screenRect.size.height + 20);
    }                completion:^(BOOL finished) {
        self.view.userInteractionEnabled = YES;
        self.navigationController.navigationBar.userInteractionEnabled = YES;
    }];
}

-(void)payment:(id)send
{
    if (!_paymentForm.amount || _paymentForm.amount == 0)
    {
      [self showAlertMessage:@"实际支付金额有误，请再试一次或者电话支付"];
      return;
    }
    
    [[GAI sharedInstance].defaultTracker sendEventWithCategory:@"订单支付"
                                                    withAction:@"易联在线支付"
                                                     withLabel:@"易联支付申请按钮"
                                                     withValue:nil];
    [UMAnalyticManager eventCount:@"易联支付申请" label:@"易联支付申请按钮"];

    //@"订单金额"
    if(![ValidateInputUtil isNotEmpty:self.payerVerifyForm.phone fieldCName:@"持卡人手机"])  {   return; }
    if(![ValidateInputUtil isEffectivePhone:self.payerVerifyForm.phone])    {   return; }
    if(![ValidateInputUtil isCardNumber:self.payerVerifyForm.cardNo])   {   return; }
    _paymentForm.cardNo=_payerVerifyForm.cardNo;
    _paymentForm.phone = _payerVerifyForm.phone;
    _paymentForm.userId = TheAppDelegate.userInfo.uid;
    if(_paymentForm.isNewOrGrayPanel)
    {
        _paymentForm.openingBankName = _openingBankNameTextField.text;
        _paymentForm.openingBankIdentityNo = _openingBankIdNoField.text;
        _paymentForm.openingBankPhone = _openingBankPhoneField.text;
        _paymentForm.userName = TheAppDelegate.userInfo.fullName;
        _paymentForm.trackNo = _payerVerifyResult.trackNo;
        if(![ValidateInputUtil isNotEmpty:_paymentForm.openingBankName fieldCName:@"开户姓名"] )
        {  return;  }
        else if([_paymentForm.openingBankName length]< 2)
        {   [self showAlertMessage:@"请输入完整的姓名"];    return; }

        if(![ValidateInputUtil isIdentifyNumber:_paymentForm.openingBankIdentityNo]) return;
        if(![ValidateInputUtil isEffectivePhone:_paymentForm.openingBankPhone]) return;
        if(![ValidateInputUtil isNotEmpty:_paymentForm.openingBankCityName fieldCName:@"开户行城市"]) return;
    }
    [self showIndicatorView];
    self.progressBarImgView.image = [UIImage imageNamed:@"progress_bar_unionCard.png"];
    self.confirmPayButton.enabled = NO;
    [self.payController.unionPaymentParser paymentRequest:_paymentForm];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self handleKeyboardDidShow : textField];

    if (textField.tag == 1 || textField.tag == 2 || textField.tag == openingBankPhoneField_tag) {
        self.doneInKeyboardButton.hidden = NO;
    } else {
        self.doneInKeyboardButton.hidden = YES;
    }

    float absolutelyTexty = textField.frame.origin.y + textField.frame.size.height + self.orderInfoView.frame.size.height
    + self.progressBarView.frame.size.height + self.navigationController.navigationBar.frame.size.height;
    float addHeight = absolutelyTexty - KEYBORAD_Y;
    self.upHeight = addHeight;

    if (absolutelyTexty > KEYBORAD_Y)
    {
        if (textField.tag != 1)
        {
            [self.inputViewForWihte setContentOffset:CGPointMake(0.0, addHeight - ADJUSTMENT_Y) animated:YES];
            [self allViewUp:ADJUSTMENT_Y];
        }
        else
        {
            [self allViewUp:addHeight];
        }
    }

}

- (void)allViewUp:(float)addHeight
{
    const int x0 = self.orderInfoView.frame.origin.x;
    const int y0 = self.orderInfoView.frame.origin.y - addHeight;
    const unsigned int w0 = self.orderInfoView.frame.size.width;
    const unsigned int h0 = self.orderInfoView.frame.size.height;
    self.orderInfoView.frame = CGRectMake(x0, y0, w0, h0);

    const int x1 = self.progressBarView.frame.origin.x;
    const int y1 = self.progressBarView.frame.origin.y - addHeight;
    const unsigned int w1 = self.progressBarView.frame.size.width;
    const unsigned int h1 = self.progressBarView.frame.size.height;
    self.progressBarView.frame = CGRectMake(x1, y1, w1, h1);

    const int x2 = self.inputViewForWihte.frame.origin.x;
    const int y2 = self.inputViewForWihte.frame.origin.y - addHeight;
    const unsigned int w2 = self.inputViewForWihte.frame.size.width;
    const unsigned int h2 = self.inputViewForWihte.frame.size.height;
    self.inputViewForWihte.frame = CGRectMake(x2, y2, w2, h2);

    const int xx = self.inputViewBlackBgView.frame.origin.x;
    const int yy = self.inputViewBlackBgView.frame.origin.y - addHeight;
    const unsigned int ww = self.inputViewBlackBgView.frame.size.width;
    const unsigned int hh = self.inputViewBlackBgView.frame.size.height;
    self.inputViewBlackBgView.frame = CGRectMake(xx, yy, ww, hh);
}

- (IBAction)textFieldDoneEditing:(id)sender
{
    [sender resignFirstResponder];
    
    UITextField *textField = (UITextField *) sender;
    
    [self payVerifyProcess:textField];
}

- (void)payVerifyProcess:(UITextField *)textField
{
    if (textField.tag == 1 || textField.tag == 2)
    {

        if (self.isNewOrGrayPanel)
        {
            if (![self.mobileTextField.text isEqualToString:@""] && ![self.cardNoTextField.text isEqualToString:@""])
            {
                if (![self.oldMoileValue isEqualToString:self.mobileTextField.text] ||
                    ![self.oldCardNoValue isEqualToString:self.cardNoTextField.text])
                {
                    self.oldMoileValue = self.mobileTextField.text;
                    self.oldCardNoValue = self.cardNoTextField.text;
                    [self verify];
                }
            }
            return;
        }

        self.oldMoileValue = self.mobileTextField.text;
        self.oldCardNoValue = self.cardNoTextField.text;
        [self verify];

    }
}

-(void) textFieldDidEndEditing:(UITextField *)textField
{
    if (!self.isNewOrGrayPanel)
    {
        if (textField.tag == 2)
        {
            [self.inputViewForWihte setContentOffset:CGPointMake(0.0, - 5.0) animated:YES];
            [self allViewDown:ADJUSTMENT_Y];
        }
        else
        {
            [self allViewDown:self.upHeight];
        }
    }
    else
    {
        [self allViewDown:ADJUSTMENT_Y];
    }

    if (textField.tag == openingBankPhoneField_tag)
    {
        [self editingDidNext:self.openingBankPhoneField];
    }

    if (self.doneInKeyboardButton.superview)
    {
        [self.doneInKeyboardButton removeFromSuperview];
    }
    
    [self payVerifyProcess:textField];
}

- (void)allViewDown:(float)subHeight
{
    const int x0 = self.orderInfoView.frame.origin.x;
    const int y0 = self.orderInfoView.frame.origin.y + subHeight;
    const unsigned int w0 = self.orderInfoView.frame.size.width;
    const unsigned int h0 = self.orderInfoView.frame.size.height;
    self.orderInfoView.frame = CGRectMake(x0, y0, w0, h0);
    
    const int x1 = self.progressBarView.frame.origin.x;
    const int y1 = self.progressBarView.frame.origin.y + subHeight;
    const unsigned int w1 = self.progressBarView.frame.size.width;
    const unsigned int h1 = self.progressBarView.frame.size.height;
    self.progressBarView.frame = CGRectMake(x1, y1, w1, h1);
    
    const int x2 = self.inputViewForWihte.frame.origin.x;
    const int y2 = self.inputViewForWihte.frame.origin.y + subHeight;
    const unsigned int w2 = self.inputViewForWihte.frame.size.width;
    const unsigned int h2 = self.inputViewForWihte.frame.size.height;
    self.inputViewForWihte.frame = CGRectMake(x2, y2, w2, h2);
    
    const int xx = self.inputViewBlackBgView.frame.origin.x;
    const int yy = self.inputViewBlackBgView.frame.origin.y + subHeight;
    const unsigned int ww = self.inputViewBlackBgView.frame.size.width;
    const unsigned int hh = self.inputViewBlackBgView.frame.size.height;
    self.inputViewBlackBgView.frame = CGRectMake(xx, yy, ww, hh);
}

#pragma mark - verifyCard
- (void)verify
{
    if(![[self.mobileTextField.text removeSpace] isEqualToString:@""] && ![[self.cardNoTextField.text removeSpace] isEqualToString:@""])
    {
        if(![ValidateInputUtil isNotEmpty:self.mobileTextField.text fieldCName:@"持卡人手机"])   {   return; }
        if(![ValidateInputUtil isEffectivePhone:self.mobileTextField.text])     {   return; }
        if(![ValidateInputUtil isCardNumber:[self.cardNoTextField.text removeSpace]])   {   return; }
        self.payerVerifyForm.cardNo = [self.cardNoTextField.text removeSpace];
        self.payerVerifyForm.phone= self.mobileTextField.text;
        [self.verifyAndPaymentParser verifyRequest:self.payerVerifyForm];
    }
}

- (void)showNewOrGrayTextField
{
    self.openingBankNameTextField.hidden = NO;
    self.openingBankNameLabel.hidden = NO;
    
    self.openingBankIdNoLabel.hidden = NO;
    self.openingBankIdNoField.hidden = NO;
    
    self.openingBankPhoneLabel.hidden = NO;
    self.openingBankPhoneField.hidden = NO;
    
    self.openingBankCityNameLabel.hidden = NO;
    self.openingBankCityNameField.hidden = NO;
}

- (void)hiddenNewOrGrayTextField
{
    self.openingBankNameTextField.hidden = YES;
    self.openingBankNameLabel.hidden = YES;
    
    self.openingBankIdNoLabel.hidden = YES;
    self.openingBankIdNoField.hidden = YES;
    
    self.openingBankPhoneLabel.hidden = YES;
    self.openingBankPhoneField.hidden = YES;
    
    self.openingBankCityNameLabel.hidden = YES;
    self.openingBankCityNameField.hidden = YES;
}

- (void) verifyOKAfterProsess:(NSDictionary *) data
{
    PayerVerifyResult *payerVerifyResult = [data valueForKey:@"payerVerifyResult"];
    _paymentForm.isNewOrGrayPanel = NO;
    if([payerVerifyResult.verifyResult isEqualToString:@"WHITE"])
    {
        self.confirmPayButton.frame = CGRectMake(34, 195, 251.0, 37.0);
        self.confirmPayButton.hidden = NO;
        UILabel *payLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 10, 80, 20)];
        payLabel.backgroundColor = [UIColor clearColor];
        payLabel.font = [UIFont boldSystemFontOfSize:18];
        payLabel.textColor = [UIColor whiteColor];
        payLabel.textAlignment = NSTextAlignmentCenter;
        payLabel.text = @"确认支付";
        [self.confirmPayButton addSubview:payLabel];
        
        
        _paymentForm.isNewOrGrayPanel = NO;
        self.isNewOrGrayPanel = NO;
        [self hiddenNewOrGrayTextField];
        [self.inputViewForWihte setContentOffset:CGPointMake(0.0, 0.0) animated:YES];
        self.progressBarImgView.image = [UIImage imageNamed:@"progress_bar_unionCard.png"];
        return;
    }
    else if([payerVerifyResult.verifyResult isEqualToString:@"NEW"] || [payerVerifyResult.verifyResult isEqualToString:@"GRAY"])
    {
        self.inputViewForWihte.scrollEnabled = YES;
        [self.inputViewForWihte setContentOffset:CGPointMake(0.0, 185.0) animated:YES];
        [self showNewOrGrayTextField];
        self.openingBankPhoneField.text = self.payerVerifyForm.phone;
        
        self.confirmPayButton.frame = CGRectMake(34, 370.0, 251.0, 37.0);
        self.confirmPayButton.hidden = NO;
        UILabel *payLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 10, 80, 20)];
        payLabel.backgroundColor = [UIColor clearColor];
        payLabel.font = [UIFont boldSystemFontOfSize:18];
        payLabel.textColor = [UIColor whiteColor];
        payLabel.textAlignment = NSTextAlignmentCenter;
        payLabel.text = @"确认支付";
        [self.confirmPayButton addSubview:payLabel];
        
        _paymentForm.isNewOrGrayPanel = YES;
        self.isNewOrGrayPanel = YES;
        self.progressBarImgView.image = [UIImage imageNamed:@"progress_bar_unionCard.png"];
        
        return;
    }
    else if([payerVerifyResult.verifyResult isEqualToString:@"BLACK"])
    {
        [self hiddenNewOrGrayTextField];
        [self showAlertMessage:@"系统不支持该银行卡"];
        self.progressBarImgView.image = [UIImage imageNamed:@"progress_bar_accountInput.png"];
        self.confirmPayButton.hidden = YES;
        return;
    }
    else if([payerVerifyResult.verifyResult isEqualToString:@"LIMITED"])
    {
        [self hiddenNewOrGrayTextField];
        [self showAlertMessage:@"该卡交易时间受限"];
        self.progressBarImgView.image = [UIImage imageNamed:@"progress_bar_accountInput.png"];
        self.confirmPayButton.hidden = YES;
        return;
    }
    else if([payerVerifyResult.verifyResult isEqualToString:@"NONSUPPORT"])
    {
        [self hiddenNewOrGrayTextField];
        [self showAlertMessage:@"系统不支持该银行卡"];
        self.progressBarImgView.image = [UIImage imageNamed:@"progress_bar_accountInput.png"];
        self.confirmPayButton.hidden = YES;
        return;
    }
}


- (void)parser:(GDataXMLParser *)parser DidParsedData:(NSDictionary *)data
{
    if([parser isKindOfClass:[PayerVerifyParser class]]){
        [self verifyOKAfterProsess:data];
    }
    [self hideIndicatorView];

}

- (void)parser:(GDataXMLParser *)parser DidFailedParseWithMsg:(NSString *)msg errCode:(NSInteger)code
{
    if([parser isKindOfClass:[PayerVerifyParser class]]){
        [self verifyFailAfterProsess:msg errCode:code];
    }
    [self hideIndicatorView];
//    self.navigationController.navigationBar.userInteractionEnabled = NO;
}


-(void)verifyFailAfterProsess :(NSString *)msg errCode:(NSInteger)code
{
    if(-1 == code){
        [self showAlertMessageWithOkButton:@"因服务器繁忙,验证银行卡号请求失败,请稍后重试或者电话支付" title:nil tag:0 delegate:nil];
    }else{
        [self showAlertMessageWithOkButton:msg title:nil tag:0 delegate:nil];
    }
    self.confirmPayButton.hidden = YES;
    self.navigationItem.hidesBackButton = NO;
}


#pragma --ApplyDelegate.applySuccessProcess
-(void)applySuccessProcess
{
    [UMAnalyticManager eventCount:@"易联在线支付申请成功" label:@"易联在线支付申请成功"];
    self.progressBarImgView.image = [UIImage imageNamed:@"progress_bar_waitCalled.png"];
    [self createSuccessViewElem];
    
    self.inputViewForWihte.hidden = YES;
    self.navigationItem.rightBarButtonItem = nil;
    _confirmAlertView.tag = ORDER_DETAIL_TAG;
   self.confirmPayButton.enabled = YES;
    [self hideIndicatorView];
}


#pragma --ApplyDelegate.applyFailProcess
-(void)applyFailProcess
{
    [self createFailViewElem];
    self.inputViewForWihte.hidden = YES;
    self.confirmPayButton.enabled = YES;
    [self hideIndicatorView];
}

-(void)createFailViewElem
{
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(55, 40, 210, 21)];
    label1.font = [UIFont systemFontOfSize:14];
    label1.backgroundColor = [UIColor clearColor];
    label1.text = @"您的支付申请失败，请您致电";
    UIImageView *splitImg1 = [[UIImageView alloc] initWithFrame:CGRectMake(35, 62, 260,1)];
    splitImg1.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dashed.png" ]];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(145, 70, 220, 21)];
    UIButton *callButton = [[UIButton alloc] initWithFrame:CGRectMake(55, 70, 100, 21)];
    [callButton setTitle:@"1010-1666" forState:UIControlStateNormal];
    [callButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    callButton.backgroundColor = [UIColor clearColor];
    [callButton addTarget:self action:@selector(callPhone:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    
    label2.font = [UIFont systemFontOfSize:14];
    label2.text = @" 进行电话支付";
    label2.backgroundColor = [UIColor clearColor];
    UIImageView *splitImg2 = [[UIImageView alloc] initWithFrame:CGRectMake(35, 92, 260, 1)];
    splitImg2.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dashed.png"]];
    
    
    [self.applyPayResultView addSubview:label1];
    [self.applyPayResultView addSubview:splitImg1];
    [self.applyPayResultView addSubview:label2];
    [self.applyPayResultView addSubview:splitImg2];
    [self.applyPayResultView addSubview:callButton];
    
    self.inputViewBlackBgView.hidden = YES;
    self.applyPayResultView.hidden = NO;
}

-(void)createSuccessViewElem
{
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(55, 40, 220, 21)];
    label1.font = [UIFont systemFontOfSize:14];
    label1.backgroundColor = [UIColor clearColor];
    label1.text = @"您的支付请求已经受理,";
    UIImageView *splitImg1 = [[UIImageView alloc] initWithFrame:CGRectMake(35, 62, 260,1)];
    splitImg1.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dashed.png" ]];
    
    UILabel *phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, 70, 110, 21)];
    phoneLabel.text = self.paymentForm.phone;
    phoneLabel.textColor = [UIColor blueColor];
    phoneLabel.backgroundColor = [UIColor clearColor];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(160, 70, 220, 21)];
    label2.font = [UIFont systemFontOfSize:14];
    
    label2.text = @" 稍后会收到银联的";
    label2.backgroundColor = [UIColor clearColor];
    UIImageView *splitImg2 = [[UIImageView alloc] initWithFrame:CGRectMake(35, 92, 260, 1)];
    splitImg2.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dashed.png"]];
    
    
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(55, 100, 185, 21)];
    label3.font = [UIFont systemFontOfSize:14];
    label3.text = @"020-96585 支付确认电话，";
    label3.backgroundColor = [UIColor clearColor];
    UIImageView *splitImg3 = [[UIImageView alloc] initWithFrame:CGRectMake(35, 122, 260, 1)];
    splitImg3.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dashed.png"]];
    
    
    UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(55, 130, 150, 21)];
    label4.font = [UIFont systemFontOfSize:14];
    label4.text = @"请保持您的手机畅通！";
    label4.backgroundColor = [UIColor clearColor];
    UIImageView *splitImg4 = [[UIImageView alloc] initWithFrame:CGRectMake(35, 151, 260, 1)];
    splitImg4.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dashed.png"]];
    
    [self.applyPayResultView addSubview:label1];
    [self.applyPayResultView addSubview:splitImg1];
    
    [self.applyPayResultView addSubview:label2];
    [self.applyPayResultView addSubview:phoneLabel];
    [self.applyPayResultView addSubview:splitImg2];
    
    [self.applyPayResultView addSubview:label3];
    [self.applyPayResultView addSubview:splitImg3];
    
    [self.applyPayResultView addSubview:label4];
    [self.applyPayResultView addSubview:splitImg4];
    
    self.inputViewBlackBgView.hidden = YES;
    self.applyPayResultView.hidden = NO;
}

#pragma mark - DepositBankCityListDelegate.buildCity
-(void)buildCity:(AllCity *)city
{
    NSString *provinceName = city.provinceName==nil?@"":city.provinceName;
    NSString *cityName = city.name == nil ? @"" : city.name;
    self.paymentForm.openingBankCityName = [NSString stringWithFormat:@"%@,%@",provinceName,cityName];
    self.openingBankCityNameField.text = city.name;
    [self hiddenConditionView];
    [self.depositBankCityListController.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UIActionSheetDelegate
- (void)callPhone:(id)sender
{
    [[GAI sharedInstance].defaultTracker sendEventWithCategory:@"电话预订"
                                                    withAction:@"电话预订"
                                                     withLabel:@"电话预订按钮"
                                                     withValue:nil];
    [UMAnalyticManager eventCount:@"电话预订" label:@"电话预订按钮"];
    
    UIActionSheet *menu = [[UIActionSheet alloc] initWithTitle:@"拨打10101666进行电话支付" delegate:self cancelButtonTitle:@"取消"
                                        destructiveButtonTitle:nil otherButtonTitles:@"1010-1666", nil];
    [menu setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    [menu setAlpha:1];  [menu showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://1010-1666"]];
    }
}

@end
