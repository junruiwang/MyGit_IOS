//
//  TcpSocketHelper.h
//  IntelligentHome
//
//  Created by jerry on 14-1-2.
//  Copyright (c) 2014年 jerry.wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDAsyncSocket.h"

@class TcpSocketHelper;

#pragma mark - TcpSocketHelperDelegate

@protocol TcpSocketHelperDelegate <NSObject>

@optional

- (void)renewPage:(TcpSocketHelper*)socketHelper responseData:(NSData *)data;

@end

#pragma mark - TcpSocketHelper

@interface TcpSocketHelper : NSObject

@property(nonatomic,strong) GCDAsyncSocket *asyncSocket;

@property (nonatomic, weak) id<TcpSocketHelperDelegate> delegate;

- (void)setupTcpConnection:(NSString *)host;
- (BOOL)isConnected;
- (void)stopTcpSocket;

@end
