//
//  LoginParser.m
//  HomeFurnishing
//
//  Created by jrwang on 15-1-4.
//  Copyright (c) 2015年 handpay. All rights reserved.
//

#import "LoginParser.h"

@implementation LoginParser

- (BOOL)parserJSONString:(NSString *)responseData
{
    if ([super parserJSONString:responseData]) {
        NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:responseData, @"data", nil];
        
        if(self.delegate != nil && [self.delegate respondsToSelector:@selector(parser:DidParsedData:)]){
            [self.delegate parser:self DidParsedData:data];
        }
        
    }
    return YES;
}

@end
