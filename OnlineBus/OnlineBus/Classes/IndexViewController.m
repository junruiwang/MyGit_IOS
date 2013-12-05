//
//  IndexViewController.m
//  OnlineBus
//
//  Created by jerry on 13-12-5.
//  Copyright (c) 2013年 jerry.wang. All rights reserved.
//

#import "IndexViewController.h"
#import "DSLoadingViewController.h"
#import "Constants.h"

@interface IndexViewController ()

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
    
    if (SYSTEM_VERSION <7.0f) {
        self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    }
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
