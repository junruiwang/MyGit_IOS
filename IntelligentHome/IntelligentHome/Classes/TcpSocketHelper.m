//
//  TcpSocketHelper.m
//  IntelligentHome
//
//  Created by jerry on 14-1-2.
//  Copyright (c) 2014年 jerry.wang. All rights reserved.
//

#import "TcpSocketHelper.h"
#import "Constants.h"
#import "CodeUtil.h"
#import "MyServerIdManager.h"

@interface TcpSocketHelper ()

@property (nonatomic, copy) NSString *tcpHost;
@property (nonatomic, strong) NSTimer *scheduleTimer;
@property (nonatomic, strong) NSTimer *connectTimer;

- (void)sendTcpMessage;
- (void)sendAuthSocketMessage;
- (void)retryConnect;
//心跳程序，每隔60秒轮询一次
- (void)heartbeatProgram;
//tcp断掉之后重连程序
- (void)tcpConnectProgram;
//tcp重连成功停止轮询
- (void)stopTimerTask;

//发起一个读取的请求，当收到数据时后面的didReadData才能被回调
- (void)listenData;

@end

@implementation TcpSocketHelper

- (id)init
{
    if(self = [super init])
    {
        
    }
    
    return self;
}

- (void)setupTcpConnection:(NSString *)host
{
    if (self.asyncSocket != nil)
	{
        [self.asyncSocket setDelegate:nil];
        [self.asyncSocket disconnect];
        self.asyncSocket = nil;
	}
    self.tcpHost = host;
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    self.asyncSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:mainQueue];
    UInt16 tcpPort = kTcpSocketPort;
    NSLog(@"Connecting to %@ on port %hu...", host, tcpPort);
    
    NSError *error = nil;
    if (![self.asyncSocket connectToHost:host onPort:tcpPort error:&error])
    {
        NSLog(@"Error connecting: %@", error);
    }
    
}

- (BOOL)isConnected
{
    return self.asyncSocket.isConnected;
}

//发起一个读取的请求，当收到数据时后面的didReadData才能被回调
- (void)listenData
{
    [self.asyncSocket readDataWithTimeout:-1 tag:0];
}

- (void)heartbeatProgram
{
    //心跳程序保持socket通畅，每隔60秒轮询一次
    if (self.scheduleTimer == nil) {
        self.scheduleTimer = [NSTimer scheduledTimerWithTimeInterval:60.0
                                                              target:self
                                                            selector:@selector(sendTcpMessage)
                                                            userInfo:nil
                                                             repeats:YES];
        
    }
    [self.scheduleTimer fire];
}

- (void)sendTcpMessage
{
    NSString* cmd = @"1";
    NSString *authMsg = [NSString stringWithFormat:@"%@\n",[CodeUtil hexStringFromString:cmd]];
    NSData *data = [authMsg dataUsingEncoding:NSUTF8StringEncoding];
    [self.asyncSocket writeData:data withTimeout:30.0 tag:0];
}

- (void)sendAuthSocketMessage
{
    MyServerIdManager *myServerIdManager = [[MyServerIdManager alloc] init];
    NSString *serverId = [myServerIdManager getCurrentServerId];
    NSString *cmd = [NSString stringWithFormat:@"{\"key\":\"\",\"body\":\"{\\\"serverId\\\":\\\"%@\\\"}\",\"messageType\":\"auth\"}",serverId];
    //转换为16进制字符串
    NSString *authMsg = [NSString stringWithFormat:@"%@\n",[CodeUtil hexStringFromString:cmd]];
    NSData *data = [authMsg dataUsingEncoding:NSUTF8StringEncoding];
    [self.asyncSocket writeData:data withTimeout:30.0 tag:0];
    //启动心跳轮询程序
    [self performSelector:@selector(heartbeatProgram) withObject:nil afterDelay:60.0];
}

- (void)tcpConnectProgram
{
    //tcp断掉重连轮询程序，每隔10秒轮询一次
    if (self.connectTimer == nil) {
        self.connectTimer = [NSTimer scheduledTimerWithTimeInterval:10.0
                                                              target:self
                                                            selector:@selector(retryConnect)
                                                            userInfo:nil
                                                             repeats:YES];
        
        [self.connectTimer fire];
    }
}

- (void)retryConnect
{
    [self setupTcpConnection:self.tcpHost];
}

- (void)stopTimerTask
{
    if (self.connectTimer) {
        [self.connectTimer invalidate];
        self.connectTimer = nil;
    }
}

#pragma mark - Socket Delegate

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
	NSLog(@"socket:%p didConnectToHost:%@ port:%hu", sock, host, port);
    [self stopTimerTask];
    [self sendAuthSocketMessage];
    [self listenData];
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
	NSLog(@"socket:%p didWriteDataWithTag:%ld", sock, tag);
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
	NSLog(@"socket:%p didReadData:withTag:%ld", sock, tag);
	
    if(self.delegate != nil && [self.delegate respondsToSelector:@selector(renewPage:responseData:)]){
        [self.delegate renewPage:self responseData:data];
    }
    
	[self listenData];
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
	NSLog(@"socketDidDisconnect:%p withError: %@", sock, err);
    [self tcpConnectProgram];
}

@end
