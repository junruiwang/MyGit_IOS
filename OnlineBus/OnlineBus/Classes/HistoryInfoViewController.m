//
//  HistoryInfoViewController.m
//  Bustime
//
//  Created by 汪君瑞 on 13-3-31.
//  Copyright (c) 2013年 Jerry Wang. All rights reserved.
//

#import "HistoryInfoViewController.h"
#import "FaverateBusLineManager.h"
#import "FaverateStationBusManager.h"
#import "BusLineTableViewCell.h"
#import "StationTableViewCell.h"
#import "BusDetailViewController.h"
#import "StationBusViewController.h"
#import "RegexKitLite.h"

#define kBusLineTag 130
#define kStationTag 140
#define CLEAN_BUTTON_TAG 140

@interface HistoryInfoViewController ()<UIAlertViewDelegate>

@property (nonatomic, strong) UIButton *rightBtn;
@property(nonatomic, strong) FaverateBusLineManager *faverateBusLineManager;
@property (nonatomic, strong) NSMutableArray *busLineArray;
@property (nonatomic, strong) NSMutableArray *busLineTotalArray;
@property(nonatomic, strong) FaverateStationBusManager *faverateStationBusManager;
@property (nonatomic, strong) NSMutableArray *stationArray;
@property (nonatomic, strong) NSMutableArray *stationTotalArray;

- (void)cleanButtonClicked:(id)sender;

@end

@implementation HistoryInfoViewController

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _faverateBusLineManager = [[FaverateBusLineManager alloc] init];
        _busLineArray = [[NSMutableArray alloc] initWithCapacity:10];
        _busLineTotalArray = [[NSMutableArray alloc] initWithCapacity:10];
        
        _faverateStationBusManager = [[FaverateStationBusManager alloc] init];
        _stationArray = [[NSMutableArray alloc] initWithCapacity:10];
        _stationTotalArray = [[NSMutableArray alloc] initWithCapacity:10];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.screenName = @"我的收藏页面";
    [self loadSegmentedButton];
}

- (void)downloadData
{
    [self.faverateBusLineManager buildLocalFileToArray:self.busLineArray total:self.busLineTotalArray];
    [self.faverateStationBusManager buildLocalFileToArray:self.stationArray total:self.stationTotalArray];
    
    if (self.busLineArray.count >0 || self.stationTotalArray.count >0) {
        //设置清除按钮
        self.rightBtn = [self generateNavButton:@"list_delete.png"  action:@selector(cleanButtonClicked:)];
        self.rightBtn.frame = CGRectMake(0, 0, 30, 30);
        
        UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightBtn];
        self.parentViewController.navigationItem.rightBarButtonItem = barButtonItem;
    } else {
        self.parentViewController.navigationItem.rightBarButtonItem = nil;
    }
    
    [self.busLineTableView reloadData];
    [self.stationTableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.parentViewController.navigationItem.title = @"我的收藏";
    [self downloadData];
    [self loadCustomBanner];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.parentViewController.navigationItem.rightBarButtonItem = nil;
}

- (void)loadSegmentedButton
{
    // segmented control as the custom title view
	NSArray *segmentTextContent = [NSArray arrayWithObjects:
                                   NSLocalizedString(@"收藏线路", @""),
                                   NSLocalizedString(@"收藏站点", @""),
								   nil];
	UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:segmentTextContent];
	segmentedControl.selectedSegmentIndex = 0;
	segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
	segmentedControl.frame = CGRectMake(90, 9, 140, kCustomButtonHeight);
	[segmentedControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
        
    [self.topView addSubview:segmentedControl];
}

- (void)viewDidUnload
{
    self.busLineTableView = nil;
    self.stationTableView = nil;
    self.topView = nil;
    self.rightBtn = nil;
    
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)segmentAction:(id)sender
{
	// The segmented control was clicked, handle it here
	UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
    if (segmentedControl.selectedSegmentIndex == 0) {
        self.busLineTableView.hidden = NO;
        self.stationTableView.hidden = YES;
    } else {
        self.busLineTableView.hidden = YES;
        self.stationTableView.hidden = NO;
    }
}

- (void)cleanButtonClicked:(id)sender
{
    [self showAlertMessageWithOkCancelButton:@"您可以侧滑删除行记录，您确定要清除所有收藏的记录吗？" tag:CLEAN_BUTTON_TAG delegate:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:FROM_FAVERATE_TO_BUSDETAIL])
    {
        BusDetailViewController *busDetailViewController = (BusDetailViewController *)segue.destinationViewController;
        BusLine *busLine = [self.busLineArray objectAtIndex:[[self.busLineTableView indexPathForSelectedRow] row]];
        
        NSMutableArray *doubleArray = [[NSMutableArray alloc] initWithCapacity:2];
        for (BusLine *tmpBusLine in self.busLineTotalArray) {
            if ([tmpBusLine.lineNumber isEqualToString:busLine.lineNumber]) {
                [doubleArray addObject:tmpBusLine];
            }
        }
        busDetailViewController.busLineArray = doubleArray;
    } else if ([segue.identifier isEqualToString:FROM_FAVERATE_TO_STATIONBUS]) {
        StationBusViewController *stationBusViewController = (StationBusViewController *)segue.destinationViewController;
        
        BusStation *busStation = [self.stationTotalArray objectAtIndex:[[self.stationTableView indexPathForSelectedRow] row]];
        NSMutableArray *doubleArray = [[NSMutableArray alloc] initWithCapacity:2];
        for (BusStation *tmpBusStation in self.stationTotalArray) {
            if ([tmpBusStation.standName isEqualToString:busStation.standName]) {
                [doubleArray addObject:tmpBusStation];
            }
        }
        stationBusViewController.stationArray = doubleArray;
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    if (tableView.tag == kBusLineTag) {
        BusLine *busLine = [self.busLineArray objectAtIndex:[indexPath row]];
        [self.busLineArray removeObjectAtIndex:row];
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                         withRowAnimation:UITableViewRowAnimationAutomatic];
        
        [self.faverateBusLineManager deleteBusLineInFaverate:busLine.lineNumber];
    } else {
        BusStation *busStation = [self.stationTotalArray objectAtIndex:[indexPath row]];
        [self.stationTotalArray removeObjectAtIndex:row];
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                         withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.faverateStationBusManager deleteBusStationInFaverate:busStation.standName];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == kBusLineTag) {
        return [self.busLineArray count];
    } else {
        return [self.stationTotalArray count];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == kBusLineTag) {
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
        cell.lineDescLabel.text = [self getLineTypeDesc:busLine.lineNumber];
        cell.sepView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dashed_detail.png"]];
        
        return cell;
    } else {
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
    
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == kBusLineTag) {
        [self performSegueWithIdentifier:FROM_FAVERATE_TO_BUSDETAIL sender:self];
    } else {
        [self performSegueWithIdentifier:FROM_FAVERATE_TO_STATIONBUS sender:self];
    }
}

- (NSString *)getLineTypeDesc:(NSString *)lineNumber
{
    NSInteger count = 0;
    for (BusLine *tmpBusLine in self.busLineTotalArray) {
        if ([tmpBusLine.lineNumber isEqualToString:lineNumber]) {
            count += 1;
        }
    }
    
    NSString *lineTypeString = @"";
    
    switch (count) {
        case 1:
            lineTypeString = @"单向线路";
            break;
        case 2:
            lineTypeString = @"双向线路";
            break;
        case 3:
            lineTypeString = @"双向线路 + 短程线路";
            break;
        default:
            lineTypeString = @"";
            break;
    }
    
    return lineTypeString;
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == CLEAN_BUTTON_TAG && buttonIndex == 1) {
        [self.faverateBusLineManager deleteAllBusLineInFaverate];
        [self.faverateStationBusManager deleteAllBusStationInFaverate];
        [self downloadData];
    }
}

@end
