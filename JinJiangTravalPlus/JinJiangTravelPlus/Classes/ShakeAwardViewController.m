//
//  ShakeAwardViewController.m
//  JinJiangTravelPlus
//
//  Created by 胡 桂祁 on 5/21/13.
//  Copyright (c) 2013 JinJiang. All rights reserved.
//

#import "ShakeAwardViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <AudioToolbox/AudioToolbox.h>
#import "Constants.h"
#import "ShakeAwardParse.h"
#import "ReadShakeAwardConfigParser.h"
#import "LotteryNumHelper.h"


@interface ShakeAwardViewController () {
    CGRect awardResultFrame;
    CATransform3D awardResultTransform;
}

@property(nonatomic) CGRect leftFrame;
@property(nonatomic) CGRect rightFrame;
@property(nonatomic) CGRect okBtnFrame;
@property(nonatomic) CGRect shakeMobileImgFrame;

@property(nonatomic) CATransform3D ribbonTransform;
@property(nonatomic) CATransform3D actionRuleTransform;
@property(nonatomic) CATransform3D actionLabelTransform;

@property(nonatomic) CATransform3D leftSymbolTransform;
@property(nonatomic) CATransform3D rightSymbolTransform;
@property(nonatomic) CGAffineTransform shakeMobileTransform;

@property(nonatomic) BOOL enableShake;
@property(nonatomic) BOOL activeEnable;
@property(nonatomic, strong) ShakeAwardParse *shakeAwardParser;
@property(nonatomic, strong) ReadShakeAwardConfigParser *shakeAwardConfigParser;
@property(nonatomic, copy) NSString *shakeAwardDesc;
@property(nonatomic, copy) NSString *status;
@property(nonatomic, copy) NSString *activeStatus;

@end

@implementation ShakeAwardViewController{

    SystemSoundID soundID;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.awardResultTextLabel.textColor = RGBCOLOR(0, 53, 103);
    self.awardDescTextLabel.textColor = RGBCOLOR(253, 153, 29);

    awardResultTransform = self.awardResultView.layer.transform;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"glass" ofType:@"wav"];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef) [NSURL fileURLWithPath:path], &soundID);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.trackedViewName = @"手机摇奖页面";
    
    _leftFrame = self.shakeSymbolLeft.frame;
    _rightFrame = self.shakeSymbolRight.frame;
    _shakeMobileImgFrame = _shakeMobileImgView.frame;
    _ribbonTransform = self.ribbonBgImgView.layer.transform;
    _actionRuleTransform = self.actionRuleBgImgView.layer.transform;
    _actionLabelTransform = self.actionLabel.layer.transform;
    _leftSymbolTransform = self.shakeSymbolLeft.layer.transform;
    _rightSymbolTransform = self.shakeSymbolRight.layer.transform;
    awardResultFrame = self.awardResultView.frame;

    _okBtnFrame = self.okBtn.frame;
    _shakeMobileTransform = self.shakeMobileImgView.transform;
    
    [self readShakeAwardConfig];

    self.enableShake = YES;
    self.activeEnable = NO;
}

- (void)backHome:(id)sender {
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
        //左右两图标的旋转淡出离开效果
        [UIView animateWithDuration:0.8
                              delay:0.1
                            options:UIViewAnimationOptionCurveEaseOut
                animations:^{
                    self.enableShake = NO;
                    self.shakeSymbolLeft.layer.transform = CATransform3DRotate(_leftSymbolTransform, M_PI * 0.5, 0, 0, 1);
                    self.shakeSymbolRight.layer.transform = CATransform3DRotate(_rightSymbolTransform, M_PI * 0.5, 0, 0, 1);

                    self.shakeSymbolLeft.frame = CGRectMake(-100, -100, 47, 67);
                    self.shakeSymbolRight.frame = CGRectMake(420, 340, 47, 67);

                    self.ribbonBgImgView.layer.transform = CATransform3DMakeTranslation(0, 460, 0);
                    self.actionRuleBgImgView.layer.transform = CATransform3DMakeTranslation(0, 460, 0);
                    self.actionLabel.layer.transform = CATransform3DMakeTranslation(0, 460, 0);
                    self.shakeShadawImgView.hidden = YES;

                } completion:^(BOOL isFinished) {
                    [self shakeAwardAnimations];
        }];
    }
}

- (void)shakeAwardAnimations {
    self.shakeMobileImgView.transform = CGAffineTransformMakeRotation(M_PI * -0.03);
    [UIView animateWithDuration:0.08
                          delay:0.0
                        options:UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse | UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveLinear
            animations:^{
                [UIView setAnimationRepeatCount:5];
                AudioServicesPlaySystemSound(soundID);
                self.shakeMobileImgView.transform = CGAffineTransformMakeRotation(M_PI * 0.03);
            } completion:^(BOOL isFinished) {
        [[self navigationController] setNavigationBarHidden:NO animated:YES];
        [self.shakeMobileImgView setTransform:CGAffineTransformIdentity];
        self.shakeMobileImgView.bounds = _shakeMobileImgFrame;
        self.awardResultView.hidden = NO;
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);

        self.awardResultView.layer.transform = CATransform3DScale(awardResultTransform, 0.1, 0.1, 1);
        [self shakeAwardHandler];
        if(![self isActiveValid]){
                    //todo
                    return;
        }
        if ([self isWin]) {
            [LotteryNumHelper plusLotteryNum];
            [self getAwardView];
        } else {
            [self notAwardView];
        }
        //弹出中奖结果页面
        [UIView animateWithDuration:0.5
                              delay:0.15
                            options:nil
                         animations:^(void) {
                             self.awardResultView.layer.transform = CATransform3DScale(self.awardResultView.layer.transform, 10, 10, 1);
                         }
                         completion:^(BOOL finished) {
                             self.okBtn.hidden = NO;
                             self.awardResultTextLabel.hidden = NO;
                             self.awardDescTextLabel.hidden = NO;
                             [UIView animateWithDuration:0.5
                                                   delay:0.0
                                                 options:UIViewAnimationOptionCurveEaseIn
                                     animations:^(void) {

                                         self.okBtn.frame = CGRectMake(82, self.mobileShadawImgView.frame.origin.y + 40, 155, 41);
                                     } completion:^(BOOL finished) {

                             }];
                         }];

    }];
}

- (BOOL)isWin {
    return [@"WIN" isEqualToString:_status];
}

- (void)shakeAwardHandler {
    if (!_shakeAwardParser) {
        _shakeAwardParser = [[ShakeAwardParse alloc] init];
        _shakeAwardParser.delegate = self;
    }
    [_shakeAwardParser shakeAward:[LotteryNumHelper readCurrentLotteryNum] withActivityCode:NULL];
}

- (IBAction)clickRestoreShakeView:(id)sender {
    [UIView animateWithDuration:0.5
            animations:^(void) {
                self.shakeSymbolLeft.layer.transform = _leftSymbolTransform;
                self.shakeSymbolRight.layer.transform = _rightSymbolTransform;
                self.shakeSymbolLeft.frame = _leftFrame;
                self.shakeSymbolRight.frame = _rightFrame;
                self.shakeMobileImgView.transform = _shakeMobileTransform;

                self.ribbonBgImgView.layer.transform = _ribbonTransform;
                self.actionRuleBgImgView.layer.transform = _actionRuleTransform;
                self.actionLabel.layer.transform = _actionLabelTransform;
                self.awardResultView.frame = awardResultFrame;
                self.okBtn.frame = _okBtnFrame;
                self.awardResultTextLabel.hidden = YES;
                self.awardDescTextLabel.hidden = YES;
                self.awardResultView.layer.transform = CATransform3DScale(awardResultTransform, 0.1, 0.1, 1);

                self.shakeShadawImgView.hidden = NO;
            } completion:^(BOOL isFinished) {
        self.enableShake = YES;
        self.awardResultView.layer.transform = awardResultTransform;
        self.awardResultView.hidden = YES;
    }];

}


- (void)getAwardView {
    self.awardResultTextLabel.text = [NSString stringWithFormat:@"恭喜您抽到%@", _shakeAwardDesc];
    self.awardDescTextLabel.text = @"运气不错哟，继续加油!";
    self.getAwardImgView.hidden = NO;
    self.notAwardImgView.hidden = YES;
}

- (void)notAwardView {
    self.awardResultTextLabel.text = @"什么都没有,这事可不赖我!";
    self.awardDescTextLabel.text = @"想要优惠券,下次继续努力吧!";
    self.getAwardImgView.hidden = YES;
    self.notAwardImgView.hidden = NO;
}

- (void)parser:(GDataXMLParser *)parser DidParsedData:(NSDictionary *)data {
    if ([parser isKindOfClass:[ShakeAwardParse class]]) {
        if ([data count] > 0) {
            NSString *status = [data valueForKey:kKeyStatus];
            NSString *awardDesc = [data valueForKey:kKeyAward];
            NSString *activeStatus = [data valueForKey:kKeyActiveStatus];
            NSString *enabled = [data valueForKey:kKeyEnabled];
            _shakeAwardDesc = awardDesc;
            _status = status;
            _activeStatus = activeStatus;
            _activeEnable = [enabled boolValue];
        }
    } else if ([parser isKindOfClass:[ReadShakeAwardConfigParser class]]) {
        [self handlerReadShakeAwardConfigParser:data];
    }
}

- (void)parser:(GDataXMLParser *)parser DidFailedParseWithMsg:(NSString *)msg errCode:(NSInteger)code {
     if ([parser isKindOfClass:[ShakeAwardParse class]]) {
         _activeStatus = @"ERROR";
         _activeEnable = NO;
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

- (void)readShakeAwardConfig {
    if (!_shakeAwardConfigParser) {
        _shakeAwardConfigParser = [[ReadShakeAwardConfigParser alloc] init];
        _shakeAwardConfigParser.delegate = self;
    }
    [_shakeAwardConfigParser getShakeAwardConfig:[LotteryNumHelper readCurrentLotteryNum]];
}

#pragma mark --readShakeAwardConfigParser
-(void) handlerReadShakeAwardConfigParser:(NSDictionary *)data
{
    NSString *status = [data objectForKey:kKeyStatus];
    const BOOL enabled =  [[data objectForKey:kKeyEnabled] boolValue];
    self.activeEnable = enabled;
    self.activeStatus = status;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
