//
//  IdentityType.h
//  JinJiangTravelPlus
//
//  Created by jerry on 13-1-6.
//  Copyright (c) 2013年 JinJiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IdentityType : NSObject

@property(nonatomic, copy) NSString* identityTypeName;
@property(nonatomic, copy) NSString* identityTypeCnName;

- (id)initWithName:(NSString *)typeName cnName:(NSString *)typeCnName;

@end
