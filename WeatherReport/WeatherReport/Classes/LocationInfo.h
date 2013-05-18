//
//  LocationInfo.h
//  JinJiangTravalPlus
//
//  Created by 汪君瑞 on 12-11-12.
//  Copyright (c) 2012年 Leon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationInfo : NSObject

@property(nonatomic, copy) NSString *cityName;
@property(nonatomic, copy) NSString *searchCode;
@property(nonatomic, assign) CLLocationCoordinate2D currentPoint;

@end
