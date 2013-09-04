//
//  CpaManager.m
//  JinJiangTravelPlus
//
//  Created by 胡 桂祁 on 4/1/13.
//  Copyright (c) 2013 JinJiang. All rights reserved.
//

#import "CpaManager.h"
#import "FileManager.h"
#import "IPAddress.h"
#import "MacAddress.h"

@implementation CpaManager

-(id)init
{
    self = [super init];
    self.cpaManagerParser = [[CpaManagerParser alloc] init];
    return self;
}

- (void) saveMacAddress:(NSString *)deviceToken
{
    self.cpaManagerParser.delegate = self;
    
    if ([self isCache]) {
        return;
    }
    
    [self sendRequest:deviceToken];
    
    [self writeToFile];
}

- (BOOL)isCache
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *path = [FileManager filePath:@"cpa.plist"];
    
    if ([fileManager fileExistsAtPath:path]) {
        return true;
    }
    return false;
}

- (void)writeToFile
{
    NSLog(@"mac address IS %@", [MacAddress currentAddress]);
    NSString *path = [FileManager filePath:@"cpa.plist"];
    NSData *myData = [NSKeyedArchiver archivedDataWithRootObject:[MacAddress currentAddress]];
    BOOL result = [myData writeToFile:path atomically:YES];
    if (!result) {
        NSLog(@"macAddress 写入文件失败！");
    }
}

- (void) sendRequest:(NSString *)deviceToken
{
    [self.cpaManagerParser saveActiveMacAddress:[MacAddress currentAddress] deviceToken: (NSString *)deviceToken];
}


#pragma mark - GDataXMLParserDelegate
- (void)parser:(GDataXMLParser*)parser DidParsedData:(NSDictionary *)data
{
    NSString *message = [data valueForKey:@"message"];
    NSLog(@"====cpaMessage:%@",message);
}

- (void)parser:(GDataXMLParser*)parser DidFailedParseWithMsg:(NSString*)msg errCode:(NSInteger)code
{
    NSLog(@"error msg is %@ error code is %d", msg, code);
}
@end
