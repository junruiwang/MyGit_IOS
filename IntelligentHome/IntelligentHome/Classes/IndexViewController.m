//
//  IndexViewController.m
//  IntelligentHome
//
//  Created by jerry on 13-10-9.
//  Copyright (c) 2013年 jerry. All rights reserved.
//

#import "IndexViewController.h"
#import "IPAddress.h"
#import "CloNetworkUtil.h"
#import "Reachability.h"

@interface IndexViewController ()

@property (nonatomic, copy) NSString *appServerUrl;
@property (nonatomic, copy) NSString *currentIP;
@property (nonatomic, strong) GCDAsyncUdpSocket *udpSocket;
@property (nonatomic) int port;
@property (nonatomic) long tag;

- (void)loadRequest;
- (void)sendUDPMessage;
- (void)afterFindAdress;

@end

@implementation IndexViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.port = 63201;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"世强智能家居";
    [self deviceIPAdress];
    
    if (self.udpSocket == nil)
	{
		[self setupSocket];
	}
    
    self.mainWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.mainWebView.scrollView.bounces = NO;
    self.mainWebView.scalesPageToFit = YES;
    self.mainWebView.delegate = self;
    [self.view addSubview:self.mainWebView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self sendUDPMessage];
}

- (void)afterFindAdress
{
    self.appServerUrl = @"http://www.163.com";
    [self loadRequest];
}

- (void)loadRequest
{
    NSURL *serverUrl = [NSURL URLWithString:[self.appServerUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
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
	if (![self.udpSocket bindToPort:self.port error:&error])
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
    NSString *msg = @"Hello,Catch me call!";
    NSData *data = [msg dataUsingEncoding:NSUTF8StringEncoding];
	[self.udpSocket sendData:data toHost:@"255.255.255.255" port:self.port withTimeout:-1 tag:self.tag];
}

#pragma mark - GCDAsyncUdpSocketDelegate
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag
{
	// You could add checks here
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error
{
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
        NSString *receiveMessage = [NSString stringWithFormat:@"message from: %@:%hu,%@",host, port,msg];
        [self showAlertMessage:receiveMessage];
        [self afterFindAdress];
    }
}


//得到本机IP
- (void) deviceIPAdress
{
    InitAddresses();
    GetIPAddresses();
    GetHWAddresses();
    
//    CloNetworkUtil *cloNetworkUtil = [[CloNetworkUtil alloc] init];
//    NetworkStatus workStatus = [cloNetworkUtil getNetWorkType];
//    switch (workStatus) {
//        case ReachableViaWiFi:
//            self.currentIP = [NSString stringWithFormat:@"%s",ip_names[2]];
//            break;
//        case ReachableViaWWAN:
//            [self showAlertMessage:@"您的手机未接入WiFi网络，无法使用遥控功能！"];
//            break;
//        default:
//            [self showAlertMessage:@"您的手机未接入网络，无法使用遥控功能！"];
//            break;
//    }
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
