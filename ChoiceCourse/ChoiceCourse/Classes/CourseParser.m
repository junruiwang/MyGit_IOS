//
//  CourseParser.m
//  ChoiceCourse
//
//  Created by 汪君瑞 on 12-10-30.
//  Copyright (c) 2012年 jerry. All rights reserved.
//

#import "CourseParser.h"
#import "SBJson.h"

@implementation CourseParser

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
