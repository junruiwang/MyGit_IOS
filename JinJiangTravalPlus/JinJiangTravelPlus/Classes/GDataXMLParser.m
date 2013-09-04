//
//  GDataXMLParser.m
//  JinJiang
//
//  Created by Leon on 10/22/12.
//
//

#import "GDataXMLParser.h"
#import "GDataXMLNode.h"
#import "NSDataAES.h"

@interface GDataXMLParser ()

@end

@implementation GDataXMLParser

@synthesize requestString = _requestString;
@synthesize isHTTPGet = _isHTTPGet;
@synthesize delegate = _delegate;
@synthesize serverAddress = _serverAddress;

-(id)init
{
    if(self = [super init])
    {
        _requestData = [[NSMutableData alloc] init];
        self.isHTTPGet = NO;
    }
    return self;
}

-(void)dealloc
{
    self.delegate = nil;

    [self cancel];
    _requestData = nil;
}

- (void)start
{
    
    {
        [self cancel];
        [_requestData resetBytesInRange:NSMakeRange(0, [_requestData length])];
        [_requestData setLength:0];
        
        NSString* uid = TheAppDelegate.userInfo.uid;
        NSString* httpBodyString = @"";
        if (_requestString !=nil && ![_requestString isEqualToString:@""])
        {   httpBodyString = [NSString stringWithFormat:@"%@&clientVersion=%@&userId=%@", _requestString, kClientVersion, uid]; }
        else
        {   httpBodyString = [NSString stringWithFormat:@"clientVersion=%@&userId=%@", kClientVersion, uid];    }
        httpBodyString = [httpBodyString stringByAppendingFormat:@"&sign=%@", [[uid stringByAppendingFormat:kSecurityKey] MD5String]];
        
        if(_isHTTPGet == YES)
        {
            NSString* url = [NSString stringWithFormat:@"%@?%@", _serverAddress, httpBodyString];
            NSLog(@"%s get:%@", __FUNCTION__, url);
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]
                                                     cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval: 10];
            _connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        }
        else
        {
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            NSLog(@"%s full url:[%@?%@]", __FUNCTION__, _serverAddress, httpBodyString);
            [request setTimeoutInterval:60]; // default is 60s
            [request setURL:[NSURL URLWithString:_serverAddress]];
            [request setHTTPMethod:@"POST"];
            [request setHTTPBody:[httpBodyString dataUsingEncoding:NSUTF8StringEncoding]];
            [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
            _connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        }
            
        [_connection start];
    }
}

- (void)startSynchronous
{
    {
        [self cancel];
        [_requestData resetBytesInRange:NSMakeRange(0, [_requestData length])];
        [_requestData setLength:0];

        NSString* uid = TheAppDelegate.userInfo.uid;
        NSString* httpBodyString = @"";
        if (self.requestString !=nil && ![self.requestString isEqualToString:@""])
        {   httpBodyString = [NSString stringWithFormat:@"%@&clientVersion=%@&userId=%@", self.requestString, kClientVersion, uid]; }
        else
        {   httpBodyString = [NSString stringWithFormat:@"clientVersion=%@&userId=%@", kClientVersion, uid];    }
        httpBodyString = [httpBodyString stringByAppendingFormat:@"&sign=%@", [[uid stringByAppendingFormat:kSecurityKey] MD5String]];

        if(self.isHTTPGet == YES)
        {
            NSString* url = [NSString stringWithFormat:@"%@?%@", self.serverAddress, httpBodyString];
            NSLog(@"%s get:%@", __FUNCTION__, url);
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]
                                                     cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval: 10];

            NSURLResponse *response = nil;
            NSError *error = nil;

            _requestData = [[NSMutableData alloc] initWithData:[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error]];

            NSString* xmlString = [[NSString alloc] initWithData:_requestData encoding:NSUTF8StringEncoding];
            [self parseXmlString:xmlString];
            [self cancel];

        }
        else
        {
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            NSLog(@"%s full url:[%@?%@]", __FUNCTION__, self.serverAddress, httpBodyString);
            [request setTimeoutInterval:30]; // default is 60s
            [request setURL:[NSURL URLWithString:self.serverAddress]];
            [request setHTTPMethod:@"POST"];
            [request setHTTPBody:[httpBodyString dataUsingEncoding:NSUTF8StringEncoding]];
            [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];

            NSURLResponse *response = nil;
            NSError *error = nil;

            _requestData = [[NSMutableData alloc] initWithData:[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error]];

            NSString* xmlString = [[NSString alloc] initWithData:_requestData encoding:NSUTF8StringEncoding];
            [self parseXmlString:xmlString];
            [self cancel];
        }
    }
}

- (void)cancel
{
    [_connection cancel];
    _connection = nil;
}

- (BOOL)parseXmlString:(NSString*)xmlString
{
    if(xmlString == nil || [xmlString length] == 0)
    {
        if(self.delegate != nil && [self.delegate respondsToSelector:@selector(parser:DidFailedParseWithMsg:errCode:)])
        {   [self.delegate parser:self DidFailedParseWithMsg:@"xmlString is nil or empty" errCode:-1];  }
        return NO;
    }
    
    NSError* error;
    GDataXMLDocument* document = [[GDataXMLDocument alloc] initWithXMLString:xmlString options:0 error:&error];
    if(document == nil)
    {
        if(self.delegate != nil && [self.delegate respondsToSelector:@selector(parser:DidFailedParseWithMsg:errCode:)])
        {
            NSString* format = @"server return: %@\nsystem error msg: %@";
            NSString* message = [NSString stringWithFormat:format, xmlString, [error localizedDescription]];
            [self.delegate parser:self DidFailedParseWithMsg:message errCode:-1];
        }
        return NO;
    }

    GDataXMLElement* rootElement = [document rootElement];
    NSString* retCode = [[rootElement attributeForName:@"code"] stringValue];

    if(![retCode isEqualToString:@"0"])
    {
        if(self.delegate != nil && [self.delegate respondsToSelector:@selector(parser:DidFailedParseWithMsg:errCode:)])
        {
            NSString* message = [[[rootElement elementsForName:@"message"] objectAtIndex:0] stringValue];
            [self.delegate parser:self DidFailedParseWithMsg:message errCode:[retCode intValue]];
        }
        return NO;
    }

    return YES;
}

#pragma mark NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if(self.delegate != nil && [self.delegate respondsToSelector:@selector(parser:DidFailedParseWithMsg:errCode:)])
    {   [self.delegate parser:self DidFailedParseWithMsg:@"connection error" errCode:-1];   }
    [self cancel];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
{
    [_requestData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString* xmlString = [[NSString alloc] initWithData:_requestData encoding:NSUTF8StringEncoding];
    [self parseXmlString:xmlString];
    [self cancel];
}

@end