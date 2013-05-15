//
//  BaseParser.h
//  ChoiceCourse
//
//  Created by 汪君瑞 on 12-11-14.
//
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"

@class BaseParser;
@protocol BaseParserDelegate <NSObject>

@optional
- (void)parser:(BaseParser*)parser DidFailedParseWithMsg:(NSString*)msg errCode:(NSInteger)code;
- (void)parser:(BaseParser*)parser DidParsedData:(NSDictionary *)data;
@end

@interface BaseParser : NSObject

@property (nonatomic, copy) NSString *requestString;
@property (nonatomic, copy) NSString *serverAddress;
@property (nonatomic, weak) id<BaseParserDelegate> delegate;
@property (nonatomic, strong) ASIHTTPRequest *httpRequest;

- (void)start;
- (void)cancel;
- (BOOL)parserJSONString:(NSString *)responseData;

@end
