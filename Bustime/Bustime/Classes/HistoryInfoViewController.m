//
//  HistoryInfoViewController.m
//  Bustime
//
//  Created by 汪君瑞 on 13-3-31.
//  Copyright (c) 2013年 Jerry Wang. All rights reserved.
//

#import "HistoryInfoViewController.h"
#import "PrettyNavigationBar.h"

@interface HistoryInfoViewController ()

@end

@implementation HistoryInfoViewController

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.trackedViewName = @"我的收藏页面";
	self.navigationItem.title = @"我的收藏";
    [self loadSegmentedButton];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStyleBordered target:self action:@selector(modifyTable)];
    
	[self loadCustomBanner];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self customizeNavBar];
}

- (void)loadSegmentedButton
{
    
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    // segmented control as the custom title view
	NSArray *segmentTextContent = [NSArray arrayWithObjects:
                                   NSLocalizedString(@"收藏线路", @""),
                                   NSLocalizedString(@"收藏站点", @""),
								   nil];
	UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:segmentTextContent];
	segmentedControl.selectedSegmentIndex = 0;
	segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
	segmentedControl.frame = CGRectMake(100, 5, 140, kCustomButtonHeight);
	[segmentedControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
        
    [navBar addSubview:segmentedControl];
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    
    [topView addSubview:navBar];
    [self.view addSubview:topView];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)segmentAction:(id)sender
{
	// The segmented control was clicked, handle it here
	//UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
    //[segmentedControl.selectedSegmentIndex];
}

- (void)modifyTable
{
    
}

@end
