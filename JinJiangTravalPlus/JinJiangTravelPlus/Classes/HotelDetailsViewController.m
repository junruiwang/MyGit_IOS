//
//  HotelDetailsViewController.m
//  JinJiangTravelPlus
//
//  Created by Leon on 11/19/12.
//  Copyright (c) 2012 JinJiang. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "HotelDetailsViewController.h"
#import "UIImageView+WebCache.h"
#import "HotelRoomHelper.h"
#import "ParameterManager.h"
#import "HotelBookInputViewController.h"
#import "HotelOverviewViewController.h"
#import "LvPingHotelRating.h"
#import "HotelPriceConfirmForm.h"
#import "LvPingRatingViewController.h"
#import "HotelImagesController.h"
#import "HotelMapViewController.h"
#import "JJHotelRoom.h"
#import "JJPlan.h"
#import "FaverateHotelManager.h"
#import "HotelTableCell.h"

@interface HotelDetailsViewController ()

@property (nonatomic, strong) KalManager *kalManager;
@property (nonatomic, strong) HotelRoomHelper *hotelRoomHelper;
@property (nonatomic, strong) LvPingHotelRating *lvPingHotelRating;
@property (nonatomic, strong) HotelPriceConfirmForm *hotelPriceConfirmForm;
@property (nonatomic, strong) HotelPriceConfirmForm *rcardPriceConfirmForm;
@property (nonatomic, strong) LoginViewController *loginViewController;
@property (nonatomic, assign) NSInteger roomOrPlanId;
@property (nonatomic, assign) BOOL roomIsloadOver;
@property (nonatomic, assign) BOOL hotelIsloadOver;
@property (nonatomic, strong) FaverateHotelManager *faverateHotelManager;

- (void)faverateButtonClicked:(id)sender;
- (void)setHotelBaseInfo;

@end

@implementation HotelDetailsViewController

@synthesize hotelOverviewParser;
@synthesize isFromOrder;


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _roomList = [[NSMutableArray alloc] init];
        _hotelRoomHelper = [[HotelRoomHelper alloc] init];
        _hotelRoomHelper.delegate = self;
        _faverateHotelManager = [[FaverateHotelManager alloc] init];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.trackedViewName = @"酒店概览页面";
    [super viewWillAppear:animated];

}

- (void)viewDidLoad
{
    [super viewDidLoad];    hasImages = YES;
	// Do any additional setup after loading the view.
    self.kalManager = [[KalManager alloc] initWithViewController:self];
    [self.kalManager setDelegate:self];
    [self.ratingView setHidden:YES];
    
    self.hotelAddressLabel = [[UILabel alloc] initWithFrame:CGRectMake(27, 5, 230, 21)];
    self.hotelTelPhoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 5, 230, 21)];
    self.hotelDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(27, 5, 230, 21)];
    [self setHotelBaseInfo];
    
    [self.hotelNameLabel sizeToFit];
    CGFloat width = self.hotelNameLabel.frame.size.width;
    CGFloat actualWidth = 170;
    if (width > actualWidth)
    {
        CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"position.x"];
        CGFloat totalTime = (width - actualWidth)/25 + 3;
        animation.duration = totalTime;
        animation.fillMode = kCAFillModeForwards;
        animation.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:width / 2],
                            [NSNumber numberWithFloat:width / 2],
                            [NSNumber numberWithFloat:actualWidth - width / 2],
                            [NSNumber numberWithFloat:actualWidth - width / 2],
                            [NSNumber numberWithFloat:width / 2], nil];
        animation.keyTimes = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0],
                              [NSNumber numberWithFloat:1/totalTime],
                              [NSNumber numberWithFloat:1/totalTime + ((totalTime - 2) / (totalTime * 2))],
                              [NSNumber numberWithFloat:2/totalTime + ((totalTime - 2) / (totalTime * 2))],
                              [NSNumber numberWithFloat:1.0], nil];
        animation.removedOnCompletion = NO;
        animation.repeatCount = HUGE_VALF;  //forever
        [self.hotelNameLabel.layer addAnimation:animation forKey:nil];
    }
}

- (void)addRightBarButton
{
    NSString* hotelID = [NSString stringWithFormat:@"%d", self.hotel.hotelId];
    isFaverate = [self.faverateHotelManager isHotelInFaverate:hotelID];
    
    if (isFaverate == YES)
    {
        faverateButton = [self generateNavButton:@"heart_icon_red.png"
                                          action:@selector(faverateButtonClicked:)];
        faverateButton.frame = CGRectMake(0, 0, 40, 44);
        
        UIBarButtonItem *fullBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:faverateButton];
        self.navigationItem.rightBarButtonItem = fullBarButtonItem;
    }
    else
    {
        faverateButton = [self generateNavButton:@"heart_icon.png"
                                          action:@selector(faverateButtonClicked:)];
        faverateButton.frame = CGRectMake(0, 0, 40, 44);
        UIBarButtonItem *fullBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:faverateButton];
        self.navigationItem.rightBarButtonItem = fullBarButtonItem;
    }
}

- (void)faverateButtonClicked:(id)sender
{
    NSString* hotelID = [NSString stringWithFormat:@"%d", self.hotel.hotelId];
    NSString* brandID = [NSString stringWithFormat:@"%d", self.hotel.brand];

    if (isFaverate == YES)
    {
        [self.faverateHotelManager deleteFromHotelInFaverate:hotelID];
        [faverateButton setImage:[UIImage imageNamed:@"heart_icon.png"] forState:UIControlStateNormal];
    }
    else
    {
        NSDictionary *hotel = [NSDictionary dictionaryWithObjects:
                                  [NSArray arrayWithObjects: self.hotelNameLabel.text, hotelID, self.hotel.cityName, brandID, nil]
                                                             forKeys:[NSArray arrayWithObjects:@"hotelName", @"hotelId", @"cityName", @"brand", nil]];
        [self.faverateHotelManager insertIntoFaverateWithHote:hotel];
        [faverateButton setImage:[UIImage imageNamed:@"heart_icon_red.png"] forState:UIControlStateNormal];
    }
    isFaverate = !isFaverate;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    self.tableView = nil;
    [super viewDidUnload];
}

- (void)setHotelRatingControl
{
    if (self.lvPingHotelRating.hotelRate && ![self.lvPingHotelRating.hotelRate isEqualToString:@""])
    {
        self.ratingLabel.text = self.lvPingHotelRating.hotelRate;
        self.rankLabel.text = self.lvPingHotelRating.hotelRank;
        self.ratingView.hidden = NO;
    }
}

- (void)setHotelBaseInfo
{
    [self.hotelNameLabel setText:self.hotel.name];
    NSURL* url = [NSURL URLWithString:self.hotel.imageUrl];
    NSData* imgData = [NSData dataWithContentsOfURL:url];
    [self.hotelImageView setBackgroundImage:[UIImage imageWithData:imgData] forState:UIControlStateNormal];
    [self.hotelAddressLabel setText:self.hotel.address];
    
    [self.hotelTelPhoneLabel setText:self.hotel.telphone];
    [self.starView setStar:self.hotel.star];
}

- (void)downloadData
{
    self.roomIsloadOver = NO;
    self.hotelIsloadOver = NO;

    [self showIndicatorView];
    
    {
        if (!self.hotelOverviewParser)
        {
            self.hotelOverviewParser = [[HotelOverviewParser alloc] init];
            self.hotelOverviewParser.isHTTPGet = NO;
            self.hotelOverviewParser.serverAddress = [kHotelOverviewURL stringByAppendingPathComponent:
                                                      [NSString stringWithFormat:@"%d", self.hotel.hotelId]];
        }

        [self.hotelOverviewParser setDelegate:self];
        [self.hotelOverviewParser start];
    }

    {
        if (!self.hotelRoomListParser)
        {
            self.hotelRoomListParser = [[HotelRoomListParser alloc] init];
            self.hotelRoomListParser.serverAddress = kHotelPricePlanURL;
        }

        ParameterManager *parameterManager = [[ParameterManager alloc] init];
        [parameterManager parserIntegerWithKey:@"hotelId" WithValue:self.hotel.hotelId];
        [parameterManager parserIntegerWithKey:@"roomCount" WithValue:1];
        [parameterManager parserStringWithKey:@"dateCheckIn"
                                    WithValue:[TheAppDelegate.hotelSearchForm.checkinDate chineseDescription]];
        [parameterManager parserStringWithKey:@"dateCheckOut"
                                    WithValue:[TheAppDelegate.hotelSearchForm.checkoutDate chineseDescription]];
        [self.hotelRoomListParser setRequestString:[parameterManager serialization]];
        [self.hotelRoomListParser setDelegate:self];
        [self.hotelRoomListParser start];
    }

    {
        if (!self.lvPingRatingParser)
        {
            self.lvPingRatingParser = [[LvPingRatingParser alloc] init];
            self.lvPingRatingParser.serverAddress = [kHotelRatingURL stringByAppendingPathComponent:
                                                     [NSString stringWithFormat:@"%d", self.hotel.hotelId]];
        }
        [self.lvPingRatingParser setDelegate:self];
        [self.lvPingRatingParser start];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 3;
    }
    if (section == 1) {
        return [self.hotelRoomHelper.headViewList count];
    }
    
    return 0;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        id object = [self.hotelRoomHelper.headViewList objectAtIndex:indexPath.row];
        if([object isKindOfClass:[RoomDetailView class]])
        {
            cell.backgroundColor = RGBCOLOR(255, 255, 244);
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.row == 1) {
                return 36;
            }
            return 40;
        }
        case 1:
        {
            id object = [self.hotelRoomHelper.headViewList objectAtIndex:indexPath.row];
            
            if([object isKindOfClass:[RoomHeadView class]])
            {
                RoomHeadView *headView = (RoomHeadView *)object;
                return headView.frame.size.height;
            }
            else
            {
                RoomDetailView *detailView = (RoomDetailView *)object;
                return detailView.frame.size.height;
            }
            break;
        }
    }
    
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    HotelDetailTableCell *cell = [[HotelDetailTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    //cell背景色
    cell.backgroundColor = [UIColor whiteColor];
    //下降阴影
    cell.dropsShadow = NO;
    //圆弧
    cell.cornerRadius = 5;
    //选中行背景色
    cell.selectionGradientStartColor = RGBCOLOR(231, 231, 231);
    cell.selectionGradientEndColor = RGBCOLOR(231, 231, 231);
    
    switch (indexPath.section) {
        case 0:
        {
            cell.customSeparatorColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dashed_detail.png"]];
            switch (indexPath.row) {
                case 0:
                {
                    [cell prepareForTableView:tableView indexPath:indexPath];
                    UIImageView *addressImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 7, 18, 18)];
                    addressImageView.image = [UIImage imageNamed:@"hotel-address.png"];
                    [cell.contentView addSubview:addressImageView];
                    
                    self.hotelAddressLabel.backgroundColor = [UIColor clearColor];
                    self.hotelAddressLabel.font = [UIFont systemFontOfSize:14];
                    self.hotelAddressLabel.textColor = [UIColor darkGrayColor];
                    self.hotelAddressLabel.text = self.hotel.address;
                    [cell.contentView addSubview:self.hotelAddressLabel];
                    
                    UIImageView *nextImageView = [[UIImageView alloc] initWithFrame:CGRectMake(285, 10, 7, 10)];
                    nextImageView.image = [UIImage imageNamed:@"hotel-next.png"];
                    [cell.contentView addSubview:nextImageView];
                    
                    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
                    return cell;
                }
                case 1:
                {
                    [cell prepareForTableView:tableView indexPath:indexPath];
                    UIImageView *telImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 7, 18, 18)];
                    telImageView.image = [UIImage imageNamed:@"hotel-phone.png"];
                    [cell.contentView addSubview:telImageView];
                    
                    self.hotelTelPhoneLabel.backgroundColor = [UIColor clearColor];
                    self.hotelTelPhoneLabel.font = [UIFont systemFontOfSize:14];
                    self.hotelTelPhoneLabel.textColor = [UIColor darkGrayColor];
                    self.hotelTelPhoneLabel.text = self.hotel.telphone;
                    [cell.contentView addSubview:self.hotelTelPhoneLabel];
                    
                    UIImageView *nextImageView = [[UIImageView alloc] initWithFrame:CGRectMake(285, 10, 7, 10)];
                    nextImageView.image = [UIImage imageNamed:@"hotel-next.png"];
                    [cell.contentView addSubview:nextImageView];
                    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
                    return cell;
                }
                case 2:
                {
                    [cell prepareForTableView:tableView indexPath:indexPath];
                    UIImageView *dateImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 7, 18, 18)];
                    dateImageView.image = [UIImage imageNamed:@"hotel-checkin.png"];
                    [cell.contentView addSubview:dateImageView];
                    
                    self.hotelDateLabel.backgroundColor = [UIColor clearColor];
                    self.hotelDateLabel.font = [UIFont systemFontOfSize:14];
                    self.hotelDateLabel.textColor = [UIColor darkGrayColor];
                    
                    NSString *checkInDate = [TheAppDelegate.hotelSearchForm.checkinDate chineseDescription];
                    NSString *checkOutDate = [TheAppDelegate.hotelSearchForm.checkoutDate chineseDescription];
                    self.hotelDateLabel.text = [NSString stringWithFormat:@"入住:%@   离店:%@", checkInDate, checkOutDate];
                    [cell.contentView addSubview:self.hotelDateLabel];
                    
                    UIImageView *nextImageView = [[UIImageView alloc] initWithFrame:CGRectMake(285, 10, 7, 10)];
                    nextImageView.image = [UIImage imageNamed:@"hotel-next.png"];
                    [cell.contentView addSubview:nextImageView];
                    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];

                    return cell;
                }
                default:
                    break;
            }
            break;
        }
        case 1:
        {
            //下降阴影
            cell.dropsShadow = NO;
            //圆弧
            cell.cornerRadius = 5;
            //cell之间的分割线
            cell.customSeparatorColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dashed_detail.png"]];
            
            id object = [self.hotelRoomHelper.headViewList objectAtIndex:indexPath.row];
            
            if([object isKindOfClass:[RoomHeadView class]])
            {
                [cell prepareForTableView:tableView indexPath:indexPath];
                
                NSArray* views = cell.subviews;
                for(UIView* view in views)
                {
                    if ([view isKindOfClass:[RoomHeadView class]]) {
                        [view removeFromSuperview];
                    }
                }
                
                RoomHeadView *headView = (RoomHeadView *)object;
                [cell addSubview:headView];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                
                return cell;
            }
            else
            {
                [cell prepareForTableView:tableView indexPath:indexPath];
                RoomDetailView *detailView = (RoomDetailView *)object;
                //获取cell的坐标
                //CGRect rect = [tableView convertRect:[tableView rectForRowAtIndexPath:indexPath] toView:[tableView superview]];
                
                [cell.contentView addSubview:detailView];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                
                return cell;
            }
            break;
        }
            
    }
    
    
    return cell;
}

- (void)hideCoverView:(id)sender
{
    NSLog(@"123");
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 0:
                {
                    [self performSegueWithIdentifier:@"hotelMap" sender:nil];
                    break;
                }
                case 1:
                {
                    [self callPhone:nil];
                    break;
                }
                case 2:
                {
                    [self.kalManager pickDate];
                    break;
                }
                default:
                    break;
            }
            PrettyTableViewCell *cell = (PrettyTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
            [cell setSelected:NO animated:YES];
            break;
        }
        case 1:
        {            
            id object = [self.hotelRoomHelper.headViewList objectAtIndex:indexPath.row];
            
            if([object isKindOfClass:[RoomHeadView class]])
            {
                RoomHeadView *headView = (RoomHeadView *)object;
                
                if([self.hotelRoomHelper.headViewList count] == indexPath.row + 1)
                {
                    object = nil;
                }
                else
                {
                    object = [self.hotelRoomHelper.headViewList objectAtIndex:indexPath.row + 1];
                }
                
                if(object == nil || [object isKindOfClass:[RoomHeadView class]])
                {
                    RoomDetailView * detailView = self.hotelRoomHelper.detailViewList[headView.section];
                    [self.hotelRoomHelper.headViewList insertObject:detailView atIndex:indexPath.row + 1];
                    
                    PrettyTableViewCell *roomCell = (PrettyTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
                    
                    [tableView beginUpdates];
                    
                    [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexPath.row + 1 inSection:1]]
                                     withRowAnimation:UITableViewRowAnimationTop];
                    [tableView endUpdates];
                    
                    const unsigned int height = [tableView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row + 1 inSection:1]].size.height;
                    
                    const int offsetY = roomCell.frame.origin.y + roomCell.frame.size.height + height;
                    if(offsetY > tableView.frame.size.height)
                    {
                        if(height + 60 > tableView.frame.size.height)
                        {
                            [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:1]
                                             atScrollPosition:UITableViewScrollPositionTop animated:YES];
                        }
                        else
                        {
                            [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row + 1 inSection:1]
                                             atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                        }
                    }
                    [self closeOpenedCellsExceptCurrentCell:tableView currentRow:detailView];
                    if (object == nil) {
                        [self.tableView reloadData];
                    }
                }
                else if ([object isKindOfClass:[RoomDetailView class]])
                {
                    [self closeOpenedCells:tableView];
                    
                    if([self.hotelRoomHelper.headViewList count] == indexPath.row + 1)
                    {
                        [self.tableView reloadData];
                    }
                }
            }
            break;
        }
        default:
            break;
    }
}

//设置group之间的间距
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

- (void)closeOpenedCells:(UITableView *)tableView
{
    for (unsigned int i = 0; i < self.hotelRoomHelper.headViewList.count; i++)
    {
        id object = self.hotelRoomHelper.headViewList[i];
        
        if ([object isKindOfClass:[RoomDetailView class]])
        {
            [self.hotelRoomHelper.headViewList removeObjectAtIndex:i];
            [tableView beginUpdates];
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:i inSection:1]] withRowAnimation:UITableViewRowAnimationTop];
            [tableView endUpdates];
        }
    }
}

- (void)closeOpenedCellsExceptCurrentCell:(UITableView *)tableView currentRow:(RoomDetailView *) currentView
{
    for (unsigned int i=0; i<self.hotelRoomHelper.headViewList.count; i++)
    {
        id object = self.hotelRoomHelper.headViewList[i];
        if ([object isKindOfClass:[RoomDetailView class]])
        {
            RoomDetailView * detailView = (RoomDetailView *)object;
            if (detailView.roomId != currentView.roomId)
            {
                [self.hotelRoomHelper.headViewList removeObjectAtIndex:i];
                [tableView beginUpdates];
                [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:i inSection:1]]
                                 withRowAnimation:UITableViewRowAnimationTop];
                [tableView endUpdates];
            }
        }
    }
}

- (IBAction)hotelNameButtonTapped:(id)sender
{
    [[GAI sharedInstance].defaultTracker sendEventWithCategory:@"酒店概览"
                                                    withAction:@"酒店概览页面酒店介绍"
                                                     withLabel:@"酒店概览页面酒店介绍按钮"
                                                     withValue:nil];
    [UMAnalyticManager eventCount:@"酒店概览页面酒店介绍" label:@"酒店概览页面酒店介绍按钮"];
    
    [self performSegueWithIdentifier:@"showOverview" sender:sender];
}

- (IBAction)imageButtonClicked:(id)sender
{
    if (hasImages == NO) {  return; }

    HotelImagesController *hotelImagesViewController = (HotelImagesController *) [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil]
                                                                                  instantiateViewControllerWithIdentifier:@"HotelImagesController"];
    [hotelImagesViewController setHotelId:self.hotel.hotelId];
    [hotelImagesViewController downloadData];
    [self.navigationController pushViewController:hotelImagesViewController animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showOverview"])
    {
        if ([segue.destinationViewController isKindOfClass:[HotelOverviewViewController class]])
        {
            HotelOverviewViewController *hotelOverviewViewController = segue.destinationViewController;
            [hotelOverviewViewController setHotelId:self.hotel.hotelId];
            [hotelOverviewViewController downloadData];
        }
    }

    if ([segue.identifier isEqualToString:@"hotelBookView"])
    {
        if (TheAppDelegate.userInfo.uid == nil || [TheAppDelegate.userInfo.uid isEqual:@"0"]) {
            TheAppDelegate.userInfo.isForGuestOrder = YES;
        }
        if ([segue.destinationViewController isKindOfClass:[HotelBookInputViewController class]])
        {
            HotelBookInputViewController *bookInputViewController = segue.destinationViewController;
            bookInputViewController.orderPriceConfirmForm = self.hotelPriceConfirmForm;
            //游客预定存入会员价
            bookInputViewController.rcardPriceConfirmForm = self.rcardPriceConfirmForm;
        }
    }

    if ([segue.identifier isEqualToString:@"lvPingRating"])
    {
        if ([segue.destinationViewController isKindOfClass:[LvPingRatingViewController class]])
        {

            LvPingRatingViewController *lvPingRatingViewController = segue.destinationViewController;
            lvPingRatingViewController.lvPingHotelRating = self.lvPingHotelRating;
        }
    }

    if ([segue.identifier isEqualToString:@"hotelImages"] && hasImages == YES)
    {
        if ([segue.destinationViewController isKindOfClass:[HotelImagesController class]])
        {
            HotelImagesController* hotelImagesViewController = segue.destinationViewController;
            [hotelImagesViewController setHotelId:self.hotel.hotelId];
            [hotelImagesViewController downloadData];
        }
    }

    if ([segue.identifier isEqualToString:@"hotelMap"])
    {
        if ([segue.destinationViewController isKindOfClass:[HotelMapViewController class]])
        {
            HotelMapViewController* controller = segue.destinationViewController;
            [controller setHotelAddress:self.hotel.address];
            [controller setHotelName:self.hotel.name];
            [controller setHotelLatitude:self.hotel.coordinate.latitude];
            [controller setHotelLongitude:self.hotel.coordinate.longitude];
        }
    }
}

- (void) loadPageContent
{
    [self.hotelRoomHelper loadRoomViews];
    [self.tableView reloadData];
}

#pragma mark - KalManagerDelegate
- (void)manager:(KalManager *)manager didSelectMinDate:(NSDate *)minDate maxDate:(NSDate *)maxDate
{
    TheAppDelegate.hotelSearchForm.checkinDate = [KalDate dateFromNSDate:minDate] ;
    TheAppDelegate.hotelSearchForm.checkoutDate = [KalDate dateFromNSDate:maxDate];
    [[NSNotificationCenter defaultCenter] postNotificationName:kHotelDateChangedNotification object:nil];
    [self downloadData];
}

#pragma mark - GDataXMLParserDelegate
- (void)parser:(GDataXMLParser*)parser DidParsedData:(NSDictionary *)data
{
    if ([parser isKindOfClass:([HotelRoomListParser class])])
    {
        self.hotel.hotelCode = data[@"hotelCode"];
        self.hotel.origin = (JJHotelOrigin)[data[@"hotelOrigin"] intValue];
        self.roomList = data[@"roomList"];
        //load cell data from hotelRoomHelper
        self.hotelRoomHelper.hotel = self.hotel;
        self.hotelRoomHelper.roomList = self.roomList;
        self.roomIsloadOver = YES;
    }
    else if ([parser isKindOfClass:([LvPingRatingParser class])])
    {
        self.lvPingHotelRating = data[@"lvPingHotelRating"];
        [self setHotelRatingControl];
    }
    else if  ([parser isKindOfClass:([HotelOverviewParser class])])
    {
        JJHotel *tmpHotel = [data objectForKey:@"hotel"];
        self.hotel.cityName = tmpHotel.cityName;

        if (self.isFromOrder == YES)
        {
            self.hotel.name = tmpHotel.name;
            self.hotel.brand = tmpHotel.brand;
            self.hotel.imageUrl = tmpHotel.imageUrl;
            self.hotel.address = tmpHotel.address;
            self.hotel.telphone = tmpHotel.telphone;
            self.hotel.coordinate = tmpHotel.coordinate;
            self.hotel.star = tmpHotel.star;
            self.hotel.distance = tmpHotel.distance;
            self.hotel.icon = tmpHotel.icon;
            [self setHotelBaseInfo];
        }
        [self setHotelIsloadOver:YES];
        NSString* images = [data objectForKey:@"images"];
        if ([images rangeOfString:@"null"].location != NSNotFound)
        {
            hasImages = NO;
        }
        else
        {
            hasImages = YES;
        }
    }
    
    if (self.roomIsloadOver && self.hotelIsloadOver)
    {
        [self loadPageContent];
        [self hideIndicatorView];
    }
}

#pragma mark - HotelRoomHelperDelegate
- (void)performBookControllerView:(NSInteger) dictKey
{
    self.roomOrPlanId = dictKey;
    if ([TheAppDelegate.userInfo checkIsLogin])
    {
        [UMAnalyticManager eventCount:@"登陆会员预订" label:@"登陆会员预订"];
        [self loginedBooking:dictKey];
    }
    else
    {
        [UMAnalyticManager eventCount:@"游客预订" label:@"游客预订"];
        [self withoutLoginBooking:dictKey];
    }
    
    [UMAnalyticManager eventCount:@"酒店详情点击预订" label:@"酒店详情点击预订按钮"];
}

- (void)showRoomImage:(UIImage*)image
{
    CGRect frame = self.view.frame;
    UITapGestureRecognizer *tapToClose = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeImage:)];
    UIView *maskView = [[UIView alloc] initWithFrame:frame];
    UIView *backView = [[UIView alloc] initWithFrame:frame];
    maskView.backgroundColor = [UIColor clearColor];
    backView.backgroundColor = [UIColor blackColor];
    backView.alpha = 0.5;
    UIImageView *roomImageView = [[UIImageView alloc] initWithImage:image];
    maskView.userInteractionEnabled = YES;
    roomImageView.frame = CGRectMake(10, 80, 300, 225);
    [maskView addSubview:backView];
    [maskView addGestureRecognizer:tapToClose];
    [maskView addSubview:roomImageView];
    [self.view addSubview:maskView];
}

- (void)closeImage:(UITapGestureRecognizer *)sender
{
    [sender.view removeFromSuperview];
}

#pragma mark - LoginViewControllerDelegate

- (void) loginAfterHandle
{
    [self loginedBooking:self.roomOrPlanId];
}

- (void)loginedBooking:(NSInteger)dictKey
{
    BOOL bookFlag = YES;
    if (self.hotel.origin == JJHotelOriginJJINN || self.hotel.origin == JJHotelOriginBESTAY)
    {
        bookFlag = [self bookingByMemberType:dictKey];
    }
    else
    {
        HotelPriceConfirmForm *priceConfirmForm = (HotelPriceConfirmForm *)[self.hotelRoomHelper.hotelPriceAskDict
                                                                            valueForKey:[NSString stringWithFormat:@"%d",dictKey]];
        [self fillDataInPriceConfirmForm:priceConfirmForm];
    }

    if (bookFlag)
    {   [self performSegueWithIdentifier:@"hotelBookView" sender:nil];  }
    else    //跳转到会员升级接口，升级为享卡会员
    {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:NSLocalizedString(@"信息提示", nil)
                                  message:@"只有享卡会员才可以预定此价格"
                                  delegate:nil
                                  cancelButtonTitle:@"确定"
                                  otherButtonTitles:nil];
        [alertView show];
    }
}

- (LoginViewController *)loginViewController
{
    _loginViewController = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil]
                            instantiateViewControllerWithIdentifier:@"LoginViewController"];
    [_loginViewController setDelegate:self];

    return _loginViewController;
}

- (BOOL)bookingByMemberType:(NSInteger) roomId
{
    NSMutableArray *plans = [[NSMutableArray alloc] initWithCapacity:2];

    for (unsigned int i = 0; i < self.roomList.count; i++)
    {
        JJHotelRoom *room = self.roomList[i];
        if (room.roomId == roomId)
        {
            for (unsigned int m=0; m<room.planList.count; m++)
            {
                JJPlan *plan = [room.planList objectAtIndex:m];
                HotelPriceConfirmForm *priceConfirmForm = (HotelPriceConfirmForm *)[self.hotelRoomHelper.hotelPriceAskDict
                                                                                    valueForKey:[NSString stringWithFormat:@"%d",plan.planId]];
                if (priceConfirmForm != nil)
                {
                    [plans addObject:priceConfirmForm];
                }
            }
            break;
        }
    }
    NSString *loginCardType = TheAppDelegate.userInfo.cardType;

    if ([loginCardType isEqualToString:(JBENEFITCARD)] || [loginCardType isEqualToString:(J2BENEFITCARD)] || [loginCardType isEqualToString:(J8BENEFITCARD)])
    {
        //享卡以上会员预定酒店
        if (plans.count == 1)
        {
            HotelPriceConfirmForm *priceConfirmForm = plans[0];
            [self fillDataInPriceConfirmForm:priceConfirmForm];
        }
        else if (plans.count == 2)
        {
            for (unsigned int i=0; i<plans.count; i++)
            {
                HotelPriceConfirmForm *priceConfirmForm = plans[i];
                if ([priceConfirmForm.rateCode caseInsensitiveCompare:@"Rcard"] == NSOrderedSame)
                {
                    [self fillDataInPriceConfirmForm:priceConfirmForm];
                }
            }
        }
    }
    else
    {
        //礼卡以下会员预定酒店
        BOOL bookFlag = NO;
        if (plans.count == 1)
        {
            HotelPriceConfirmForm *priceConfirmForm = plans[0];
            if ([priceConfirmForm.rateCode caseInsensitiveCompare:@"Rcard"] == NSOrderedSame) {
                bookFlag = NO;
            } else {
                [self fillDataInPriceConfirmForm:priceConfirmForm];
                bookFlag = YES;
            }
        }
        else if (plans.count == 2)
        {
            for (unsigned int i=0; i<plans.count; i++)
            {
                HotelPriceConfirmForm *priceConfirmForm = plans[i];
                if ([priceConfirmForm.rateCode caseInsensitiveCompare:@"SCard"] == NSOrderedSame)
                {
                    [self fillDataInPriceConfirmForm:priceConfirmForm];
                    bookFlag = YES;
                }
            }
        }

        return bookFlag;
    }
    
    return YES;
}

//游客预定
- (void)withoutLoginBooking:(NSInteger)dictKey
{
    BOOL bookFlag = YES;
    
    if (self.hotel.origin == JJHotelOriginJJINN || self.hotel.origin == JJHotelOriginBESTAY)
    {
        NSMutableArray *plans = [[NSMutableArray alloc] initWithCapacity:2];
        
        for (unsigned int i = 0; i < self.roomList.count; i++)
        {
            JJHotelRoom *room = self.roomList[i];
            if (room.roomId == dictKey)
            {
                for (unsigned int m=0; m<room.planList.count; m++)
                {
                    JJPlan *plan = [room.planList objectAtIndex:m];
                    HotelPriceConfirmForm *priceConfirmForm = (HotelPriceConfirmForm *)[self.hotelRoomHelper.hotelPriceAskDict
                                                                                        valueForKey:[NSString stringWithFormat:@"%d",plan.planId]];
                    if (priceConfirmForm != nil)
                    {
                        [plans addObject:priceConfirmForm];
                    }
                }
                break;
            }
        }
   
        if (plans.count == 1)
        {
            HotelPriceConfirmForm *priceConfirmForm = plans[0];
            if ([priceConfirmForm.rateCode caseInsensitiveCompare:@"Rcard"] == NSOrderedSame) {
                bookFlag = NO;
            } else {
                [self fillDataInPriceConfirmForm:priceConfirmForm];
                bookFlag = YES;
            }
        }
        else if (plans.count == 2)
        {
            for (unsigned int i=0; i<plans.count; i++)
            {
                HotelPriceConfirmForm *priceConfirmForm = plans[i];
                if ([priceConfirmForm.rateCode caseInsensitiveCompare:@"SCard"] == NSOrderedSame)
                {
                    [self fillDataInPriceConfirmForm:priceConfirmForm];
                    bookFlag = YES;
                } else {
                    priceConfirmForm.checkInDate = [TheAppDelegate.hotelSearchForm.checkinDate chineseDescription];
                    priceConfirmForm.checkOutDate = [TheAppDelegate.hotelSearchForm.checkoutDate chineseDescription];
                    priceConfirmForm.cardType = TheAppDelegate.userInfo.cardType;
                    self.rcardPriceConfirmForm = priceConfirmForm;
                }
            }
        }
    }
    else
    {
        HotelPriceConfirmForm *priceConfirmForm = (HotelPriceConfirmForm *)[self.hotelRoomHelper.hotelPriceAskDict
                                                                            valueForKey:[NSString stringWithFormat:@"%d",dictKey]];
        [self fillDataInPriceConfirmForm:priceConfirmForm];
    }
    
    if (bookFlag) {
        [self performSegueWithIdentifier:@"hotelBookView" sender:nil];
    } else {
        //跳转到登录界面
        UINavigationController *nav = [[UINavigationController alloc]
                                       initWithRootViewController:self.loginViewController];
        [self presentModalViewController:nav animated:YES];
    }
}


- (void) fillDataInPriceConfirmForm:(HotelPriceConfirmForm *) priceConfirmForm
{
    priceConfirmForm.checkInDate = [TheAppDelegate.hotelSearchForm.checkinDate chineseDescription];
    priceConfirmForm.checkOutDate = [TheAppDelegate.hotelSearchForm.checkoutDate chineseDescription];
    priceConfirmForm.cardType = TheAppDelegate.userInfo.cardType;
    self.hotelPriceConfirmForm = priceConfirmForm;
}

- (IBAction)performToLvPingRatingAction
{
    [self performSegueWithIdentifier:@"lvPingRating" sender:nil];
}


- (void)callPhone:(id)sender
{
    [[GAI sharedInstance].defaultTracker sendEventWithCategory:@"电话预订"
                                                    withAction:@"电话预订"
                                                     withLabel:@"电话预订按钮"
                                                     withValue:nil];
    [UMAnalyticManager eventCount:@"电话预订" label:@"电话预订按钮"];
    
    UIActionSheet *menu = [[UIActionSheet alloc] initWithTitle:@"酒店前台电话" delegate:self cancelButtonTitle:@"取消"
                                        destructiveButtonTitle:nil otherButtonTitles:self.hotelTelPhoneLabel.text, nil];
    [menu setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    [menu setAlpha:1];
    [menu showInView:self.view];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *tel = [NSString stringWithFormat:@"tel://%@", self.hotelTelPhoneLabel.text];

    if (buttonIndex == 0)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:tel]];
    }
}

@end
