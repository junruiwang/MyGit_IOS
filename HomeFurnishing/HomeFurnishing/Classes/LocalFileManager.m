//
//  LocalFileManager.m
//  HomeFurnishing
//
//  Created by jrwang on 15-1-3.
//  Copyright (c) 2015年 handpay. All rights reserved.
//

#import "LocalFileManager.h"
#import "FileManager.h"

#define LOCAL_FILE_LIST @"LocalExecutionList.plist"

@implementation LocalFileManager

- (BOOL)insertIntoLocalWithObject:(ExecutionUnit *) myUnit
{
    NSString *path = [FileManager filePath:LOCAL_FILE_LIST];
    NSMutableArray *objArray = [self readObjectListFromLocalFile];
    
    BOOL isExist = NO;
    if (objArray) {
        for (int i=0; i<objArray.count; i++) {
            NSData *data = objArray[i];
            ExecutionUnit *execUnit = [ExecutionUnit unarchived:data];
            if ([myUnit.executCode isEqualToString:execUnit.executCode]) {
                [objArray replaceObjectAtIndex:i withObject:[myUnit archived]];
                isExist = YES;
                break;
            }
        }
    } else {
        objArray = [[NSMutableArray alloc] initWithCapacity:10];
    }
    
    if (!isExist) {
        [objArray addObject:[myUnit archived]];
    }
    
    return [objArray writeToFile: path atomically:YES];
}

- (BOOL)deleteObjectInLocal:(NSString *) relationCode
{
    NSMutableArray *objArray = [self readObjectListFromLocalFile];
    
    if (objArray) {
        for (NSInteger i=0; i < [objArray count]; i++) {
            NSData *data = [objArray objectAtIndex:i];
            ExecutionUnit *execUnit = [ExecutionUnit unarchived:data];
            if ([relationCode isEqualToString:execUnit.executCode]) {
                [objArray removeObjectAtIndex:i];
                break;
            }
        }
    }
    
    NSString *path = [FileManager filePath:LOCAL_FILE_LIST];
    return [objArray writeToFile: path atomically:YES];
}

- (ExecutionUnit *)buildLocalFileToObjectByCode:(NSString *) relationCode
{
    NSMutableArray *objArray = [self readObjectListFromLocalFile];
    if (objArray) {
        for (NSData *data in objArray) {
            ExecutionUnit *execUnit = [ExecutionUnit unarchived:data];
            if ([relationCode isEqualToString:execUnit.executCode]) {
                return execUnit;
            }
        }
    }
    
    return nil;
}

- (NSMutableArray *)readObjectListFromLocalFile
{
    NSString *path = [FileManager filePath:LOCAL_FILE_LIST];
    return [[NSMutableArray alloc] initWithContentsOfFile:path];
}

@end
