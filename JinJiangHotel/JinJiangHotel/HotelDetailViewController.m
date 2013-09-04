//
//  HotelDetailViewController.m
//  JinJiangHotel
//
//  Created by Rong Hao on 13-8-20.
//  Copyright (c) 2013年 jinjiang. All rights reserved.
//

#import "HotelDetailViewController.h"
#import "HotelBookingViewController.h"
#import "LoginViewController.h"
#import "JJStarView.h"
#import "RoomDetailView.h"
#import "RoomHeadView.h"
#import "HotelTableCell.h"
#import "HotelRoomListParser.h"
#import "HotelPriceConfirmForm.h"
#import "HotelOverviewParser.h"
#import "ParameterManager.h"
#import "RoomStyleCell.h"

@interface HotelDetailViewController ()
@property (weak, nonatomic) IBOutlet UIButton *selectedButton;

//@property (nonatomic, strong) KalManager *kalManager;
@property (nonatomic, strong) HotelRoomHelper *hotelRoomHelper;
@property (nonatomic, strong) HotelPriceConfirmForm *hotelPriceConfirmForm;
//@property (nonatomic, strong) LoginViewController *loginViewController;
@property (nonatomic, assign) NSInteger roomOrPlanId;
@property (nonatomic, assign) BOOL roomIsloadOver;
@property (nonatomic, assign) BOOL hotelIsloadOver;
@property (nonatomic, strong) HotelOverviewParser *hotelOverviewParser;
@property (nonatomic, strong) HotelRoomListParser *hotelRoomListParser;
//@property (nonatomic, strong) FaverateHotelManager *faverateHotelManager;

@property (nonatomic, strong) NSMutableArray *roomStyleViewList;
@property (nonatomic, strong) NSMutableArray *roomList;
@property (nonatomic) CGPoint secondNaviCenter;
@property (nonatomic) BOOL hasImages;
@property (nonatomic) BOOL isElasticFinished;
@property (nonatomic) CGSize roomStyleSize;

@end

@implementation HotelDetailViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:FROM_HOTEL_LIST_TO_BOOKING]) {
        HotelBookingViewController *hbvc = (HotelBookingViewController *)segue.destinationViewController;
        hbvc.orderPriceConfirmForm = self.hotelPriceConfirmForm;
    } else if ([segue.identifier isEqualToString:FROM_HOTEL_LIST_TO_LOGIN]) {
        TheAppDelegate.loginEnterance = JJHHotelDetailLogin;
        LoginViewController *lvc = segue.destinationViewController;
        lvc.hotelPriceConfirmForm = self.hotelPriceConfirmForm;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    if (!self.hotel) {
        
        self.hotel = [[JJHotel alloc] init];
        //    self.hotel.name = @"我的名字很长有十个字";
        //    self.hotel.star = 4;
        //    self.hotel.address = @"我是地址我有数字也有文字";
        self.hotel.hotelId = 534;
        self.isFromOrder = YES;
        
    }
    //初始化导航栏
    [self initNavigationBarWithStyle:JJTwoLineTilteBarStyle];
    self.navigationBar.mainLabel.text = self.hotel.name;
    [self.navigationBar addRightBarButton:@"btn_faverate.png"];
    [self.navigationBar addOtherBarButton:@"btn_resend.png"];
    [self.selectedButton setTitle:self.roomStyleButton.titleLabel.text forState:UIControlStateNormal];
    
    //设置酒店基本信息
    [self setHotelBaseInfo];
    
    //设定页面滚动规则
    [self.mainScrollerView setContentSize:CGSizeMake(320, 580)];
    self.mainScrollerView.delegate = self;
    self.secondNaviCenter = CGPointMake(160, 240);
    
    
    
    self.roomList = [[NSMutableArray alloc] init];
    self.hotelRoomHelper = [[HotelRoomHelper alloc] init];
    self.hotelRoomHelper.delegate = self;
    
    self.isElasticFinished = YES;
    
    [self downloadData];
}

- (void)setHotelBaseInfo
{
    
    [self.navigationBar.subTitleView addSubview:[[JJStarView alloc] initWithStar:self.hotel.star]];
    
    self.navigationBar.mainLabel.text = self.hotel.name;
    self.hotelDetailTextView.text = self.hotel.description;
    CGSize size = self.hotelDetailTextView.contentSize;
    CGRect frame = self.hotelDetailTextView.frame;
    frame.size = size;
    self.hotelDetailTextView.frame = frame;
    self.hotelDetailTextView.layer.borderWidth = 1;
    self.hotelDetailTextView.layer.borderColor = RGBCOLOR(240, 210, 151).CGColor;
    self.hotelDetailTextView.layer.cornerRadius = 4;
    
    self.contactView.layer.borderColor = RGBCOLOR(240, 210, 151).CGColor;
    self.contactView.layer.borderWidth = 1;
    self.contactView.layer.cornerRadius = 4;
    self.telephoneLabel.text = [NSString stringWithFormat:@"%@%@", NSLocalizedString(@"telephone", @""), self.hotel.telphone];
    self.fexLabel.text = [NSString stringWithFormat:@"%@%@", NSLocalizedString(@"fax", @""), self.hotel.telphone];
    
    CLLocation *locA = [[CLLocation alloc] initWithLatitude:self.hotel.coordinate.latitude longitude:self.hotel.coordinate.longitude];
    
    CLLocation *locB = [[CLLocation alloc] initWithLatitude:TheAppDelegate.locationInfo.currentPoint.latitude longitude:TheAppDelegate.locationInfo.currentPoint.longitude];
    
    CLLocationDistance distance = [locA distanceFromLocation:locB];
    
    if (distance < 100) {
        self.distanceLabel.text = distance > 10.0f ? [NSString stringWithFormat:@"%f%@", distance, NSLocalizedString(@"meter", @"")] : @"";
    } else if (distance < 200000) {
        self.distanceLabel.text = [NSString stringWithFormat:@"%f%@", distance * 0.001f, NSLocalizedString(@"kilometer", @"")];
    } else {
        self.distanceLabel.text = NSLocalizedString(@"faraway", @"");
    }
    
    
    [self.addressLabel setText:self.hotel.address];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (![scrollView isKindOfClass:[UITableView class]]) {
        NSLog(@"is scroll");
        CGPoint scrollOffset = scrollView.contentOffset;
        if (scrollOffset.y <= 170) {
            CGPoint currentSecondNaviCenter = CGPointMake(160, self.secondNaviCenter.y - scrollOffset.y);
            self.secondNaviView.center = currentSecondNaviCenter;
        } else {
            self.secondNaviView.center = CGPointMake(160, 70);
        }
    } else {
        NSLog(@"not scroll");
    }

    
}

- (void)showRoomStyleView
{
    [self createRoomStyleView];
}

- (void)createRoomStyleView
{
    self.roomStyleViewList = self.hotelRoomHelper.headViewList;
    
    int index = 0;
    CGFloat subViewHeight = 4;
    
    for (int i = 0; i < self.roomStyleViewList.count; i++) {
        if (i % 3 == 1) {
            continue;
        }
        
        switch (i % 3) {
            case 0:
            {
                RoomHeadView *view = [self.roomStyleViewList objectAtIndex:i];
                CGRect frame = view.frame;
                frame.origin.y = subViewHeight;
                view.frame = frame;
                [self.subDetailView addSubview:view];
                subViewHeight += frame.size.height;
            }
                break;
            case 2:
            {
                RoomFootView *view = [self.roomStyleViewList objectAtIndex:i];
                CGRect frame = view.frame;
                frame.origin.y = subViewHeight;
                view.frame = frame;
                [self.subDetailView addSubview:view];
                subViewHeight += frame.size.height;
            }
                break;
            default:
                break;
                
        }
        
        index++;
        
    }
    self.subDetailView.frame = CGRectMake(0, 210, 320, subViewHeight);
    self.mainScrollerView.contentSize = CGSizeMake(320, subViewHeight + 210 + 20);
    
    self.roomStyleSize = self.mainScrollerView.contentSize;
}

- (IBAction)descPressed:(UIButton *)sender {
    if ([self selectedButtonEffect:sender])
        [self displayHotelDescription];
}
- (IBAction)roomStylePressed:(UIButton *)sender {
    if ([self selectedButtonEffect:sender])
        [self displayRoomStyle];
}
- (IBAction)facilityPressed:(UIButton *)sender {
    if ([self selectedButtonEffect:sender])
        [self displayFacility];
}

- (BOOL)selectedButtonEffect:(UIButton *)sender
{
    if (!self.isElasticFinished) {
        return NO;
    }
    self.isElasticFinished = NO;
    
    [self.selectedButton setTitle:sender.titleLabel.text forState:UIControlStateNormal];
    [self.selectedButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [self animationWithelasticity:sender.frame withTime:0.3];
    
    self.subDetailView.hidden = YES;
    self.hotelInfoView.hidden = YES;
    return YES;
}

- (void)animationWithelasticity:(CGRect)frame withTime:(NSTimeInterval)time
{
    CGRect originalFrame = frame;
    frame.origin.x = frame.origin.x + (frame.origin.x - self.selectedButton.frame.origin.x) * 0.2;
    [UIView animateWithDuration:time delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^(void){
        self.selectedButton.frame = frame;
    } completion:^(BOOL finished){
        if (fabsf(originalFrame.origin.x - self.selectedButton.frame.origin.x) > 1.0) {
            [self animationWithelasticity:originalFrame withTime:time];
        } else {
            self.selectedButton.frame = originalFrame;
            self.isElasticFinished = YES;
        }
    }];
}


- (void)displayRoomStyle
{
    self.subDetailView.hidden = NO;
    self.mainScrollerView.contentSize = self.roomStyleSize;
    [self.mainScrollerView scrollsToTop];
}

- (void)displayHotelDescription
{
    self.hotelInfoView.hidden = NO;
    CGRect frame = self.hotelDetailTextView.frame;
    self.mainScrollerView.contentSize = CGSizeMake(320, 210 + 163 + frame.size.height + 20);
    [self.mainScrollerView scrollsToTop];
}

- (void)displayFacility
{
    
}

- (void)rightButtonPressed
{

    NSLog(@"faverate pressed");
}

- (void)otherButtonPressed
{
    NSLog(@"other pressed");
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
            self.hotel.description = [data objectForKey:@"description"];
            [self setHotelBaseInfo];
        }
        [self setHotelIsloadOver:YES];
        NSString* images = [data objectForKey:@"images"];
        if ([images rangeOfString:@"null"].location != NSNotFound)
        {
            self.hasImages = NO;
        }
        else
        {
            self.hasImages = YES;
            
            NSArray *imageArray = [images componentsSeparatedByString:@";"];
            if (imageArray.count > 0) {
                
                for (int i = 0; i < imageArray.count; i++) {
                    NSString *imgStr = [imageArray objectAtIndex:i];
                    NSArray *imageMap = [imgStr componentsSeparatedByString:@","];
                    NSString *imagePath = [imageMap objectAtIndex:1];
                    imagePath = [imagePath stringByAddingPercentEscapesUsingEncoding:
                                            NSUTF8StringEncoding];
                    if (imagePath != nil) {
                        
                        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * 320, 0, 320, 170)];
                        [imageView setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:[UIImage imageNamed:@"defaultHotelIcon.png"]];
                        [self.imagePageView addSubview:imageView];
                    }
                }
                self.imagePageView.contentSize = CGSizeMake(imageArray.count * 320, 170);
                
            }
        }
    }
    
    if (self.roomIsloadOver && self.hotelIsloadOver)
    {
        [self loadPageContent];
        [self hideIndicatorView];
    }
}

- (void) loadPageContent
{
    [self.hotelRoomHelper loadRoomViews];
    [self showRoomStyleView];
}

#pragma mark - HotelRoomHelperDelegate
- (void)performBookControllerView:(HotelPriceConfirmForm *)confirmForm;
{
    [self fillDataInPriceConfirmForm:confirmForm];
    
    if ([TheAppDelegate.userInfo checkIsLogin]) {
        [self performSegueWithIdentifier:FROM_HOTEL_LIST_TO_BOOKING sender:nil];
//        NSLog(@"start book");
    } else {
        //跳转到登录界面
        [self performSegueWithIdentifier:FROM_HOTEL_LIST_TO_LOGIN sender:nil];
        NSLog(@"back to login");
    }
}

- (void)showRoomStyleDetailInfo:(RoomHeadView *)headView
{
    int modify = !headView.isDetailOpen ? 71 : -71;
    
    NSUInteger index = [self.hotelRoomHelper.headViewList indexOfObject:headView] + 1;
    
    RoomDetailView *detailView = [self.hotelRoomHelper.headViewList objectAtIndex:index];
    detailView.layer.zPosition = -999;
    
    CGSize size = self.mainScrollerView.contentSize;
    size.height += modify;
    
    if (!headView.isDetailOpen) {
        
        CGRect headViewFrame  = headView.frame;
        detailView.frame = CGRectMake(0, headViewFrame.origin.y + 66, 307, 76);
        [self.subDetailView addSubview:detailView];
        
        [UIView animateWithDuration:0.5 animations:^(void){
            
            self.mainScrollerView.contentSize = size;
            for (int i = index + 1; i < self.hotelRoomHelper.headViewList.count; i++) {
                UIView *viewInSubDetailView = [self.hotelRoomHelper.headViewList objectAtIndex:i];
                CGRect frame = viewInSubDetailView.frame;
                frame.origin.y += modify;
                CGRect subDetailViewFrame = self.subDetailView.frame;
                subDetailViewFrame.size.height += modify;
                viewInSubDetailView.frame = frame;
                self.subDetailView.frame = subDetailViewFrame;
            }
        }];
        
    } else {
        [UIView animateWithDuration:0.5 animations:^(void){
            
            self.mainScrollerView.contentSize = size;
            for (int i = index + 1; i < self.hotelRoomHelper.headViewList.count; i++) {
                UIView *viewInSubDetailView = [self.hotelRoomHelper.headViewList objectAtIndex:i];
                CGRect frame = viewInSubDetailView.frame;
                frame.origin.y += modify;
                CGRect subDetailViewFrame = self.subDetailView.frame;
                subDetailViewFrame.size.height += modify;
                viewInSubDetailView.frame = frame;
                self.subDetailView.frame = subDetailViewFrame;
            }
        } completion:^(BOOL isFinished){
            [detailView removeFromSuperview];
            
        }];
    }
    
    
}

- (void)subDetailViewAnimationStartAtIndex:(NSUInteger)index withModify:(int)modify
{
}


- (void)showRoomImage:(UIImage *)imageView
{
    
}

- (void) fillDataInPriceConfirmForm:(HotelPriceConfirmForm *) priceConfirmForm
{
    priceConfirmForm.checkInDate = [TheAppDelegate.hotelSearchForm.checkinDate chineseDescription];
    priceConfirmForm.checkOutDate = [TheAppDelegate.hotelSearchForm.checkoutDate chineseDescription];
    priceConfirmForm.cardType = TheAppDelegate.userInfo.cardType;
    self.hotelPriceConfirmForm = priceConfirmForm;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)callHotel:(UIButton *)sender {
    UIActionSheet *menu = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"call", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", @"")
                                        destructiveButtonTitle:nil otherButtonTitles:self.hotel.telphone, nil];
    [menu setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    [menu setAlpha:1.0f];
    [menu showInView:self.view];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {   [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", self.hotel.telphone]]];   }
}


- (void)viewDidUnload {
    [self setSelectedButton:nil];
    [self setSubDetailView:nil];
    [self setAddressLabel:nil];
    [self setMainScrollerView:nil];
    [self setSecondNaviView:nil];
    [self setRoomStyleButton:nil];
    [self setHotelInfoView:nil];
    [self setTelephoneLabel:nil];
    [self setFexLabel:nil];
    [self setHotelDetailTextView:nil];
    [self setContactView:nil];
    [self setDistanceLabel:nil];
    [self setImagePageView:nil];
    [super viewDidUnload];
}
@end
