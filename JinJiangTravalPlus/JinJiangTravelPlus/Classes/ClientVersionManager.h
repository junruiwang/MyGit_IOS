//
//  ClientVersionManager.h
//  JinJiangTravelPlus
//
//  Created by jerry on 12-12-14.
//  Copyright (c) 2012年 JinJiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ClientVersion.h"
#import "GDataXMLParser.h"
#import "ClientVersionParser.h"

@interface ClientVersionManager : NSObject<GDataXMLParserDelegate>

@property(nonatomic, strong) ClientVersion *clientVersion;
@property(nonatomic, strong) ClientVersionParser *clientVersionParser;

- (void)downloadData;

@end
