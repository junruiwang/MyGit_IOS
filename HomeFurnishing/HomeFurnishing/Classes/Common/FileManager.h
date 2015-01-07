//
//  FileManager.h
//  IntelligentHome
//
//  Created by jerry on 13-12-14.
//  Copyright (c) 2013年 jerry.wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileManager : NSObject

+ (NSString *)filePath:(NSString *)fileName;
+ (NSString *)fileCachesPath:(NSString *)fileName;

@end
