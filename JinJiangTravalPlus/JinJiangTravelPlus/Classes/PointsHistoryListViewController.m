//
//  PointsHostoryListViewController.m
//  JinJiangTravelPlus
//
//  Created by 胡 桂祁 on 7/15/13.
//  Copyright (c) 2013 JinJiang. All rights reserved.
//

#import "PointsHistoryListViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "PointsHistoryCell.h"
#import "PointsHistory.h"
#import "PointsHistoryParser.h"
#import "PointsHistoryCacheHelper.h"
#import "NSString+Categories.h"
#import "SVProgressHUD.h"

@interface PointsHistoryListViewController ()

@property(nonatomic,strong) PointsHistoryParser *pointsHistoryParser;

@end

@implementation PointsHistoryListViewController


-(void)viewWillAppear:(BOOL)animated
{
    self.trackedViewName = @"积分历史查询页面";
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//     [self.pointsHistoryParser loadHistoryPointsRecentMonth];
    
    if (![PointsHistoryCacheHelper isExistMonthRecord]) {
        [SVProgressHUD show];
        [self.pointsHistoryParser loadHistoryPointsRecentMonth];
    }else{
        _historyList = [PointsHistoryCacheHelper getHistoryFromCache];
    }
    self.fullNameLabel.text = [TheAppDelegate.userInfo.fullName isBlank]?TheAppDelegate.userInfo.mobile:TheAppDelegate.userInfo.fullName;
    self.cardNoLabel.text = TheAppDelegate.userInfo.cardNo;
    self.remainPointsLabel.text = [NSString stringWithFormat:@"%@分", TheAppDelegate.userInfo.point==nil?@"0":TheAppDelegate.userInfo.point];
    [self initBackGroundView];
    [self initHistoryListTableView];
    
}

-(void)initHistoryListTableView
{
    self.tableView.layer.backgroundColor = RGBCOLOR(253, 248, 223).CGColor;
    self.tableView.separatorColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dashed_detail.png"]];
    
    self.headView.layer.cornerRadius = 5.0;
    self.headView.layer.borderColor = RGBCOLOR(245, 209, 134).CGColor;
    self.headView.layer.backgroundColor = RGBCOLOR(245, 209, 134).CGColor;
    
    self.historyListView.layer.cornerRadius = 5.0;
    self.historyListView.layer.borderColor = RGBCOLOR(245, 209, 134).CGColor;
    self.historyListView.layer.borderWidth = 1.0;
}

- (void)initBackGroundView
{
    CALayer *subLayer = [CALayer layer];
    subLayer.backgroundColor = [UIColor clearColor].CGColor;
    subLayer.cornerRadius = 5;
    subLayer.borderColor = [UIColor colorWithRed:215.0/255.0 green:215.0/255.0 blue:215.0/255.0 alpha:1.0].CGColor;
    subLayer.borderWidth = 1;
    
    subLayer.frame = CGRectMake(0, 1, self.bgView.frame.size.width, self.bgView.frame.size.height-45);
    [self.bgView.layer addSublayer:subLayer];
}

-(PointsHistoryParser *)pointsHistoryParser
{
    if (!_pointsHistoryParser) {
        _pointsHistoryParser = [[PointsHistoryParser alloc] init];
        _pointsHistoryParser.delegate = self;

    }
    return _pointsHistoryParser;
}

-(NSMutableArray *) historyList
{
    if (!_historyList) {
        _historyList = [NSMutableArray array];
    }
    return _historyList;
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_historyList count];
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PointsHistoryCell *cell = (PointsHistoryCell *)[tableView dequeueReusableCellWithIdentifier:@"pointsHistoryCell"];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSInteger row = [indexPath row];
    PointsHistory *pointsHistory = [_historyList objectAtIndex:row];
    cell.monthLabel.text = pointsHistory.month;
    cell.usePointsLabel.text = pointsHistory.usePoints;
    cell.addPointsLabel.text = pointsHistory.addPoints;
    cell.remainLabel.text = pointsHistory.remainPoints;
    return cell;
}

#pragma mark - GDataXMLParserDelegate DidFailedParseWithMsg
- (void)parser:(GDataXMLParser*)parser DidFailedParseWithMsg:(NSString*)msg errCode:(NSInteger)code
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示信息" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}

#pragma mark - GDataXMLParserDelegate DidParsedData
- (void)parser:(GDataXMLParser*)parser DidParsedData:(NSDictionary *)data
{
    PointsHistory *pointsHistory = [data objectForKey:@"pointsHistory"];
    if ([self isNotBlankPointsHistory:pointsHistory]) {
       pointsHistory.addPoints =[pointsHistory.addPoints isBlank]?@"0":pointsHistory.addPoints;
        pointsHistory.remainPoints =[pointsHistory.remainPoints isBlank]?@"0":pointsHistory.remainPoints;
        pointsHistory.usePoints =[pointsHistory.usePoints isBlank]?@"0":pointsHistory.usePoints;
        self.historyList = [PointsHistoryCacheHelper getHistoryFromCache];
        if (![self hasMonthCache:pointsHistory.month]) {
                [self.historyList insertObject:pointsHistory atIndex:0];
                [PointsHistoryCacheHelper savePointsToCache:_historyList];
        }
    }
    [SVProgressHUD dismiss];
    [self.tableView reloadData];
}

-(BOOL)hasMonthCache:(NSString *) month{
    for(PointsHistory *temp in self.historyList){
        if ([temp.month isEqualToString:month]) {
            return YES;
        }
    }
    return NO;
}

-(BOOL)isNotBlankPointsHistory:(PointsHistory *) pointsHistory
{
    return ![pointsHistory.addPoints isBlank] || ![pointsHistory.remainPoints isBlank] || ![pointsHistory.usePoints isBlank];
}

-(BOOL)isNotZeroPointsHistory:(PointsHistory *) pointsHistory
{
    return [self numberNotZero:pointsHistory.addPoints] && [self numberNotZero:pointsHistory.remainPoints] && [self numberNotZero:pointsHistory.usePoints];
}

-(BOOL)numberNotZero:(NSString *)intStr
{
    if ([intStr isBlank]) {
        return NO;
    }
    
    int resultInt = [intStr intValue];
    return resultInt == 0?NO:YES;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
