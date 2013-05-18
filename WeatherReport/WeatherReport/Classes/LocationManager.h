//
//  LocationManager.h
//  JinJiangTravalPlus
//
//  Created by jerry on 12-11-8.
//  Copyright (c) 2012年 Leon. All rights searchButtonTapped.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "LocationParser.h"

@interface LocationManager : NSObject <CLLocationManagerDelegate, BaseParserDelegate>

@property(nonatomic, assign) BOOL isLocationOver;
@property(nonatomic, retain) CLLocationManager *locationManager;
@property(nonatomic, assign) CLLocationCoordinate2D userPosition;
@property(nonatomic, retain) LocationParser *locationParser;

- (void)stopUpdatingLocation:(NSString *)state;
- (void)startLocation;

@end

