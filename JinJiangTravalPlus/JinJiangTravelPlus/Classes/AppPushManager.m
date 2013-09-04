//
//  AppPushManager.m
//  JinJiang
//
//  Created by jerry on 12-7-18.
//
//

#import "AppPushManager.h"
#import "FileManager.h"
#import "ParameterManager.h"
#import "IndexViewController.h"
#import "PromotionListController.h"
#import "WebViewController.h"
#import "MacAddress.h"
#import "CpaManager.h"

@interface AppPushManager ()

@property (nonatomic, copy) NSString *deviceToken;
@property (nonatomic, strong) ApnsDeviceTokenParser *apnsDeviceTokenParser;

- (NSUInteger) switchSettings;
- (void)loadLocalToken;
- (void)writeTokenToFile;
- (void)executionProvider;

@end

@implementation AppPushManager

- (id) init
{
    if (self = [super init]) {  }

    return self;
}

- (void) registerForRemoteNotification
{
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:[self switchSettings]];
}

- (void) saveRemoteDeviceToken: (NSString *) remoteDeviceToken
{
    if (remoteDeviceToken == nil || [remoteDeviceToken isEqualToString:@""])
    {
        NSLog(@"Get remote device token was error for this application");
        return;
    }
    [self loadLocalToken];
    remoteDeviceToken = [remoteDeviceToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    remoteDeviceToken = [remoteDeviceToken substringFromIndex:1];
    remoteDeviceToken = [remoteDeviceToken substringToIndex:remoteDeviceToken.length-1];

    if ([remoteDeviceToken caseInsensitiveCompare:self.deviceToken] == NSOrderedSame)
    {   return; }
    self.deviceToken = remoteDeviceToken;
    //deviceToken 写入本地文件
    [self writeTokenToFile];
    //请求服务端，保存当前的deviceToken值
    [self executionProvider];
    //保存cpa mac地址与deviceToken到文件
    CpaManager *cpaManager = [[CpaManager alloc] init];
    [cpaManager saveMacAddress:remoteDeviceToken];

}

- (void) saveRemoteDeviceTokenAfterLogin
{
    if (self.deviceToken != nil && ![self.deviceToken isEqualToString:@""]) {
        //请求服务端，保存当前的deviceToken值
        [self executionProvider];
    }
}

- (NSUInteger) switchSettings
{
	NSUInteger which = 0;
	which = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert;

    return which;
}

- (void)loadLocalToken
{
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSString* path = [FileManager filePath:@"deviceToken.plist"];
    
    if ([fileManager fileExistsAtPath:path])
    {   self.deviceToken = [NSKeyedUnarchiver unarchiveObjectWithData:[NSData dataWithContentsOfFile:path]];    }
    NSLog(@"LocalDeviceToken: %@",self.deviceToken);
}

- (void)writeTokenToFile
{
    NSString* path = [FileManager filePath:@"deviceToken.plist"];
    NSData* myData = [NSKeyedArchiver archivedDataWithRootObject:self.deviceToken];

    BOOL result = [myData writeToFile:path atomically:YES];
    if (!result) {  NSLog(@"DeviceToken 写入文件失败！");  }
}

- (void)executionProvider
{
    if (!self.apnsDeviceTokenParser)
    {
        self.apnsDeviceTokenParser = [[ApnsDeviceTokenParser alloc] init];
        self.apnsDeviceTokenParser.serverAddress = kApnsDeviceTokenURL;
    }
    ParameterManager *parameterManager = [[ParameterManager alloc] init];
    [parameterManager parserStringWithKey:@"deviceToken" WithValue:self.deviceToken];
    [parameterManager parserStringWithKey:@"macAddress" WithValue:[MacAddress currentAddress]];
    //渠道
    [parameterManager parserStringWithKey:@"productChannel" WithValue:PRODUCT_CHANNEL];
    NSString *loginCardType = TheAppDelegate.userInfo.cardType;
    if (TheAppDelegate.userInfo.cardType == nil || [TheAppDelegate.userInfo.cardType isEqualToString:@""]) {
        loginCardType = @"";
    }
    //会员级别
    [parameterManager parserStringWithKey:@"cardType" WithValue:loginCardType];
    //设备类型
    [parameterManager parserStringWithKey:@"deviceType" WithValue:[[UIDevice currentDevice] model]];
    
    [self.apnsDeviceTokenParser setRequestString:[parameterManager serialization]];
    [self.apnsDeviceTokenParser setDelegate:self];
    [self.apnsDeviceTokenParser start];
}

- (void) processRemoteNotification:(NSDictionary *)notification
{
    NSString *msgType = (NSString *)[notification valueForKeyPath:@"msgType"];
    if ([msgType isEqualToString:@"PROMOTION"])
    {   [[NSNotificationCenter defaultCenter] postNotificationName:@"PromotionsPushFinished" object:nil];   }
    else if ([msgType isEqualToString:@"URL"])
    {   [[NSNotificationCenter defaultCenter] postNotificationName:@"WebUrlPushFinished" object:notification];  }
    else if ([msgType isEqualToString:@"PRODUCT"])
    {   /* TODO: add process for product message */ }
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

#pragma mark - GDataXMLParserDelegate

- (void)parser:(GDataXMLParser *)parser DidParsedData:(NSDictionary *)data
{
    NSLog(@"Save device token success");
}

- (void)parser:(GDataXMLParser *)parser DidFailedParseWithMsg:(NSString *)msg errCode:(NSInteger)code
{
    if(code == -1 || code == 10000)
    {   NSLog(@"网路异常，保存用户Token失败");  }
    else
    {   NSLog(@"Save token fail %@", msg);  }
}

@end
