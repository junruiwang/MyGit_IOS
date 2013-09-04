//
//  HotelDetailsViewController.h
//  JinJiangTravelPlus
//
//  Created by Leon on 11/19/12.
//  Copyright (c) 2012 JinJiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JJHotel.h"
#import "JJStarView.h"
#import "Kal.h"
#import "KalManager.h"
#import "HotelRoomListParser.h"
#import "RoomHeadView.h"
#import "RoomDetailView.h"
#import "HotelRoomHelper.h"
#import "LvPingRatingParser.h"
#import "LoginViewController.h"
#import "HotelOverviewParser.h"
#import "Constants.h"

@interface HotelDetailsViewController : JJViewController<UITableViewDataSource, UITableViewDelegate, KalManagerDelegate,  HotelRoomHelperDelegate, LoginViewControllerDelegate, UIActionSheetDelegate>
{
    BOOL hasImages, isFaverate;
    UIButton* faverateButton;
}

@property (nonatomic, strong) JJHotel *hotel;
@property (nonatomic, strong) NSMutableArray *roomList;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *hotelImageView;
@property (weak, nonatomic) IBOutlet UILabel *hotelNameLabel;
@property (strong, nonatomic) UILabel *hotelAddressLabel;
@property (weak, nonatomic) IBOutlet JJStarView *starView;
@property (strong, nonatomic) UILabel *hotelDateLabel;

@property (strong, nonatomic) UILabel *hotelTelPhoneLabel;

@property (nonatomic, weak) IBOutlet UIControl *ratingView;
@property (nonatomic, weak) IBOutlet UILabel *ratingLabel;
@property (nonatomic, weak) IBOutlet UILabel *rankLabel;
@property (nonatomic, strong) HotelRoomListParser* hotelRoomListParser;
@property (nonatomic, strong) LvPingRatingParser* lvPingRatingParser;
@property (nonatomic, strong) HotelOverviewParser* hotelOverviewParser;
@property (nonatomic) BOOL isFromOrder;

- (IBAction)hotelNameButtonTapped:(id)sender;
- (IBAction)imageButtonClicked:(id)sender;
- (IBAction)performToLvPingRatingAction;
- (IBAction)callPhone:(id)sender;
@end
