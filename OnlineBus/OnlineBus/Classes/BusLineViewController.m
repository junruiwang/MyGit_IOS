//
//  BusLineViewController.m
//  OnlineBus
//
//  Created by jerry on 13-12-5.
//  Copyright (c) 2013年 jerry.wang. All rights reserved.
//

#import "BusLineViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "BusLineParser.h"
#import "BusLineTableViewCell.h"
#import "BusLine.h"
#import "RegexKitLite.h"
#import "BusDetailViewController.h"

@interface BusLineViewController ()

@property (nonatomic, strong) NSMutableArray *busLineArray;
@property (nonatomic, strong) NSMutableArray *busLineTotalArray;

@property (nonatomic, strong) BusLineParser *busLineParser;
@property (nonatomic, strong) UIControl *touchView;

@end

@implementation BusLineViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _busLineArray = [[NSMutableArray alloc] initWithCapacity:10];
        _busLineTotalArray = [[NSMutableArray alloc] initWithCapacity:10];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.screenName = @"线路查询页面";
    //设置顶部查询栏视图背景色
    self.topSearchView.layer.borderColor = [UIColor colorWithRed:215.0/255.0 green:215.0/255.0 blue:215.0/255.0 alpha:1.0].CGColor;
    self.topSearchView.layer.borderWidth = 1.0;
    //设置遮罩层背景色
    self.touchView = [[UIControl alloc] initWithFrame:self.tableView.frame];
    [self.touchView addTarget:self action:@selector(closeTouchView) forControlEvents:UIControlEventTouchUpInside];
    self.touchView.backgroundColor = [UIColor blackColor];
    self.touchView.alpha = 0.8;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.parentViewController.navigationItem.title = @"线路查询";
    [self loadCustomBanner];
}

- (IBAction)searchButtonTapped:(id)sender
{
    [self.queryField resignFirstResponder];
    [self.touchView removeFromSuperview];
    
    if ([ValidateInputUtil isNotEmpty:self.queryField.text fieldCName:@"查询线路"]) {
        //GA跟踪搜索按钮
        [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createEventWithCategory:@"线路查询" action:@"用户点击" label:@"查询按钮" value:nil] build]];
        [self downloadData];
    }
}

- (void)closeTouchView
{
    [self.queryField resignFirstResponder];
    [self.touchView removeFromSuperview];
}

- (void)downloadData
{
    if (self.busLineParser != nil) {
        [self.busLineParser cancel];
        self.busLineParser = nil;
    }
    self.busLineParser = [[BusLineParser alloc] init];
    self.busLineParser.serverAddress = query_bus_line;
    self.busLineParser.requestString = [NSString stringWithFormat:@"lineNumber=%@",self.queryField.text];
    self.busLineParser.delegate = self;
    [self.busLineParser start];
    [SVProgressHUD showWithStatus:@"正在为您查询" maskType:SVProgressHUDMaskTypeGradient];
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
    cell.lineDescLabel.text = [self getLineTypeDesc:busLine.lineNumber];
    cell.sepView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dashed_detail.png"]];
    
    //cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:FROM_BUSLIST_TO_BUSDETAIL sender:self];
}

#pragma mark JsonParserDelegate
- (void)parser:(JsonParser*)parser DidParsedData:(NSDictionary *)data
{
    self.busLineArray = [data valueForKey:@"data"];
    self.busLineTotalArray = [data valueForKey:@"busLineArry"];
    [self.tableView reloadData];
    [SVProgressHUD dismiss];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self.view addSubview:self.touchView];
}

@end
