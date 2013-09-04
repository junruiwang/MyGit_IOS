//
//  ImageToFileConnection.h
//  chengguo
//
//  Created by Jeff.Yan on 11-5-21.
//  Copyright 2011年 W+K. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageToFileConnection : NSObject {
   // NSString *type;
   // NSString *_fileName;
    SEL _onDidOk;
    SEL _onErr;
    id _delegate;
}
//@property (nonatomic, retain) NSString *type;

- (void)cancel;

-(void)saveImageToFile:(NSMutableData *)data fileName:(NSString *)fileName;
-(void)readImageFromFile:(NSString *)fileName onDidOk:(SEL)onDidOk onErr:(SEL)onErr delegate:(id)delegate;


+(void)saveImageToFile:(NSMutableData *)data fileName:(NSString *)fileName;
+(void)readImageFromFile:(NSString *)fileName onDidOk:(SEL)onDidOk onErr:(SEL)onErr delegate:(id)delegate;

@end
