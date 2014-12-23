//
//  ExecutionUnit.h
//  HomeFurnishing
//
//  Created by jerry on 14/12/23.
//  Copyright (c) 2014年 handpay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExecutionUnit : NSObject<NSCoding, NSCopying>

@property(nonatomic, copy) NSString *executCode;
@property(nonatomic, copy) NSString *imageName;
@property(nonatomic, copy) NSString *cName;
@property(nonatomic, copy) NSString *eName;
@property(nonatomic, assign) NSInteger displayNumber;  // 0:cName 1:eName
@property (nonatomic, strong) NSMutableArray *sceneArray;

+ (ExecutionUnit *)unarchived:(NSData *) data;
- (id) initWithDictionary : (NSDictionary *) dict;
- (NSData *)archived;

@end
