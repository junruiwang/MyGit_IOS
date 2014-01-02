//
//  TcpSocketHelper.h
//  IntelligentHome
//
//  Created by jerry on 14-1-2.
//  Copyright (c) 2014年 jerry.wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDAsyncSocket.h"

@interface TcpSocketHelper : NSObject

@property(nonatomic,strong) GCDAsyncSocket *asyncSocket;

- (void)setupTcpConnection:(NSString *)host;
- (BOOL)isConnected;

@end
