//
//  NSString+URLEncoding.h
//  chengguo
//
//  Created by Jeff.Yan on 11-5-14.
//  Copyright 2011年 W+K. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (URLEncodingAdditions)
- (NSString *)URLEncodedString;
- (NSString *)URLDecodedString;
@end
