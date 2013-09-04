//
//  VersionHandle.m
//  jinjiang
//
//  Created by xicheng wang on 12-4-24.
//  Copyright (c) 2012年 W+K. All rights reserved.
//

#import "VersionHandle.h"
#import "Version.h"

NSString *CLIENT_VERSION = @"1.10";
NSString *updateUrl = @"http://itunes.apple.com/cn/app/id492178323?";
NSString *updateVersionUrl= @"http://gateway.jinjiang.com/gateway/getIpadClientVersion?userId=test&sign=EE4AB5BBAC5852FA2057CB476CF1C679";


@interface VersionHandle() <HTTPConnectionDelegate, UIAlertViewDelegate>

@property (nonatomic, retain) Version *version;

@property (nonatomic, retain) HTTPConnection *connection;

- (void) send;

@end

@implementation VersionHandle

@synthesize version;

@synthesize connection;

- (id) init
{
    if (self = [super init]) {
        connection = [[HTTPConnection alloc] init];
        connection.delegate = self;
        version = [[Version alloc] init];
    }
    return self;
}

- (void) load 
{
    [self send];
}

- (void) send
{
    [connection sendRequest:updateVersionUrl postData:nil type:nil];
}

- (Version *) prepareVersion : (NSDictionary *)dic
{
    version.version = [dic valueForKey:@"version"];
    NSLog(@"version is %@", version.version);
    version.releaseNotes = [dic valueForKey:@"releaseNotes"];
    return version;
}

- (BOOL) checkDidNeedUpdate : (Version*) version
{
    NSNumber *currentVersionInteger = [[version.version stringByReplacingOccurrencesOfString:@"." withString:@""] intValue];
    NSNumber *localVersionInteger = [[CLIENT_VERSION stringByReplacingOccurrencesOfString:@"." withString:@""] intValue];
    if (currentVersionInteger > localVersionInteger) {
        return true;
    }
    return false;
}

- (NSMutableString *) createAndPrepareNote: (Version *) version
{
    NSMutableString *note = [[[NSMutableString alloc] init] autorelease];
    [note appendString:version.version];
    [note appendString:@"\n"];
    [note appendString:version.releaseNotes];
    return note;
}

- (void) showMessage : (NSString *)note
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"发现新版本" message:note delegate:self cancelButtonTitle:@"以后提醒" otherButtonTitles:@"现在更新", nil];
    [alert show];
    [alert release];
}

- (void) delloc
{
    [version release];
    [connection release];
}

#pragma mark -
#pragma mark <HTTPConnectionDelegate> Implementation
- (void)postHTTPDidFinish:(NSMutableData *)_data hc:(HTTPConnection *) _hc
{
    NSAutoreleasePool *autoPool = [[NSAutoreleasePool alloc] init];
    NSString *responseDataString = [[NSString alloc] initWithData:_data encoding:NSUTF8StringEncoding];
    version = [self prepareVersion : [responseDataString JSONValue]];
    if ([self checkDidNeedUpdate:version]) {
        [self showMessage:[self createAndPrepareNote:version]];
    }
    
    [autoPool release];
    self.connection.delegate = nil;
    self.connection = nil;
}

- (void)postHTTPError:(HTTPConnection *) _hc
{
}

#pragma mark <UIAlertViewDelegate> Implementation
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:updateUrl]];
    }
}

@end

