//
//  HTTPConnection.h
//  chengguo
//
//  Created by Jeff.Yan on 11-5-14.
//  Copyright 2011年 W+K. All rights reserved.
//

#import <Foundation/Foundation.h>




@protocol HTTPConnectionDelegate;

@interface HTTPConnection : NSObject {
    id <HTTPConnectionDelegate> delegate;
    NSMutableData * _receivedData;          //received data
    NSString *requestType;               //request type
    BOOL _isHTTPResponseOK;                 //flag of http response
    NSURLConnection *_connection;
}
@property (nonatomic, retain) id <HTTPConnectionDelegate> delegate;
/*!
 *  send a request type A
 */
@property  (nonatomic, retain)NSString *requestType; 
- (void)sendRequest:(NSString *)url postData:(NSMutableDictionary *)_postData type:(NSString *)_type;

- (void)loadImage:(NSString *)url type:(NSString *)_type;
-(void)uploadImage:(NSString *)url imageData:(NSData *)imageData;
- (void)postExtracted;
- (void)postHTTPError;

- (void)cancelDownload;


@end

@protocol HTTPConnectionDelegate 

- (void)postHTTPDidFinish:(NSMutableData *)_data hc:(HTTPConnection *) _hc;

- (void)postHTTPError:(HTTPConnection *) _hc;


@end