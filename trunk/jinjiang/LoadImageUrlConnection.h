//
//  LoadImageUrlConnection.h
//  jinjiang
//
//  Created by Jeff.Yan on 11-11-9.
//  Copyright 2011年 W+K. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTTPConnection.h"
@interface LoadImageUrlConnection : NSObject <HTTPConnectionDelegate>{
    
    NSString *_url;
    
    HTTPConnection *hc;
    
    BOOL isCancel;
    id _index;
    
    SEL _onDidOk;
    SEL _onErr;
    id _delegate;
}
-(void)cancel;

-(void)loadImage:(NSString *)url onDidOk:(SEL)onDidOk onErr:(SEL)onErr delegate:(id)delegate index:(id)index;
+(id)initLoadImage:(NSString *)url onDidOk:(SEL)onDidOk onErr:(SEL)onErr delegate:(id)delegate index:(id)index;
+(void)loadImage:(NSString *)url onDidOk:(SEL)onDidOk onErr:(SEL)onErr delegate:(id)delegate index:(id)index;

@end
