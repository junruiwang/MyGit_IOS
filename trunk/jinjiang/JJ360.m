//
//  Magzine.m
//  jinjiang
//
//  Created by Leon on 12-4-6.
//  Copyright (c) 2012年 W+K. All rights reserved.
//

#import "JJ360.h"
#import "GlobalFunction.h"

@implementation JJ360

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

@end