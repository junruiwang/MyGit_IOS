//
//  StationSearchViewController.m
//  Bustime
//
//  Created by 汪君瑞 on 13-3-31.
//  Copyright (c) 2013年 Jerry Wang. All rights reserved.
//

#import "StationSearchViewController.h"
#import "StationTableViewCell.h"
#import "BusStation.h"
#import "ValidateInputUtil.h"

@interface StationSearchViewController ()

@property (nonatomic, strong) NSMutableArray *stationTotalArray;
@property (nonatomic, strong) BusStationParser *busStationParser;

@property (nonatomic, strong) UIControl *touchView;

@end

@implementation StationSearchViewController

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _stationTotalArray = [[NSMutableArray alloc] initWithCapacity:10];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.screenName = @"站点搜索页面";
	
    //设置顶部查询栏视图背景色
    self.topSearchView.layer.borderColor = [UIColor colorWithRed:215.0/255.0 green:215.0/255.0 blue:215.0/255.0 alpha:1.0].CGColor;
    self.topSearchView.layer.borderWidth = 1.0;
    //设置遮罩层背景色
    self.touchView = [[UIControl alloc] initWithFrame:self.tableView.frame];
    [self.touchView addTarget:self action:@selector(closeTouchView) forControlEvents:UIControlEventTouchUpInside];
    self.touchView.backgroundColor = [UIColor blackColor];
    self.touchView.alpha = 0.8;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.parentViewController.navigationItem.title = @"站点查询";
    [self loadCustomBanner];
}

- (void)downloadData
{
    if (self.busStationParser != nil) {
        [self.busStationParser cancel];
        self.busStationParser = nil;
    }
    self.busStationParser = [[BusStationParser alloc] init];
    self.busStationParser.serverAddress = query_bus_station;
    self.busStationParser.requestString = [NSString stringWithFormat:@"stationName=%@",self.queryField.text];
    self.busStationParser.delegate = self;
    [self.busStationParser start];
    [SVProgressHUD showWithStatus:@"正在为您查询" maskType:SVProgressHUDMaskTypeGradient];
}

- (IBAction)searchButtonTapped:(id)sender
{
    [self.queryField resignFirstResponder];
    [self.touchView removeFromSuperview];
    
    if ([ValidateInputUtil isNotEmpty:self.queryField.text fieldCName:@"查询站点"]) {
        //GA跟踪搜索按钮
        [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createEventWithCategory:@"站点查询" action:@"用户点击" label:@"查询按钮" value:nil] build]];
        [self downloadData];
    }
}

- (void)closeTouchView
{
    [self.queryField resignFirstResponder];
    [self.touchView removeFromSuperview];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
//    if ([segue.destinationViewController isKindOfClass:[StationBusViewController class]]) {
//        StationBusViewController *stationBusViewController = (StationBusViewController *)segue.destinationViewController;
//        
//        BusStation *busStation = [self.stationArray objectAtIndex:[[self.tableView indexPathForSelectedRow] row]];
//        
//        NSMutableArray *doubleArray = [[NSMutableArray alloc] initWithCapacity:2];
//        for (BusStation *tmpBusStation in self.stationTotalArray) {
//            if ([tmpBusStation.standName isEqualToString:busStation.standName]) {
//                [doubleArray addObject:tmpBusStation];
//            }
//        }
//        stationBusViewController.stationArray = doubleArray;
//    }
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.stationTotalArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    StationTableViewCell *cell = (StationTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"StationTableViewCell"];
    cell.backgroundColor = [UIColor clearColor];
    BusStation *busStation = [self.stationTotalArray objectAtIndex:[indexPath row]];
    cell.stationNameLabel.text = [NSString stringWithFormat:@"%@（%@）",busStation.standName, busStation.trend];
    cell.areaLabel.text = busStation.area;
    cell.roadLabel.text = busStation.road;
    cell.busLabel.text = [NSString stringWithFormat:@"途经站台的线路：%@",busStation.bus];
    cell.sepView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dashed_detail.png"]];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"" sender:self];
}

#pragma mark - JsonParserDelegate

- (void)parser:(JsonParser*)parser DidFailedParseWithMsg:(NSString*)msg errCode:(NSInteger)code
{
    [SVProgressHUD dismiss];
    [self showAlertMessage:@"很抱歉，可能是网络原因，无法帮助到您，请稍后再试！" dismissAfterDelay:1.2];
}

- (void)parser:(JsonParser*)parser DidParsedData:(NSDictionary *)data
{
    self.stationTotalArray = [data valueForKey:@"data"];
    [self.tableView reloadData];
    [SVProgressHUD dismiss];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self.view addSubview:self.touchView];
}

@end
