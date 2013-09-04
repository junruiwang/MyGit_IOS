//
//  HotelListViewController.h
//  JinJiangTravalPlus
//
//  Created by Leon on 11/7/12.
//  Copyright (c) 2012 Leon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "HotelListParser.h"
#import "JJMoreFooter.h"
#import "ConditionView.h"
#import "HotelFilterViewController.h"
#import "JJViewController.h"
#import "Constants.h"
#import "Desitination.h"

@interface HotelListViewController : JJViewController<UITableViewDataSource, UITableViewDelegate, MKMapViewDelegate, HotelFilterViewDelegate>
{
    UIButton* list_Btn; BOOL isListView;
    UILongPressGestureRecognizer* longPress;
}

@property (weak, nonatomic) IBOutlet UILabel *checkInDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *checkOutDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *hotelCountLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *priceOrderButton;
@property (weak, nonatomic) IBOutlet UIButton *distanceOrderButton;
@property (weak, nonatomic) IBOutlet UILabel *noResultLabel;
@property (weak, nonatomic) IBOutlet UIButton *fileterButton;
@property (strong, nonatomic) HotelFilterViewController *filterViewController;
@property (strong, nonatomic) MKMapView* mapView;
@property (nonatomic, strong) Desitination *poi;
@property (nonatomic, strong) NSMutableArray *hotelsArray;

@property (nonatomic, strong) HotelListParser *hotelListParser;

@property (nonatomic, strong) ConditionView *conditionView;

- (IBAction)orderButtonTapped:(id)sender;
- (IBAction)showFilterView:(id)sender;

@end
