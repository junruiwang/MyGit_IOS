//
//  Magzine.m
//  jinjiang
//
//  Created by Leon on 12-4-6.
//  Copyright (c) 2012年 W+K. All rights reserved.
//

#import "Magzine.h"
#import "GlobalFunction.h"

@implementation Magzine

@synthesize fileList = _fileList;
@synthesize progress = _progress;

- (void)setProgress:(int)progress
{
    if (_progress != progress) {
        UIImage *cover = [UIImage imageWithContentsOfFile:self.coverImagePath];
        if (progress<=100) {
            cover = [GlobalFunction shadowImage:cover];
            if (self.state == JJFileStateDownloading)
                cover = [GlobalFunction combineImage:cover withText:@"下载中"];
            UIImage *progressImage = [UIImage imageNamed:[NSString stringWithFormat:@"progress_%d.png", progress]];
            self.coverImage = [GlobalFunction combineImage:cover withProgress:progressImage];
        }
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(jjFileDownloadChanged:)]) {
            [self.delegate jjFileDownloadChanged:self];
        }
    }
    _progress = progress;
}

- (id)initWithRootPath:(NSString *)rootPath fileId:(int)fileId title:(NSString *)title coverImageURL:(NSString *)coverImageURL fileURL:(NSString *)fileURL fileSize:(int)fileSize fileList:(NSArray *)fileList
{
    if ((self = [super initWithRootPath:rootPath fileId:fileId title:title coverImageURL:coverImageURL fileURL:fileURL fileSize:fileSize])) {
        _fileList = [fileList retain];
        
        int progress = (int)((float)_receivedSize*10/(float)fileSize)*10;
        self.progress = progress;
        if (_receivedSize > 0) {
            self.coverImage = [GlobalFunction pauseImage:self.coverImage];
        } else if (self.state != JJFileStateComplete) {
            self.coverImage = [GlobalFunction startDownloadImage:self.coverImage];
        }
    }
    return self;
}

- (void)startDownload
{
    [super startDownload];
    UIImage *cover = [UIImage imageWithContentsOfFile:self.coverImagePath];
    cover = [GlobalFunction shadowImage:cover];
    cover = [GlobalFunction downloadImage:cover];
    UIImage *progressImage = [UIImage imageNamed:[NSString stringWithFormat:@"progress_%d.png", self.progress]];
    self.coverImage = [GlobalFunction combineImage:cover withProgress:progressImage];
}

- (void)pauseDownload
{
    [super pauseDownload];
    
    UIImage *cover = [UIImage imageWithContentsOfFile:self.coverImagePath];
    cover = [GlobalFunction shadowImage:cover];
    cover = [GlobalFunction pauseImage:cover];
    UIImage *progressImage = [UIImage imageNamed:[NSString stringWithFormat:@"progress_%d.png", self.progress]];
    self.coverImage = [GlobalFunction combineImage:cover withProgress:progressImage];
}

- (void)connection:(NSURLConnection *)aConnection didReceiveData:(NSData *)data {
    [super connection:aConnection didReceiveData:data];
    
    int progress = (int)((float)_receivedSize*10/(float)self.fileSize)*10;
    self.progress = progress;
}

- (void)connection:(NSURLConnection *)aConnection didFailWithError:(NSError *)error {
    UIImage *cover = [UIImage imageWithContentsOfFile:self.coverImagePath];
    cover = [GlobalFunction shadowImage:cover];
    cover = [GlobalFunction failImage:cover];
    UIImage *progressImage = [UIImage imageNamed:[NSString stringWithFormat:@"progress_%d.png", self.progress]];
    self.coverImage = [GlobalFunction combineImage:cover withProgress:progressImage];
    [super connection:aConnection didFailWithError:error];
}

- (void)dealloc
{
    [_fileList release]; _fileList = nil;
    [super dealloc];
}

@end
