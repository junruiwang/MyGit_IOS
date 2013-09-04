//
//  ActivityDetailWebViewController.m
//  JinJiangTravelPlus
//
//  Created by jerry on 13-7-30.
//  Copyright (c) 2013年 JinJiang. All rights reserved.
//

#import "ActivityDetailWebViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <AudioToolbox/AudioToolbox.h>
#import "Constants.h"
#import "ShakeAwardParse.h"
#import "LotteryNumHelper.h"
#import "LoginViewController.h"
#import "ValidateInputUtil.h"
#import "WinnerInfoParser.h"

@interface ActivityDetailWebViewController () {
    CGRect awardResultFrame;
    CATransform3D awardResultTransform;
    CGRect productResultFrame;
    CATransform3D productResultTransform;
}

@property(nonatomic) CGRect leftFrame;
@property(nonatomic) CGRect rightFrame;
@property(nonatomic) CGRect okBtnFrame;
@property(nonatomic) CGRect shakeMobileImgFrame;

@property(nonatomic) CATransform3D ribbonTransform;
@property(nonatomic) CATransform3D ribbonLabelTransform;
@property(nonatomic) CATransform3D actionRuleTransform;
@property(nonatomic) CATransform3D actionLabelTransform;

@property(nonatomic) CATransform3D leftSymbolTransform;
@property(nonatomic) CATransform3D rightSymbolTransform;
@property(nonatomic) CGAffineTransform shakeMobileTransform;

@property(nonatomic) BOOL enableShake;
@property(nonatomic) BOOL activeEnable;
@property(nonatomic, strong) ShakeAwardParse *shakeAwardParser;
@property(nonatomic, strong) WinnerInfoParser *winnerInfoParser;
@property(nonatomic, copy) NSString *shakeAwardDesc;
@property(nonatomic, strong) NSString *status;
@property(nonatomic, copy) NSString *activeStatus;
@property(nonatomic, copy) NSString *prizeRecordId;
@property(nonatomic, copy) NSString *awardType;
@property(nonatomic) BOOL isWin;

@property (nonatomic, strong) NSString *shareInfo;
@property (nonatomic, strong) NSString *shareDetailPrefix;
@property (nonatomic, strong) NSString *shareDetail;
@property (nonatomic, strong) NSString *ribbonDescription;

@end

@implementation ActivityDetailWebViewController{
    
    SystemSoundID soundID;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"activityToLogin"]) {
        LoginViewController *lvc = segue.destinationViewController;
        lvc.activityUrl = self.url;
        lvc.activeConfig = self.config;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.url != nil) {
        [self.webView setDelegate:self];
        self.webView.scalesPageToFit = YES;
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]
                                                   cachePolicy:NSURLRequestUseProtocolCachePolicy
                                               timeoutInterval:8]];
    }
    
    self.shareToSNSManager = [[ShareToSNSManager alloc] init];
    
    self.getAwardLabel.textColor = RGBCOLOR(0, 53, 103);
    self.getAwardDescription.textColor = RGBCOLOR(253, 153, 29);
    
    self.nameTextField.delegate = self;
    self.phoneTextField.delegate = self;
    self.addressTextView.delegate = self;
    
    awardResultTransform = self.awardResult.layer.transform;
    productResultTransform = self.productResultView.layer.transform;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"glass" ofType:@"wav"];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef) [NSURL fileURLWithPath:path], &soundID);
}

- (void)getPrizeDescription
{
    NSArray *array = [self.config.prizeDescription componentsSeparatedByString:@"|"];
    if (array.count == 4) {
        self.ribbonDescription = [array objectAtIndex:0];
        self.shareInfo = [array objectAtIndex:1];
        self.shareDetailPrefix = [array objectAtIndex:2];
        self.shareDetail = [array objectAtIndex:3];
    } else {
        self.ribbonDescription = @"摇一摇，抽大奖！好礼多多，拿到手酸。拼运气，人品大爆炸就在此刻了！";
        self.shareInfo = @"兴奋，激动……是不是无法表达你中奖的喜悦啊，告诉你的朋友们吧，独乐乐不如众乐乐哦！";
        self.shareDetailPrefix = @"我在锦江旅行家APP摇到了";
        self.shareDetail = @",别愣着了，一起摇吧，别说我没告诉你！下载";
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.trackedViewName = @"手机摇奖页面";
    
    [self getPrizeDescription];
    
    self.ribbonLabel.text = self.config.prizeTitle;
    self.ruleLabel.text = self.ribbonDescription;
    
    _leftFrame = self.shakeLeft.frame;
    _rightFrame = self.shakeRight.frame;
    _shakeMobileImgFrame = self.phone.frame;
    _ribbonTransform = self.ribbon.layer.transform;
    _ribbonLabelTransform = self.ribbonLabel.layer.transform;
    _actionRuleTransform = self.ruleBack.layer.transform;
    _actionLabelTransform = self.ruleLabel.layer.transform;
    _leftSymbolTransform = self.shakeLeft.layer.transform;
    _rightSymbolTransform = self.shakeRight.layer.transform;
    awardResultFrame = self.awardResult.frame;
    productResultFrame = self.productResultView.frame;
    
    _okBtnFrame = self.confirmButton.frame;
    _shakeMobileTransform = self.phone.transform;
    
    self.enableShake = NO;
    self.activeEnable = NO;
}

int prewTag ;  //编辑上一个UITextField的TAG,需要在XIB文件中定义或者程序中添加，不能让两个控件的TAG相同
float prewMoveY; //编辑的时候移动的高度

-(BOOL)textFieldShouldReturn:(UITextField*)textField;
{
    NSInteger nextTag = textField.tag + 1;
    // Try to find next responder
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        // Not found, so remove keyboard.
        [textField resignFirstResponder];
    }
    return NO; // We do not want UITextField to insert line-breaks.
}
- (IBAction)textViewFinished:(id)sender {
    [self resignAll];
}

- (void)resignAll
{
    
    [self.nameTextField resignFirstResponder];
    [self.phoneTextField resignFirstResponder];
    [self.addressTextView resignFirstResponder];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGFloat yOffset = textField == self.phoneTextField ? 50 : 20;
    
    CGRect rect = self.productResultView.frame;
    [UIView beginAnimations:@"ResizeView" context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    self.productResultView.frame = CGRectMake(rect.origin.x, rect.origin.y - yOffset, rect.size.width, rect.size.height);
    [UIView commitAnimations];//设置调整界面的动画效果
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
    CGFloat yOffset = textField == self.phoneTextField ? 50 : 20;
    CGRect rect = self.productResultView.frame;
    [UIView beginAnimations:@"ResizeView" context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    self.productResultView.frame = CGRectMake(rect.origin.x, rect.origin.y + yOffset, rect.size.width, rect.size.height);
    [UIView commitAnimations];//设置调整界面的动画效果
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    CGRect rect = self.productResultView.frame;
    [UIView beginAnimations:@"ResizeView" context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    self.productResultView.frame = CGRectMake(rect.origin.x, rect.origin.y - 100, rect.size.width, rect.size.height);
    [UIView commitAnimations];//设置调整界面的动画效果
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    
    CGRect rect = self.productResultView.frame;
    //self.view移回原位置
    [UIView beginAnimations:@"ResizeView" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    self.productResultView.frame = CGRectMake(rect.origin.x, rect.origin.y + 100, rect.size.width, rect.size.height);
    [UIView commitAnimations];
    [textView resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    CGSize winSize = webView.frame.size;
    NSString *requestPath = [[request URL] absoluteString];
    if ([requestPath rangeOfString:@"activity_toShake_sugue"].length > 0) {
        
        
        if ([TheAppDelegate.userInfo checkIsLogin] == YES)
        {
            self.enableShake = YES;
            [UIView animateWithDuration:0.5 animations:^{
                self.shakeView.frame = CGRectMake(0, 0, winSize.width, winSize.height);
            }];
        }else{
            //跳转到登录
            TheAppDelegate.customEnumType = JJCustomTypeActivity;
            [self performSegueWithIdentifier:@"activityToLogin" sender:nil];
        }
        
        return NO;
    }
    //self.title = theTitle;
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.webView];
    NSLog(@"%f, %f", point.x, point.y);
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self showIndicatorView];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self hideIndicatorView];
//    [self performSegueWithIdentifier:@"activity_toShake_sugue" sender:nil];
    
    NSString *jsCommand = [NSString stringWithFormat:@"document.body.style.zoom = %f;",[[NSUserDefaults standardUserDefaults] boolForKey:USER_DEVICE_5] ? 1.5 : 1.4];
    [self.webView stringByEvaluatingJavaScriptFromString:jsCommand];
    self.webView.scrollView.scrollEnabled = NO;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self hideIndicatorView];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"内容加载发生错误"
                                                   delegate:self cancelButtonTitle:nil
                                          otherButtonTitles:@"确定", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag != 200) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    NSString *name = [@"PRODUCT" isEqualToString:self.awardType] ? @"实物中奖" : @"其他中奖";
    switch (buttonIndex) {
        case 0:
        {
            self.enableShake = YES;
        }
            break;
        case 1:
        {
            
            [[GAI sharedInstance].defaultTracker sendEventWithCategory:@"活动页面"
                                                            withAction:name
                                                             withLabel:@"活动页面中奖"
                                                             withValue:nil];
            [UMAnalyticManager eventCount:@"中奖分享" label:name];
            
            [self.shareToSNSManager shareWithActionSheet:self shareImage:[UIImage imageNamed:@"qrcode_product.png"] shareText:[NSString stringWithFormat:@"%@ %@ %@", self.shareDetailPrefix, self.shakeAwardDesc, self.shareDetail]];
            self.enableShake = YES;
        }
            break;
        default:
            break;
    }
    
}

- (void)backHome:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (BOOL)canBecomeFirstResponder {
    return YES;
    
}

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    
    if (motion == UIEventSubtypeMotionShake && self.enableShake) {
        [UMAnalyticManager eventCount:@"摇奖总数" label:@"摇奖次数"];
        [[GAI sharedInstance].defaultTracker sendEventWithCategory:@"手机摇一摇"
                                                        withAction:@"摇奖页面摇手机计数"
                                                         withLabel:@"摇奖页面摇手机计数"
                                                         withValue:nil];
        
        [[self navigationController] setNavigationBarHidden:YES animated:YES];
        //左右两图标的旋转淡出离开效果q
        [UIView animateWithDuration:0.8
                              delay:0.1
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             self.enableShake = NO;
                             self.shakeLeft.layer.transform = CATransform3DRotate(_leftSymbolTransform, M_PI * 0.5, 0, 0, 1);
                             self.shakeRight.layer.transform = CATransform3DRotate(_rightSymbolTransform, M_PI * 0.5, 0, 0, 1);
                             
                             self.shakeLeft.frame = CGRectMake(-100, -100, 47, 67);
                             self.shakeRight.frame = CGRectMake(420, 340, 47, 67);
                             
                             self.ribbon.layer.transform = CATransform3DMakeTranslation(0, 460, 0);
                             self.ribbonLabel.layer.transform = CATransform3DMakeTranslation(0, 460, 0);
                             self.ruleBack.layer.transform = CATransform3DMakeTranslation(0, 460, 0);
                             self.ruleLabel.layer.transform = CATransform3DMakeTranslation(0, 460, 0);
                             self.phone_shadow.hidden = YES;
                             
                         } completion:^(BOOL isFinished) {
                             [self shakeAwardAnimations];
                         }];
    }
}

- (void)shakeAwardAnimations {
    self.phone.transform = CGAffineTransformMakeRotation(M_PI * -0.03);
    
    [UIView animateWithDuration:0.08
                          delay:0.0
                        options:UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse | UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveLinear
                     animations:^{
                         [UIView setAnimationRepeatCount:5];
                         AudioServicesPlaySystemSound(soundID);
                         self.phone.transform = CGAffineTransformMakeRotation(M_PI * 0.03);
                     } completion:^(BOOL isFinished) {
                         [[self navigationController] setNavigationBarHidden:NO animated:YES];
                         [self.phone setTransform:CGAffineTransformIdentity];
                         self.phone.bounds = _shakeMobileImgFrame;
                         AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                         
                         [self shakeAwardHandler];
                     }];
}

- (BOOL)checkIsWin {
    return [@"WIN" isEqualToString:_status];
}


- (IBAction)clickRestoreShakeView:(id)sender {
    [UIView animateWithDuration:0.5
                     animations:^(void) {
                         self.shakeLeft.layer.transform = _leftSymbolTransform;
                         self.shakeRight.layer.transform = _rightSymbolTransform;
                         self.shakeLeft.frame = _leftFrame;
                         self.shakeRight.frame = _rightFrame;
                         self.phone.transform = _shakeMobileTransform;
                         
                         self.ribbon.layer.transform = _ribbonTransform;
                         self.ribbonLabel.layer.transform = _ribbonLabelTransform;
                         self.ruleBack.layer.transform = _actionRuleTransform;
                         self.ruleLabel.layer.transform = _actionLabelTransform;
                         self.awardResult.frame = awardResultFrame;
                         self.confirmButton.frame = _okBtnFrame;
                         self.getAwardLabel.hidden = YES;
                         self.getAwardDescription.hidden = YES;
                         self.awardResult.layer.transform = CATransform3DScale(awardResultTransform, 0.1, 0.1, 1);
                         
                         self.phone.hidden = NO;
                     } completion:^(BOOL isFinished) {
                         self.enableShake = YES;
                         self.awardResult.layer.transform = awardResultTransform;
                         self.awardResult.hidden = YES;
                         
                         [self shareResult:NO];
                     }];
    
}

- (void)shareResult:(BOOL)isRealProduct
{
    if (!self.isWin)return;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息" message:self.shareInfo delegate:self cancelButtonTitle:@"算了" otherButtonTitles:@"分享", nil];
    alert.tag = 200;
    [alert show];
}

- (void)getAwardView {
    self.getAwardLabel.text = [NSString stringWithFormat:@"恭喜您抽到%@", _shakeAwardDesc];
    self.getAwardDescription.text = @"运气不错哟，继续加油!";
    self.getAward.hidden = NO;
    self.notAward.hidden = YES;
}

- (void)notAwardView {
    self.getAwardLabel.text = @"什么都没有,这事可不赖我!";
    self.getAwardDescription.text = @"想要奖品,下次继续努力吧!";
    self.getAward.hidden = YES;
    self.notAward.hidden = NO;
}

- (void)runAwardResult {
    if(![self isActiveValid]){
        //todo
        return;
    }
    if (self.isWin) {
        [LotteryNumHelper plusLotteryNum];
        [self getAwardView];
    } else {
        [self notAwardView];
    }
    
    if ([@"PRODUCT" isEqualToString:self.awardType]) {
        
        self.productNameLabel.text = self.shakeAwardDesc;
    
        
        self.productResultView.hidden = NO;
        self.productResultView.layer.transform = CATransform3DScale(productResultTransform, 0.1, 0.1, 1);
        [UIView animateWithDuration:0.5
                              delay:0.15
                            options:nil
                         animations:^(void) {
                             self.productResultView.layer.transform = CATransform3DScale(self.productResultView.layer.transform, 10, 10, 1);
                         }
                         completion:^(BOOL finished) {
                             
                         }];
    } else {
        self.awardResult.hidden = NO;
        self.awardResult.layer.transform = CATransform3DScale(awardResultTransform, 0.1, 0.1, 1);
        //弹出中奖结果页面
        [UIView animateWithDuration:0.5
                              delay:0.15
                            options:nil
                         animations:^(void) {
                             self.awardResult.layer.transform = CATransform3DScale(self.awardResult.layer.transform, 10, 10, 1);
                         }
                         completion:^(BOOL finished) {
                             self.confirmButton.hidden = NO;
                             self.getAwardLabel.hidden = NO;
                             self.getAwardDescription.hidden = NO;
                             [UIView animateWithDuration:0.5
                                                   delay:0.0
                                                 options:UIViewAnimationOptionCurveEaseIn
                                              animations:^(void) {
                                                  
                                                  self.confirmButton.frame = CGRectMake(82, self.shadow.frame.origin.y + 40, 155, 41);
                                              } completion:^(BOOL finished) {
                                                  
                                              }];
                         }];
    }
}

- (void)parser:(GDataXMLParser *)parser DidParsedData:(NSDictionary *)data {
    if ([parser isKindOfClass:[ShakeAwardParse class]]) {
        if ([data count] > 0) {
            NSLog(@"%@",data);
            self.status = [data valueForKey:kKeyStatus];
            self.activeStatus= [data valueForKey:kKeyActiveStatus];
            self.activeEnable = [[data valueForKey:kKeyEnabled] boolValue];
            self.isWin = [self checkIsWin];
            if (self.isWin) {
                self.shakeAwardDesc = [data valueForKey:kKeyAward];
                self.prizeRecordId = [data valueForKey:kKeyPrizeRecordId];
                self.awardType = [data valueForKey:kKeyAwardType];
            } else {
                
                self.shakeAwardDesc = nil;
                self.prizeRecordId = nil;
                self.awardType = nil;
            }
            [self runAwardResult];
        }
    } else if ([parser isKindOfClass:[WinnerInfoParser class]]) {
        
        [UIView animateWithDuration:0.5
                         animations:^(void) {
                             self.shakeLeft.layer.transform = _leftSymbolTransform;
                             self.shakeRight.layer.transform = _rightSymbolTransform;
                             self.shakeLeft.frame = _leftFrame;
                             self.shakeRight.frame = _rightFrame;
                             self.phone.transform = _shakeMobileTransform;
                             
                             self.ribbon.layer.transform = _ribbonTransform;
                             self.ribbonLabel.layer.transform = _ribbonLabelTransform;
                             self.ruleBack.layer.transform = _actionRuleTransform;
                             self.ruleLabel.layer.transform = _actionLabelTransform;
                             self.productResultView.frame = productResultFrame;
                             self.confirmButton.frame = _okBtnFrame;
                             self.getAwardLabel.hidden = YES;
                             self.getAwardDescription.hidden = YES;
                             self.productResultView.layer.transform = CATransform3DScale(productResultTransform, 0.1, 0.1, 1);
                             
                             self.phone.hidden = NO;
                         } completion:^(BOOL isFinished) {
                             self.enableShake = YES;
                             self.productResultView.layer.transform = productResultTransform;
                             self.productResultView.hidden = YES;
                             
                             [self shareResult:YES];
                         
                         }];
    }
}

- (void)parser:(GDataXMLParser *)parser DidFailedParseWithMsg:(NSString *)msg errCode:(NSInteger)code {
    if ([parser isKindOfClass:[ShakeAwardParse class]]) {
        _activeStatus = @"ERROR";
        _activeEnable = NO;
        
        [self runAwardResult];
    } else if ([parser isKindOfClass:[WinnerInfoParser class]]) {
        _activeStatus = @"ERROR";
        _activeEnable = NO;
        
        [self runAwardResult];
    }
}


- (BOOL)isActiveValid {
    if(_activeEnable){
        return YES;
    } else if([@"ACTIVE_OFF" isEqualToString:_activeStatus]){
        [self alertMsgView:@"摇奖活动已结束"];
        return NO;
    } else if([@"OUTDATE" isEqualToString:_activeStatus]){
        [self alertMsgView:@"摇奖活动已结束"];
        return NO;
    } else if([@"OUT_MAXWINLOTTERYSIZE" isEqualToString:_activeStatus]){
        [self alertMsgView:@"亲，今天已经中过奖了，休息会明天再摇吧~~~~"];
        return NO;
    } else{
        [self alertMsgView:@"服务器正忙，请稍后重试"];
        return NO;
    }
    [self clickRestoreShakeView:nil];
    return NO;
}

-(void)alertMsgView:(NSString *)msg{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    [self clickRestoreShakeView:nil];
}

- (void)shakeAwardHandler {
    if (!_shakeAwardParser) {
        _shakeAwardParser = [[ShakeAwardParse alloc] init];
        _shakeAwardParser.delegate = self;
    }
    [_shakeAwardParser shakeAward:[LotteryNumHelper readCurrentLotteryNum] withActivityCode:kKeyCarnivalActivityCode];
}

- (void)winnerParserHandler
{
    if (!_winnerInfoParser) {
        _winnerInfoParser = [[WinnerInfoParser alloc] init];
        _winnerInfoParser.delegate = self;
    }
    [_winnerInfoParser sendWinnerName:self.nameTextField.text phoneNumber:self.phoneTextField.text address:self.addressTextView.text prizeRecordId:self.prizeRecordId];
}

- (BOOL)verify
{
    if (![ValidateInputUtil isNotEmpty:self.phoneTextField.text fieldCName:@"手机"])
        return NO;
    
    if (![ValidateInputUtil isEffectivePhone:self.phoneTextField.text])
        return NO;
    
    if (![ValidateInputUtil isNotEmpty:self.nameTextField.text fieldCName:@"姓名"])
        return NO;
    
    if (![ValidateInputUtil isNotEmpty:self.addressTextView.text fieldCName:@"地址"])
        return NO;
    return YES;
}

- (IBAction)commitResult:(UIButton *)sender {
    [self resignAll];
    if ([self verify]) {
        [self winnerParserHandler];
        
    }
    
}

- (IBAction)callHelp:(UIButton *)sender {
    [super call];
}

#pragma mark --readShakeAwardConfigParser
-(void) handlerReadShakeAwardConfigParser:(NSDictionary *)data
{
    NSString *status = [data objectForKey:kKeyStatus];
    const BOOL enabled =  [[data objectForKey:kKeyEnabled] boolValue];
    self.activeEnable = enabled;
    self.activeStatus = status;
}


- (void)viewDidUnload {
    [self setPhone_shadow:nil];
    [self setShakeLeft:nil];
    [self setShakeRight:nil];
    [self setShadow:nil];
    [self setRuleBack:nil];
    [self setPhone:nil];
    [self setRibbon:nil];
    [self setRuleLabel:nil];
    [self setAwardResult:nil];
    [self setGetAward:nil];
    [self setNotAward:nil];
    [self setGetAwardLabel:nil];
    [self setGetAwardDescription:nil];
    [self setShakeView:nil];
    [self setConfirmButton:nil];
    [self setShakeView:nil];
    [self setRibbonLabel:nil];
    [self setProductResultView:nil];
    [self setProductDescription:nil];
    [self setCommitButton:nil];
    [self setNameTextField:nil];
    [self setPhoneTextField:nil];
    [self setAddressTextView:nil];
    [self setProductNameLabel:nil];
    [super viewDidUnload];
}
@end
