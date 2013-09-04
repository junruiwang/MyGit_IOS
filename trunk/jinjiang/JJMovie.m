//
//  JJMovie.m
//  jinjiang
//
//  Created by jerry on 12-4-24.
//  Copyright (c) 2012年 W+K. All rights reserved.
//

#import "JJMovie.h"
#import "GlobalFunction.h"
#import "ZipArchive.h"

@implementation JJMovie

- (id)initWithRootPath:(NSString *)rootPath fileId:(int)fileId title:(NSString *)title coverImageURL:(NSString *)coverImageURL fileURL:(NSString *)fileURL fileSize:(int)fileSize
{
    if ((self = [super initWithRootPath:rootPath fileId:fileId title:title coverImageURL:coverImageURL fileURL:fileURL fileSize:fileSize])) {        
        int progress = (int)((float)_receivedSize*100/(float)fileSize);
        self.progress = progress;
    }
    return self;
}

- (void)connection:(NSURLConnection *)aConnection didReceiveData:(NSData *)data {
    [super connection:aConnection didReceiveData:data];
    self.progress = (int)((float)_receivedSize*100/(float)self.fileSize);
    if (self.delegate && [self.delegate respondsToSelector:@selector(jjFileDownloadChanged:)]) {
        [self.delegate jjFileDownloadChanged:self];
    }
}

//==================================================

- (void)connectionDidFinishLoading:(NSURLConnection *)aConnection {
    ZipArchive* zip = [[ZipArchive alloc] init];
    if( [zip UnzipOpenFile:self.zipFilePath] )
    {
        BOOL ret = [zip UnzipFileTo:self.filePath overWrite:YES];
        if( NO==ret ) {
            NSLog(@"unzip failed");
            [super retryConnection:aConnection];
            return;
        }
        [zip UnzipCloseFile];        
    } else {
        [super retryConnection:aConnection];
        return;
    }
    [zip release];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:self.zipFilePath error:nil];
    
    NSArray *aryMp4 = [fileManager contentsOfDirectoryAtPath:self.filePath error:nil];
    NSString *fileName = [aryMp4 objectAtIndex:0];
    [fileManager moveItemAtPath:[self.filePath stringByAppendingPathComponent:fileName] toPath:[self.filePath stringByAppendingPathComponent:@"princess.mp4"]  error:nil];
    
    
	self.state = JJFileStateComplete;
    UIImage *cover = [UIImage imageWithContentsOfFile:self.coverImagePath];
    self.coverImage = cover;
    if ([self.delegate respondsToSelector:@selector(jjFileDownloadComplete:)]) {
        [self.delegate jjFileDownloadComplete:self];
    }
    [self cancelConnection];
}

@end
