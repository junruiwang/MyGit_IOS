//
//  BannerViewController.h
//  WeatherReport
//
//  Created by jerry on 13-4-24.
//  Copyright (c) 2013年 jerry. All rights reserved.
//

#import "TrendViewController.h"
#import "LineChartView.h"

@implementation TrendViewController

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)loadView
{
    [super loadView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadSegmentedButton];
    float imageHeight = 367;
    if ([[NSUserDefaults standardUserDefaults] boolForKey:USER_DEVICE_5]) {
        imageHeight += 88;
    }
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, imageHeight)];
    bgImageView.backgroundColor = [UIColor clearColor];
    bgImageView.image = [UIImage imageNamed:@"load_bg3.png"];
    [self.view addSubview:bgImageView];

    
    UIView *alphaBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, imageHeight)];
    alphaBgView.backgroundColor = [UIColor blackColor];
    alphaBgView.alpha = 0.8;
    [self.view addSubview:alphaBgView];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    float imageHeight = 367;
    if ([[NSUserDefaults standardUserDefaults] boolForKey:USER_DEVICE_5]) {
        imageHeight += 88;
    }
    LineChartView *lineChartView = [[LineChartView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, imageHeight)];
    
    NSMutableArray *pointArr = [[NSMutableArray alloc]init];
    //生成随机点
    [pointArr addObject:[NSValue valueWithCGPoint:CGPointMake(55*0, 200)]];
    [pointArr addObject:[NSValue valueWithCGPoint:CGPointMake(55*1, 240)]];
    [pointArr addObject:[NSValue valueWithCGPoint:CGPointMake(55*2, 180)]];
    [pointArr addObject:[NSValue valueWithCGPoint:CGPointMake(55*3, 220)]];
    [pointArr addObject:[NSValue valueWithCGPoint:CGPointMake(55*4, 210)]];
    [pointArr addObject:[NSValue valueWithCGPoint:CGPointMake(55*5, 190)]];
    //竖轴
    NSMutableArray *vArr = [[NSMutableArray alloc]initWithCapacity:pointArr.count-1];
    for (int i=0; i<20; i++) {
        [vArr addObject:[NSString stringWithFormat:@"%d",i*2]];
    }
    //横轴
    NSMutableArray *hArr = [[NSMutableArray alloc]initWithCapacity:pointArr.count-1];
    [hArr addObject:@"05/26"];
    [hArr addObject:@"05/27"];
    [hArr addObject:@"05/28"];
    [hArr addObject:@"05/29"];
    [hArr addObject:@"05/30"];
    [hArr addObject:@"05/31"];
    
    [lineChartView setHDesc:hArr];
    [lineChartView setVDesc:vArr];
    [lineChartView setArray:pointArr];
    
    [self.view addSubview:lineChartView];
}

- (void)loadSegmentedButton
{
    // segmented control as the custom title view
	NSArray *segmentTextContent = [NSArray arrayWithObjects: @"温度", @"风力", nil];
	UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:segmentTextContent];
	segmentedControl.selectedSegmentIndex = 0;
	segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
	segmentedControl.frame = CGRectMake(0, 0, 140, 30);
	[segmentedControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    
	self.navigationItem.titleView = segmentedControl;
    //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:segmentedControl];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

@end
