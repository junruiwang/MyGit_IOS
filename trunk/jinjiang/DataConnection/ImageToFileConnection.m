//
//  ImageToFileConnection.m
//  chengguo
//
//  Created by Jeff.Yan on 11-5-21.
//  Copyright 2011年 W+K. All rights reserved.
//

#import "ImageToFileConnection.h"


@implementation ImageToFileConnection



- (void)cancel{
    
}

-(void)saveImageToFile:(NSMutableData *)data fileName:(NSString *)fileName{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    if (!documentsDirectory) {
        NSLog(@"Documents directory not found!");
        
    }
    //NSString *fileName=[self getUrl];
    
    NSString *appFile = [documentsDirectory stringByAppendingPathComponent:fileName];
    [data writeToFile:appFile atomically:YES];
}
-(void)readImageFromFile:(NSString *)fileName onDidOk:(SEL)onDidOk onErr:(SEL)onErr delegate:(id)delegate{
    _onErr=onErr;
    _onDidOk=onDidOk;
    _delegate=delegate;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    if (!documentsDirectory) {
        NSLog(@"Documents directory not found!");
        if(_onErr!=nil && _delegate!=nil)
            [_delegate performSelector:_onErr withObject:self];
        
        //[self release];
        return;  
    }
    // NSString *fileName=[self getUrl];
    
    NSString *appFile = [documentsDirectory stringByAppendingPathComponent:fileName];
    
    NSFileManager *file_manager = [NSFileManager defaultManager];
    if (![file_manager fileExistsAtPath:appFile]){
        if(_onErr!=nil && _delegate!=nil)
            [_delegate performSelector:_onErr withObject:self];
        //[self release];
        return;  
    }
    
    NSData *myData = [[NSData alloc] initWithContentsOfFile:appFile];// autorelease];
    if(myData==nil){
        ///*
        if(_onErr!=nil && _delegate!=nil)
            [_delegate performSelector:_onErr withObject:self];
       // [self release];
        //*/
        // [self loadDataForSever];
        return;  
    }
    if(_onDidOk!=nil && _delegate!=nil)
        [_delegate performSelector:_onDidOk withObject:myData withObject:self];
    [myData release];
    //[self release];
    
}


+(void)saveImageToFile:(NSMutableData *)data fileName:(NSString *)fileName{
    ImageToFileConnection *_imageToFileConnection=[[ImageToFileConnection alloc] init];
   // _imageToFileConnection.type=_type;
    [_imageToFileConnection saveImageToFile:data fileName:fileName];
     [_imageToFileConnection release];
    
}
+(void)readImageFromFile:(NSString *)fileName onDidOk:(SEL)onDidOk onErr:(SEL)onErr delegate:(id)delegate{
    ImageToFileConnection *_imageToFileConnection=[[ImageToFileConnection alloc] init];
   // _imageToFileConnection.type=_type;
    [_imageToFileConnection readImageFromFile:fileName onDidOk:onDidOk onErr:onErr delegate:delegate];
    [_imageToFileConnection release];

}



@end
