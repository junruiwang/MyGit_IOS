//
//  SceneListParser.m
//  HomeFurnishing
//
//  Created by jerry on 14/12/25.
//  Copyright (c) 2014年 handpay. All rights reserved.
//

#import "SceneListParser.h"

@implementation SceneListParser

- (BOOL)parserJSONString:(NSString *)responseData
{
    if ([super parserJSONString:responseData]) {
        NSArray *array = [responseData JSONValue];
        if(self.delegate != nil && [self.delegate respondsToSelector:@selector(parser:DidParsedData:)]){
            NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:array, @"data", nil];
            [self.delegate parser:self DidParsedData:data];
        }
    }
    return YES;
}

@end
