//
//  SceneModeViewController.m
//  HomeFurnishing
//
//  Created by jrwang on 14-12-7.
//  Copyright (c) 2014年 handpay. All rights reserved.
//

#import "SceneModeViewController.h"
#import "GCDAsyncUdpSocket.h"
#import "BaseServerParser.h"
#import "AppDelegate.h"
#import "IPAddress.h"
#import "CloNetworkUtil.h"
#import "Reachability.h"
#import "Constants.h"
#import "NetworkHelper.h"
#import "UdpIndicatorViewController.h"
#import "CodeUtil.h"
#import "MyServerIdManager.h"
#import "LoginViewController.h"
#import "ControllerFunction.h"

@interface SceneModeViewController ()<GCDAsyncUdpSocketDelegate, JsonParserDelegate, ControllerFunction>

@property (nonatomic, copy) NSString *currentIP;
@property (nonatomic, strong) GCDAsyncUdpSocket *udpSocket;
@property (nonatomic) int udpBroadcastPort;
@property (nonatomic) long tag;
@property (nonatomic) int localServerPort;
//是否收到回播
@property (nonatomic, assign) BOOL isReceived;
//最近一次刷新资源时间
@property(nonatomic, strong) NSDate *invokeTime;
//UDP广播遮罩层效果
@property(nonatomic, strong) UdpIndicatorViewController *udpIndicatorViewController;

@property(nonatomic,strong) LoginViewController *loginViewController;

@property (nonatomic, strong) BaseServerParser *baseServerParser;

@property(nonatomic, strong) MyServerIdManager *myServerIdManager;

- (void)workingForFindServerUrl;
- (void)sendUDPMessage;
- (void)killUdpSocketImmediately;
- (void)didAppBecomeActive;
- (BOOL)isRightJsonData:(NSString *)responseData;
- (void)loadUserSettingModel:(NSString *)dataUrl;

@end

@implementation SceneModeViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.udpBroadcastPort = kUdpBroadcastPort;
        self.isReceived = NO;
        self.myServerIdManager = [[MyServerIdManager alloc] init];
        
        //注册通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didAppBecomeActive) name:@"applicationDidBecomeActiveNotifi" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(killUdpSocketImmediately) name:@"applicationWillResignActiveNotifi" object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"SNB SmartHome";
    [self deviceIPAdress];
    //启动UPD服务
    [self setupSocket];
    //设置调用时间
    self.invokeTime = [NSDate date];
    //启动UDP查找主机
    [self workingForFindServerUrl];
}

-(IBAction)systemButtonClick:(id)sender
{
    if (!self.loginViewController) {
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        self.loginViewController = [board instantiateViewControllerWithIdentifier:@"LoginViewController"];
        self.loginViewController.delegate = self;
    }
    
//    [self.view addSubview:self.loginViewController.view];
//    [self.view bringSubviewToFront:self.loginViewController.view];
    
//    [UIView
//     transitionWithView:current.navigationController.view
//     duration:0.8
//     options:UIViewAnimationOptionTransitionCurlUp
//     animations:^{
//         [current.navigationController pushViewController:next animated:NO];
//     } completion:NULL];
    
    [UIView transitionFromView:self.view toView:self.loginViewController.view duration:0.8 options:UIViewAnimationOptionTransitionCurlUp completion:NULL];
    
//    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^(void){
//        [self.view addSubview:self.loginViewController.view];
//        [self.view bringSubviewToFront:self.loginViewController.view];
//    } completion:NULL];
}

- (void)didAppBecomeActive
{
    NSTimeInterval intCurrentTime = [[NSDate date] timeIntervalSince1970];
    if (self.invokeTime == nil || (intCurrentTime - [self.invokeTime timeIntervalSince1970]) > 10.0) {
        self.invokeTime = [NSDate date];
        //启动UPD服务
        [self setupSocket];
        //执行查找
        [self workingForFindServerUrl];
    }
}

- (void)workingForFindServerUrl
{
    //先判定当前网络环境是WIFI，还是其他网络
    CloNetworkUtil *cloNetworkUtil = [[CloNetworkUtil alloc] init];
    NetworkStatus workStatus = [cloNetworkUtil getNetWorkType];
    switch (workStatus) {
        case ReachableViaWiFi:
        {
            //局域网查找
            [self execScheduleTimer];
            break;
        }
        case ReachableViaWWAN:
        {
            //互联网查找
            [self findHostServerByRemote];
            break;
        }
        default:
        {
            [self showAlertMessage:@"You are not connected to the network, please check your network connection!"];
            break;
        }
    }
}


- (void)execScheduleTimer
{
    [self showIndicatorView];
    self.isReceived = NO;
    //UDP广播查找局域网主机
    for (int i=0; i<5; i++) {
        [self sendUDPMessage];
    }
    
    [self performSelector:@selector(estimateSearchByRemote) withObject:nil afterDelay:5.0];
}

- (void)killUdpSocketImmediately
{
    if (self.udpSocket != nil)
    {
        [self.udpSocket close];
        self.udpSocket = nil;
    }
    //记录退出时间
    self.invokeTime = [NSDate date];
}

//远程查询，不存在的话，网络不可用
- (void)findHostServerByRemote
{
    NSString *serverId = [self.myServerIdManager getCurrentServerId];
    
    if (serverId != nil) {
        if (self.baseServerParser != nil) {
            [self.baseServerParser cancel];
            self.baseServerParser = nil;
        }
        [self showIndicatorView];
        self.baseServerParser = [[BaseServerParser alloc] init];
        self.baseServerParser.serverAddress = kAliyunURL;
        self.baseServerParser.requestString = [NSString stringWithFormat:@"id=%@",serverId];
        self.baseServerParser.delegate = self;
        [self.baseServerParser start];
    }
}

//加载用户已设置情景模式
- (void)loadUserSettingModel:(NSString *)dataUrl
{
    NSLog(@"loadUserSettingModel...");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//建立基于UDP的Socket连接
- (void)setupSocket
{
    if (self.udpSocket != nil)
    {
        [self.udpSocket close];
        self.udpSocket = nil;
    }
    //初始化udp
    self.udpSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    NSError *error = nil;
    //绑定端口
    if (![self.udpSocket bindToPort:kUdpSocketPort error:&error])
    {
        NSLog(@"Error binding: %@", error);
        return;
    }
    //发送广播设置
    if (![self.udpSocket enableBroadcast:YES error:&error]) {
        NSLog(@"Error broadcast: %@", error);
        return;
    }
    //启动接收线程
    if (![self.udpSocket beginReceiving:&error])
    {
        NSLog(@"Error receiving: %@", error);
        return;
    }
    
    if (kLogEnable) {
        NSLog(@"Client Ready!");
    }
}


- (void)sendUDPMessage
{
    NSString *msg = @"Hello,Catch me call!";
    NSData *data = [msg dataUsingEncoding:NSUTF8StringEncoding];
    [self.udpSocket sendData:data toHost:kUdpBroadcastHost port:self.udpBroadcastPort withTimeout:3.0 tag:self.tag];
}

- (void)estimateSearchByRemote
{
    //UPD查找完毕关闭UDP服务
    if (self.udpSocket != nil)
    {
        [self.udpSocket close];
        self.udpSocket = nil;
    }
    
    if (!self.isReceived) {
        [self hideIndicatorView];
        //udp广播未找到主机，通过远程主机获取服务器访问路径
        [self findHostServerByRemote];
    }
}

#pragma mark - GCDAsyncUdpSocketDelegate

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag
{
    if (kLogEnable) {
        NSLog(@"Client didSendData!");
    }
    // You could add checks here
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error
{
    NSLog(@"Client didSendDataError!");
    // You could add checks here
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext
{
    if (!self.isReceived) {
        NSString *host = nil;
        uint16_t port = 0;
        [GCDAsyncUdpSocket getHost:&host port:&port fromAddress:address];
        
        //收到自己发的广播时不显示出来
        NSMutableString *tempIP = [NSMutableString stringWithFormat:@"::ffff:%@",self.currentIP];
        if ([host isEqualToString:self.currentIP]||[host isEqualToString:tempIP])
        {
            return;
        }
        self.isReceived = YES;
        
        [self hideIndicatorView];
        NSString *msg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        BOOL isReceive = [self parserJSONString:msg];
        if (isReceive) {
            //加载用户已设置情景模式
            [self loadUserSettingModel:[NSString stringWithFormat:@"http://%@:%d/",host,self.localServerPort]];
        }
    }
}


- (BOOL)parserJSONString:(NSString *)responseData
{
    if ([self isRightJsonData:responseData]) {
        NSDictionary *dictionary = [responseData JSONValue];
        
        NSString *serverId = [dictionary valueForKey:@"serverId"];
        if (serverId == nil || [serverId isEqualToString:@""]) {
            return NO;
        }
        self.localServerPort = [[dictionary valueForKey:@"port"] intValue];
        
        return [self.myServerIdManager addServerIdToFile:serverId];
    } else {
        return NO;
    }
    
}

- (BOOL)isRightJsonData:(NSString *)responseData
{
    if(responseData == nil || [responseData length] == 0)
    {
        return NO;
    }
    NSDictionary *dictionary = [responseData JSONValue];
    if (dictionary == nil) {
        return NO;
    }
    
    return YES;
}

//得到本机IP
- (void) deviceIPAdress
{
    InitAddresses();
    GetIPAddresses();
    NSString *ipAdress = [NSString stringWithFormat:@"%s",ip_names[2]];
    if (!ipAdress) {
        ipAdress = [NSString stringWithFormat:@"%s",ip_names[1]];
    }
    
    self.currentIP = ipAdress;
}

- (void)showAlertMessage:(NSString *)msg
{
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:NSLocalizedString(@"Information prompt", nil)
                              message:msg
                              delegate:nil
                              cancelButtonTitle:NSLocalizedString(@"OK", nil)
                              otherButtonTitles:nil];
    [alertView show];
}

#pragma mark - UDP loading view

- (void)showIndicatorView
{
    if (self.udpIndicatorViewController == nil)
    {
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        self.udpIndicatorViewController = [board instantiateViewControllerWithIdentifier:@"UdpIndicatorViewController"];
        CGRect frame = self.udpIndicatorViewController.view.frame;
        frame.origin = CGPointMake(0, 0);
        self.udpIndicatorViewController.view.frame = frame;
        [self.view bringSubviewToFront:self.udpIndicatorViewController.view];
    }
    [self.view addSubview:self.udpIndicatorViewController.view];
}

- (void)hideIndicatorView
{
    [self.udpIndicatorViewController.view removeFromSuperview];
    self.udpIndicatorViewController = nil;
}

#pragma mark JsonParserDelegate

- (void)parser:(JsonParser*)parser DidFailedParseWithMsg:(NSString*)msg errCode:(NSInteger)code
{
    [self showAlertMessage:@"Your network has been disconnected!"];
    [self hideIndicatorView];
}

- (void)parser:(JsonParser*)parser DidParsedData:(NSDictionary *)data
{
    [self hideIndicatorView];
    NSString *str_url = [data valueForKey:@"url"];
//    NSString *hostIp = [data valueForKey:@"host"];
    //加载用户已设置情景模式
    [self loadUserSettingModel:str_url];
}


#pragma mark delegate ControllerFunction

- (void)dismissViewController:(HFController) viewController
{
    switch (viewController) {
        case kLoginView:
        {
            [UIView transitionFromView:self.loginViewController.view toView:self.view duration:0.8 options:UIViewAnimationOptionTransitionCurlDown completion:NULL];
            break;
        }
        case kSceneModeView:
            
            break;
        case kSettingIndexView:
            
            break;
        default:
            break;
    }
}

@end
