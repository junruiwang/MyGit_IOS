//
//  SingleLineTimeParser.m
//  Bustime
//
//  Created by 汪君瑞 on 13-4-5.
//  Copyright (c) 2013年 Jerry Wang. All rights reserved.
//

#import "SingleLineTimeParser.h"
#import "BusSingleLine.h"
#import "ValidateInputUtil.h"

@implementation SingleLineTimeParser

- (BOOL)parserJSONString:(NSString *)responseData
{
    if ([super parserJSONString:responseData]) {
        
        NSDictionary *dictionary = [responseData JSONValue];
        
        NSArray *array = [dictionary valueForKey:@"data"];
        NSMutableArray *busRunSingleArry = [[NSMutableArray alloc] initWithCapacity:10];
        
        for (NSDictionary *dict in array)
        {
            BusSingleLine *busSingleLine = [[BusSingleLine alloc] init];
            busSingleLine.standCode = [ValidateInputUtil valueOfObjectToString:[dict objectForKey:@"code"]];
            busSingleLine.time = [ValidateInputUtil valueOfObjectToString:[dict objectForKey:@"value"]];
            [busRunSingleArry addObject:busSingleLine];
        }
        NSDictionary *data = @{@"data":busRunSingleArry};
        if(self.delegate != nil && [self.delegate respondsToSelector:@selector(parser:DidParsedData:)]){
            [self.delegate parser:self DidParsedData:data];
        }
        
    }
    return YES;
}

@end
