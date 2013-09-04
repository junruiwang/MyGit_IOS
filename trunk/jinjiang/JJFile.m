//
//  JJFile.m
//  jinjiang
//
//  Created by Leon on 12-4-10.
//  Copyright (c) 2012年 W+K. All rights reserved.
//

#import "JJFile.h"
#import "GlobalFunction.h"
#import "ZipArchive.h"

@interface JJFile()

@property (nonatomic, retain) NSMutableData *buffer;
@property (nonatomic, retain)  NSURLConnection *innerConnection;

- (void)startDownloadWithSize:(int)size;
- (void)cancelConnection;
- (void)retryConnection:(NSURLConnection *)aConnection;

@end

@implementation JJFile

@synthesize fileId = _fileId;
@synthesize title = _title;
@synthesize coverImageURL = _coverImageURL;
@synthesize coverImagePath;
@synthesize coverImage = _coverImage;
@synthesize fileURL = _fileURL;
@synthesize state = _state;
@synthesize buffer = _buffer;
@synthesize innerConnection = _innerConnection;
@synthesize delegate = _delegate;
@synthesize fileSize = _fileSize;
@synthesize progress = _progress;
@synthesize rootPath = _rootPath;

- (NSString *)coverImagePath
{
    return [self.rootPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.png", _fileId]];
}

- (NSString *)filePath
{
    return [self.rootPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%d", _fileId]];
}

- (NSString *)zipFilePath
{
    return [self.rootPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.zip", _fileId]];
}

- (id)initWithRootPath:(NSString *)rootPath fileId:(int)fileId title:(NSString *)title coverImageURL:(NSString *)coverImageURL fileURL:(NSString *)fileURL fileSize:(int)fileSize
{
    if ((self = [super init])) {
        _retryTime = MAX_RETRY_TIME;
        _rootPath = [rootPath copy];
        _fileId = fileId;
        _title = [title copy];
        _coverImageURL = [coverImageURL copy];
        _fileURL = [fileURL copy];
        _fileSize = fileSize;
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:self.filePath]) {
            self.state = JJFileStateComplete;
        } else {
            if ([fileManager fileExistsAtPath:self.zipFilePath]) {
                NSDictionary *cacheFileAttributes = [fileManager attributesOfItemAtPath:self.zipFilePath error:nil];
                _receivedSize = cacheFileAttributes.fileSize;
                self.state = JJFileStatePause;
            } else {
                self.state = JJFileStatePrepare;
            }
        }
        
        if (![fileManager fileExistsAtPath:self.rootPath]) {
            [fileManager createDirectoryAtPath:self.rootPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        if (![fileManager fileExistsAtPath:self.coverImagePath]) {
            //download cover image
            NSURL *url = [NSURL URLWithString:_coverImageURL];
            NSData *data = [NSData dataWithContentsOfURL:url];
            [data writeToFile:self.coverImagePath atomically:YES];
            UIImage *image = [UIImage imageWithData:data];
            self.coverImage = [GlobalFunction shadowImage:image];
        }
        UIImage *cover = [UIImage imageWithContentsOfFile:self.coverImagePath];
        if (self.state == JJFileStateComplete)
            self.coverImage = cover;
        else
            self.coverImage = [GlobalFunction shadowImage:cover];
    }
    return self;
}

- (void)startDownload
{
    if (_receivedSize == 0 && self.state == JJFileStatePrepare) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"下载该内容将消耗大约%@的网络流量，请确认是否继续？", [self stringFromFileSize:self.fileSize]] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
        [alertView release];
    } else {
        [self startDownloadWithSize:_receivedSize];
    }
}

- (NSString *)stringFromFileSize:(int)theSize
{
	float floatSize = theSize;
	if (theSize<1023)
		return([NSString stringWithFormat:@"%i bytes",theSize]);
	floatSize = floatSize / 1024;
	if (floatSize<1023)
		return([NSString stringWithFormat:@"%1.1f KB",floatSize]);
	floatSize = floatSize / 1024;
	if (floatSize<1023)
		return([NSString stringWithFormat:@"%1.1f MB",floatSize]);
	floatSize = floatSize / 1024;
    
	// Add as many as you like
    
	return([NSString stringWithFormat:@"%1.1f GB",floatSize]);
}

- (void)startDownloadWithSize:(int)size
{
    if ([_delegate respondsToSelector:@selector(jjFileStartDownload:)]) {
        [_delegate jjFileStartDownload:self];
	}
    
    NSString *tempURL = [self.fileURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
	NSURL *URL = [NSURL URLWithString:tempURL];
    
	NSAssert(URL,@"can't convert to NSURL");
	
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:20.f];
    if (size > 0) {
        [request setValue:[NSString stringWithFormat:@"bytes=%d-", size] forHTTPHeaderField:@"Range"];
    }
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	self.innerConnection = conn;
	[conn release];
	[self.innerConnection start];
    
    self.state = JJFileStateDownloading;
}

- (void)pauseDownload
{
    [self.innerConnection cancel];
	self.innerConnection = nil;
	self.buffer = nil;
    self.state = JJFileStatePause;
}

- (void)cancelDownload
{
    [self cancelConnection];
    self.state = JJFileStatePrepare;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:self.zipFilePath error:nil];
}

#pragma mark - NSUrlConnection delegate
/////////////////////////////////////////////////////////////

- (void)connection:(NSURLConnection *)aConnection didFailWithError:(NSError *)error {
	self.buffer = nil;
    self.innerConnection = nil;
    self.state = JJFileStateFailed;
	if ([_delegate respondsToSelector:@selector(jjFile:downloadFailedWithError:)]) {
        [_delegate jjFile:self downloadFailedWithError:error];
	}
}

- (void)connection:(NSURLConnection *)aConnection didReceiveResponse:(NSURLResponse *)response {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:self.zipFilePath]) {
        [fileManager createFileAtPath:self.zipFilePath contents:nil attributes:nil];
    }
}

- (void)connection:(NSURLConnection *)aConnection didReceiveData:(NSData *)data {
    NSFileHandle *fileHandel = [NSFileHandle fileHandleForWritingAtPath:self.zipFilePath];
    [fileHandel seekToEndOfFile];
    [fileHandel writeData:data];
    [fileHandel closeFile];
    _receivedSize += data.length;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)aConnection {
    ZipArchive* zip = [[ZipArchive alloc] init];
    if( [zip UnzipOpenFile:self.zipFilePath] )
    {
        BOOL ret = [zip UnzipFileTo:self.filePath overWrite:YES];
        if( NO==ret ) {
            NSLog(@"unzip failed");
            [self retryConnection:aConnection];
            return;
        }
        [zip UnzipCloseFile];        
    } else {
        [self retryConnection:aConnection];
        return;
    }
    [zip release];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:self.zipFilePath error:nil];
    
	self.state = JJFileStateComplete;
    UIImage *cover = [UIImage imageWithContentsOfFile:self.coverImagePath];
    self.coverImage = cover;
    if ([_delegate respondsToSelector:@selector(jjFileDownloadComplete:)]) {
        [_delegate jjFileDownloadComplete:self];
    }
    self.innerConnection = nil;
}

- (void)retryConnection:(NSURLConnection *)aConnection
{
    if (_retryTime > 0) {
        _retryTime--;
        [self startDownloadWithSize:_receivedSize];
    } else {
        _retryTime = MAX_RETRY_TIME;
        [self connection:aConnection didFailWithError:nil];
    }
}

- (void)cancelConnection 
{
	[self.innerConnection cancel];
	self.innerConnection = nil;
	self.buffer = nil;
    _receivedSize = 0;
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self startDownloadWithSize:_receivedSize]; 
    }
}

- (void)dealloc
{
    [self cancelConnection];
    [_title release]; _title = nil;
    [_coverImageURL release]; _coverImageURL = nil;
    [_coverImage release]; _coverImage = nil;
    [_fileURL release]; _fileURL = nil;
    [super dealloc];
}

@end

