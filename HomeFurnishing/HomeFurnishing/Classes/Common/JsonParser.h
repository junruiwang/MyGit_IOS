//
//  GDataParser.h
//  JinJiang
//
//  Created by Leon on 10/22/12.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SBJson.h"

typedef enum : NSInteger {
    ReturnValueTypeString = 0,
    ReturnValueTypeArray,
    ReturnValueTypeDictionary
} ReturnValueType;

@class JsonParser;

#pragma mark - JsonParserDelegate

@protocol JsonParserDelegate <NSObject>

@optional

- (void)parser:(JsonParser*)parser DidFailedParseWithMsg:(NSString*)msg errCode:(NSInteger)code;
- (void)parser:(JsonParser*)parser DidParsedData:(NSDictionary *)data;

@end

#pragma mark - JsonParser

@interface JsonParser : NSObject
{
    NSURLConnection*    _connection;
    NSMutableData*      _requestData;
    BOOL _reachAbility;
}

@property (nonatomic) BOOL isHTTPGet;
@property (nonatomic, weak) id<JsonParserDelegate> delegate;
@property (nonatomic, copy) NSString* serverAddress;
@property (nonatomic, copy) NSString* requestString;
@property (nonatomic) ReturnValueType valType;

- (void)start;
- (void)cancel;
- (BOOL)parserJSONString:(NSString *)responseData;

@end