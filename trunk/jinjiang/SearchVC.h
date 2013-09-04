//
//  SearchVC.h
//  jinjiang
//
//  Created by Jeff.Yan on 11-10-27.
//  Copyright 2011年 W+K. All rights reserved.
//
#import <MapKit/MapKit.h>
#import <UIKit/UIKit.h>

#import <Foundation/Foundation.h>
#import "JJUIViewController.h"
#import "ControlView.h"
#import "HTTPConnection.h"

#import "LeftScrollView.h"
#import "SearchLeftScrollView.h"
#import "SearchResultTVC.h"
#import "SearchLeftView.h"

@interface SearchVC:JJUIViewController <MKMapViewDelegate,CLLocationManagerDelegate,HTTPConnectionDelegate,LeftScrollViewDelegate,SearchLeftViewDelegate,UITextFieldDelegate>{
    MKMapView *myMapView;
    
    HTTPConnection *hTTPConnection;

    NSString *loadurl;
    
    SearchLeftView *searchLeftView;
    SearchLeftScrollView *searchResultBar;

    UITextField *searchTxt;
    
    
    //UILabel *nullTxt;
    
    NSArray *searchData;
    
    CLLocationCoordinate2D myCoordinate;
    CLLocationManager *myLocationManager;
    
    UIButton *myBtn;
    
    NSInteger index;
    
    UIView *seachBg;
    
    UIView *lineView;
    
    NSDictionary *cutDic;
    
    BOOL isSelect;
    
    BOOL isData;
 
    
}
-(void)seach:(NSString *)str cityName:(NSString *)cityName typeName:(NSString *)typeName;
-(void)seach:(NSString *)str;
@end
