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
#import "TcpSocketHelper.h"
#import "CodeUtil.h"
#import "MyServerIdManager.h"

@interface IndexViewController () <TcpSocketHelperDelegate>

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
//webView遮罩层效果
@property(nonatomic, strong) HZActivityIndicatorView *customIndicator;
//tcp通道
@property(nonatomic, strong) TcpSocketHelper *tcpSocketHelper;

@property (nonatomic, strong) BaseServerParser *baseServerParser;

@property(nonatomic, strong) MyServerIdManager *myServerIdManager;


- (void)workingForFindServerUrl;
- (void)loadRequest;
- (void)sendUDPMessage;
- (void)killUdpSocketImmediately;
- (void)didAppBecomeActive;
- (BOOL)isRightJsonData:(NSString *)responseData;
- (void)webViewFinishLoadProcess;

@end

@implementation IndexViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.udpBroadcastPort = kUdpBroadcastPort;
        self.isReceived = NO;
        //初始化TCP通信通道
        self.tcpSocketHelper = [[TcpSocketHelper alloc] init];
        self.tcpSocketHelper.delegate = self;
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
    
    self.mainWebView.scrollView.bounces = NO;
    self.mainWebView.scalesPageToFit = NO;
    self.mainWebView.delegate = self;
    //设置调用时间
    self.invokeTime = [NSDate date];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0) {
        self.mainWebView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-20);
    }
    
    [self workingForFindServerUrl];
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

- (void)loadRequest
{
    NSURL *serverUrl = [NSURL URLWithString:[TheAppDelegate.serverBaseUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest *request = [NSURLRequest requestWithURL:serverUrl cachePolicy:NSURLCacheStorageAllowedInMemoryOnly timeoutInterval:10];
    [self showLoadingView];
    [self.mainWebView loadRequest:request];
}

- (void)killUdpSocketImmediately
{
    if (self.udpSocket != nil)
	{
        [self.udpSocket close];
        self.udpSocket = nil;
	}
    //关闭TCP连接通道
    [self.tcpSocketHelper stopTcpSocket];
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
            TheAppDelegate.serverBaseUrl = [NSString stringWithFormat:@"http://%@:%d/",host,self.localServerPort];
            [self loadRequest];
            //建立TCP通信通道
            [self.tcpSocketHelper setupTcpConnection:host];
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

- (void)webViewFinishLoadProcess
{
    NSString *appInfo = [NSString stringWithFormat:@"{\"appInfo\":\"iOS\",\"version\":\"%@\"}",kClientVersion];
    NSString *jsCommand = [NSString stringWithFormat:@"if (typeof %@ != 'undefined' && %@ instanceof Function) {%@(%@);}", kHtmlFinishLoadFunction, kHtmlFinishLoadFunction, kHtmlFinishLoadFunction, appInfo];
    [self.mainWebView stringByEvaluatingJavaScriptFromString:jsCommand];
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *locationUrl = [[request URL] absoluteString];
    //获取serverId列表
    if ([locationUrl hasPrefix:kServerIdList]) {
        NSRange range = [locationUrl rangeOfString:kSeparateFlag];
        NSString *callFunction = [locationUrl substringFromIndex:(range.location+range.length)];
        NSString *jsCommand = [NSString stringWithFormat:@"if (typeof %@ != 'undefined' && %@ instanceof Function) {%@(%@);}", callFunction, callFunction, callFunction, [self.myServerIdManager getServerListByJson]];
        [self.mainWebView stringByEvaluatingJavaScriptFromString:jsCommand];
        return NO;
    } else if ([locationUrl hasPrefix:kChangeServer]) {
        NSRange range = [locationUrl rangeOfString:kSeparateFlag];
        NSString *targetServerId = [locationUrl substringFromIndex:(range.location+range.length)];
        //切换Server，切换之后一律通过云主机交互
        if (targetServerId != nil && ![targetServerId isEqualToString:[self.myServerIdManager getCurrentServerId]]) {
            //本地serverId列表排序更新
            [self.myServerIdManager addServerIdToFile:targetServerId];
            //关闭TCP连接通道
            [self.tcpSocketHelper stopTcpSocket];
            //重新打开服务器连接，建立socket通道
            NSString *str_url = [NSString stringWithFormat:@"%@/index.html?serverId=%@",kBaseURL,targetServerId];
            NSString *hostIp = kHostAddress;
            //通过访问远程云主机，获取服务器访问路径
            TheAppDelegate.serverBaseUrl = str_url;
            [self loadRequest];
            //建立TCP通信通道
            [self.tcpSocketHelper setupTcpConnection:hostIp];
        }
        return NO;
    }
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self hideLoadingView];
    [self webViewFinishLoadProcess];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self hideLoadingView];
    NSString *failMsg = [NSString stringWithFormat:@"Unable to open the host address : %@",TheAppDelegate.serverBaseUrl];
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
    [self showAlertMessage:@"Your network has been disconnected!"];
    [self hideIndicatorView];
}

- (void)parser:(JsonParser*)parser DidParsedData:(NSDictionary *)data
{
    [self hideIndicatorView];
    NSString *str_url = [data valueForKey:@"url"];
    NSString *hostIp = [data valueForKey:@"host"];
    //通过访问远程云主机，获取服务器访问路径
    TheAppDelegate.serverBaseUrl = str_url;
    [self loadRequest];
    //建立TCP通信通道
    [self.tcpSocketHelper setupTcpConnection:hostIp];
}

#pragma mark TcpSocketHelperDelegate

- (void)renewPage:(TcpSocketHelper*)socketHelper responseData:(NSData *)data
{
    NSString *httpResponse = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSString *notifyMsg = [CodeUtil stringFromHexString:httpResponse];
    if (kLogEnable) {
        NSLog(@"HTTP Response:\n%@", notifyMsg);
    }
    if (![[notifyMsg uppercaseString] isEqualToString:kUpperOk]) {
        //执行JS调用
        NSString *jsCommand = [NSString stringWithFormat:@"if (typeof %@ != 'undefined' && %@ instanceof Function) {%@(%@);}", kTcpNotifyFunction, kTcpNotifyFunction, kTcpNotifyFunction, notifyMsg];
        [self.mainWebView stringByEvaluatingJavaScriptFromString:jsCommand];
    }
}

@end
