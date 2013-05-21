//
//  SqliteService.h
//  WeatherReport
//
//  Created by 汪君瑞 on 13-5-19.
//  Copyright (c) 2013年 jerry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "ModelWeather.h"

#define kFilename @"Localweather.sql"

@interface SqliteService : NSObject
{
    sqlite3 *_database;
}
@property (nonatomic) sqlite3 *_database;
//创建数据库
- (BOOL) CreatTable:(sqlite3 *)db;
//插入数据
- (BOOL) insertModel:(ModelWeather *)modelWeather;
//删除数据
- (BOOL)deleteWeatherModel:(NSString *)cityName;
//更新数据
- (BOOL)updateWeatherModel:(ModelWeather *)modelWeather;
//获取全部数据
- (NSMutableArray *)getWeatherModelArray;
//排序
- (void)sortWeatherModelArray:(NSMutableArray *)cityArray;

@end
