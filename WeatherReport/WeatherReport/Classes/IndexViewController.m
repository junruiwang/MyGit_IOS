//
//  IndexViewController.m
//  WeatherReport
//
//  Created by jerry on 13-4-24.
//  Copyright (c) 2013年 jerry. All rights reserved.
//

#import "IndexViewController.h"

@interface IndexViewController ()

@property(nonatomic, strong) UIImage *bgImage;

@end

@implementation IndexViewController

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
    //加载背景图片
    [self loadBgImageView];
    
    [self initalToolbar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadBgImageView
{
    if (self.bgImage == nil) {
        if ([[NSUserDefaults standardUserDefaults] boolForKey:USER_DEVICE_5]) {
            self.bgImage = [UIImage imageNamed:@"cloud-568h.jpg"];
        } else {
            self.bgImage = [UIImage imageNamed:@"cloud.jpg"];
        }
    }
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:self.bgImage];
}

//初始化工具条
- (void)initalToolbar
{
    UIToolbar* tools = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 110, 45)];
    [tools setBarStyle:UIBarStyleBlack];
    
    NSMutableArray* buttons = [[NSMutableArray alloc] initWithCapacity:2];
    
    UIBarButtonItem *btnRefresh = [[UIBarButtonItem alloc] initWithTitle:@"更新" style:UIBarButtonItemStyleBordered target:self action:@selector(refreshCityBtnClicked:)];
	UIBarButtonItem *btndelete = [[UIBarButtonItem alloc]
                                  initWithTitle:@"管理" style:UIBarButtonItemStyleBordered target:self action:@selector(removeCityBtnClicked:)];
    [buttons addObject:btnRefresh];
	[buttons addObject:btndelete];
	[tools setItems:buttons animated:NO];

    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]
										   initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addCityBtnClicked:)];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:tools];
}

@end
