//
//  LineIndex.h
//  OnlineBus
//
//  Created by jerry on 13-12-6.
//  Copyright (c) 2013年 jerry.wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LineIndex : NSObject

@property(nonatomic, assign) NSInteger number;
@property(nonatomic, copy) NSString *lineCode;
@property(nonatomic, copy) NSString *segmentName;

@end
