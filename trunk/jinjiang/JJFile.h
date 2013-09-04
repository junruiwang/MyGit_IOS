//
//  JJFile.h
//  jinjiang
//
//  Created by Leon on 12-4-10.
//  Copyright (c) 2012年 W+K. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Foundation/Foundation.h>

typedef enum {
    JJFileStatePrepare,
    JJFileStatePause,
    JJFileStateDownloading,
    JJFileStateComplete,
    JJFileStateFailed,
} JJFileState;

@protocol JJFileDownloadDelegate;

@interface JJFile : NSObject<NSURLConnectionDelegate, UIAlertViewDelegate>
{
    int _receivedSize;
    int _retryTime;
}

@property (nonatomic, assign) int fileId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *coverImageURL;
@property (nonatomic, readonly) NSString *coverImagePath;
@property (nonatomic, retain) UIImage *coverImage;
@property (nonatomic, copy) NSString *fileURL;
@property (nonatomic, assign) JJFileState state;
@property (nonatomic, assign) id<JJFileDownloadDelegate> delegate;
@property (nonatomic, readonly) NSString *filePath;
@property (nonatomic, assign) int fileSize;
@property (nonatomic, copy) NSString *rootPath;
@property (nonatomic, assign) int progress;
@property (nonatomic, readonly) NSString *zipFilePath;

- (id)initWithRootPath:(NSString *)rootPath fileId:(int)fileId title:(NSString *)title coverImageURL:(NSString *)coverImageURL fileURL:(NSString *)fileURL fileSize:(int)fileSize;
- (void)startDownload;
- (void)pauseDownload;

@end

@protocol JJFileDownloadDelegate <NSObject>

- (void)jjFileStartDownload:(JJFile *)file;
- (void)jjFileDownloadChanged:(JJFile *)file;
- (void)jjFileDownloadComplete:(JJFile *)file;
- (void)jjFile:(JJFile *)file downloadFailedWithError:(NSError *)error;

@end
