//
//  BusLineViewController.m
//  Bustime
//
//  Created by 汪君瑞 on 13-3-31.
//  Copyright (c) 2013年 Jerry Wang. All rights reserved.
//

#import "BusLineViewController.h"
#import "SVProgressHUD.h"
#import "ServerAddressManager.h"
#import "BusLineTableViewCell.h"
#import "BusLine.h"
#import "RegexKitLite.h"
#import "BusDetailViewController.h"

@interface BusLineViewController ()

@end

@implementation BusLineViewController

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _busLineArray = [[NSMutableArray alloc] initWithCapacity:10];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadCustomBanner];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)searchButtonTapped:(id)sender
{
    [self.queryField resignFirstResponder];
    [self downloadData];
}

- (void)downloadData
{
    if (self.busLineParser != nil) {
        [self.busLineParser cancel];
        self.busLineParser = nil;
    }
    self.busLineParser = [[BusLineParser alloc] init];
    self.busLineParser.serverAddress = [ServerAddressManager serverAddress:@"query_bus_line"];
    self.busLineParser.requestString = [NSString stringWithFormat:@"lineNumber=%@",self.queryField.text];
    self.busLineParser.delegate = self;
    [self.busLineParser start];
    [SVProgressHUD showWithStatus:@"正在加载" maskType:SVProgressHUDMaskTypeGradient];
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
    BusLineTableViewCell *cell = (BusLineTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"BusLineTableViewCell"];
    cell.iconView.clipsToBounds = YES;
    
    BusLine *busLine = [self.busLineArray objectAtIndex:[indexPath row]];
    
    NSString *regexString = @"^[0-9]*$";

    BOOL matched = [busLine.lineNumber isMatchedByRegex:regexString];
    if (matched) {
        cell.nameLabel.text =[NSString stringWithFormat:@"%@路", busLine.lineNumber];
    } else {
        cell.nameLabel.text = busLine.lineNumber;
    }
    
    cell.stationLabel.text = [NSString stringWithFormat:@"%@ - %@", busLine.startStation, busLine.endStation];
    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    //cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark -
#pragma mark BaseJSONParserDelegate
- (void)parser:(GDataParser*)parser DidFailedParseWithMsg:(NSString*)msg errCode:(NSInteger)code
{
    
}

- (void)parser:(GDataParser*)parser DidParsedData:(NSDictionary *)data
{
    self.busLineArray = [data valueForKey:@"data"];
    [self.tableView reloadData];
    [SVProgressHUD dismiss];
}

@end
