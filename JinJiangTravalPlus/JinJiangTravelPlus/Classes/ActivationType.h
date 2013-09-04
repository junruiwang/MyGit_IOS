//
//  ActivationType.h
//  JinJiangTravelPlus
//
//  Created by 吕 硕 on 12-12-19.
//  Copyright (c) 2012年 JinJiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActivationType : NSObject
{
    NSString* _cnName;
    NSString* _enName;
}

@property(nonatomic, readonly)NSString* cnName;
@property(nonatomic, readonly)NSString* enName;

- (id)initWithCnName:(NSString*)chinese andEnName:(NSString*)english;

@end
