//
//  SceneExecParser.m
//  HomeFurnishing
//
//  Created by jrwang on 15-1-5.
//  Copyright (c) 2015年 handpay. All rights reserved.
//

#import "SceneExecParser.h"

@implementation SceneExecParser

- (BOOL)parserJSONString:(NSString *)responseData
{
    if ([super parserJSONString:responseData]) {
        NSDictionary *dictionary = [responseData JSONValue];
        if(self.delegate != nil && [self.delegate respondsToSelector:@selector(parser:DidParsedData:)]){
            [self.delegate parser:self DidParsedData:dictionary];
        }
        
    }
    return YES;
}

@end
