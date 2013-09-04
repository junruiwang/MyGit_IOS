//
//  ClientVersionManager.m
//  JinJiangTravelPlus
//
//  Created by jerry on 12-12-14.
//  Copyright (c) 2012年 JinJiang. All rights reserved.
//

#import "ClientVersionManager.h"

@interface ClientVersionManager ()

- (void)writeToClient;

@end

@implementation ClientVersionManager

- (void) downloadData
{
    if (!self.clientVersionParser)
    {
        self.clientVersionParser = [[ClientVersionParser alloc] init];
        self.clientVersionParser.serverAddress = kClientVersionURL;
    }
    self.clientVersionParser.delegate = self;
    [self.clientVersionParser start];
}

- (void)writeToClient
{
    TheAppDelegate.clientVersion = self.clientVersion;
}

#pragma mark - GDataXMLParserDelegate

- (void)parser:(GDataXMLParser *)parser DidFailedParseWithMsg:(NSString *)msg errCode:(NSInteger)code
{
    if(code == -1 || code == 10000)
    {
        NSLog(@"%@",kNetworkProblemAlertMessage);
    }
    else
    {
        NSLog(@"%@",msg);
    }
}

- (void)parser:(GDataXMLParser *)parser DidParsedData:(NSDictionary *)data
{
    self.clientVersion = data[@"clientVersion"];
    [self writeToClient];
}

@end
