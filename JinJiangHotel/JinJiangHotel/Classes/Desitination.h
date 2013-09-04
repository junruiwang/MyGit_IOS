//
//  Desitination.h
//  JinJiangTravelPlus
//
//  Created by jerry on 13-3-6.
//  Copyright (c) 2013年 JinJiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Desitination : NSObject<MKAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, copy) NSString *title;

- (id)initWithCoords:(CLLocationCoordinate2D) coords;

@end
