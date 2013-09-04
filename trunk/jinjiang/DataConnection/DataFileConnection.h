//
//  DataFileConnection.h
//  chengguo
//
//  Created by Jeff.Yan on 11-5-14.
//  Copyright 2011年 W+K. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSON.h"

@interface DataFileConnection : NSObject {

    //NSString *_fileName;
    SEL _onDidOk;
    SEL _onErr;
    id _delegate;
}

-(BOOL)saveDataToFileFun:(NSDictionary *)data fileName:(NSString *)fileName setType:(NSString *)_type;

-(void)readDataFromFileFun:(NSString *)_type fileName:(NSString *)fileName onDidOk:(SEL)onDidOk onErr:(SEL)onErr delegate:(id)delegate;

- (void)cancel;

+(BOOL)deleteFile:(NSString *)fileName;
+(id)saveDataToFile:(NSDictionary *)data fileName:(NSString *)fileName setType:(NSString *)_type;
+(id)readDataFromFile:(NSString *)_type fileName:(NSString *)fileName onDidOk:(SEL)onDidOk onErr:(SEL)onErr delegate:(id)delegate;


@end
