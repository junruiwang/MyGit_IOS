//
//  AreaListHandle.m
//  JinJiangTravelPlus
//
//  Created by 胡 桂祁 on 11/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AreaListHandle.h"
#import "AreaListParser.h"
#import "FileManager.h"
#import "AreaInfo.h"
#import "AreaListViewController.h"
#import "Constants.h"

@interface AreaListHandle (PrivateMethod)

@end

@implementation AreaListHandle

- (void)writeAreaListToFile:areas
{
    NSLog(@"%s writeAreaListToFile...", __FUNCTION__);
    if ([areas count] == 0) {   return; }

    NSString* path = [FileManager fileCachesPath:@"areaList.plist"];

    NSMutableArray* areaArray = [[NSMutableArray alloc] initWithCapacity:300];
    for (AreaInfo *area in areas)
    {
        if (area.name == nil) { continue;   }
        NSDictionary* tempDict = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:area.name, nil]
                                                             forKeys:[NSArray arrayWithObjects:@"Name", nil]];
        [areaArray addObject:tempDict];
    }
    NSString *cityName = TheAppDelegate.hotelSearchForm.cityName;
    if (cityName == nil || [@"" isEqualToString:cityName]) {    return; }
    NSDictionary *sourceDict = [NSDictionary dictionaryWithObject:areaArray forKey:cityName];
    BOOL res = [sourceDict writeToFile:path atomically:YES];
    if (res == YES) {   [[NSUserDefaults standardUserDefaults] synchronize];    }
//  NSLog(@"%s save city list to path %@ result: %d", __FUNCTION__, path, res);
}

- (NSMutableArray *)unBoxingDictToAreaList:(NSArray *)dictArray
{
    NSMutableArray* areaArray = [[NSMutableArray alloc] initWithCapacity:700];
    for (NSDictionary* tempDict in dictArray)
    {
        AreaInfo *areaInfo = [[AreaInfo alloc] init];
        [areaInfo setName:[tempDict valueForKey:@"Name"]];
        [areaArray addObject:areaInfo];
    }
    return areaArray;
}

- (NSMutableArray *)readAreaListFromLocalFile
{
    NSString* path = [FileManager fileCachesPath:@"arealist.plist"];

    NSDictionary* dict = [[NSDictionary alloc] initWithContentsOfFile:path];
    NSArray* areaArray = [dict objectForKey:TheAppDelegate.hotelSearchForm.cityName];

    if (areaArray.count == 0) {
        return NO;
    }
    NSMutableArray* areas = [self unBoxingDictToAreaList:areaArray];

    return areas;
}

- (void)downLoadAreaList
{
    NSString* paramStr = [NSString stringWithFormat:@"cityName=%@", TheAppDelegate.hotelSearchForm.cityName];
    self.areaListParser = [[AreaListParser alloc] init];
    self.areaListParser.isHTTPGet = NO;
    self.areaListParser.serverAddress = kAreaListURL;
    self.areaListParser.requestString = paramStr;
    self.areaListParser.delegate = self;
    [self.areaListParser start];
}

- (NSMutableArray *)getCacheAreas {
    NSLog(@"%s getCacheAreas...", __FUNCTION__);
    NSMutableArray * areas = [self readAreaListFromLocalFile];
    if (areas != nil && [areas count] >0) {
        return areas;
    }
    return nil;
}

-(BOOL)hasCacheAreas{
    NSMutableArray * areas = [self getCacheAreas];
    if(areas != nil && [areas count] > 0){
        [self.areaListHandleDelegate setAreaList: areas];
    }
    return (areas != nil && [areas count] > 0);
}

- (void)parser:(GDataXMLParser *)parser DidParsedData:(NSDictionary *)data {
    NSMutableArray *areas = [data objectForKey:@"areas"];
    areas=areas==nil?[[NSMutableArray alloc] init]:areas;
    if([areas count] == 0){
        [self.areaListHandleDelegate setAreaList:areas];
        return;
    }
    [self.areaListHandleDelegate setAreaList:areas];
    [self writeAreaListToFile:areas];
}

- (void)parser:(GDataXMLParser *)parser DidFailedParseWithMsg:(NSString *)msg errCode:(NSInteger)code
{
    if(code == -1 || code == 10000)
    {   [self showAlertMessageWithOkCancelButton:kNetworkProblemAlertMessage title:nil tag:0 delegate:self];
    }
    else
    {   [self showAlertMessageWithOkButton:msg title:nil tag:0 delegate:nil];   }
}


-(void)buildAreas{
    if([self hasCacheAreas]){
        return;
    }
    [self downLoadAreaList];
}

- (void)showAlertMessageWithOkCancelButton:(NSString *)msg title:(NSString *)title tag:(NSInteger)tag delegate:(id)delegate
{
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:title
                              message:msg
                              delegate:delegate
                              cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                              otherButtonTitles:NSLocalizedString(@"Ok", nil), nil];
    alertView.tag = tag;
    [alertView show];
}

- (void)showAlertMessageWithOkButton:(NSString *)msg title:(NSString *)title tag:(NSInteger)tag delegate:(id)delegate
{
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:title
                              message:msg
                              delegate:delegate
                              cancelButtonTitle:NSLocalizedString(@"Ok", nil)
                              otherButtonTitles:nil];
    alertView.tag = tag;
    [alertView show];
}

@end
