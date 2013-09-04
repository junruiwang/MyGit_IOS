//
//  AreaListParser.m
//  JinJiangTravelPlus
//
//  Created by 胡 桂祁 on 11/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AreaListParser.h"
#import "GDataXMLNode.h"
#import "AreaInfo.h"

@interface AreaListParser(PrivateParser)

@property (strong,nonatomic) NSMutableArray *areaList;

@end

@implementation AreaListParser


- (BOOL)parseXmlString:(NSString *)xmlString
{
    if ([super parseXmlString:xmlString])
    {
        NSError *error;
        GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithXMLString:xmlString options:0 error:&error];
        GDataXMLElement *rootElement = [document rootElement];

        NSArray *areaListNodes = [rootElement elementsForName:@"areaList"];
        NSMutableArray *areas = [[NSMutableArray alloc] initWithCapacity:100];
        if ([self notExistNodes:areaListNodes])
        {
            [self callBackAreaListViewController:areas];
            return NO;
        }

        GDataXMLElement* areaListElement = areaListNodes[0];
        NSArray* areaList = [areaListElement elementsForName:@"area"];

        if ([self notExistNodes:areaList])
        {
            [self callBackAreaListViewController:areas];
            return NO;
        }

        AreaInfo *areaInfo;
        for (GDataXMLElement *areaInfoElement in areaList)
        {
            NSString *name = [[areaInfoElement elementsForName:@"name"][0] stringValue];
            areaInfo = [[AreaInfo alloc] init];
            areaInfo.name = name;
            [areas addObject:areaInfo];
        }
        [self callBackAreaListViewController:areas];
    }
    return YES;
}

- (BOOL)notExistNodes:(NSArray *)listNodes
{
    return (listNodes == nil || [listNodes count] == 0);
}

- (void)callBackAreaListViewController:(NSMutableArray *)areas
{
    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:areas, @"areas", nil];
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(parser:DidParsedData:)])
    {   [self.delegate parser:self DidParsedData:data]; }
}

//解决通过查询城市区域出现网络错误时无响应问题
//- (void)cancel{
//    [super cancel];
//    if(self.areaList !=nil && [self.areaList count]>0){
//        [self callBackAreaListViewController:self.areaList];
//    }

//}

@end
