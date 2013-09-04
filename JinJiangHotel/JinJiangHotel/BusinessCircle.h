//
//  BusinessCircle.h
//  JinJiangTravalPlus
//
//  Created by jerry on 12-11-2.
//  Copyright (c) 2012年 Leon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MKAnnotation.h>

@interface BusinessCircle : NSObject

@property(nonatomic, strong) NSString *name;
@property(nonatomic, assign) CLLocationCoordinate2D coordinate;


@end
