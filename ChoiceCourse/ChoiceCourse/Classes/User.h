//
//  User.h
//  ChoiceCourse
//
//  Created by 杨 栋栋 on 12-10-16.
//  Copyright (c) 2012年 jerry. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject <NSCoding, NSCopying>

@property (nonatomic, retain) NSString *email;

- (void) write;

@end
