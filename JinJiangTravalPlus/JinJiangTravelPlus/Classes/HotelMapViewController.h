//
//  HotelMapViewController.h
//  JinJiangTravelPlus
//
//  Created by 吕 硕 on 12-12-18.
//  Copyright (c) 2012年 JinJiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "JJViewController.h"

#pragma mark - HotelMapViewController

@interface HotelMapViewController : JJViewController<NSURLConnectionDataDelegate, MKMapViewDelegate>
{
    NSMutableArray* _routes;
    double _currentLatitude;
    double _currentLongitude;
}

@property(nonatomic, strong)NSString* hotelName;
@property(nonatomic, strong)NSString* hotelAddress;
@property(nonatomic, strong)MKMapView* mapView;
@property(nonatomic, strong, readonly)NSMutableArray* routes;
@property(nonatomic)double hotelLatitude;
@property(nonatomic)double hotelLongitude;

+ (BOOL)isLatitude:(double)latitude andLongitude:(double)longitude inRegion:(MKCoordinateRegion)region;

@end
