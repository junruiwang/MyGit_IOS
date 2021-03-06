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
        //TODO
    }
    return self;
}

-(void) dealloc
{
    [self.requestString release];
    [self.serverAddress release];
    [self.httpRequest clearDelegatesAndCancel];
    [self.httpRequest release];
    self.delegate = nil;
    [super dealloc];
}

- (void)start
{
    self.httpRequest= [ASIHTTPRequest requestWithURL:[NSURL URLWithString:self.serverAddress]];
    [self.httpRequest setPostBody:[NSMutableData dataWithData:[self.requestString dataUsingEncoding:NSUTF8StringEncoding]]];
    [self.httpRequest setTimeOutSeconds:5];
    [self.httpRequest setRequestMethod:@"POST"];
    [self.httpRequest setDelegate:self];
    [self.httpRequest startAsynchronous];
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
    NSString *code = [dictionary valueForKey:@"code"];
    NSString *errorMessage = [dictionary valueForKey:@"errorMessage"];
    if(![code isEqualToString:@"200"]){
        if(self.delegate != nil && [self.delegate respondsToSelector:@selector(parser:DidFailedParseWithMsg:errCode:)])
            [self.delegate parser:self DidFailedParseWithMsg:errorMessage errCode:[code intValue]];
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
    NSString* jsonString = [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease];
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
