//
//  HotelDetailViewController.h
//  JinJiangHotel
//
//  Created by Rong Hao on 13-8-20.
//  Copyright (c) 2013年 jinjiang. All rights reserved.
//

#import "JJViewController.h"
#import "JJHotel.h"
#import "HotelRoomHelper.h"

@interface HotelDetailViewController : JJViewController <JJNavigationBarDelegate, UITableViewDataSource, UITableViewDelegate, HotelRoomHelperDelegate, UIScrollViewDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) JJHotel *hotel;
@property (weak, nonatomic) IBOutlet UIView *subDetailView;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollerView;
@property (weak, nonatomic) IBOutlet UIView *secondNaviView;
@property (weak, nonatomic) IBOutlet UIButton *roomStyleButton;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;

@property (weak, nonatomic) IBOutlet UIView *hotelInfoView;
@property (weak, nonatomic) IBOutlet UILabel *telephoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *fexLabel;
@property (weak, nonatomic) IBOutlet UITextView *hotelDetailTextView;
@property (weak, nonatomic) IBOutlet UIView *contactView;
@property (weak, nonatomic) IBOutlet UIScrollView *imagePageView;

@property (nonatomic) BOOL isFromOrder;
@end
