//
//  BusDetailViewController.m
//  Bustime
//
//  Created by 汪君瑞 on 13-4-2.
//  Copyright (c) 2013年 Jerry Wang. All rights reserved.
//

#import "BusDetailViewController.h"
#import "SampleConstants.h"
#import <QuartzCore/QuartzCore.h>
#import "RegexKitLite.h"
#import "BusLine.h"

@interface BusDetailViewController ()

@property(nonatomic, strong) UIColor *defaultTintColor;

@end

@implementation BusDetailViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadDefaultPageView];
    
    self.subScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.subScrollView.backgroundColor = [UIColor clearColor];
    
    [self loadSegmentedButton];
    [self loadTopTitleView];
    [self loadBottomView];
    [self.subScrollView setContentSize:CGSizeMake(320, 110 + self.bottomView.frame.size.height + 80)];
    self.subScrollView.scrollEnabled = YES;
    self.subScrollView.showsHorizontalScrollIndicator = NO;
    self.subScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.subScrollView];
}

- (void)loadDefaultPageView
{
    BusLine *busLine = self.busLineArray[0];
    NSString *regexString = @"^[0-9]*$";
    BOOL matched = [busLine.lineNumber isMatchedByRegex:regexString];
    if (matched) {
        self.title =[NSString stringWithFormat:@"%@路", busLine.lineNumber];
    } else {
        self.title = busLine.lineNumber;
    }
    [self loadBusBaseInfo:busLine];
    
}

- (void)loadBusBaseInfo:(BusLine *) busLine
{
    self.timeLabel.text = [NSString stringWithFormat:@" 首末班时间：%@", busLine.runTime];
    self.totalStationLabel.text = [NSString stringWithFormat:@"全程线路共%d站", busLine.totalStation];
    self.startStationLabel.text = busLine.startStation;
    self.endStationLabel.text = busLine.endStation;
}


- (void)loadSegmentedButton
{
    // segmented control as the custom title view
	NSArray *segmentTextContent = [NSArray arrayWithObjects:
                                   NSLocalizedString(@"上行", @""),
                                   NSLocalizedString(@"下行", @""),
								   nil];
	UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:segmentTextContent];
	segmentedControl.selectedSegmentIndex = 0;
	segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
	segmentedControl.frame = CGRectMake(0, 0, 100, kCustomButtonHeight);
	[segmentedControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
	
	self.defaultTintColor = segmentedControl.tintColor;	// keep track of this for later
    
	//self.navigationItem.titleView = segmentedControl;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:segmentedControl];
}

- (void)loadTopTitleView
{
    self.topTitleView.backgroundColor = [UIColor clearColor];
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
    topView.backgroundColor = [UIColor clearColor];
    
    CALayer *subLayer = [CALayer layer];
    subLayer.backgroundColor = [UIColor whiteColor].CGColor;
    subLayer.shadowOffset = CGSizeMake(0, 1);
    subLayer.shadowRadius = 5.0;
    subLayer.shadowColor = [UIColor blackColor].CGColor;
    subLayer.shadowOpacity = 0.5;
    subLayer.frame = CGRectMake(10, 5, 300, 95);
    subLayer.cornerRadius = 10;
    subLayer.borderWidth = 0;
    [topView.layer addSublayer:subLayer];
    [topView addSubview:self.topTitleView];
    [self.subScrollView addSubview:topView];
}

- (void)loadBottomView
{
    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 100, 320, 800)];
    self.bottomView.backgroundColor = [UIColor clearColor];
    
    UIView *graphcisView = [self graphcisStationViews];
    self.bottomView.frame = CGRectMake(0, 100, 320, graphcisView.frame.size.height);
    CALayer *subLayer = [CALayer layer];
    subLayer.backgroundColor = [UIColor whiteColor].CGColor;
    subLayer.shadowOffset = CGSizeMake(0, 1);
    subLayer.shadowRadius = 5.0;
    subLayer.shadowColor = [UIColor blackColor].CGColor;
    subLayer.shadowOpacity = 0.5;
    subLayer.frame = CGRectMake(10, 10, 300, self.bottomView.frame.size.height-20);
    subLayer.cornerRadius = 10;
    subLayer.borderWidth = 0;
    [self.bottomView.layer addSublayer:subLayer];
    
    [self.bottomView addSubview:graphcisView];
    [self.subScrollView addSubview:self.bottomView];
}


- (UIView *)graphcisStationViews
{
    CGFloat totalHeight = 0;
    UIView *graphcisView = [[UIView alloc] initWithFrame:CGRectMake(20, 20, 300, 800)];
    graphcisView.backgroundColor = [UIColor clearColor];
    
    for (int i=0; i< 15; i++) {
        if (i%10 == 0) {
            UIImageView *imageStartView = [[UIImageView alloc] initWithFrame:CGRectMake(15, i*79, 13, 51)];
            imageStartView.image = [UIImage imageNamed:@"start_icon.png"];
            [graphcisView addSubview:imageStartView];
            
            UIImageView *imageStationView = [[UIImageView alloc] initWithFrame:CGRectMake(6, 51+(i*79), 30, 30)];
            imageStationView.image = [UIImage imageNamed:@"run_current_station.9.png"];
            [graphcisView addSubview:imageStationView];
            
            UIImageView *imageTopView = [[UIImageView alloc] initWithFrame:CGRectMake(49, 11+(i*79), 221, 39)];
            imageTopView.image = [UIImage imageNamed:@"current_top.png"];
            [graphcisView addSubview:imageTopView];
            
            UIImageView *imageBottomView = [[UIImageView alloc] initWithFrame:CGRectMake(49, 50+(i*79), 221, 35)];
            imageBottomView.image = [UIImage imageNamed:@"current_bottom.png"];
            [graphcisView addSubview:imageBottomView];
            
            UILabel *stationLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 22+(i*79), 197, 21)];
            stationLabel.backgroundColor = [UIColor clearColor];
            stationLabel.font = [UIFont boldSystemFontOfSize:17];
            stationLabel.textColor = [UIColor whiteColor];
            stationLabel.text = @"火车站南广场";
            [graphcisView addSubview:stationLabel];
            
            UILabel *stationTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 56+(i*79), 197, 18)];
            stationTimeLabel.backgroundColor = [UIColor clearColor];
            stationTimeLabel.font = [UIFont systemFontOfSize:14];
            stationTimeLabel.text = @"进站时间  21:15:30";
            [graphcisView addSubview:stationTimeLabel];
            
            totalHeight = 51+(i*79) + 80;
            
        } else {
            UIImageView *imageStartView = [[UIImageView alloc] initWithFrame:CGRectMake(15, i*79, 13, 51)];
            imageStartView.image = [UIImage imageNamed:@"start_icon.png"];
            [graphcisView addSubview:imageStartView];
            
            UIImageView *imageStationView = [[UIImageView alloc] initWithFrame:CGRectMake(7, 51+(i*79), 30, 30)];
            imageStationView.image = [UIImage imageNamed:@"run_station.9.png"];
            [graphcisView addSubview:imageStationView];
            
            UILabel *stationLabel = [[UILabel alloc] initWithFrame:CGRectMake(49, 51+(i*79)+6, 221, 18)];
            stationLabel.backgroundColor = [UIColor clearColor];
            stationLabel.font = [UIFont boldSystemFontOfSize:14];
            stationLabel.text = @"火车站南广场";
            [graphcisView addSubview:stationLabel];
            totalHeight = 51+(i*79) + 80;
        }
    }
    graphcisView.frame = CGRectMake(20, 20, 300, totalHeight);
    
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
    if ([self.busLineArray count] > 1) {
        BusLine *busLine = self.busLineArray[segmentedControl.selectedSegmentIndex];
        [self loadBusBaseInfo:busLine];
        [self loadBottomView];
    } else {
        BusLine *busLine = self.busLineArray[0];
        [self loadBusBaseInfo:busLine];
        [self loadBottomView];
    }
}

@end
