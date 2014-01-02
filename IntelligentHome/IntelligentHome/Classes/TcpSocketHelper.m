//
//  TcpSocketHelper.m
//  IntelligentHome
//
//  Created by jerry on 14-1-2.
//  Copyright (c) 2014年 jerry.wang. All rights reserved.
//

#import "TcpSocketHelper.h"
#import "Constants.h"

@interface TcpSocketHelper ()

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
    if (self.asyncSocket == nil) {
        dispatch_queue_t mainQueue = dispatch_get_main_queue();
        self.asyncSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:mainQueue];
    }
    UInt16 tcpPort = kTcpSocketPort;
    NSLog(@"Connecting to %@ on port %hu...", host, tcpPort);
    
    NSError *error = nil;
    if (![self.asyncSocket connectToHost:host onPort:tcpPort error:&error])
    {
        NSLog(@"Error connecting: %@", error);
    }
    
}

- (void)isConnected
{
    
}

- (void)listenData
{
    [self.asyncSocket readDataToData:[GCDAsyncSocket CRLFData] withTimeout:-1 tag:0];
}

@end
