//
//  IndexViewController.m
//  IntelligentHome
//
//  Created by jerry on 13-10-9.
//  Copyright (c) 2013年 jerry. All rights reserved.
//

#import "IndexViewController.h"
#import "AppDelegate.h"
#import "IPAddress.h"
#import "CloNetworkUtil.h"
#import "Reachability.h"
#import "Constants.h"

@interface IndexViewController ()

@property (nonatomic, copy) NSString *currentIP;
@property (nonatomic, strong) GCDAsyncUdpSocket *udpSocket;
@property (nonatomic) int udpBroadcastPort;
@property (nonatomic) long tag;

@property (nonatomic, strong) NSTimer *scheduleTimer;
//轮询次数
@property (nonatomic, assign) NSInteger pollCount;

- (void)loadRequest;
- (void)sendUDPMessage;
- (void)afterFindAdress;

@end

@implementation IndexViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.udpBroadcastPort = kUdpBroadcastPort;
        self.isWifiServerAds = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"世强智能家居";
    [self deviceIPAdress];
    
//    TheAppDelegate.serverBaseUrl = kBaseURL;
//    self.isWifiServerAds = YES;
    
    if (self.udpSocket == nil)
	{
		[self setupSocket];
	}
    self.mainWebView.scrollView.bounces = NO;
    self.mainWebView.scalesPageToFit = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"%@", NSStringFromCGRect(self.view.frame));
    self.mainWebView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    //先判定当前网络环境是WIFI，还是其他网络
    CloNetworkUtil *cloNetworkUtil = [[CloNetworkUtil alloc] init];
    NetworkStatus workStatus = [cloNetworkUtil getNetWorkType];
    switch (workStatus) {
        case ReachableViaWiFi:
        {
            [self operateForWifi];
            break;
        }
        case ReachableViaWWAN:
        {
            [self showAlertMessage:@"您的手机当前接入网络环境为2G/3G网络！"];
            break;
        }
        default:
        {
            [self showAlertMessage:@"您尚未接入网络，请检查网络连接！"];
            break;
        }
    }
    
}

- (void)operateForWifi
{
    if (self.isWifiServerAds) {
        NSURL *baseUrl = [NSURL URLWithString:TheAppDelegate.serverBaseUrl];
        if ([[UIApplication sharedApplication] canOpenURL:baseUrl]) {
            [self loadRequest];
        } else {
            [self execScheduleTimer];
        }
        
    } else {
        [self execScheduleTimer];
    }
}

- (void)execScheduleTimer
{
    //UDP广播查找局域网主机
    if (self.scheduleTimer == nil) {
        self.scheduleTimer = [NSTimer scheduledTimerWithTimeInterval:11.0
                                                              target:self
                                                            selector:@selector(sendUDPMessage)
                                                            userInfo:nil
                                                             repeats:YES];
        
    }
    [self.scheduleTimer fire];
}

- (void)afterFindAdress
{
    //停止 Timer
    [self.scheduleTimer invalidate];
    
    [self showAlertMessage:TheAppDelegate.serverBaseUrl];
    [self loadRequest];
}

- (void)loadRequest
{
    NSURL *serverUrl = [NSURL URLWithString:[TheAppDelegate.serverBaseUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest *request = [NSURLRequest requestWithURL:serverUrl cachePolicy:NSURLCacheStorageAllowedInMemoryOnly timeoutInterval:20];
    [self.mainWebView loadRequest:request];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//建立基于UDP的Socket连接
- (void)setupSocket
{
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
	
    NSLog(@"Client Ready!");
}


- (void)sendUDPMessage
{
    
    if (self.pollCount < kMaxPollCount) {
        self.pollCount += 1;
        NSString *msg = @"Hello,Catch me call!";
        NSLog(@"%@",msg);
        NSData *data = [msg dataUsingEncoding:NSUTF8StringEncoding];
        [self.udpSocket sendData:data toHost:kUdpBroadcastHost port:self.udpBroadcastPort withTimeout:10 tag:self.tag];
    } else {
        //停止 Timer
        [self.scheduleTimer invalidate];
    }
}

#pragma mark - GCDAsyncUdpSocketDelegate

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag
{
    NSLog(@"Client didSendData!");
	// You could add checks here
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error
{
    NSLog(@"Client didSendDataError!");
	// You could add checks here
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext
{
    NSString *host = nil;
    uint16_t port = 0;
    [GCDAsyncUdpSocket getHost:&host port:&port fromAddress:address];
    
    //收到自己发的广播时不显示出来
    NSMutableString *tempIP = [NSMutableString stringWithFormat:@"::ffff:%@",self.currentIP];
    if ([host isEqualToString:self.currentIP]||[host isEqualToString:tempIP])
    {
        return;
    }
    NSString *msg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if ([msg isEqualToString:@"you_find_me"]) {
//        NSString *receiveMessage = [NSString stringWithFormat:@"message from: %@:%hu,%@",host, port,msg];
        self.isWifiServerAds = YES;
        TheAppDelegate.serverBaseUrl = kBaseURL; //[NSString stringWithFormat:@"http://%@",host];
        [self afterFindAdress];
    }
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
                              initWithTitle:NSLocalizedString(@"信息提示", nil)
                              message:msg
                              delegate:nil
                              cancelButtonTitle:NSLocalizedString(@"确定", nil)
                              otherButtonTitles:nil];
    [alertView show];
}

@end
