//
//  DSLoadingViewController.m
//  OnlineBus
//
//  Created by jerry on 13-12-5.
//  Copyright (c) 2013年 jerry.wang. All rights reserved.
//

#import "DSLoadingViewController.h"
#import "Constants.h"

@interface DSLoadingViewController ()

@property (nonatomic, strong) GADInterstitial *interstitial;

@end

@implementation DSLoadingViewController

- (void)loadView
{
    [super loadView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.interstitial = [[GADInterstitial alloc] init];
    self.interstitial.adUnitID = kSampleAdUnitID;
    self.interstitial.delegate = self;
    [self.interstitial loadRequest:[GADRequest request]];
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark GADInterstitialDelegate
- (void)interstitialDidReceiveAd:(GADInterstitial *)ad
{
    [self.interstitial presentFromRootViewController:self];
}

@end
