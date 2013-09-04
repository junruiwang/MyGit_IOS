//
//  JJPassbookViewController.m
//  JinJiangTravelPlus
//
//  Created by 胡 桂祁 on 4/17/13.
//  Copyright (c) 2013 JinJiang. All rights reserved.
//

#import "JJPassbookViewController.h"
#import "CloNetworkUtil.h"


@interface JJPassbookViewController ()

@property(nonatomic)int limitCount;

@end

@implementation JJPassbookViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.limitCount = 10;
	// Do any additional setup after loading the view.
}

-(void)initPassbookParser{
    if(!_passbookRequestParse){
        self.passbookRequestParse = [[PassbookRequestParse alloc] init];
        self.passbookRequestParse.passUrlDelegate = self;
    }
}

+(BOOL)canUsePassbook
{
    double version = [[UIDevice currentDevice].systemVersion doubleValue];//判定系统版本。
    
    if(version>=6.0f){
        return YES;
    }
    return NO;
}

-(void)addToPassbook
{
    if ([self filterPassData]) {
        [self showPassbookView];
    }
}

-(BOOL)filterPassData{
    BOOL flag = NO;
    if (![self readPassFromLocal]) {
        CloNetworkUtil *cloNetwork = [[CloNetworkUtil alloc] init];
        if (![cloNetwork getNetWorkStatus]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您当前的网络缓慢，请稍后再试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
            return flag;
        }
        [self getPassDataForPassUrl];
    }
    
    if ([self isNotEmptyPassData]) {
        flag = YES;
    }
    return flag;
}

-(void)getPassDataForPassUrl
{
    if (!_passUrl) {
        return;
    }
    NSError *error = nil;
    self.passData = [NSData dataWithContentsOfURL:self.passUrl options:NSDataReadingUncached error:&error];
    NSLog(@"getPassDataForPassUrl error value is %@",error);
    if(error){
        return;
    }
    if ([self isNotEmptyPassData]) {
        [self writeToFile];
    }else if(self.limitCount != 0){
        self.limitCount --;
        NSLog(@"aaaaa%i",self.limitCount);
        [self getPassDataForPassUrl];
    }
}


-(BOOL)isNotEmptyPassData
{
    return _passData != nil && [_passData length]>0;
}

-(void)showPassbookView
{
    if(![self isNotEmptyPassData]){
        return;
    }
    NSError *error = nil;
    PKPass *pass = [[PKPass alloc] initWithData:self.passData error:&error];
    
    if (error!=nil) {
        [[[UIAlertView alloc] initWithTitle:@"Passes error"
                                    message:[error
                                             localizedDescription]
                                   delegate:nil
                          cancelButtonTitle:@"关闭"
                          otherButtonTitles: nil] show];
        return;
    }
    
    PKAddPassesViewController *addController =
    [[PKAddPassesViewController alloc] initWithPass:pass];
    
    addController.delegate = self;
    [self.showPassbookViewController presentViewController:addController
                                                     animated:YES
                                                   completion:nil];
}

-(void)getPassUr:(NSString *)passUrl
{
    if (!passUrl) {
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"生成passbook失败,服务器正在更新,请稍后重试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alertView show];
        return;
    }
    NSURL *url = [[NSURL alloc] initWithString:passUrl];
    self.passUrl = url;
    if (self.passUrl) {
        [self writePassbookUrlToFile];
        [self getPassDataForPassUrl];
    }
    
}

-(void)writePassbookUrlToFile
{
    
}

-(BOOL)readPassFromLocal
{
    return NO;
}

-(void)writeToFile
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
