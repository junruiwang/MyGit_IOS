//
//  DataFileConnection.m
//  chengguo
//
//  Created by Jeff.Yan on 11-5-14.
//  Copyright 2011年 W+K. All rights reserved.
//

#import "DataFileConnection.h"
//#import "CGDataConnection.h"

@implementation DataFileConnection



-(BOOL)saveDataToFileFun:(NSDictionary *)data fileName:(NSString *)fileName setType:(NSString *)_type{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    if (!documentsDirectory) {
        NSLog(@"Documents directory not found!");

    }
    NSMutableArray *tem=[NSMutableArray arrayWithArray:[fileName componentsSeparatedByString:@"/"]];
    [tem removeLastObject];
    NSString *dir = [documentsDirectory stringByAppendingPathComponent:[tem componentsJoinedByString:@"/"]];
    
    NSFileManager *file_manager = [NSFileManager defaultManager];
    if (![file_manager fileExistsAtPath:dir]){
       
        if(![file_manager createDirectoryAtPath:dir withIntermediateDirectories:NO attributes:nil error:nil]){
             NSLog(@"createDirectoryAtPath lost!");
            return NO;
        }
 
    }
   // [[NSFileManager defaultManager]   createDirectoryAtPath: [NSString stringWithFormat:@"%@/myFolder", NSHomeDirectory()] attributes:nil];
    
    NSString *appFile = [documentsDirectory stringByAppendingPathComponent:fileName];
    
    
    NSString *strData=[data JSONRepresentation];
    //NSLog(@"appFile:::::::%@",appFile);
    BOOL saved=[strData writeToFile:appFile atomically:YES encoding:NSUTF8StringEncoding error:nil];
    return saved;
}
-(void)readDataFromFileFun:(NSString *)_type fileName:(NSString *)fileName onDidOk:(SEL)onDidOk onErr:(SEL)onErr delegate:(id)delegate{
    _onErr=onErr;
    _onDidOk=onDidOk;
    _delegate=delegate;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    if (!documentsDirectory) {
        NSLog(@"Documents directory not found!");
        if(_onErr!=nil && _delegate!=nil)
        [_delegate performSelector:_onErr withObject:self];
        
        return;  
    }
   // NSString *fileName=[self getUrl];
    
    NSString *appFile = [documentsDirectory stringByAppendingPathComponent:fileName];
    // NSLog(@"appFile2:::::::%@",appFile);
    NSFileManager *file_manager = [NSFileManager defaultManager];
    if (![file_manager fileExistsAtPath:appFile]){
       //  NSLog(@"appFile not found!");
        if(_onErr!=nil && _delegate!=nil)
        [_delegate performSelector:_onErr withObject:self];
        
        return;  
    }
    //[NSDictionary dictionaryWithContentsOfFile:appFile];//
    NSString *strData=[[NSString alloc] initWithContentsOfFile:appFile encoding:NSUTF8StringEncoding error:nil];
   // NSDictionary *myData =[[NSDictionary alloc] initWithContentsOfFile:appFile];// autorelease];
    //[myData setObject:@"212" forKey:@"22"];
    if(strData==nil){
        ///*
       // NSLog(@"myData not found!");
       if(_onErr!=nil && _delegate!=nil)
        [_delegate performSelector:_onErr withObject:self];
        //*/
       // [self loadDataForSever];
         
         return;  
    }

    if(_onDidOk!=nil && _delegate!=nil){
       // [_delegate performSelector:_onDidOk withObject:myData  withObject:self];
         [_delegate performSelector:_onDidOk withObject:[strData JSONValue]  withObject:self];
    }
    [strData release];
   
   //[myData release];
    
    
}
- (void)dealloc
{
    NSLog(@"DataFileConnection dealloc");
    [super dealloc];
}
- (void)cancel{
    
}
+(BOOL)deleteFile:(NSString *)fileName{
    BOOL isOk=YES;
    NSError *error;
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    if (!documentsDirectory) {
       isOk=NO;
        
    }else{
        NSString *appFile = [documentsDirectory stringByAppendingPathComponent:fileName];
        if([fileMgr fileExistsAtPath:appFile]){
            if (![fileMgr removeItemAtPath:appFile error:&error]) {
                isOk=NO;
            }
        }
        
    }
    return(isOk);
}
+(id)saveDataToFile:(NSDictionary *)data fileName:(NSString *)fileName setType:(NSString *)_type{
    DataFileConnection *_dataFileConnection=[[DataFileConnection alloc] init];
    //_dataFileConnection.type=_type;
    [_dataFileConnection saveDataToFileFun:data fileName:fileName setType:_type];
    [_dataFileConnection release];
     return(nil);
}
+(id)readDataFromFile:(NSString *)_type fileName:(NSString *)fileName onDidOk:(SEL)onDidOk onErr:(SEL)onErr delegate:(id)delegate{
    DataFileConnection *_dataFileConnection=[[DataFileConnection alloc] init];
    //_dataFileConnection.type=_type;
    [_dataFileConnection readDataFromFileFun:_type fileName:fileName onDidOk:onDidOk onErr:onErr delegate:delegate];
    [_dataFileConnection release];
    return(nil);
}

@end
