//
//  ActivationViewController.m
//  JinJiangTravelPlus
//
//  Created by 吕 硕 on 12-12-18.
//  Copyright (c) 2012年 JinJiang. All rights reserved.
//

#import "ActivationViewController.h"
#import "ActivationType.h"
#import "GAI.h"
#import <QuartzCore/QuartzCore.h>

#define activation  @"activation"

const unsigned int loginAlertTag = 999;
const unsigned int CallAlertTag = 9999;
const unsigned int alertFieldTag = 998;
const unsigned int alertTextTag = 9898;

@interface ActivationViewController ()

@property(nonatomic, strong) UIControl *leftView;
@property (weak, nonatomic) IBOutlet UIButton *activeButton;
@property (weak, nonatomic) IBOutlet UIView *formView;

- (void)typeButtonClicked:(id)sender;
- (void)phoneButtonClicked:(id)sender;
- (void)phoneButtonClicked1:(id)sender;
- (void)showViewInSidebar:(UIView *)view title:(NSString *)title;
- (void)handleTap;
- (void)handleRsigned;
- (void)jjInRegisterWithPhoneNumber:(NSString*)number;

@end

@implementation ActivationViewController

@synthesize userID;
@synthesize typeArray;
@synthesize avtivationResultView;
@synthesize activeResultText;
@synthesize typeButton;
@synthesize loginButton;
@synthesize phoneButton;
@synthesize phoneTextField;

@synthesize identityTypeList;
@synthesize activateParams;
@synthesize identityType;
@synthesize activateJJInnMemberParser;
@synthesize jjInnRegisterParser;
@synthesize phoneNumber;

- (UIControl *)leftView
{
    if (!_leftView)
    {
        _leftView = [[UIControl alloc] initWithFrame:CGRectMake(0, 20.0, 50.0, 460.0)];
        [_leftView addTarget:self action:@selector(handleTap) forControlEvents:UIControlEventTouchUpInside];
        [_leftView setBackgroundColor:[UIColor clearColor]];
        [_leftView setHidden:YES];
        [self.navigationController.view.window addSubview:_leftView];
    }
    return _leftView;
}

- (ConditionView *)conditionView
{
    if (!_conditionView)
    {
        _conditionView = [[ConditionView alloc] initWithFrame:CGRectMake(320, 20, 285.0, 460.0)];
        [self.navigationController.view.window addSubview:_conditionView];
        UISwipeGestureRecognizer *tapGR = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap)];
        tapGR.direction = UISwipeGestureRecognizerDirectionRight;
        [_conditionView addGestureRecognizer:tapGR];
    }
    return _conditionView;
}

- (ActivationTypeController *)activationTypeController
{
    if (!_activationTypeController)
    {
        _activationTypeController = (ActivationTypeController *) [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil]
                                                                  instantiateViewControllerWithIdentifier:@"ActivationTypeController"];
        _activationTypeController.delegate = self;
    }
    return _activationTypeController;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.trackedViewName = @"锦江之星会员自助激活页面";
    [super viewWillAppear:animated];

    if (self.avtivationResultView != nil)
    {
        [self.avtivationResultView setHidden:YES];
        [self setTitle:@"自助激活"];
    }

}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    hasNothing = NO;

    if (self.avtivationResultView != nil)
    {
        [self.avtivationResultView setHidden:YES];
        [self setTitle:@"自助激活"];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.view removeGestureRecognizer:tapHide];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"自助激活"];
    index = 0; temp = 0;    hasNothing = NO;
	// Do any additional setup after loading the view.

    const float version = [[[UIDevice currentDevice] systemVersion] floatValue];

    if (version >= 5.8)
    {
        tapHide = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleRsigned)];
        [self.view addGestureRecognizer:tapHide];
        [self.navigationController.view addGestureRecognizer:tapHide];
    }

    ActivationType* idCard  = [[ActivationType alloc] initWithCnName:@"身份证"     andEnName:@"ID"];
    ActivationType* paspot  = [[ActivationType alloc] initWithCnName:@"护照"      andEnName:@"Passport"];
    ActivationType* soldier = [[ActivationType alloc] initWithCnName:@"军人证"     andEnName:@"Soldier"];
    ActivationType* driving = [[ActivationType alloc] initWithCnName:@"驾照"      andEnName:@"Driving License"];
    ActivationType* taiwan  = [[ActivationType alloc] initWithCnName:@"台胞证"     andEnName:@"Taiwan"];
    ActivationType* retur1  = [[ActivationType alloc] initWithCnName:@"回乡证"     andEnName:@"Return"];
    ActivationType* pass    = [[ActivationType alloc] initWithCnName:@"通行证"     andEnName:@"Pass"];
    ActivationType* forei   = [[ActivationType alloc] initWithCnName:@"外国人居留证"  andEnName:@"Foreigner"];
    ActivationType* work    = [[ActivationType alloc] initWithCnName:@"工作证"     andEnName:@"Work"];
    ActivationType* others  = [[ActivationType alloc] initWithCnName:@"其他"      andEnName:@"Others"];

    [self setTypeArray:[[NSArray alloc] initWithObjects:
                        idCard, paspot, soldier, driving, taiwan, retur1,
                        pass, forei, work, others, nil]];
    
    self.formView.layer.borderColor = [UIColor colorWithRed:215.0/255.0 green:215.0/255.0 blue:215.0/255.0 alpha:1.0].CGColor;
    self.formView.layer.borderWidth = 1.0;

    [self.nameTextField becomeFirstResponder];
    [self.nameTextField setDelegate:self];
    [self.nameTextField setReturnKeyType:UIReturnKeyDone];


    [self.typeTextField setText:[((ActivationType*)[self.typeArray objectAtIndex:0]) cnName]];
    [self.typeTextField setEnabled:NO];

    self.typeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.typeButton setFrame:self.typeTextField.frame];
    [self.typeButton setBackgroundColor:[UIColor clearColor]];
    [self.typeButton setTitle:@"" forState:UIControlStateNormal];
    [self.typeButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    [self.typeButton addTarget:self action:@selector(typeButtonClicked:)
              forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.typeButton];

    [self.numbTextField becomeFirstResponder];
    [self.numbTextField setDelegate:self];
    [self.numbTextField setReturnKeyType:UIReturnKeyDone];


    self.identityType = [((ActivationType*)[self.typeArray objectAtIndex:0]) enName];

    const unsigned int www = self.view.frame.size.width;
    const unsigned int hhh = self.view.frame.size.height;

    self.avtivationResultView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, www, hhh)];
    [self.avtivationResultView setBackgroundColor:[UIColor whiteColor]];
    {
        if (version >= 5.8)
        {
            UITapGestureRecognizer* tapHide2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleRsigned)];
            [self.view addGestureRecognizer:tapHide2];
        }

        self.activeResultText = [[UITextView alloc] initWithFrame:CGRectMake(30, 30, 260, 200)];
        [self.activeResultText setEditable:NO];
        [self.activeResultText setFont:[UIFont systemFontOfSize:14]];
        [self.avtivationResultView addSubview:self.activeResultText];

        self.loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.loginButton setFrame:CGRectMake(80, 270, 160, 40)];
        [self.loginButton setBackgroundImage:[UIImage imageNamed:@"unlock-up.png"] forState:UIControlStateNormal];
        [self.loginButton setBackgroundImage:[UIImage imageNamed:@"unlock.png"] forState:UIControlStateHighlighted];
        [self.loginButton setTitle:@"立即登录" forState:UIControlStateNormal];
        [self.loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.loginButton addTarget:self action:@selector(backHome:)
                   forControlEvents:UIControlEventTouchUpInside];
        [self.avtivationResultView addSubview:self.loginButton];

        self.phoneTextField = [[UITextField alloc] init];
        [self.phoneTextField setFrame:CGRectMake(30, 120, 260, 30)];
        [self.phoneTextField setHidden:YES];
        [self.phoneTextField setKeyboardType:UIKeyboardTypeNumberPad];
        [self.phoneTextField setBackgroundColor:[UIColor whiteColor]];
        [self.phoneTextField setBorderStyle:UITextBorderStyleRoundedRect];
        [self.phoneTextField setTextAlignment:UITextAlignmentCenter];
        [self.phoneTextField setTextColor:[UIColor blackColor]];
        [self.avtivationResultView addSubview:self.phoneTextField];

        self.phoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.phoneButton setFrame:CGRectMake(80, 170, 160, 40)];
        [self.phoneButton setBackgroundImage:[UIImage imageNamed:@"unlock-up.png"] forState:UIControlStateNormal];
        [self.phoneButton setBackgroundImage:[UIImage imageNamed:@"unlock.png"] forState:UIControlStateHighlighted];
        [self.phoneButton setTitle:@"确认发送" forState:UIControlStateNormal];
        [self.phoneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.phoneButton addTarget:self action:@selector(phoneButtonClicked1:)
                   forControlEvents:UIControlEventTouchUpInside];
        [self.phoneButton setHidden:YES];[self.phoneTextField resignFirstResponder];
        [self.avtivationResultView addSubview:self.phoneButton];
    }
    [self.avtivationResultView setHidden:YES];
    [self.view addSubview:self.avtivationResultView];

    //[self.nameTextField setText:@"miles"]; [self.numbTextField setText:@"01223581675"];
}

- (void)backHome:(id)sender
{
    if (sender != nil)
    {   
        [[GAI sharedInstance].defaultTracker sendEventWithCategory:@"锦江之星会员自助激活"
                                                        withAction:@"锦江之星会员自助激活后登陆"
                                                         withLabel:@"锦江之星会员自助激活结果页面登陆按钮"
                                                         withValue:nil];
        [UMAnalyticManager eventCount:@"锦江之星会员自助激活后登陆" label:@"锦江之星会员自助激活后登陆按钮"];
    }

    [super backHome:sender];
}

- (void)typeButtonClicked:(id)sender
{
    [self.numbTextField resignFirstResponder];
    [self.nameTextField resignFirstResponder];

    [self.activationTypeController setDelegate:self];
    [self.activationTypeController setTypeArray:[[NSMutableArray alloc] initWithArray:self.typeArray]];
    [self.activationTypeController.typeTableView reloadData];
    [self showViewInSidebar:self.activationTypeController.view title:@"请选择证件类型"];
}

- (void)phoneButtonClicked:(id)sender
{
    [self.numbTextField resignFirstResponder];
    [self.nameTextField resignFirstResponder];

    UIActionSheet *menu = [[UIActionSheet alloc] initWithTitle:@"拨打客服电话" delegate:self
        cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"1010-1666", nil];
    [menu setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    [menu setAlpha:1];
    [menu showInView:self.view];
}
- (IBAction)activationPressed:(id)sender {
    if ([[self.nameTextField text] isEqualToString:@""] || [self.nameTextField text] == nil)
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"请输入姓名" message:@"" delegate:nil
                                              cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];   [self.nameTextField becomeFirstResponder];   return;
    }
    else if ([[self.numbTextField text] isEqualToString:@""] || [self.numbTextField text] == nil)
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"请输入证件号码" message:@"" delegate:nil
                                              cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];   [self.numbTextField becomeFirstResponder];   return;
    }
    
    [self downloadData];
    
    [[GAI sharedInstance].defaultTracker sendEventWithCategory:@"锦江之星会员自助激活"
                                                    withAction:@"锦江之星会员自助激活"
                                                     withLabel:@"锦江之星会员自助激活页面自助激活按钮"
                                                     withValue:nil];
    [UMAnalyticManager eventCount:@"锦江之星会员自助激活" label:@"锦江之星会员自助激活按钮"];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIPickerViewDataSource

-(void)selectActivationType:(unsigned int) activationTypeIndex
{
    temp = activationTypeIndex; index = temp;

    [self.typeTextField setText:[((ActivationType*)[self.typeArray objectAtIndex:index]) cnName]];
    self.identityType = [((ActivationType*)[self.typeArray objectAtIndex:index]) enName];[self handleTap];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];

    return YES;
}

#pragma mark - 业务逻辑

- (void)downloadData
{
    if (!self.activateJJInnMemberParser)
    {
        self.activateJJInnMemberParser = [[ActivateJJInnMemberParser alloc] init];
        self.activateJJInnMemberParser.isHTTPGet = NO;
        self.activateJJInnMemberParser.serverAddress = kActivationURL;
    }

    self.activateParams = [NSString stringWithFormat:@"fullName=%@&identityType=%@&identityNo=%@", self.nameTextField.text,
                           self.identityType, self.numbTextField.text];
    self.activateJJInnMemberParser.requestString = self.activateParams;
    self.activateJJInnMemberParser.delegate = self;

    [self.activateJJInnMemberParser start];

    [self showIndicatorView];
}

- (void)jjInRegisterWithPhoneNumber:(NSString*)number
{
    if (!self.jjInnRegisterParser)
    {
        self.jjInnRegisterParser = [[JJInnRegisterParser alloc] init];
        self.jjInnRegisterParser.isHTTPGet = NO;
        self.jjInnRegisterParser.serverAddress = kJJInnRegisterURL;
    }

    self.jjInnRegisterParser.requestString = [NSString stringWithFormat:@"%@&mobile=%@", self.activateParams, number];
    self.jjInnRegisterParser.delegate = self;

    [self.jjInnRegisterParser start];

    [self showIndicatorView];   hasNothing = YES;
}

#pragma mark - GDataXMLParserDelegate

- (void)parser:(GDataXMLParser*)parser DidParsedData:(NSDictionary *)data
{
    if ([parser isKindOfClass:[GDataXMLParser class]])
    {
        JJInnActivateResult activateResult = (JJInnActivateResult)[[data objectForKey:@"status"] intValue];
        if ([data objectForKey:@"mobile"] && ![[data objectForKey:@"mobile"] isEqualToString:@""])
        {   self.userID = [data objectForKey:@"mobile"];    }
        else if ([data objectForKey:@"email"] && ![[data objectForKey:@"email"] isEqualToString:@""])
        {   self.userID = [data objectForKey:@"email"]; }
        else
        {   self.userID = @"";  }

        switch (activateResult)
        {
            case JJInnActivateResultHasAlreadyActivated:
            {
                NSString* message = @"您已经是锦江旅行家的会员，请直接用您的手机或邮箱进行登录。";
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"" message:message
                                                               delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert setTag:loginAlertTag]; [alert show];     break;
            }
            case JJInnActivateResultFailed:
            {
                [[GAI sharedInstance].defaultTracker sendEventWithCategory:@"锦江之星会员自助激活失败页面"
                                                                withAction:@"锦江之星会员自助激活失败"
                                                                 withLabel:@"锦江之星会员自助激活页面自助激活失败"
                                                                 withValue:nil];
                [UMAnalyticManager eventCount:@"锦江之星会员自助激活失败" label:@"锦江之星会员自助激活失败按钮"];

                NSString* message = [data objectForKey:@"message"];
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"激活失败" message:message delegate:nil
                                                      cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];   break;
            }
            case JJInnActivateResultNotExist:
            {
                [[GAI sharedInstance].defaultTracker sendEventWithCategory:@"锦江之星会员自助激活失败页面"
                                                                withAction:@"锦江之星会员自助激活会员不存在"
                                                                 withLabel:@"锦江之星会员自助激活会员不存在"
                                                                 withValue:nil];
                [UMAnalyticManager eventCount:@"锦江之星会员自助激活会员不存在" label:@"锦江之星会员自助激活会员不存在"];

                NSString* message = @"您输入的个人信息没有匹配成功，请确认后再次输入或直接拨打客服电话寻求帮助。";
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"激活失败" message:message delegate:self
                                                      cancelButtonTitle:@"确定" otherButtonTitles:@"客服电话", nil];
                [alert setTag:1019];    [alert show];   break;
            }
            case JJInnActivateResultHaveMobile:
            {   
                [[GAI sharedInstance].defaultTracker sendEventWithCategory:@"锦江之星会员自助激活激活成功"
                                                                withAction:@"锦江之星会员自助激活存在手机"
                                                                 withLabel:@"锦江之星会员自助激活存在手机"
                                                                 withValue:nil];
                [UMAnalyticManager eventCount:@"锦江之星会员自助激活存在手机" label:@"锦江之星会员自助激活激活成功"];
                
                self.title = @"激活成功";
                NSString* mobile;
                if (hasNothing == YES)
                {   mobile = [[NSString alloc] initWithString:self.phoneNumber];    }
                else
                {   mobile = [data objectForKey:@"mobile"];     }

                if (([mobile longLongValue] < 13000000000 || [mobile longLongValue] >= 19000000000) ||
                    ([mobile longLongValue] < 18000000000 && [mobile longLongValue] >= 16000000000))
                {
                    NSString* format = @"但是您在锦江之星注册时留下的手机号码为\"%@\"，我们无法向该号码发送短信息，请电话联系客服部门，获取您的登录信息。";
                    NSString* message = [NSString stringWithFormat:format, mobile];
                    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"激活成功" message:message delegate:self
                                                          cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];   [alert setTag:CallAlertTag];    break;
                }
                else
                {
                    self.userID = mobile;
                    if ([mobile length] > 6)
                    {  mobile = [mobile stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];  }

                    NSString* format = @"恭喜您已经成功升级为锦江礼享+会员，您的登录密码已经通过短信方式发送到您\"%@\"的手机号码，您可以直接使用该手机号码和密码登录锦江旅行家，若您的手机号码已经更改，请立刻拨打客服电话修改手机号。";

                    [self.activeResultText setText:[NSString stringWithFormat:format, mobile]];
                    [self.phoneButton setHidden:YES];[self.phoneTextField setHidden:YES];
                    [self.phoneTextField resignFirstResponder];hasNothing = NO;
                    [self.loginButton setHidden:NO]; [self.avtivationResultView setHidden:NO]; break;
                }
            }
            case JJInnActivateResultHaveEmail:
            {   
                [[GAI sharedInstance].defaultTracker sendEventWithCategory:@"锦江之星会员自助激活激活成功页面"
                                                                withAction:@"锦江之星会员自助激活存在邮箱"
                                                                 withLabel:@"锦江之星会员自助激活存在邮箱"
                                                                 withValue:nil];
                
                [UMAnalyticManager eventCount:@"锦江之星会员自助激活存在邮箱" label:@"锦江之星会员自助激活激活成功"];
                
                self.title = @"激活成功";

                NSString* email = [data objectForKey:@"email"]; self.userID = email;

                if ([email rangeOfString:@"@"].location == NSNotFound)
                {
                    NSString* format = @"但是您在锦江之星注册时留下的Email地址为\"%@\"，我们无法向该地址发送邮件，请电话联系客服部门，获取您的登录信息。";
                    NSString* message = [NSString stringWithFormat:format, email];
                    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"激活成功" message:message delegate:self
                                                          cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];   [alert setTag:CallAlertTag];    break;
                }
                else
                {
                    [[GAI sharedInstance].defaultTracker sendEventWithCategory:@"锦江之星会员自助激活激活成功页面"
                                                                    withAction:@"锦江之星会员自助激活成功完成"
                                                                     withLabel:@"锦江之星会员自助激活成功完成"
                                                                     withValue:nil];
                    
                    [UMAnalyticManager eventCount:@"锦江之星会员自助激活成功完成" label:@"锦江之星会员自助激活成功完成"];

                    NSString* format= @"恭喜您已经成功升级为锦江礼享+会员，您的登录密码已经通过邮件方式发送到您\n\"%@\"的邮箱，您可以直接以该邮箱地址和密码进行登录。";
                    self.activeResultText.text = [NSString stringWithFormat:format, email];
                    [self.phoneButton setHidden:YES];[self.phoneTextField setHidden:YES];
                    [self.phoneTextField resignFirstResponder];
                    [self.loginButton setHidden:NO]; [self.avtivationResultView setHidden:NO]; break;
                }
            }
            case JJInnActivateResultNoMobileAndEmail:
            {
                [[GAI sharedInstance].defaultTracker sendEventWithCategory:@"锦江之星会员自助激活激活成功页面"
                                                                withAction:@"锦江之星会员自助激活成功输入手机号"
                                                                 withLabel:@"锦江之星会员自助激活成功输入手机号"
                                                                 withValue:nil];
                [UMAnalyticManager eventCount:@"锦江之星会员自助激活输入手机号" label:@"锦江之星会员自助激活输入手机号"];
                [self.numbTextField resignFirstResponder];
                [self.nameTextField resignFirstResponder];

                self.activeResultText.text = @"请输入您的手机号码，我们会将您的密码通过短信方式发送到该手机号码。";
                [self.phoneButton setHidden:NO];[self.phoneTextField setHidden:NO]; hasNothing = YES;
                [self.phoneTextField becomeFirstResponder];
                [self.loginButton setHidden:YES];[self.avtivationResultView setHidden:NO]; break;
            }
            default:
            {
                break;
            }
        }
    }
    else if([parser isKindOfClass:[jjInnRegisterParser class]])
    {
        if ([[data objectForKey:@"status"] isEqualToString:@"1"])
        {
//          NSDictionary *result = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:1],
//                                    @"status", @"", @"message", self.phoneNumber, @"mobile", @"", @"email", nil];
        }
        else if ([[data objectForKey:@"status"] isEqualToString:@"-2"])
        {
            [self showAlertMessageWithOkButton:@"您已经是锦江旅行家的会员，请直接用您的手机或邮箱进行登录。" title:nil tag:1 delegate:self];
        }
        else
        {
            [self showAlertMessageWithOkButton:[data objectForKey:@"message"] title:nil tag:0 delegate:nil];
        }
    }

    [self hideIndicatorView];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if([alertView tag] == loginAlertTag)
    {
        [self backHome:nil];
    }
    else if([alertView tag] == alertTextTag)
    {

    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if([alertView tag] == CallAlertTag)
    {
        [self phoneButtonClicked:nil];
    }
    else if([alertView tag] == 1019 && buttonIndex >= 1)
    {
        [self phoneButtonClicked:nil];
    }
}

#pragma mark - ActivationTypeController

- (void)showViewInSidebar:(UIView *)view title:(NSString *)title
{
    [self.conditionView addContentView:view];
    self.conditionView.title = title;

    self.view.userInteractionEnabled = NO;
    self.navigationController.navigationBar.userInteractionEnabled = NO;

    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.conditionView.frame = CGRectMake(35, 20.0, 285.0, 460.0);
    }                completion:^(BOOL finished) {
        self.leftView.hidden = NO;
    }];
}

- (void)handleRsigned
{
    if ([self.nameTextField isFirstResponder])
    {   [self.nameTextField resignFirstResponder];  }
    if ([self.numbTextField isFirstResponder])
    {   [self.numbTextField resignFirstResponder];  }
    if ([self.phoneTextField isFirstResponder])
    {   [self.phoneTextField resignFirstResponder]; }
}

- (void)handleTap
{
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.conditionView.frame = CGRectMake(320.0, 20.0, 285.0, 460.0);
    }   completion:^(BOOL finished) {
        self.leftView.hidden = YES;
        self.view.userInteractionEnabled = YES;
        self.navigationController.navigationBar.userInteractionEnabled = YES;
    }];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {   
        [[GAI sharedInstance].defaultTracker sendEventWithCategory:@"锦江之星激活"
                                                        withAction:@"锦江之星激活失败页面拨打电话"
                                                         withLabel:@"锦江之星激活失败页面拨打电话按钮"
                                                         withValue:nil];
        [UMAnalyticManager eventCount:@"锦江之星激活失败页面拨打电话" label:@"锦江之星激活失败页面拨打电话按钮"];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://1010-1666"]];
    }
}

- (void)phoneButtonClicked1:(id)sender
{
    NSString* phoneNum = [self.phoneTextField text];
    [self setPhoneNumber:phoneNum]; hasNothing = YES;
    if (([phoneNum longLongValue] < 13000000000 || [phoneNum longLongValue] >= 19000000000) ||
        ([phoneNum longLongValue] < 18000000000 && [phoneNum longLongValue] >= 16000000000))
    {
        NSString* message = [NSString stringWithFormat:@"您输入的手机号码\"%@\"错误", self.phoneNumber];
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:nil
                                              cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];   return;
    }

    [self jjInRegisterWithPhoneNumber:phoneNum];
}

- (void)viewDidUnload {
    [self setNameTextField:nil];
    [self setNumbTextField:nil];
    [self setTypeTextField:nil];
    [self setActiveButton:nil];
    [self setFormView:nil];
    [super viewDidUnload];
}
@end
