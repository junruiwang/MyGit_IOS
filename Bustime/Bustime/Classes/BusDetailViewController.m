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
    self.title = @"19路";
    self.subScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.subScrollView.backgroundColor = [UIColor clearColor];
    [self loadSegmentedButton];
    [self loadTopTitleView];
    [self loadBottomView];
    [self.subScrollView setContentSize:CGSizeMake(320, 90 + self.bottomView.frame.size.height + 80)];
    self.subScrollView.scrollEnabled = YES;
    self.subScrollView.showsHorizontalScrollIndicator = NO;
    self.subScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.subScrollView];
	NSLog(@"width:%f,height:%f",self.view.frame.size.width,self.view.frame.size.height);
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
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 90)];
    topView.backgroundColor = [UIColor clearColor];
    
    CALayer *subLayer = [CALayer layer];
    subLayer.backgroundColor = [UIColor whiteColor].CGColor;
    subLayer.shadowOffset = CGSizeMake(0, 1);
    subLayer.shadowRadius = 5.0;
    subLayer.shadowColor = [UIColor blackColor].CGColor;
    subLayer.shadowOpacity = 0.5;
    subLayer.frame = CGRectMake(10, 10, 300, 70);
    subLayer.cornerRadius = 10;
    subLayer.borderWidth = 0;
    [topView.layer addSublayer:subLayer];
    [topView addSubview:self.topTitleView];
    [self.subScrollView addSubview:topView];
}

- (void)loadBottomView
{
    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 80, 320, 500)];
    self.bottomView.backgroundColor = [UIColor clearColor];
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
    [self.subScrollView addSubview:self.bottomView];
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
	NSLog(@"Segment clicked: %d", segmentedControl.selectedSegmentIndex);
}

@end
