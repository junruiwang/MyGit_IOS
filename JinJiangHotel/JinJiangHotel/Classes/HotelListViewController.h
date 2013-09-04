//
//  HotelListViewController.h
//  JinJiangHotel
//
//  Created by 胡 桂祁 on 8/16/13.
//  Copyright (c) 2013 jinjiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JJViewController.h"
#import "Desitination.h"
#import "HotelListParser.h"
#import "HotelTableCell.h"

@interface HotelListViewController :JJViewController<UITableViewDataSource, UITableViewDelegate,MKMapViewDelegate>
{
    BOOL isHotelListFlag;
    BOOL isOpenRightBtn;
}

@property (nonatomic, strong) NSMutableArray *hotelsArray;

@property (weak, nonatomic) IBOutlet UIButton *priceOrderButton;
@property (weak, nonatomic) IBOutlet UIButton *distanceOrderButton;
@property (weak, nonatomic) IBOutlet UIButton *starOrderButton;
@property (strong, nonatomic) IBOutlet UIButton *mapListButton;

@property (nonatomic,weak) IBOutlet UITableView *hotelTableView;
@property (weak, nonatomic) IBOutlet UILabel *noResultLabel;
@property (weak, nonatomic) IBOutlet UIView *filterView;
@property (nonatomic,weak) IBOutlet UILabel *hotelCountLabel;
@property(nonatomic,weak) IBOutlet MKMapView *mapView;
@property(nonatomic,weak) IBOutlet UILongPressGestureRecognizer* longPress;

@property (nonatomic, strong) HotelListParser *hotelListParser;
@property (nonatomic, strong) NSMutableArray *mapAnnotations;

@property (nonatomic, strong) Desitination *poi;

- (IBAction)orderButtonTapped:(id)sender;

-(IBAction)showMaplList:(id)sender;

-(IBAction)handleLongPress:(id)sender;

@end
