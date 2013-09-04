//
//  PointsHistoryParser.m
//  JinJiangTravelPlus
//
//  Created by 胡 桂祁 on 7/17/13.
//  Copyright (c) 2013 JinJiang. All rights reserved.
//

#import "PointsHistoryParser.h"
#import "PointsHistory.h"

@implementation PointsHistoryParser

- (BOOL)parseXmlString:(NSString *)xmlString
{
    if ([super parseXmlString:xmlString])
    {
        NSError *error;
        GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithXMLString:xmlString options:0 error:&error];
        GDataXMLElement *rootElement = [document rootElement];
        GDataXMLNode *codeNode = [rootElement attributeForName:kKeyCode];
        NSString *code = [codeNode stringValue];
        if ([@"0" isEqualToString:code])
        {
           NSString *usablePoints = [[rootElement elementsForName:kKeyUsablePoints][0] stringValue];
            NSString *usedPoints = [[rootElement elementsForName:kKeyUsedPoints][0] stringValue];
            NSString *month = [[rootElement elementsForName:kKeyMonth][0] stringValue];
            NSString *addPoints = [[rootElement elementsForName:kKeyAddPoints][0] stringValue];
            
            PointsHistory *pointsHistory = [[PointsHistory alloc] init];
            pointsHistory.usePoints = usedPoints;
            pointsHistory.remainPoints = usablePoints;
            pointsHistory.month = month;
            pointsHistory.addPoints = addPoints;
            NSDictionary *data = @{@"pointsHistory" : pointsHistory};
            if (self.delegate != nil && [self.delegate respondsToSelector:@selector(parser:DidParsedData:)])
                [self.delegate parser:self DidParsedData:data];
        }else{
            NSString *message = [[rootElement elementsForName:kKeyMessage][0] stringValue];
            if (self.delegate != nil && [self.delegate respondsToSelector:@selector(parser:DidFailedParseWithMsg:)])
                [self.delegate parser:self DidFailedParseWithMsg:message errCode:[code intValue]];
            return NO;
        }
    }
    return YES;
}


-(void)loadHistoryPointsRecentMonth{
    self.serverAddress = kHistoryPointsURL;
    [self start];
    
//    PointsHistory *pointsHistory = [[PointsHistory alloc] init];
//    pointsHistory.usePoints = @"40";
//    pointsHistory.remainPoints = @"50";
//    pointsHistory.month = @"2013-1";
//    pointsHistory.addPoints = @"30";
//    NSDictionary *data = @{@"pointsHistory" : pointsHistory};
//    [self.delegate parser:self DidParsedData:data];
}

@end
