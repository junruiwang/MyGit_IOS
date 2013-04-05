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

@interface StationSearchViewController ()

@property (nonatomic, strong) NSMutableArray *stationArray;
@property (nonatomic, strong) NSMutableArray *stationTotalArray;
@property (nonatomic, strong) BusStationParser *busStationParser;

@end

@implementation StationSearchViewController

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _stationArray = [[NSMutableArray alloc] initWithCapacity:10];
        _stationTotalArray = [[NSMutableArray alloc] initWithCapacity:10];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"站点查询";
	[self loadCustomBanner];
}

- (void)downloadData
{
    if (self.busStationParser != nil) {
        [self.busStationParser cancel];
        self.busStationParser = nil;
    }
    self.busStationParser = [[BusStationParser alloc] init];
    self.busStationParser.serverAddress = [ServerAddressManager serverAddress:@"query_bus_station"];
    self.busStationParser.requestString = [NSString stringWithFormat:@"stationName=%@",self.queryField.text];
    self.busStationParser.delegate = self;
    [self.busStationParser start];
    [SVProgressHUD showWithStatus:@"正在加载" maskType:SVProgressHUDMaskTypeGradient];
}

- (IBAction)searchButtonTapped:(id)sender
{
    [self.queryField resignFirstResponder];
    [self downloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.stationArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    StationTableViewCell *cell = (StationTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"StationTableViewCell"];
    cell.iconView.clipsToBounds = YES;
    
    BusStation *busStation = [self.stationArray objectAtIndex:[indexPath row]];
    cell.stationLabel.text = busStation.standName;
    cell.areaLabel.text = busStation.area;
    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    //cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    
    return cell;
}

#pragma mark -
#pragma mark BaseJSONParserDelegate
- (void)parser:(GDataParser*)parser DidFailedParseWithMsg:(NSString*)msg errCode:(NSInteger)code
{
    
}

- (void)parser:(GDataParser*)parser DidParsedData:(NSDictionary *)data
{
    self.stationArray = [data valueForKey:@"data"];
    self.stationTotalArray = [data valueForKey:@"stationTotalArray"];
    [self.tableView reloadData];
    [SVProgressHUD dismiss];
}

@end
