//
//  ClientVersion.h
//  JinJiangTravelPlus
//
//  Created by jerry on 12-12-14.
//  Copyright (c) 2012年 JinJiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClientVersion : NSObject

@property(nonatomic, copy) NSString *version;
@property(nonatomic, copy) NSString *userId;
@property(nonatomic, copy) NSString *forceUpdate;
@property(nonatomic, copy) NSString *updateUrl;
@property(nonatomic, copy) NSString *commentUrl;
@property(nonatomic, copy) NSString *reason;
@property(nonatomic, copy) NSString *description;

@end
