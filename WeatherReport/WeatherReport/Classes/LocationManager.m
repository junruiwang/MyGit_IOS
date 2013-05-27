//
//  LocationManager.m
//  JinJiangTravalPlus
//
//  Created by jerry on 12-11-8.
//  Copyright (c) 2012年 Leon. All rights reserved.
//

#import "LocationManager.h"
#import "AppDelegate.h"
#import "Constants.h"

@interface LocationManager ()

@end

@implementation LocationManager
{
    //统计定位次数
    NSUInteger locationCount;
}

- (id)init
{
    if (self = [super init])
    {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
        self.locationManager.distanceFilter = 1000.0f;
        self.locationParser = [[LocationParser alloc] init];
        self.locationParser.delegate = self;
        locationCount = 0;
    }

    return self;
}

- (void)startLocation
{
    if (!self.isLocationOver) {
        [self.locationManager startUpdatingLocation];
        locationCount +=1;
        [self performSelector:@selector(stopUpdatingLocation:) withObject:nil afterDelay:10];
    }
}

- (void)stopUpdatingLocation:(NSString *)state
{
    [self.locationManager stopUpdatingLocation];
    if (TheAppDelegate.locationInfo.cityName == nil && locationCount <2)
    {   [self startLocation];   }
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    self.isLocationOver = YES;
    self.userPosition = newLocation.coordinate;
    NSString *coordinateString = [NSString stringWithFormat: @"%lf,%lf", self.userPosition.latitude, self.userPosition.longitude];
    TheAppDelegate.locationInfo.currentPoint = self.userPosition;
    
    [self.locationParser reverseGeocodingPosition:coordinateString];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSString *errorMessage = (error.code == kCLErrorDenied) ? @"用户拒绝访问，请打开定位服务" : @"无法确定当前位置";
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"获取位置信息出错" message:errorMessage
                                                       delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}

#pragma mark - BaseParserDelegate

- (void)parser:(BaseParser *)parser DidFailedParseWithMsg:(NSString*)msg errCode:(NSInteger)code
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"获取位置信息出错" message:@"无法连接到网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}

- (void)parser:(BaseParser *)parser DidParsedData:(NSDictionary *)data
{
    NSDictionary *placemark = [data valueForKey:@"result"];
    NSString *cityName = [placemark valueForKeyPath:@"addressComponent.city"];
    NSString *provinceName = [placemark valueForKeyPath:@"addressComponent.province"];
    
    cityName = [cityName stringByReplacingOccurrencesOfString:@"市" withString:@""];
    
    if ([provinceName rangeOfString:@"黑龙江"].length > 0 || [provinceName rangeOfString:@"内蒙古"].length > 0) {
        provinceName = [provinceName substringToIndex:3];
    } else {
        provinceName = [provinceName substringToIndex:2];
    }

    NSLog(@"省份：%@, 城市名称：%@",provinceName,cityName);
    TheAppDelegate.locationInfo.cityName = cityName;
    TheAppDelegate.locationInfo.province = provinceName;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"cityList" ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    TheAppDelegate.locationInfo.searchCode = [dict valueForKey:cityName];
    
    //推送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"locationCurrentFinished" object:self userInfo:nil];
}

@end
