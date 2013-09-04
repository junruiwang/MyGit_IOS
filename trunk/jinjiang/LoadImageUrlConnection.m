//
//  LoadImageUrlConnection.m
//  jinjiang
//
//  Created by Jeff.Yan on 11-11-9.
//  Copyright 2011年 W+K. All rights reserved.
//

#import "LoadImageUrlConnection.h"
#import "DataFileConnection.h"
#import "ImageToFileConnection.H"

static NSMutableDictionary *imageDic = nil;
static NSMutableDictionary *temImageDic = nil;

@implementation LoadImageUrlConnection
-(NSString *)getTimeStr{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM-dd-hh-mm-ss-SSSS"];
    NSString *locationString=[formatter stringFromDate: [NSDate date]];
    NSArray *timeArray=[locationString componentsSeparatedByString:@"-"];
    int value_M=   [[timeArray objectAtIndex:0]intValue];
    int value_D=   [[timeArray objectAtIndex:1]intValue];
    int value_h=  [ [timeArray objectAtIndex:2]intValue];
    int value_m= [ [timeArray objectAtIndex:3]intValue];
    int value_s=  [ [timeArray objectAtIndex:4]intValue];
    int value_ss=  [ [timeArray objectAtIndex:5]intValue];
    //int value_All=value_D*24*60*60+value_h*60*60+value_m*60+value_s*60+value_ss;
    NSString *str=[NSString stringWithFormat:@"f_%d_%d_%d_%d_%d_%d",value_M,value_D,value_h,value_m,value_s,value_ss];
    [formatter release];
    return(str);
}

-(void)releaseAll{
    if(hc!=nil){
        [hc release];
        
    }
    
    [_index release];
    [_delegate release];
    [_url release];
    hc=nil;
    _url=nil;
    _delegate=nil;
    _index=nil;
    
}
-(void)cancel{
    isCancel=YES;
    if(hc)[hc cancelDownload];
    [self releaseAll];
}

- (void)postHTTPDidFinish:(NSMutableData *)_data hc:(HTTPConnection *) _hc{
    if(isCancel)return;
    UIImage *image=[[UIImage alloc] initWithData:_data];// autorelease];
    if(image!=nil){
        if(_onDidOk!=nil && _delegate!=nil && [_delegate retainCount]>0){
            
            
            //NSLog(@"cao::%d",[self.delegate retainCount]);
            @try {
                [_delegate performSelector:_onDidOk withObject:image withObject:_index];
            }@catch(NSException *e){
                
            }@finally{
                
            }
        }
        
        NSString *fileName=[self getTimeStr];
        
        
        if (imageDic == nil) {
            imageDic=[[NSMutableDictionary alloc] init];
        }else{
            
        }
        //NSLog(@"imageDic_url_url::%@",_url);
        
        [ImageToFileConnection saveImageToFile:_data fileName:fileName];
        
        [imageDic setObject:fileName forKey:_url];
        if ([imageDic count]>300){
            NSArray *fileNames = [imageDic allValues];
            
            fileNames=[fileNames sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
            
            fileName=[fileNames objectAtIndex:0];
            
            
            //fileName=[imageDic objectForKey:key];
            if([DataFileConnection deleteFile:fileName]){
                [imageDic removeObjectForKey:[imageDic allKeysForObject:fileName]];
                //allKeysForObject
            }
        }
        [DataFileConnection saveDataToFile:imageDic fileName:@"load_image_data_info" setType:@" "];
        if(temImageDic!=nil){
            [temImageDic removeObjectForKey:_url];
        }
        
    }else{
        if(_onErr!=nil && _delegate!=nil)
            [_delegate performSelector:_onErr withObject:_index];
    }
    [image release];
    [self releaseAll];
    //[self release];
}

- (void)postHTTPError:(HTTPConnection *) _hc{
    if(isCancel)return;
    
    //[self release];
    if(_onDidOk!=nil && _delegate!=nil && [_delegate retainCount]>0){
        @try {
            [_delegate performSelector:_onErr withObject:_index];
        }@catch(NSException *e){
            
        }@finally{
            
        }
    }
    
    [self releaseAll];
    //[self release];
}



-(void)readFile{
    if(isCancel)return;
    if (imageDic == nil) {
        [self performSelector:@selector(httpLoadImage)];
    }else{
        NSString *fileName=@"";
        
        fileName=[imageDic objectForKey:_url];
        if(fileName!=nil){
            // NSLog(@"ImageToFileConnection:::::::::");
            [ImageToFileConnection readImageFromFile:fileName onDidOk:@selector(readFileDidOk:) onErr:@selector(readErr) delegate:self];
        }else{
            //NSLog(@"ImageToFileConnection:::::::::httpLoadImage");
            [self performSelector:@selector(httpLoadImage)];
        }
    }
    
    
}
-(void)readFileDidOk:(NSMutableData *)data{
    if(isCancel)return;
    UIImage *image=[[UIImage alloc] initWithData:data];
    if(image!=nil){
        if(_onDidOk!=nil && _delegate!=nil && [_delegate retainCount]>0)
            @try {
                [_delegate performSelector:_onDidOk  withObject:image withObject:_index];
            }@catch(NSException *e){
                
            }@finally{
                
            }
        
    }else{
        if(_onErr!=nil && _delegate!=nil && [_delegate retainCount]>0)
            @try {
                [_delegate performSelector:_onErr withObject:_index];
            }@catch(NSException *e){
                
            }@finally{
                
            }
        
    }
    [image release];
    [self releaseAll];
    // [self release];
    //[self performSelector:@selector(httpLoadImage)];
}
-(void)httpLoadImage{
    if(isCancel)return;
    if(temImageDic!=nil){
        NSString *isLoading=@"";
        isLoading=[temImageDic objectForKey:_url];
        if(isLoading!=nil){
            //if([isLoading isEqualToString:@"isLoading....."]){
            [self performSelector:@selector(readFile) withObject:nil afterDelay:0.5];
            return;
        }else{
        }
        
    }else{
        
    }
    if(temImageDic==nil){
        temImageDic=[[NSMutableDictionary alloc] init];
    }
    [temImageDic setObject:@"isLoading....." forKey:_url];
    if(hc!=nil){
        [hc cancelDownload];
        [hc release];
        hc=nil;
    }
    hc=[[HTTPConnection alloc] init];
    hc.delegate=self;
    [hc loadImage:_url type:@"loadImage"];
   
    
}
-(void)readErr{
    //[_delegate performSelector:_onErr withObject:self];
    [self performSelector:@selector(httpLoadImage)];
    
}
-(void)onLoadDataDidOk:(NSMutableDictionary *)data{
    
    if (imageDic == nil) {
        //imageDic=[[NSMutableDictionary alloc] init];
        imageDic=[[NSMutableDictionary alloc]initWithDictionary:data];
        //[imageDic addEntriesFromDictionary:data];
        //imageDic=[NSMutableDictionary dictionaryWithDictionary:data];
        
    }else{
    }
    [self performSelector:@selector(readFile)];
    
    
}
-(void)onLoadDataErr{
    imageDic=[[NSMutableDictionary alloc] init];
    [DataFileConnection saveDataToFile:imageDic fileName:@"load_image_data_info" setType:@" "];
    [self performSelector:@selector(readFile)];
    
    //NSMutableDictionary *ns=[[[NSMutableDictionary alloc] init] autorelease];
    //imageDic
    
}
-(void)loadImage:(NSString *)url onDidOk:(SEL)onDidOk onErr:(SEL)onErr delegate:(id)delegate index:(id)index{
    _onDidOk=onDidOk;
    _onErr=onErr;
    _delegate=[delegate retain];
    _index=[index retain];
    _url=[url retain];//[[NSString alloc] initWithString:url];//[url retain];//
    //NSLog(@"loadImage:%@",_url);
    
    if (imageDic == nil) {
        [DataFileConnection readDataFromFile:@"loadImageListData" fileName:@"load_image_data_info" onDidOk:@selector(onLoadDataDidOk:) onErr:@selector(onLoadDataErr) delegate:self];
    }else{
        [self performSelector:@selector(readFile)];
    }
}
- (void)dealloc
{
    
    [self releaseAll];
    NSLog(@"loadImage dealloc");
    [super dealloc];
}

+(id)initLoadImage:(NSString *)url onDidOk:(SEL)onDidOk onErr:(SEL)onErr delegate:(id)delegate index:(id)index{

    if(url!=nil){
        //NSLog(@"initLoadImage:%@",url);
        LoadImageUrlConnection *imageConnection=[[LoadImageUrlConnection alloc] init];
        
        [imageConnection loadImage:url onDidOk:onDidOk onErr:onErr delegate:delegate index:index];
        //[cgImageConnection release];
        return(imageConnection);
    }
    return(nil);
}
+(void)loadImage:(NSString *)url onDidOk:(SEL)onDidOk onErr:(SEL)onErr delegate:(id)delegate index:(id)index{
    
    LoadImageUrlConnection *imageConnection=[LoadImageUrlConnection initLoadImage:url onDidOk:onDidOk onErr:onErr delegate:delegate index:index];
    [imageConnection release];
}

@end
