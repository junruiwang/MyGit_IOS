//
//  FaverateHotelManager.m
//  JinJiangTravelPlus
//
//  Created by jerry on 13-3-8.
//  Copyright (c) 2013年 JinJiang. All rights reserved.
//

#import "FaverateHotelManager.h"
#import "FileManager.h"

@interface FaverateHotelManager ()

- (NSMutableArray *) readFaverateHotelListFromLocalFile;

@end

@implementation FaverateHotelManager

- (BOOL)insertIntoFaverateWithHote:(NSDictionary *)hotel
{
    NSString *path = [FileManager fileCachesPath:@"FaverateHotelList.plist"];
    
    NSMutableArray *hotelArray = [self readFaverateHotelListFromLocalFile];
    if (hotelArray == nil) {
        hotelArray = [[NSMutableArray alloc] initWithCapacity:20];
    }
    [hotelArray addObject:hotel];
    
    BOOL res = [hotelArray writeToFile: path atomically:YES];
    if (res == YES) {
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    return res;
    
}
- (BOOL)isHotelInFaverate:(NSString *)hotelId
{
    NSMutableArray *hotelArray = [self readFaverateHotelListFromLocalFile];
    if (hotelArray) {
        for (NSDictionary *hotel in hotelArray) {
            NSString *favHotelId = [hotel valueForKey:@"hotelId"];
            if ([hotelId caseInsensitiveCompare:favHotelId] == NSOrderedSame) {
                return YES;
            }
        }
    }
    return NO;
}
- (BOOL)deleteFromHotelInFaverate:(NSString *)hotelId
{
    NSMutableArray *hotelArray = [self readFaverateHotelListFromLocalFile];
    if (hotelArray) {
        for (int i=0; i<hotelArray.count; i++) {
            NSDictionary *hotel = hotelArray[i];
            NSString *favHotelId = [hotel valueForKey:@"hotelId"];
            if ([hotelId caseInsensitiveCompare:favHotelId] == NSOrderedSame) {
                [hotelArray removeObjectAtIndex:i];
                break;
            }
        }
    }
    
    NSString *path = [FileManager fileCachesPath:@"FaverateHotelList.plist"];
    return [hotelArray writeToFile: path atomically:YES];
}

- (void)selectDistinctCityIntoArray:(NSMutableArray *)array
{
    NSMutableArray *hotelArray = [self readFaverateHotelListFromLocalFile];
    NSMutableSet *citySet = [NSMutableSet setWithCapacity:10];
    
    if (hotelArray) {
        for (NSDictionary *hotel in hotelArray) {
            [citySet addObject:[hotel valueForKey:@"cityName"]];
        }
    }
    [array removeAllObjects];
    [array addObjectsFromArray:[citySet allObjects]];
}

- (void)selectHotelsInFaverateByCity:(NSString *)cityName intoArray:(NSMutableArray *)array
{
    [array removeAllObjects];
    NSMutableArray *hotelArray = [self readFaverateHotelListFromLocalFile];
    if (hotelArray) {
        for (NSDictionary *hotel in hotelArray) {
            NSString *favCityName = [hotel valueForKey:@"cityName"];
            if ([cityName caseInsensitiveCompare:favCityName] == NSOrderedSame) {
                [array addObject:hotel];
            }
        }
    }
}

- (NSMutableArray *) readFaverateHotelListFromLocalFile
{
    NSString *path = [FileManager fileCachesPath:@"FaverateHotelList.plist"];
    return [[NSMutableArray alloc] initWithContentsOfFile:path];
}

@end
