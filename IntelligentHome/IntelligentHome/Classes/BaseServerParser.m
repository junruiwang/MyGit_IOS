//
//  BaseServerParser.m
//  IntelligentHome
//
//  Created by jerry on 13-12-14.
//  Copyright (c) 2013年 jerry.wang. All rights reserved.
//

#import "BaseServerParser.h"

@implementation BaseServerParser

- (BOOL)parserJSONString:(NSString *)responseData
{
    if ([super parserJSONString:responseData]) {
        NSDictionary *dictionary = [responseData JSONValue];
        NSDictionary *data = [dictionary valueForKey:@"info"];
        
        if(self.delegate != nil && [self.delegate respondsToSelector:@selector(parser:DidParsedData:)]){
            [self.delegate parser:self DidParsedData:data];
        }
        
    }
    return YES;
}

@end
