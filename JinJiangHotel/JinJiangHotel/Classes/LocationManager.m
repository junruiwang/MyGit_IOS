//
//  LocationManager.m
//  JinJiangTravalPlus
//
//  Created by jerry on 12-11-8.
//  Copyright (c) 2012年 Leon. All rights reserved.
//

#import "LocationManager.h"
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
    CLGeocoder *reverseGeocoder = [[CLGeocoder alloc] init];
    
    [reverseGeocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error)
     {
         NSLog(@"reverse called!");
         if (error){
             NSLog(@"Geocode failed with error: %@", error);
             return;
         }
         
         NSLog(@"Received placemarks: %@", placemarks);
         
         
         CLPlacemark *myPlacemark = [placemarks objectAtIndex:0];
         NSDictionary *locateDict = myPlacemark.addressDictionary;
         NSString *cityName = [locateDict objectForKey:@"State"];
         cityName = [cityName stringByReplacingOccurrencesOfString:@"市" withString:@""];
         
         NSLog(@"城市名称：%@",cityName);
         TheAppDelegate.locationInfo.cityName = cityName;
         self.isLocationOver = YES;
         self.userPosition = newLocation.coordinate;
         TheAppDelegate.locationInfo.currentPoint = self.userPosition;
        
         //推送通知
         [[NSNotificationCenter defaultCenter] postNotificationName:@"locationCurrentFinished" object:self userInfo:nil];
     }];
    
    
    

}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSString *errorMessage = (error.code == kCLErrorDenied) ? @"用户拒绝访问，请打开定位服务" : @"无法确定当前位置";
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"获取位置信息出错" message:errorMessage
                                                       delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}

#pragma mark - GDataXMLParserDelegate

- (void)parser:(GDataXMLParser*)parser DidFailedParseWithMsg:(NSString*)msg errCode:(NSInteger)code
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"获取位置信息出错" message:@"无法连接到网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}

- (void)parser:(GDataXMLParser*)parser DidParsedData:(NSDictionary *)data
{
    NSDictionary *placemark = [data valueForKey:@"result"];
    NSString *cityName = [placemark valueForKeyPath:@"addressComponent.city"];
    
    cityName = [cityName stringByReplacingOccurrencesOfString:@"市" withString:@""];

    NSLog(@"城市名称：%@",cityName);
    TheAppDelegate.locationInfo.cityName = cityName;
    //推送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"locationCurrentFinished" object:self userInfo:nil];
}

@end
