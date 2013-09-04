//
//  Magzine.h
//  jinjiang
//
//  Created by Leon on 12-4-6.
//  Copyright (c) 2012年 W+K. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JJFile.h"

@interface Magzine : JJFile

@property (nonatomic, retain) NSArray *fileList;

- (id)initWithRootPath:(NSString *)rootPath fileId:(int)fileId title:(NSString *)title coverImageURL:(NSString *)coverImageURL fileURL:(NSString *)fileURL fileSize:(int)fileSize fileList:(NSArray *)fileList;

@end
