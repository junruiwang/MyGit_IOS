//
//  LocalFileManager.h
//  HomeFurnishing
//
//  Created by jrwang on 15-1-3.
//  Copyright (c) 2015年 handpay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ExecutionUnit.h"

@interface LocalFileManager : NSObject

- (BOOL)insertIntoLocalWithObject:(ExecutionUnit *) myUnit;
- (BOOL)deleteObjectInLocal:(NSString *) relationCode;
- (ExecutionUnit *)buildLocalFileToObjectByCode:(NSString *) relationCode;

@end
