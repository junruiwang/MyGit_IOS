//
//  HotelSearchMapController.h
//  JinJiangTravelPlus
//
//  Created by 吕 硕 on 12-12-20.
//  Copyright (c) 2012年 JinJiang. All rights reserved.  searchMap
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "JJViewController.h"
#import "HotelAnnotation.h"
#import "ParameterManager.h"
#import "HotelListParser.h"
#import "JJHotel.h"
#import "JJMapView.h"

@interface HotelSearchMapController : JJViewController<MKMapViewDelegate, CLLocationManagerDelegate,
                                                       UITableViewDataSource, UITableViewDelegate,
                                                        GDataXMLParserDelegate>
{
    double _searchLatitude;
    double _searchLongitude;
    double _currentLatitude;
    double _currentLongitude;
    CLLocationManager* _locationManager;
    NSMutableDictionary* _downloaders;

    dispatch_queue_t _serialQueue;
    BOOL needUpDateData, isListView, userLocEnabled;
    UIButton* list_Btn; float _iOS_version;

    UILongPressGestureRecognizer* longPress;
    HotelAnnotation* pressPlace;
}

@property(nonatomic, readonly)double searchLatitude;
@property(nonatomic, readonly)double searchLongitude;
@property(nonatomic, strong, readonly) CLLocationManager* locationManager;
@property(nonatomic, strong) JJMapView* mapView;
@property(nonatomic, strong) UITableView* tableView;
@property(nonatomic, strong) NSMutableArray* hotelsArray;
@property(nonatomic, strong) NSMutableArray* annotiArray;

@property(nonatomic, strong) ParameterManager* parameterManager;
@property(nonatomic, strong) HotelListParser* hotelListParser;

@end
