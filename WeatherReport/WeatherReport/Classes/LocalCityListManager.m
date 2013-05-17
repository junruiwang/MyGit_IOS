//
//  LocalCityListManager.m
//  WeatherReport
//
//  Created by jerry on 13-5-17.
//  Copyright (c) 2013年 jerry. All rights reserved.
//

#import "LocalCityListManager.h"
#import "FileManager.h"


@interface LocalCityListManager ()

- (NSMutableArray *) readFaverateCityFromLocalFile;

@end

@implementation LocalCityListManager

- (BOOL)insertIntoFaverateWithCity:(City *) city
{
    NSString *path = [FileManager fileCachesPath:@"FaverateCity.plist"];
    
    NSMutableArray *cityArray = [self readFaverateCityFromLocalFile];
    if (cityArray == nil) {
        cityArray = [[NSMutableArray alloc] initWithCapacity:20];
    }
    BOOL hasCity = NO;
    for (NSInteger i=0; i < [cityArray count]; i++) {
        NSData *data = [cityArray objectAtIndex:i];
        City *currentCity = [City unarchived:data];
        if ([city.cityName caseInsensitiveCompare:currentCity.cityName] == NSOrderedSame) {
            hasCity = YES;
            break;
        }
    }
    
    if (!hasCity) {
        [cityArray addObject:[city archived]];
    }
    
    return [cityArray writeToFile: path atomically:YES];
}

- (BOOL)deleteCityInFaverate:(NSString *) cityName
{
    NSMutableArray *cityArray = [self readFaverateCityFromLocalFile];
    if (cityArray) {
        for (NSInteger i=0; i < [cityArray count]; i++) {
            NSData *data = [cityArray objectAtIndex:i];
            City *city = [City unarchived:data];
            if ([cityName caseInsensitiveCompare:city.cityName] == NSOrderedSame) {
                [cityArray removeObjectAtIndex:i];
                break;
            }
        }
    }
    NSString *path = [FileManager fileCachesPath:@"FaverateCity.plist"];
    return [cityArray writeToFile: path atomically:YES];
}

- (void)buildLocalFileToArray:(NSMutableArray *) cityArray
{
    NSMutableArray *localCityArray = [self readFaverateCityFromLocalFile];
    [cityArray removeAllObjects];
    
    if (localCityArray) {
        for (NSInteger i=0; i < [localCityArray count]; i++) {
            NSData *data = [localCityArray objectAtIndex:i];
            City *city = [City unarchived:data];
            [cityArray addObject:city];
        }
    }
}

- (NSMutableArray *) readFaverateCityFromLocalFile
{
    NSString *path = [FileManager fileCachesPath:@"FaverateCity.plist"];
    return [[NSMutableArray alloc] initWithContentsOfFile:path];
}

@end
