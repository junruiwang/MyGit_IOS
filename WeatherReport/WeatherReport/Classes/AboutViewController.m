//
//  AboutViewController.m
//  WeatherReport
//
//  Created by 汪君瑞 on 13-6-7.
//  Copyright (c) 2013年 jerry. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = RGBCOLOR(0, 133, 197);
	self.navigationItem.title = @"关于软件";
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 50, 320, 100)];
    imageView.image = [UIImage imageNamed:@"about_logo.png"];
    [self.view addSubview:imageView];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showWeibo:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://weibo.com/u/2248196321"]];
}

@end
