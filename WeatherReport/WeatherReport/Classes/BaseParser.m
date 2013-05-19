//
//  BaseParser.m
//  ChoiceCourse
//
//  Created by 汪君瑞 on 12-11-14.
//
//

#import "BaseParser.h"
#import "SBJson.h"


@implementation BaseParser

-(id) init
{
    if (self =[super init]) {
        
    }
    return self;
}

- (void)start
{
    self.httpRequest= [ASIHTTPRequest requestWithURL:[NSURL URLWithString:self.serverAddress]];
//    [self.httpRequest setPostBody:[NSMutableData dataWithData:[self.requestString dataUsingEncoding:NSUTF8StringEncoding]]];
//    [self.httpRequest setTimeOutSeconds:10];
//    [self.httpRequest setRequestMethod:@"POST"];
    [self.httpRequest setDefaultResponseEncoding:NSUTF8StringEncoding];
    [self.httpRequest setDelegate:self];
    [self.httpRequest startAsynchronous];
}

- (void)startSynchronous:(id) object
{
    self.httpRequest= [ASIHTTPRequest requestWithURL:[NSURL URLWithString:self.serverAddress]];
    [self.httpRequest setDefaultResponseEncoding:NSUTF8StringEncoding];
    [self.httpRequest startSynchronous];
    NSError *error = [self.httpRequest error];
    
    if (error) {
        if(self.delegate != nil && [self.delegate respondsToSelector:@selector(parser:DidFailedParseWithMsg:errCode:)])
            [self.delegate parser:self DidFailedParseWithMsg:@"connection error" errCode:-1];
    }else{
        NSData *responseData = [self.httpRequest responseData];
        NSString* jsonString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        [self parserJSONString:jsonString withObject:object];
    }
}

- (void)cancel
{
    [self.httpRequest cancel];
    [self.httpRequest clearDelegatesAndCancel];
}

- (BOOL)parserJSONString:(NSString *)responseData
{
    if(responseData == nil || [responseData length] == 0)
    {
        if(self.delegate != nil && [self.delegate respondsToSelector:@selector(parser:DidFailedParseWithMsg:errCode:)])
            [self.delegate parser:self DidFailedParseWithMsg:@"response data is nil or empty" errCode:-1];
        return NO;
    }
    NSDictionary *dictionary = [responseData JSONValue];
    if (dictionary == nil) {
        if(self.delegate != nil && [self.delegate respondsToSelector:@selector(parser:DidFailedParseWithMsg:errCode:)])
            [self.delegate parser:self DidFailedParseWithMsg:@"response data is not NSDictionary" errCode:-1];
        return NO;
    }
    
    return YES;
}

- (BOOL)parserJSONString:(NSString *)responseData withObject:(id) object
{
    if(responseData == nil || [responseData length] == 0)
    {
        if(self.delegate != nil && [self.delegate respondsToSelector:@selector(parser:DidFailedParseWithMsg:errCode:)])
            [self.delegate parser:self DidFailedParseWithMsg:@"response data is nil or empty" errCode:-1];
        return NO;
    }
    NSDictionary *dictionary = [responseData JSONValue];
    if (dictionary == nil) {
        if(self.delegate != nil && [self.delegate respondsToSelector:@selector(parser:DidFailedParseWithMsg:errCode:)])
            [self.delegate parser:self DidFailedParseWithMsg:@"response data is not NSDictionary" errCode:-1];
        return NO;
    }
    
    return YES;
}

#pragma mark ASIHTTPRequestDelegate

- (void)requestFinished:(ASIHTTPRequest *)request
{
    // Use when fetching text data
    //NSString *responseString = [request responseString];
    
    // Use when fetching binary data
    NSData *responseData = [request responseData];
    NSString* jsonString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    [self parserJSONString:jsonString];
    [self cancel];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    if(self.delegate != nil && [self.delegate respondsToSelector:@selector(parser:DidFailedParseWithMsg:errCode:)])
        [self.delegate parser:self DidFailedParseWithMsg:@"connection error" errCode:-1];
    [self cancel];
}

@end
