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
#import "NetworkHelper.h"
#import "UdpIndicatorViewController.h"
#import "HZActivityIndicatorView.h"

@interface IndexViewController ()

@property (nonatomic, copy) NSString *currentIP;
@property (nonatomic, strong) GCDAsyncUdpSocket *udpSocket;
@property (nonatomic) int udpBroadcastPort;
@property (nonatomic) long tag;
@property (nonatomic) int localServerPort;
//是否wifi标识
@property (nonatomic, assign) BOOL isWifiServerAds;
//是否收到回播
@property (nonatomic, assign) BOOL isReceived;

@property (nonatomic, strong) NSTimer *scheduleTimer;
//轮询次数
@property (nonatomic, assign) NSInteger pollCount;
//最近一次刷新资源时间
@property(nonatomic, strong) NSDate *invokeTime;
//UDP广播遮罩层效果
@property(nonatomic, strong) UdpIndicatorViewController *udpIndicatorViewController;
//webView遮罩层效果
@property(nonatomic, strong) HZActivityIndicatorView *customIndicator;

@property (nonatomic, strong) BaseServerParser *baseServerParser;

- (void)workingForFindServerUrl;
- (void)stopTimerTask;
- (void)firstStoreSSID;
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
        self.isReceived = NO;
        self.pollCount = 0;
        //注册通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(workingForFindServerUrl) name:@"applicationDidBecomeActiveNotifi" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopTimerTask) name:@"applicationWillResignActiveNotifi" object:nil];
        //初始化 ServerId
        [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:kCurrentServerId];
        [[NSUserDefaults standardUserDefaults] synchronize];
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
    self.mainWebView.scrollView.bounces = NO;
    self.mainWebView.scalesPageToFit = NO;
    self.mainWebView.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0) {
        self.mainWebView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-20);
    }
    
    [self workingForFindServerUrl];
}

- (void)stopTimerTask
{
    if (self.scheduleTimer) {
        [self hideIndicatorView];
        [self.scheduleTimer invalidate];
        self.scheduleTimer = nil;
    }
}

- (void)workingForFindServerUrl
{
    NSTimeInterval intCurrentTime = [[NSDate date] timeIntervalSince1970];
    
    if (self.invokeTime == nil || (intCurrentTime - [self.invokeTime timeIntervalSince1970]) > 1800) {
        self.invokeTime = [NSDate date];
        //先判定当前网络环境是WIFI，还是其他网络
        CloNetworkUtil *cloNetworkUtil = [[CloNetworkUtil alloc] init];
        NetworkStatus workStatus = [cloNetworkUtil getNetWorkType];
        switch (workStatus) {
            case ReachableViaWiFi:
            {
                //局域网查找
                [self operateForWifi];
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
                [self showAlertMessage:@"您尚未接入网络，请检查网络连接！"];
                break;
            }
        }
    }
}

//WIFI网络操作
- (void)operateForWifi
{
    NSString *ssid = [[NSUserDefaults standardUserDefaults] valueForKey:kCurrentServerWifiSSID];
    NSString *curssid = [NetworkHelper fetchSSIDInfo];
    
    NSMutableArray *ssidList = [[NSUserDefaults standardUserDefaults] valueForKey:kLocalWifiSSIDList];
    //新网络环境走UDP广播
    if (ssidList == nil) {
        if (curssid != nil && ![curssid isEqualToString:@""]) {
            ssidList = [[NSMutableArray alloc] initWithCapacity:1];
            [ssidList addObject:curssid];
            [[NSUserDefaults standardUserDefaults] setValue:ssidList forKey:kLocalWifiSSIDList];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        [self execScheduleTimer];
    } else if (![ssidList containsObject:curssid]) {
        if (curssid != nil && ![curssid isEqualToString:@""]) {
            [ssidList addObject:curssid];
            [[NSUserDefaults standardUserDefaults] setValue:ssidList forKey:kLocalWifiSSIDList];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        [self execScheduleTimer];
    } else {
        if (ssid == nil) {
            //未设置过局域网内主机，执行广播查找
            [self execScheduleTimer];
        } else if ([curssid isEqualToString:ssid]) {
            //用户的网络环境为局域网主机环境，判定是否需要执行广播查找
            [self execScheduleTimer];
        } else {
            //互联网查找主机
            [self findHostServerByRemote];
        }
    }
}


- (void)execScheduleTimer
{
    [self showIndicatorView];
    self.isReceived = NO;
    self.pollCount = 0;
    //UDP广播查找局域网主机
    if (self.scheduleTimer == nil) {
        self.scheduleTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
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
    //如果是首次入网记录网络SSID
    [self firstStoreSSID];
    
    [self loadRequest];
}

- (void)loadRequest
{
    NSURL *serverUrl = [NSURL URLWithString:[TheAppDelegate.serverBaseUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest *request = [NSURLRequest requestWithURL:serverUrl cachePolicy:NSURLCacheStorageAllowedInMemoryOnly timeoutInterval:10];
    [self showLoadingView];
    [self.mainWebView loadRequest:request];
}

//远程查询，不存在的话，网络不可用
- (void)findHostServerByRemote
{
    NSString *serverId = [[NSUserDefaults standardUserDefaults] valueForKey:kCurrentServerId];
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

- (void)firstStoreSSID
{
    NSString *alreadyRunKey = kFIRST;
    if (![[NSUserDefaults standardUserDefaults] boolForKey:alreadyRunKey])
    {
        NSString *ssid = [NetworkHelper fetchSSIDInfo];
        if (ssid && ![ssid isEqualToString:@""]) {
            [[NSUserDefaults standardUserDefaults] setValue:ssid forKey:kCurrentServerWifiSSID];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:alreadyRunKey];
            NSMutableArray *ssidList = [[NSMutableArray alloc] initWithCapacity:1];
            [ssidList addObject:ssid];
            [[NSUserDefaults standardUserDefaults] setValue:ssidList forKey:kLocalWifiSSIDList];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
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
        NSData *data = [msg dataUsingEncoding:NSUTF8StringEncoding];
        [self.udpSocket sendData:data toHost:kUdpBroadcastHost port:self.udpBroadcastPort withTimeout:3.0 tag:self.tag];
    } else {
        //停止 Timer
        [self.scheduleTimer invalidate];
        [self performSelector:@selector(estimateSearchByRemote) withObject:nil afterDelay:5.0];
    }
}

- (void)estimateSearchByRemote
{
    if (!self.isReceived) {
        [self hideIndicatorView];
        //udp广播未找到主机，通过远程主机获取服务器访问路径
        [self findHostServerByRemote];
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
            self.isWifiServerAds = YES;
            TheAppDelegate.serverBaseUrl = [NSString stringWithFormat:@"http://%@:%d/",host,self.localServerPort];
            [self afterFindAdress];
        }
    }
}


- (BOOL)parserJSONString:(NSString *)responseData
{
    if(responseData == nil || [responseData length] == 0)
    {
        return NO;
    }
    NSDictionary *dictionary = [responseData JSONValue];
    if (dictionary == nil) {
        return NO;
    }
    
    NSString *serverId = [dictionary valueForKey:@"serverId"];
    if (serverId == nil || [serverId isEqualToString:@""]) {
        return NO;
    }
    self.localServerPort = [[dictionary valueForKey:@"port"] intValue];
    [[NSUserDefaults standardUserDefaults] setValue:serverId forKey:kCurrentServerId];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    return YES;
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self hideLoadingView];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self hideLoadingView];
    NSString *failMsg = [NSString stringWithFormat:@"无法打开主机地址：%@",TheAppDelegate.serverBaseUrl];
    [self showAlertMessage:failMsg];
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

#pragma mark - UDP loading view

- (void)showIndicatorView
{
    if (self.udpIndicatorViewController == nil)
    {
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
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

#pragma mark - webview loading

- (void)showLoadingView
{
    if (self.customIndicator == nil)
    {
        self.customIndicator = [[HZActivityIndicatorView alloc] initWithFrame:CGRectMake(100, 150, 0, 0)];
        self.customIndicator.backgroundColor = self.view.backgroundColor;
        self.customIndicator.opaque = YES;
        self.customIndicator.steps = 16;
        self.customIndicator.finSize = CGSizeMake(8, 40);
        self.customIndicator.indicatorRadius = 20;
        self.customIndicator.stepDuration = 0.100;
        self.customIndicator.color = [UIColor colorWithRed:0.0 green:34.0/255.0 blue:85.0/255.0 alpha:1.000];
        self.customIndicator.roundedCoreners = UIRectCornerTopRight;
        self.customIndicator.cornerRadii = CGSizeMake(10, 10);
        [self.customIndicator startAnimating];
        
        [self.mainWebView bringSubviewToFront:self.customIndicator];
        [self.mainWebView addSubview:self.customIndicator];
    }
}

- (void)hideLoadingView
{
    [self.customIndicator removeFromSuperview];
    self.customIndicator = nil;
}

#pragma mark JsonParserDelegate

- (void)parser:(JsonParser*)parser DidFailedParseWithMsg:(NSString*)msg errCode:(NSInteger)code
{
    [self showAlertMessage:@"您的网络已经断开！"];
    [self hideIndicatorView];
}

- (void)parser:(JsonParser*)parser DidParsedData:(NSDictionary *)data
{
    [self hideIndicatorView];
    NSString *str_url = [data valueForKey:@"url"];
    //通过访问远程云主机，获取服务器访问路径
    self.isWifiServerAds = NO;
    TheAppDelegate.serverBaseUrl = str_url;
    [self loadRequest];
}

@end
