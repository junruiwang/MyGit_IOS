//
//  StationBusViewController.m
//  Bustime
//
//  Created by 汪君瑞 on 13-4-6.
//  Copyright (c) 2013年 Jerry Wang. All rights reserved.
//

#import "StationBusViewController.h"
#import "BusLineTableViewCell.h"
#import "BusLine.h"
#import "BusStation.h"
#import "BusDetailViewController.h"
#import "FaverateStationBusManager.h"
#import "RegexKitLite.h"


@interface StationBusViewController ()

@property (nonatomic, strong) NSMutableArray *busLineArray;
@property (nonatomic, strong) NSMutableArray *busLineTotalArray;
@property(nonatomic, strong) BusLineParser *busLineParser;
@property(nonatomic, assign) BOOL isFirst;
@property(nonatomic, strong) FaverateStationBusManager *faverateStationBusManager;
@property(nonatomic, assign) BOOL isFaverate;
@property(nonatomic, strong) UIButton *faverateButton;
@property(nonatomic, strong) UIView *noDataView;

@end

@implementation StationBusViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _busLineArray = [[NSMutableArray alloc] initWithCapacity:10];
        _busLineTotalArray = [[NSMutableArray alloc] initWithCapacity:10];
        _faverateStationBusManager = [[FaverateStationBusManager alloc] init];
        _isFirst = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.screenName = @"站点关联线路查询页面";
    self.navigationItem.title = @"线路查询";
    
    if ([self.stationArray count] >0) {
        BusStation *busStation = [self.stationArray objectAtIndex:0];
        [self downloadData:busStation.standCode];
    }
}

- (void)loadDefaultPageView
{
    BusStation *busStation = [self.stationArray objectAtIndex:0];
    self.isFaverate = [self.faverateStationBusManager isBusStationInFaverate:busStation.standName];
    
    if (self.isFaverate)
    {
        if (SYSTEM_VERSION <7.0f) {
            self.faverateButton = [self generateNavButton:@"heart_icon_red.png"  action:@selector(faverateButtonClicked:)];
        } else {
            self.faverateButton = [self generateNavButton:@"favorite_delete.png"  action:@selector(faverateButtonClicked:)];
        }
    }
    else
    {
        if (SYSTEM_VERSION <7.0f) {
            self.faverateButton = [self generateNavButton:@"heart_icon.png"  action:@selector(faverateButtonClicked:)];
        } else {
            self.faverateButton = [self generateNavButton:@"favorite_add.png"  action:@selector(faverateButtonClicked:)];
        }
    }
    [self addRightBarButton:self.faverateButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)noDataViewShow
{
    self.noDataView = [[UIView alloc] initWithFrame:CGRectMake(60, self.view.frame.size.height - 300, 200, 60)];
    self.noDataView.backgroundColor = [UIColor whiteColor];
    self.noDataView.layer.borderColor = [UIColor colorWithRed:215.0/255.0 green:215.0/255.0 blue:215.0/255.0 alpha:1.0].CGColor;
    self.noDataView.layer.borderWidth = 1.0;
    UILabel *messageBox = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 190, 50)];
    messageBox.lineBreakMode = NSLineBreakByWordWrapping;
    messageBox.numberOfLines = 0;
    messageBox.backgroundColor = [UIColor clearColor];
    messageBox.textColor = [UIColor darkTextColor];
    messageBox.font = [UIFont systemFontOfSize:15];
    messageBox.text = @"暂时无运行车辆信息";
    messageBox.textAlignment = NSTextAlignmentCenter;
    [self.noDataView addSubview:messageBox];
    [self.view addSubview:self.noDataView];
}

- (void)downloadData:(NSString *) stationCode
{
    if (self.busLineParser != nil) {
        [self.busLineParser cancel];
        self.busLineParser = nil;
    }
    self.busLineParser = [[BusLineParser alloc] init];
    self.busLineParser.serverAddress = query_station_line;
    self.busLineParser.requestString = [NSString stringWithFormat:@"stationCode=%@", stationCode];
    self.busLineParser.delegate = self;
    [self.busLineParser start];
    
    if (self.isFirst) {
        [SVProgressHUD showWithStatus:@"正在为您查询" maskType:SVProgressHUDMaskTypeGradient];
    }
}

- (void)faverateButtonClicked:(id) sender
{
    BusStation *busStation = [self.stationArray objectAtIndex:0];
    if (self.isFaverate) {
        [self.faverateStationBusManager deleteBusStationInFaverate:busStation.standName];
        if (SYSTEM_VERSION <7.0f) {
            [self.faverateButton setImage:[UIImage imageNamed:@"heart_icon.png"] forState:UIControlStateNormal];
        } else {
            [self.faverateButton setImage:[UIImage imageNamed:@"favorite_add.png"] forState:UIControlStateNormal];
        }
        [self showAlertMessage:@"您已经成功删除收藏的站点！" dismissAfterDelay:1.2];
    } else {
        [self.faverateStationBusManager insertIntoFaverateWithStation:busStation];
        if ([self.stationArray count] > 1) {
            [self.faverateStationBusManager insertIntoFaverateWithStation:[self.stationArray objectAtIndex:1]];
        }
        if (SYSTEM_VERSION <7.0f) {
            [self.faverateButton setImage:[UIImage imageNamed:@"heart_icon_red.png"] forState:UIControlStateNormal];
        } else {
            [self.faverateButton setImage:[UIImage imageNamed:@"favorite_delete.png"] forState:UIControlStateNormal];
        }
        [self showAlertMessage:@"您已经成功收藏本站点！" dismissAfterDelay:1.2];
    }
    self.isFaverate = !self.isFaverate;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[BusDetailViewController class]]) {
        BusDetailViewController *busDetailViewController = (BusDetailViewController *)segue.destinationViewController;
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        BusLine *busLine = [self.busLineArray objectAtIndex:[indexPath row]];
        
        NSMutableArray *doubleArray = [[NSMutableArray alloc] initWithCapacity:2];
        for (BusLine *tmpBusLine in self.busLineTotalArray) {
            if ([tmpBusLine.lineNumber isEqualToString:busLine.lineNumber]) {
                [doubleArray addObject:tmpBusLine];
            }
        }
        busDetailViewController.busLineArray = doubleArray;
        
        BusLineTableViewCell *cell = (BusLineTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        [cell setSelected:NO animated:YES];
    }
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.busLineArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BusLineTableViewCell *cell = (BusLineTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"LineTableViewCell"];
    cell.backgroundColor = [UIColor clearColor];
    BusLine *busLine = [self.busLineArray objectAtIndex:[indexPath row]];
    
    NSString *regexString = @"^[0-9]*$";
    
    BOOL matched = [busLine.lineNumber isMatchedByRegex:regexString];
    if (matched) {
        cell.lineNameLabel.text =[NSString stringWithFormat:@"%@路", busLine.lineNumber];
    } else {
        cell.lineNameLabel.text = busLine.lineNumber;
    }
    
    cell.stationLabel.text = [NSString stringWithFormat:@"%@ - %@", busLine.startStation, busLine.endStation];
    
    BOOL matchStandNum = [busLine.standNum isMatchedByRegex:regexString];
    if (matchStandNum) {
        cell.lineDescLabel.text =[NSString stringWithFormat:@"%@站", busLine.standNum];
    } else {
        cell.lineDescLabel.text = busLine.standNum;
    }
    cell.sepView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dashed_detail.png"]];
    
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:FROM_BUSSTATION_TO_BUSDETAIL sender:self];
}

#pragma mark - BaseJSONParserDelegate

- (void)parser:(JsonParser*)parser DidFailedParseWithMsg:(NSString*)msg errCode:(NSInteger)code
{
    [SVProgressHUD dismiss];
    [self showAlertMessage:@"很抱歉，可能是网络原因，无法帮助到您，请稍后再试！" dismissAfterDelay:1.2];
}

- (void)parser:(JsonParser*)parser DidParsedData:(NSDictionary *)data
{
    if (self.isFirst) {
        self.busLineArray = [data valueForKey:@"data"];
        self.busLineTotalArray = [data valueForKey:@"busLineArry"];
        
        if (self.busLineArray.count==0 && self.isFirst) {
            [self noDataViewShow];
        }
        self.isFirst = NO;
        
        if (self.busLineArray.count >0) {
            [self.noDataView removeFromSuperview];
            [self loadDefaultPageView];
            
            [self.tableView reloadData];
            if ([self.stationArray count] > 1) {
                BusStation *busStation = [self.stationArray objectAtIndex:1];
                [self downloadData:busStation.standCode];
            } else {
                [SVProgressHUD dismiss];
            }
        } else {
            [SVProgressHUD dismiss];
        }
    } else {
        [self.busLineTotalArray addObjectsFromArray:[data valueForKey:@"busLineArry"]];
        [SVProgressHUD dismiss];
    }
    
}

@end
