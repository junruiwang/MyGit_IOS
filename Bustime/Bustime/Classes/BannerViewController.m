//
//  BannerViewController.m
//  ChoiceCourse
//
//  Created by jerry on 13-3-28.
//
//

#import "BannerViewController.h"
#import "SampleConstants.h"

@interface BannerViewController ()

@end

@implementation BannerViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] init];
    barButtonItem.title = @"返回";
    self.navigationItem.leftBarButtonItem = barButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    self.adBanner.delegate = nil;
    self.adBanner = nil;
}

- (void) loadCustomBanner
{
    //Initialize the banner off the screen so that it animates up when displaying
    self.adBanner = [[GADBannerView alloc] initWithFrame:CGRectMake(0.0,
                                                                    self.view.frame.size.height,
                                                                    GAD_SIZE_320x50.width,
                                                                    GAD_SIZE_320x50.height)];
    self.adBanner.adUnitID = kSampleAdUnitID;
    self.adBanner.delegate = self;
    self.adBanner.rootViewController = self;
    [self.view addSubview:self.adBanner];
    [self.adBanner loadRequest:[self createRequest]];
    self.adBanner = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
}

- (GADRequest *)createRequest
{
    GADRequest *request = [GADRequest request];
    
    //Make the request for a test ad
    //request.testDevices = [NSArray arrayWithObjects: GAD_SIMULATOR_ID, nil];
    return request;
}

#pragma mark GADBannerViewDelegate impl
- (void)adViewDidReceiveAd:(GADBannerView *)adView {
    [UIView animateWithDuration:1.0 animations:^ {
        adView.frame = CGRectMake(0.0,
                                  self.view.frame.size.height -
                                  adView.frame.size.height,
                                  adView.frame.size.width,
                                  adView.frame.size.height);
        
    }];
}

- (void)adView:(GADBannerView *)view didFailToReceiveAdWithError:(GADRequestError *)error {
    NSLog(@"Failed to receive ad with error: %@", [error localizedFailureReason]);
}

- (void)adViewWillLeaveApplication:(GADBannerView *)adView {
    NSLog(@"用户触摸 Click-to-App-Store 或 Click-to-iTunes 横幅广告而转至后台或终止！");
}

@end
