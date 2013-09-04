//
//  GDataXMLParser.h
//  JinJiang
//
//  Created by Leon on 10/22/12.
//
//

#import <Foundation/Foundation.h>

@class GDataXMLParser;

#pragma mark - GDataXMLParserDelegate

@protocol GDataXMLParserDelegate <NSObject>

@optional

- (void)parser:(GDataXMLParser*)parser DidFailedParseWithMsg:(NSString*)msg errCode:(NSInteger)code;
- (void)parser:(GDataXMLParser*)parser DidParsedData:(NSDictionary *)data;

@end

#pragma mark - GDataXMLParser

@interface GDataXMLParser : NSObject
{
    NSURLConnection*    _connection;
    NSMutableData*      _requestData;
    BOOL _reachAbility;
}

@property (nonatomic) BOOL isHTTPGet;
@property (nonatomic, weak) id<GDataXMLParserDelegate> delegate;
@property (nonatomic, copy) NSString* serverAddress;
@property (nonatomic, copy) NSString* requestString;

- (void)start;
- (void)startSynchronous;
- (void)cancel;
- (BOOL)parseXmlString:(NSString*)xmlString;

@end