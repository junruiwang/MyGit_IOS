//
//  BusDetailViewController.m
//  Bustime
//
//  Created by 汪君瑞 on 13-4-2.
//  Copyright (c) 2013年 Jerry Wang. All rights reserved.
//

#import "BusDetailViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "BusLine.h"
#import "FaverateBusLineManager.h"
#import "RegexKitLite.h"
#import "LineIndex.h"
#import "SingleLineTimeParser.h"

@interface BusDetailViewController ()

@property(nonatomic, strong) BusSingleLineParser *busSingleLineParser;
@property(nonatomic, strong) SingleLineTimeParser *singleLineTimeParser;
@property(nonatomic, strong) BusLine *currentBusLine;
@property(nonatomic, assign) BOOL isFirst;
@property(nonatomic, strong) NSMutableArray *lineIndexArry;
@property(nonatomic, strong) NSMutableArray *busSingleStationArry;
@property(nonatomic, strong) FaverateBusLineManager *faverateBusLineManager;
@property(nonatomic, assign) BOOL isFaverate;
@property(nonatomic, strong) UIButton *faverateButton;
@property(nonatomic, assign) BOOL isLoadOver;

@end

@implementation BusDetailViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _isFirst = YES;
        self.isLoadOver = NO;
        _busSingleStationArry = [[NSMutableArray alloc] initWithCapacity:20];
        _lineIndexArry = [[NSMutableArray alloc] initWithCapacity:2];
        _faverateBusLineManager = [[FaverateBusLineManager alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.screenName = @"运行车俩详情页面";
    [self loadDefaultPageView];
    
    self.subScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.subScrollView.backgroundColor = [UIColor clearColor];
    
    self.toolView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 50, self.view.frame.size.width, 50)];
    self.toolView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bottom_jielong_bg_ios7.png"]];
    //添加底部工具栏
    [self.view addSubview:self.toolView];
    
    [self loadSegmentedButton];
    [self loadReFlushButton];
    [self loadTopTitleView];
    self.subScrollView.scrollEnabled = YES;
    self.subScrollView.showsHorizontalScrollIndicator = NO;
    self.subScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.subScrollView];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.toolView.frame = CGRectMake(0, self.view.frame.size.height - 50, self.view.frame.size.width, 50);
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
    messageBox.text = @"sorry，无法获取最新线路实况，请稍后再试";
    [self.noDataView addSubview:messageBox];
    [self.view addSubview:self.noDataView];
}

- (void)downloadDataForBusStation
{
    if (!self.isLoadOver) {
        [SVProgressHUD showWithStatus:@"正在为您查询" maskType:SVProgressHUDMaskTypeGradient];
    }
    
    if (self.busSingleLineParser != nil) {
        [self.busSingleLineParser cancel];
        self.busSingleLineParser = nil;
    }
    self.busSingleLineParser = [[BusSingleLineParser alloc] init];
    self.busSingleLineParser.serverAddress = query_bus_single_line;
    self.busSingleLineParser.delegate = self;
    self.busSingleLineParser.requestString = [NSString stringWithFormat:@"lineCode=%@",self.currentBusLine.lineCode];
    [self.busSingleLineParser start];
}

- (void)downloadRealTimeStation
{
    if (self.singleLineTimeParser != nil) {
        [self.singleLineTimeParser cancel];
        self.singleLineTimeParser = nil;
    }
    self.singleLineTimeParser = [[SingleLineTimeParser alloc] init];
    self.singleLineTimeParser.serverAddress = query_bus_single_time;
    self.singleLineTimeParser.delegate = self;
    self.singleLineTimeParser.requestString = [NSString stringWithFormat:@"lineCode=%@",self.currentBusLine.lineCode];
    [self.singleLineTimeParser start];
}

- (void)loadDefaultPageView
{
    self.currentBusLine = self.busLineArray[0];
    self.isFaverate = [self.faverateBusLineManager isBusLineInFaverate:self.currentBusLine.lineNumber];
    
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
    
    [self loadBusBaseInfo:self.currentBusLine];
    [self downloadDataForBusStation];
}

- (void)loadBusBaseInfo:(BusLine *) busLine
{
    NSString *regexString = @"^[0-9]*$";
    
    BOOL matched = [self.currentBusLine.lineNumber isMatchedByRegex:regexString];
    if (matched) {
        self.navigationItem.title =[NSString stringWithFormat:@"%@路", self.currentBusLine.lineNumber];
    } else {
        self.navigationItem.title = self.currentBusLine.lineNumber;
    }
    
    self.timeLabel.text = [NSString stringWithFormat:@" 首末班时间：%@", busLine.runTime];
    self.totalStationLabel.text = [NSString stringWithFormat:@"全程%d站", busLine.totalStation];
    self.startStationLabel.text = busLine.startStation;
    self.endStationLabel.text = busLine.endStation;
}

- (NSArray *)buildSegmentByListCount
{
    NSArray *segmentTextContent = nil;
    NSInteger count = [self.busLineArray count];
    switch (count) {
        case 2:
        {
            BusLine *busLine_1 = self.busLineArray[0];
            LineIndex *lineIndex_1 = [[LineIndex alloc] init];
            lineIndex_1.number = 0;
            lineIndex_1.lineCode = busLine_1.lineCode;
            lineIndex_1.segmentName = @"上行线";
            [self.lineIndexArry addObject:lineIndex_1];
            
            BusLine *busLine_2 = self.busLineArray[1];
            LineIndex *lineIndex_2 = [[LineIndex alloc] init];
            lineIndex_2.number = 1;
            lineIndex_2.lineCode = busLine_2.lineCode;
            lineIndex_2.segmentName = @"下行线";
            [self.lineIndexArry addObject:lineIndex_2];
            
            segmentTextContent = [NSArray arrayWithObjects: @"上行线", @"下行线", nil];
            break;
        }
        case 3:
        {
            BusLine *busLine_1 = self.busLineArray[0];
            LineIndex *lineIndex_1 = [[LineIndex alloc] init];
            lineIndex_1.number = 0;
            lineIndex_1.lineCode = busLine_1.lineCode;
            lineIndex_1.segmentName = @"上行线";
            [self.lineIndexArry addObject:lineIndex_1];
            
            BusLine *busLine_2 = self.busLineArray[1];
            if ([busLine_2.startStation isEqualToString:busLine_1.startStation] || [busLine_2.endStation isEqualToString:busLine_1.endStation]) {
                
                BusLine *busLine_3 = self.busLineArray[2];
                LineIndex *lineIndex_3 = [[LineIndex alloc] init];
                lineIndex_3.number = 2;
                lineIndex_3.lineCode = busLine_3.lineCode;
                lineIndex_3.segmentName = @"下行线";
                [self.lineIndexArry addObject:lineIndex_3];
                
            } else {
                LineIndex *lineIndex_2 = [[LineIndex alloc] init];
                lineIndex_2.number = 1;
                lineIndex_2.lineCode = busLine_2.lineCode;
                lineIndex_2.segmentName = @"下行线";
                [self.lineIndexArry addObject:lineIndex_2];
            }
            segmentTextContent = [NSArray arrayWithObjects: @"上行线", @"下行线", nil];
            break;
        }
        default:
            break;
    }
    
    return segmentTextContent;
}

- (void)loadSegmentedButton
{
    // segmented control as the custom title view
	NSArray *segmentTextContent = [self buildSegmentByListCount];
    
    if (segmentTextContent && segmentTextContent.count == 2) {
        UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:segmentTextContent];
        segmentedControl.selectedSegmentIndex = 0;
        segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
        segmentedControl.frame = CGRectMake(30, 10, 100, kCustomButtonHeight);
        [segmentedControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
        [self.toolView addSubview:segmentedControl];
//        self.navigationItem.titleView = segmentedControl;
    }
    
    //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:segmentedControl];
}

- (void)loadReFlushButton
{
    UIButton *flushBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    flushBtn.frame = CGRectMake(260, 6, 40, 40);
    [flushBtn addTarget:self action:@selector(refreshBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [flushBtn setBackgroundImage:[UIImage imageNamed:@"synchronized.png"] forState:UIControlStateNormal];
    
    [self.toolView addSubview:flushBtn];
}

- (void)refreshBtnClicked:(id)sender
{
    [self downloadDataForBusStation];
}

- (void)loadTopTitleView
{
    //设置顶部查询栏视图背景色
    self.topTitleView.layer.borderColor = [UIColor colorWithRed:215.0/255.0 green:215.0/255.0 blue:215.0/255.0 alpha:1.0].CGColor;
    self.topTitleView.layer.borderWidth = 1.0;
    [self.subScrollView addSubview:self.topTitleView];
}

- (void)loadBottomView:(int) index
{
    [self.bottomView removeFromSuperview];
    UIView *graphcisView = [self graphcisStationViews:index];
    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(8, 110, 304, graphcisView.frame.size.height)];
    self.bottomView.backgroundColor = [UIColor whiteColor];
    
    self.bottomView.layer.borderColor = [UIColor colorWithRed:215.0/255.0 green:215.0/255.0 blue:215.0/255.0 alpha:1.0].CGColor;
    self.bottomView.layer.borderWidth = 1.0;
    [self.bottomView addSubview:graphcisView];
    [self.subScrollView addSubview:self.bottomView];
    [self.subScrollView setContentSize:CGSizeMake(320, 110 + self.bottomView.frame.size.height + 100)];
    [self.subScrollView setContentOffset:CGPointMake(0.0, 0.0) animated:YES];
    
    [self.view bringSubviewToFront:self.toolView];
}


- (UIView *)graphcisStationViews:(int) index
{
    BusLine *bline = self.busLineArray[index];
    
    
    CGFloat totalHeight = 0;
    UIView *graphcisView = [[UIView alloc] initWithFrame:CGRectMake(2, 2, 300, 800)];
    graphcisView.backgroundColor = [UIColor clearColor];
    
    for (int i=0; i< [bline.stationArray count]; i++) {
        BusSingleLine *singStation = [bline.stationArray objectAtIndex:i];
        
        if (singStation.time != nil && ![singStation.time isEqualToString:@""]) {
            
            UIView *startView = [[UIView alloc] initWithFrame:CGRectMake(17, i*79, 10, 51)];
            startView.backgroundColor = RGBCOLOR(100, 182, 57);
            
            UIImageView *imageStartView = [[UIImageView alloc] initWithFrame:CGRectMake(15, i*79, 13, 51)];
            imageStartView.image = [UIImage imageNamed:@"start_icon.png"];
            if (i==0) {
                [graphcisView addSubview:imageStartView];
            } else {
                [graphcisView addSubview:startView];
            }
            
            UIImageView *imageStationView = [[UIImageView alloc] initWithFrame:CGRectMake(6, 51+(i*79), 30, 30)];
            imageStationView.image = [UIImage imageNamed:@"run_current_station.png"];
            [graphcisView addSubview:imageStationView];
            
            UIImageView *imageTopView = [[UIImageView alloc] initWithFrame:CGRectMake(49, 21+(i*79), 221, 39)];
            imageTopView.image = [UIImage imageNamed:@"current_top.png"];
            [graphcisView addSubview:imageTopView];
            
            UIImageView *imageBottomView = [[UIImageView alloc] initWithFrame:CGRectMake(49, 60+(i*79), 221, 35)];
            imageBottomView.image = [UIImage imageNamed:@"current_bottom.png"];
            [graphcisView addSubview:imageBottomView];
            
            UILabel *stationLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 32+(i*79), 197, 21)];
            stationLabel.backgroundColor = [UIColor clearColor];
            stationLabel.font = [UIFont boldSystemFontOfSize:17];
            stationLabel.textColor = [UIColor whiteColor];
            stationLabel.text = singStation.standName;
            [graphcisView addSubview:stationLabel];
            
            UILabel *stationTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 66+(i*79), 197, 18)];
            stationTimeLabel.backgroundColor = [UIColor clearColor];
            stationTimeLabel.font = [UIFont systemFontOfSize:14];
            stationTimeLabel.text = [NSString stringWithFormat:@"进站时间  %@",singStation.time];
            [graphcisView addSubview:stationTimeLabel];
            
            totalHeight = 51+(i*79) + 80;
            
        } else {
            UIView *startView = [[UIView alloc] initWithFrame:CGRectMake(17, i*79, 10, 51)];
            startView.backgroundColor = RGBCOLOR(100, 182, 57);
            
            UIImageView *imageStartView = [[UIImageView alloc] initWithFrame:CGRectMake(15, i*79, 13, 51)];
            imageStartView.image = [UIImage imageNamed:@"start_icon.png"];
            if (i==0) {
                [graphcisView addSubview:imageStartView];
            } else {
                [graphcisView addSubview:startView];
            }
            
            UIImageView *imageStationView = [[UIImageView alloc] initWithFrame:CGRectMake(7, 51+(i*79), 30, 30)];
            imageStationView.image = [UIImage imageNamed:@"run_station.png"];
            [graphcisView addSubview:imageStationView];
            
            UILabel *stationLabel = [[UILabel alloc] initWithFrame:CGRectMake(49, 51+(i*79)+6, 221, 18)];
            stationLabel.backgroundColor = [UIColor clearColor];
            stationLabel.font = [UIFont boldSystemFontOfSize:14];
            stationLabel.text = singStation.standName;
            [graphcisView addSubview:stationLabel];
            totalHeight = 51+(i*79) + 80;
        }
    }
    graphcisView.frame = CGRectMake(2, 2, 300, totalHeight);
    
    return graphcisView;
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
    
    if ([self.lineIndexArry count] == 2 && segmentedControl.selectedSegmentIndex == 1) {
        LineIndex *lineIndex = self.lineIndexArry[1];
        BusLine *busLine = self.busLineArray[lineIndex.number];
        self.currentBusLine = busLine;
        [self loadBusBaseInfo:busLine];
        [self loadBottomView:lineIndex.number];
    } else {
        BusLine *busLine = self.busLineArray[0];
        self.currentBusLine = busLine;
        [self loadBusBaseInfo:busLine];
        [self loadBottomView:0];
    }
}

- (void)faverateButtonClicked:(id) sender
{
    BusLine *busLine = self.busLineArray[0];
    
    if (self.isFaverate) {
        [self.faverateBusLineManager deleteBusLineInFaverate:busLine.lineNumber];
        if (SYSTEM_VERSION <7.0f) {
            [self.faverateButton setImage:[UIImage imageNamed:@"heart_icon.png"] forState:UIControlStateNormal];
        } else {
            [self.faverateButton setImage:[UIImage imageNamed:@"favorite_add.png"] forState:UIControlStateNormal];
        }
        [self showAlertMessage:@"您已经成功删除收藏的线路！" dismissAfterDelay:1.2];
    } else {
        [self.faverateBusLineManager insertIntoFaverateWithBusLine:busLine];
        if ([self.busLineArray count] > 1) {
            [self.faverateBusLineManager insertIntoFaverateWithBusLine:self.busLineArray[1]];
        }
        
        if (SYSTEM_VERSION <7.0f) {
            [self.faverateButton setImage:[UIImage imageNamed:@"heart_icon_red.png"] forState:UIControlStateNormal];
        } else {
            [self.faverateButton setImage:[UIImage imageNamed:@"favorite_delete.png"] forState:UIControlStateNormal];
        }
        
        [self showAlertMessage:@"您已经成功收藏本线路！" dismissAfterDelay:1.2];
    }
    self.isFaverate = !self.isFaverate;
}

- (void) mergeDataFromArry
{    
    if (self.isFirst) {
        BusLine *bline = self.busLineArray[0];
        self.currentBusLine = bline;
        [bline.stationArray removeAllObjects];
        [bline.stationArray addObjectsFromArray:self.busSingleStationArry];
        self.isFirst = NO;
        [self loadBottomView:0];
        //如果是双向线路
        if ([self.lineIndexArry count] == 2) {
            LineIndex *lineIndex = self.lineIndexArry[1];
            BusLine *nextLine = self.busLineArray[lineIndex.number];
            self.currentBusLine = nextLine;
            self.isLoadOver = YES;
            [self downloadDataForBusStation];
        }
    } else {
        for (int i=0; i<[self.busLineArray count]; i++) {
            BusLine *bline = self.busLineArray[i];
            if ([bline.lineCode isEqualToString:self.currentBusLine.lineCode]) {
                [bline.stationArray removeAllObjects];
                [bline.stationArray addObjectsFromArray:self.busSingleStationArry];
                break;
            }
        }
        //初始化数据后还原当前显示线路
        if (self.isLoadOver) {
            self.isLoadOver = NO;
            self.currentBusLine = self.busLineArray[0];
        }
    }
    
}

- (void)mergeRealTimeStation:(NSMutableArray *)busRunSingleArry
{
    for (BusSingleLine *realTimeStation in busRunSingleArry) {
        
        for (BusSingleLine *busStation in self.busSingleStationArry) {
            if ([realTimeStation.standCode isEqualToString:busStation.standCode]) {
                busStation.time = realTimeStation.time;
                break;
            }
        }
    }
    //合并数据
    [self mergeDataFromArry];
}

#pragma mark - BaseJSONParserDelegate
- (void)parser:(JsonParser*)parser DidFailedParseWithMsg:(NSString*)msg errCode:(NSInteger)code
{
    NSLog(@"查询运行车辆发生异常：%@，错误代码：%d", msg, code);
    [SVProgressHUD dismiss];
}

- (void)parser:(JsonParser*)parser DidParsedData:(NSDictionary *)data
{
    if ([parser isKindOfClass:[BusSingleLineParser class]]) {
        self.busSingleStationArry = [data valueForKey:@"data"];
        if (self.busSingleStationArry.count==0 && self.isFirst) {
            [self noDataViewShow];
        }
        if (self.busSingleStationArry.count >0) {
            [self.noDataView removeFromSuperview];
            [self downloadRealTimeStation];
        } else {
            [SVProgressHUD dismiss];
        }
    } else if ([parser isKindOfClass:[SingleLineTimeParser class]]) {
        NSMutableArray *busRunSingleArry = [data valueForKey:@"data"];
        [self mergeRealTimeStation:busRunSingleArry];
        [SVProgressHUD dismiss];
    }
}

@end
