//
//  HotelListViewController.m
//  JinJiangHotel
//
//  Created by 胡 桂祁 on 8/16/13.
//  Copyright (c) 2013 jinjiang. All rights reserved.
//

#import "HotelListViewController.h"
#import "JJMoreFooter.h"
#import "HotelTableCell.h"
#import "JJHotel.h"
#import "UIImageView+WebCache.h"
#import "HotelDetailViewController.h"
#import "NSString+Categories.h"
#import "HotelAnnotation.h"
#import "HotelAnnotationView.h"

#define kDistanceOrderButtonTag 1001
#define kPriceOrderButtonTag 1002
#define kStarOrderButtonTag 1003
#define kMapButtonTag 999
#define kHotelListButtonTag 0

#define WORD_COLOR RGBCOLOR(160, 140, 25);

@interface HotelListViewController ()

-(void)rightButtonPressed;

@end

@implementation HotelListViewController
{
    NSInteger _pageIndex;
    NSInteger _totalHotelCount;
    JJMoreFooter *_moreFooter;
    int _selectSortIndex;
    BOOL _selectSortAcsending;   // YES: ASC, NO: DESC
    BOOL _isBottem;
    CGRect _countLabelFrame;
}

#pragma mark - (id)init

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        // Custom initialization
        _hotelsArray = [[NSMutableArray alloc] init];
        _pageIndex = 1;
        _totalHotelCount = -1;
        _moreFooter = [[JJMoreFooter alloc] initWithFrame:CGRectMake(0, 0, 320, 70)];
        _selectSortIndex = kDistanceOrderButtonTag;
        _selectSortAcsending = YES;
        _poi = [[Desitination alloc] initWithCoords:TheAppDelegate.hotelSearchForm.searchPoint];
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *backgroundName = self.view.frame.size.height > 480 ? @"bg_5.png" : @"bg.png";
    self.hotelTableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:backgroundName]];
    
    self.distanceOrderButton.tag = kDistanceOrderButtonTag;
    self.priceOrderButton.tag = kPriceOrderButtonTag;
    self.starOrderButton.tag = kStarOrderButtonTag;
    isHotelListFlag = YES;
    [self setOrderButtonStyle:self.distanceOrderButton];
    _countLabelFrame = self.hotelCountLabel.frame;
    [self downloadData];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self initNavigationBarStyle];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.navigationBar.subTitleLabel.frame = CGRectMake(self.navigationBar.subTitleLabel.bounds.origin.x, self.navigationBar.subTitleLabel.bounds.origin.y, 170, self.navigationBar.subTitleLabel.bounds.size.height);
    if (!self.filterView.hidden) {
        isOpenRightBtn = YES;
    }
}


-(void)viewWillAppear:(BOOL)animated
{
    self.trackedViewName = @"酒店列表页面";
    [super viewWillAppear:animated];
}



-(void)initNavigationBarStyle
{
    [self initNavigationBarWithStyle:JJTwoLineTilteBarStyle];
    [self.navigationBar addRightBarButton:@"right_filter_btn.png"];
    self.navigationBar.mainLabel.text = NSLocalizedStringFromTable(@"hotel list", @"HotelList", @"");
    
    UILabel *checkInLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 12)];
    checkInLabel.text = [NSString stringWithFormat:@"%@:%@",NSLocalizedStringFromTable(@"checkIn", @"HotelList", @""),[TheAppDelegate.hotelSearchForm.checkinDate chineseDescription]];
    checkInLabel.textColor = WORD_COLOR;
    checkInLabel.font = [UIFont boldSystemFontOfSize:12];
    checkInLabel.backgroundColor = [UIColor clearColor];
    
    UILabel *checkOutLabel = [[UILabel alloc] initWithFrame:CGRectMake(105, 0, 100, 12)];
    checkOutLabel.text = [NSString stringWithFormat:@"%@:%@",NSLocalizedStringFromTable(@"checkOut", @"HotelList", @""),[TheAppDelegate.hotelSearchForm.checkoutDate chineseDescription]];
    checkOutLabel.textColor = WORD_COLOR;
    checkOutLabel.font = [UIFont boldSystemFontOfSize:12];
    checkOutLabel.backgroundColor = [UIColor clearColor];
    
    [self.navigationBar.subTitleLabel addSubview:checkInLabel];
    [self.navigationBar.subTitleLabel addSubview:checkOutLabel];
    self.navigationBar.subTitleLabel.frame = CGRectMake(self.navigationBar.subTitleLabel.bounds.origin.x, self.navigationBar.subTitleLabel.bounds.origin.y, 200, self.navigationBar.subTitleLabel.bounds.size.height);

//    [self hiddenFilterView];
    
    [self rightButtonPressed];
    
}

-(void)initMapAnnotation
{
    [self.mapView setShowsUserLocation:NO];
    self.mapAnnotations = [[NSMutableArray alloc] initWithCapacity:10];
    for (JJHotel *hotel in self.hotelsArray) {
        HotelAnnotation *hotelAnnotation = [[HotelAnnotation alloc] init];
        hotelAnnotation.hotel = hotel;
        hotelAnnotation.topImage =  [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:hotel.iconUrl]]];
        [self.mapAnnotations addObject:hotelAnnotation];
    }
    
}

- (IBAction)orderButtonTapped:(id)sender
{
    if (sender == self.distanceOrderButton && _selectSortIndex != kDistanceOrderButtonTag)
    {
        [[GAI sharedInstance].defaultTracker sendEventWithCategory:@"酒店列表页面"
                                                        withAction:@"酒店列表页面距离排序"
                                                         withLabel:@"酒店列表页面距离排序按钮"
                                                         withValue:nil];
        [UMAnalyticManager eventCount:@"酒店列表页面距离排序" label:@"酒店列表页面距离排序按钮"];
        
        _selectSortAcsending = YES;
        [self reLoadTableViewBySelectTag:sender];
    }
    else if (sender == self.priceOrderButton)
    {
        [[GAI sharedInstance].defaultTracker sendEventWithCategory:@"酒店列表页面"
                                                        withAction:@"酒店列表页面价格排序"
                                                         withLabel:@"酒店列表页面价格排序按钮"
                                                         withValue:nil];
        [UMAnalyticManager eventCount:@"酒店列表页面价格排序" label:@"酒店列表页面价格排序按钮"];
        _selectSortAcsending = !_selectSortAcsending;
        [self reLoadTableViewBySelectTag:sender];
    }else if (sender == self.starOrderButton){
        [[GAI sharedInstance].defaultTracker sendEventWithCategory:@"酒店列表页面"
                                                        withAction:@"酒店列表页面星级排序"
                                                         withLabel:@"酒店列表页面星级排序按钮"
                                                         withValue:nil];
        [UMAnalyticManager eventCount:@"酒店列表页面价格排序" label:@"酒店列表页面星级排序按钮"];
        _selectSortAcsending = !_selectSortAcsending;
        [self reLoadTableViewBySelectTag:sender];
    }
}

- (void) reLoadTableViewBySelectTag:(id)sender
{
    _selectSortIndex = [sender tag];
    [self setOrderButtonStyle:sender];
    _pageIndex = 1;
    [self.hotelTableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
    [self downloadData];
}


- (void)setOrderButtonStyle:(UIButton *)button
{
    [self resetOrderButtonStyle];
    
    [button setBackgroundImage:[UIImage imageNamed:@"filter_selected_btn.png"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"filter_selected_btn.png"] forState:UIControlStateHighlighted];
    
    [button setTitleColor:RGBCOLOR(255, 128, 0) forState:UIControlStateNormal];
    [button setTitleColor:RGBCOLOR(255, 128, 0) forState:UIControlStateHighlighted];
    
}

- (void)resetOrderButtonStyle
{
    [self.distanceOrderButton setBackgroundImage:nil forState:UIControlStateNormal];
    [self.priceOrderButton setBackgroundImage:nil forState:UIControlStateNormal];
    [self.starOrderButton setBackgroundImage:nil forState:UIControlStateNormal];
    
    [self.distanceOrderButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.distanceOrderButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    
    [self.priceOrderButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.priceOrderButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    
    [self.starOrderButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.starOrderButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    
}


- (void)downloadData
{
    if (!self.hotelListParser)
    {
        self.hotelListParser = [[HotelListParser alloc] init];
        self.hotelListParser.isHTTPGet = NO;
        self.hotelListParser.serverAddress = kHotelSearchURL;
        self.hotelListParser.delegate = self;
    }
    
    NSString *orderName = @"";
    switch (_selectSortIndex)
    {
        case kDistanceOrderButtonTag:
        {
            orderName = @"orderSequenceForDistance";
            break;
        }
        case kPriceOrderButtonTag:
        {
            orderName = @"orderSequenceForPrice";
            break;
        }
        case kStarOrderButtonTag:
        {
            orderName = @"orderSequenceForStar";
            break;
        }
        default:
        {
            orderName = @"orderSequenceForDistance";
            break;
        }
    }
    NSString *orderVal = @"";
    if (_selectSortAcsending)
    {   orderVal = @"asc";  }
    else
    {   orderVal = @"desc"; }
    
    [self showIndicatorView];
    
    [self.hotelListParser getHotelList:_pageIndex orderName:orderName orderVal:orderVal];
    
    self.hotelTableView.tableFooterView = _moreFooter;
}

-(void)hiddenFilterView
{
    [self.navigationBar.rightButton setBackgroundImage:[UIImage imageNamed:@"right_filter_btn.png"] forState:UIControlStateNormal];
    [self.navigationBar.rightButton setBackgroundImage:[UIImage imageNamed:@"right_filter_btn.png"] forState:UIControlStateHighlighted];
    self.filterView.hidden = YES;
    self.hotelTableView.frame = CGRectMake(0, 0, self.hotelTableView.bounds.size.width, 445 + 50);
    self.mapView.frame = CGRectMake(0, 0, self.mapView.bounds.size.width, 445 + 50);
}

-(void)showFilterView
{
    [self.navigationBar.rightButton setBackgroundImage:[UIImage imageNamed:@"right_filter_selected_btn.png"] forState:UIControlStateNormal];
    [self.navigationBar.rightButton setBackgroundImage:[UIImage imageNamed:@"right_filter_selected_btn.png"] forState:UIControlStateHighlighted];
    self.filterView.hidden = NO;
    self.hotelTableView.frame = CGRectMake(0, 50, self.hotelTableView.bounds.size.width, 445);
    self.mapView.frame = CGRectMake(0, 50, self.mapView.bounds.size.width, 445);
}

#pragma --JJNavigationBar delegate
- (void)rightButtonPressed{
    if (isOpenRightBtn){
        isOpenRightBtn = NO;
        [self showFilterView];
        return;
    }
    
    if (self.filterView.hidden) {
        [self showFilterView];
    }else{
        [self hiddenFilterView];
    }
}

-(IBAction)showMaplList:(id)sender
{
    if (isHotelListFlag) {
        [self showMapListView];
    }else{
         [self showHotelListView];
    }
}


-(void)showMapListView
{
    isHotelListFlag = NO;
    
    [self hiddenFilterBtns];
    
    if (self.mapAnnotations != nil && [self.mapAnnotations count] >= 1)
    {
        [UIView beginAnimations:@"mapListAnimaId" context:nil];
        [UIView setAnimationDuration:0.5f];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationRepeatAutoreverses:NO];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight
                               forView:self.view cache:YES];
        [self showIndicatorView];
        [self.hotelTableView setHidden:YES];
        [self.mapView setHidden:NO];
        [self centerMap];
        [self performSelector:@selector(gotoLocation) withObject:nil afterDelay:0.5];
        [UIView commitAnimations];
    }

}

-(void)showHotelListView
{
    isHotelListFlag = YES;
    [self showFilterBtns];
    
    [UIView beginAnimations:@"hotelListAnimaId" context:nil];
    [UIView setAnimationDuration:0.5f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationRepeatAutoreverses:NO];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft
                           forView:self.view cache:YES];
    [self.hotelTableView setHidden:NO];
    [self.mapView setHidden:YES];
    [UIView commitAnimations];

//    [self downloadData];
}


-(void)hiddenFilterBtns
{
    [self.mapListButton setImage:[UIImage imageNamed:@"map_btn_selected.png"] forState:UIControlStateNormal];
    self.priceOrderButton.enabled = NO;
    self.priceOrderButton.alpha = 0.5;
    self.starOrderButton.enabled = NO;
    self.starOrderButton.alpha = 0.5;
    self.distanceOrderButton.enabled = NO;
    self.distanceOrderButton.alpha = 0.5;
}

-(void)showFilterBtns{
    [self.mapListButton setImage:[UIImage imageNamed:@"map_btn_default.png"] forState:UIControlStateNormal];
    self.priceOrderButton.enabled = YES;
    self.priceOrderButton.alpha = 1;
    self.starOrderButton.enabled = YES;
    self.starOrderButton.alpha = 1;
    self.distanceOrderButton.enabled = YES;
    self.distanceOrderButton.alpha = 1;
}

-(void)gotoLocation
{
    [self.mapView removeAnnotations:self.mapAnnotations];  // remove any annotations that exist
    [self.mapView addAnnotations:self.mapAnnotations];
    [self centerMap];
    [self hideIndicatorView];
}

- (void)centerMap
{
	MKCoordinateRegion region;
    region.center.latitude = self.poi.coordinate.latitude;
	region.center.longitude = self.poi.coordinate.longitude;
    region.span.latitudeDelta  = 0.04;
	region.span.longitudeDelta = 0.04;
	[self.mapView setRegion:region animated:YES];
    
    [self.mapView setCenterCoordinate:self.poi.coordinate animated:YES];
    [self.mapView addAnnotation:self.poi];
}


-(IBAction)handleLongPress:(id)sender
{
    UILongPressGestureRecognizer *longPressRecognizer = (UILongPressGestureRecognizer *)sender;
    if (longPressRecognizer.state != UIGestureRecognizerStateBegan) // filter the long press end event.
    {   return;
    }
    [self.mapView removeAnnotations:self.mapAnnotations];
    CGPoint touchPoint = [longPressRecognizer locationOfTouch:0 inView:self.mapView];
    TheAppDelegate.hotelSearchForm.searchPoint = [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
    [self moveDestination:TheAppDelegate.hotelSearchForm.searchPoint animated:YES];
    _pageIndex = 1;
    [self downloadData];
}

- (void)moveDestination:(CLLocationCoordinate2D)newCoordinate animated:(BOOL)isAnnimation
{
    [self.mapView deselectAnnotation:self.poi animated:NO];
    MKAnnotationView *annotationView;
    CGRect beginFrame;
    if (isAnnimation)
    {
        annotationView = [self.mapView viewForAnnotation:self.poi];
        beginFrame = annotationView.frame;
    }
    self.poi.subtitle = nil;
    [self.poi setCoordinate:newCoordinate];
    if (isAnnimation)
    {
        CGRect endFrame = annotationView.frame;
        annotationView.frame = beginFrame;
        [UIView beginAnimations:@"moving" context:NULL];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [annotationView setFrame:endFrame];
        [UIView commitAnimations];
    }
}


#pragma mark - GDataXMLParserDelegate
- (void)parser:(GDataXMLParser *)parser DidParsedData:(NSDictionary *)data
{
    if (_pageIndex == 1)
    {
        [self.hotelsArray removeAllObjects];
    }
    _totalHotelCount = [data[@"total"] intValue];
    
    if (_totalHotelCount == 0)
    {
        self.noResultLabel.hidden = NO;
        [self hideIndicatorView];
        self.hotelTableView.tableFooterView = nil;
        return;
    }
    else
    {
        self.noResultLabel.hidden = YES;
    }
    
    [self.hotelsArray addObjectsFromArray:data[@"hotelList"]];
    
    if (self.hotelsArray.count == _totalHotelCount) {
        self.hotelTableView.tableFooterView = nil;
    }
    self.hotelCountLabel.text = [NSString stringWithFormat:@"一共%d家酒店", _totalHotelCount];
    
    [self.hotelTableView reloadData];
    
    [self initMapAnnotation];
    
    //rebuild map view
    if (isHotelListFlag) {
        [self hideIndicatorView];
    } else {
        [self gotoLocation];
    }
    
}

- (void)parser:(GDataXMLParser *)parser DidFailedParseWithMsg:(NSString *)msg errCode:(NSInteger)code
{
    [self hideIndicatorView];
    if(code == -1 || code == 10000)
    {   [self showAlertMessageWithOkCancelButton:kNetworkProblemAlertMessage title:nil tag:0 delegate:self];    }
    else
    {
        [self showAlertMessageWithOkButton:msg title:nil tag:0 delegate:nil];
        [self.hotelTableView setTableFooterView:nil];
    }
}


//#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.hotelsArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *HotelTableIdentifier = @"HotelTableCell";
    HotelTableCell *cell = [tableView dequeueReusableCellWithIdentifier:HotelTableIdentifier];
    if (cell == nil) {
        cell = [[HotelTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:HotelTableIdentifier];
    }

    JJHotel *hotel = self.hotelsArray[indexPath.row];
    NSString *trimText = [hotel.name  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (trimText.length<5) {
        [cell.nameLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
        if (hotel.hasCoupon) {
            cell.saleHotelImg.hidden = NO;
                cell.saleHotelImg.frame = CGRectMake(122 - 18, cell.saleHotelImg.frame.origin.y, cell.saleHotelImg.frame.size.width, cell.saleHotelImg.frame.size.height);
        }
    }else if (trimText.length >=5 &&trimText.length<7) {
        [cell.nameLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
        if(hotel.hasCoupon){
            cell.saleHotelImg.hidden = NO;
        }
    }else if (trimText.length >= 7 && trimText.length<12) {
        [cell.nameLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
        cell.nameLabel.frame = CGRectMake(cell.nameLabel.frame.origin.x, cell.nameLabel.frame.origin.y, 110 + 20, cell.nameLabel.bounds.size.height);
        if(hotel.hasCoupon){
            cell.saleHotelImg.hidden = NO;
            cell.saleHotelImg.frame = CGRectMake(122 + 15, cell.saleHotelImg.frame.origin.y, cell.saleHotelImg.frame.size.width, cell.saleHotelImg.frame.size.height);
        }
    } else if(trimText.length >= 12 && trimText.length<16){
        [cell.nameLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12]];
        cell.nameLabel.frame = CGRectMake(cell.nameLabel.frame.origin.x, cell.nameLabel.frame.origin.y, 110+ 40, cell.nameLabel.bounds.size.height);
        if(hotel.hasCoupon){
            cell.saleHotelImg.hidden = NO;
            cell.saleHotelImg.frame = CGRectMake(122 + 30, cell.saleHotelImg.frame.origin.y, cell.saleHotelImg.frame.size.width, cell.saleHotelImg.frame.size.height);
        }
    }else{
        [cell.nameLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12]];
        cell.nameLabel.frame = CGRectMake(cell.nameLabel.frame.origin.x, cell.nameLabel.frame.origin.y, 110+ 35, cell.nameLabel.bounds.size.height);
        if(hotel.hasCoupon){
            cell.saleHotelImg.hidden = NO;
            cell.saleHotelImg.frame = CGRectMake(122 + 50, cell.saleHotelImg.frame.origin.y, cell.saleHotelImg.frame.size.width, cell.saleHotelImg.frame.size.height);
        }
    }
    
    cell.nameLabel.text = hotel.name;
   
    if(hotel.price<=0){
        cell.priceLabel.font = [UIFont systemFontOfSize:18];
        cell.priceLabel.textAlignment = NSTextAlignmentCenter;
        cell.priceLabel.text = [NSString stringWithFormat:@"售完"];
    }else if(hotel.price>=1000){
        cell.priceLabel.textAlignment = NSTextAlignmentLeft;
        cell.priceLabel.font = [UIFont fontWithName:@"Georgia" size:20];
        cell.priceLabel.text = [NSString stringWithFormat:@"￥%d", hotel.price];
    }else{
        cell.priceLabel.textAlignment = NSTextAlignmentLeft;
        cell.priceLabel.font = [UIFont fontWithName:@"Georgia" size:24];
        cell.priceLabel.text = [NSString stringWithFormat:@"￥%d", hotel.price];
    }
    cell.areaLabel.text = hotel.zone;
    
    [cell.iconView setImageWithURL:[NSURL URLWithString:hotel.imageUrl] placeholderImage:[UIImage imageNamed:@"defaultHotelIcon.png"]];
    cell.distanceLabel.text = [NSString stringWithFormat:@"%0.1f公里", hotel.distance];
    cell.starView = [[JJStarView alloc] initWithStar:hotel.star];
    cell.starView.frame =CGRectMake(16, cell.areaLabel.frame.origin.y +5, cell.starView.bounds.size.width, cell.starView.bounds.size.height);
    [cell addSubview:cell.starView];
    //load next page data
    if ((indexPath.row == self.hotelsArray.count-1) && self.hotelsArray.count < _totalHotelCount)
    {
        _pageIndex++;
        [self downloadData];
    }else if (indexPath.row + 1 == _totalHotelCount) {
        _isBottem = YES;
    }
    return cell;
}


- (void)scrollViewDidScroll:(UIScrollView *)aScrollView {
    CGPoint offset = aScrollView.contentOffset;
    CGRect bounds = aScrollView.bounds;
    CGSize size = aScrollView.contentSize;
    UIEdgeInsets inset = aScrollView.contentInset;
    float y = offset.y + bounds.size.height - inset.bottom;
    float h = size.height;
    
    if (_isBottem && y > h-90) {
        //todo show
        self.hotelCountLabel.frame = _countLabelFrame;
        self.hotelCountLabel.hidden = NO;
    }else{
        //todo hidden
        self.hotelCountLabel.frame = CGRectMake(_countLabelFrame.origin.x, _countLabelFrame.origin.y + (h - y)/5,_countLabelFrame.size.width,_countLabelFrame.size.height);
    }
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.row +1 == _totalHotelCount) {
//        return 265;
//    }
    return 245;
}

//设置group之间的间距
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 1)];
    [headView setBackgroundColor:[UIColor clearColor]];
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footView =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 1)];
    [footView setBackgroundColor:[UIColor clearColor]];
    return footView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self showIndicatorView];
    HotelTableCell *cell = (HotelTableCell *)[tableView cellForRowAtIndexPath:indexPath];
    [UMAnalyticManager eventCount:@"酒店列表页面点击进入酒店详情" label:@"酒店列表页面点击进入酒店详情事件"];
    [self performSelector:@selector(pageToDetail:) withObject:cell afterDelay:0.5];
}


- (void)pageToDetail:(HotelTableCell *) cell
{
    [self performSegueWithIdentifier:FROM_HOTEL_LIST_TO_DETAIL sender:nil];
    [self hideIndicatorView];
    [cell setSelected:NO animated:YES];
}

-(void)showDetails:(JJHotel *)hotel
{
    [self performSegueWithIdentifier:FROM_MAP_HOTEL_LIST_TO_DETAIL sender:hotel];
    [self hideIndicatorView];
}


// user tapped the disclosure button in the callout
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    id <MKAnnotation> annotation = [view annotation];
    if ([annotation isKindOfClass:[HotelAnnotation class]])
    {
        HotelAnnotation *hotelAnnotation = (HotelAnnotation *)annotation;
        [self showDetails:hotelAnnotation.hotel];
    }
    
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    // in case it's the user location, we already have an annotation, so just return nil
    if ([annotation isKindOfClass:[MKUserLocation class]])
    {
        return nil;
    }
    if ([annotation isKindOfClass:[HotelAnnotation class]]){
        static NSString *HotelAnnotationIdentifier = @"HotelAnnotationIdentifier";
        
        HotelAnnotationView *annotationView =
        (HotelAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:HotelAnnotationIdentifier];
        if (annotationView == nil)
        {
            annotationView = [[HotelAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:HotelAnnotationIdentifier];
        }
        annotationView.canShowCallout = YES;
        
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        [rightButton addTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
        annotationView.rightCalloutAccessoryView = rightButton;
        return annotationView;
    }
    
    return nil;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender    //  Hotel Detail
{
    if ([segue.identifier isEqualToString:FROM_HOTEL_LIST_TO_DETAIL])
    {
        HotelDetailViewController *detailVC = (HotelDetailViewController *)(segue.destinationViewController);
        detailVC.hotel = self.hotelsArray[[self.hotelTableView indexPathForSelectedRow].row];
        [detailVC setIsFromOrder:NO];
    }
    if ([FROM_MAP_HOTEL_LIST_TO_DETAIL isEqualToString:segue.identifier]) {
        HotelDetailViewController *detailVC = (HotelDetailViewController *)(segue.destinationViewController);
        detailVC.hotel = (JJHotel *) sender;
        [detailVC setIsFromOrder:NO];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
