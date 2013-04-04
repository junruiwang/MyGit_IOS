//
//  BannerViewController.m
//  ChoiceCourse
//
//  Created by jerry on 13-3-28.
//
//

#import "BannerViewController.h"
#import "SampleConstants.h"
#import "PrettyNavigationBar.h"
#import "PrettyDrawing.h"


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

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0.902 alpha:1.000];
//    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0 green:179/255.0 blue:134/255.0 alpha:1];
    [self customizeNavBar];
    
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(backHome:)];
}

- (void) customizeNavBar {
    PrettyNavigationBar *navBar = (PrettyNavigationBar *)self.navigationController.navigationBar;
    navBar.topLineColor = [UIColor colorWithHex:0xFF1000];
    navBar.gradientStartColor = [UIColor colorWithHex:0xDD0000];
    navBar.gradientEndColor = [UIColor colorWithHex:0xAA0000];
    navBar.bottomLineColor = [UIColor colorWithHex:0x990000];
    navBar.tintColor = navBar.gradientEndColor;
    navBar.roundedCornerRadius = 8;
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
    //self.adBanner = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
}

- (GADRequest *)createRequest
{
    GADRequest *request = [GADRequest request];
    
    //Make the request for a test ad
    //request.testDevices = [NSArray arrayWithObjects: GAD_SIMULATOR_ID, nil];
    return request;
}

- (void)backHome:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addLeftBarButton:(NSString *) imageName
{
    //add left back button
    UIButton *backButton = [self generateNavButton:imageName action:@selector(backHome:)];
    backButton.frame = CGRectMake(0, 0, 48, 44);
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = barButtonItem;
}

- (UIButton *)generateNavButton:(NSString *)imageName action:(SEL)actionName
{
    UIButton* targetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [targetBtn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [targetBtn setShowsTouchWhenHighlighted:YES];
    [targetBtn addTarget:self action:actionName forControlEvents:UIControlEventTouchUpInside];
    
    return targetBtn;
}

- (void)closeBannerView
{
    [UIView animateWithDuration:0.5 animations:^ {
        self.adBanner.frame = CGRectMake(0.0,
                                  self.view.frame.size.height,
                                  self.adBanner.frame.size.width,
                                  self.adBanner.frame.size.height);
        
    }];
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
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.frame = CGRectMake(280, 10, 40, 30);
    [closeButton addTarget:self action:@selector(closeBannerView) forControlEvents:UIControlEventTouchUpInside];
    [closeButton setImage:[UIImage imageNamed:@"ads_close.png"] forState:UIControlStateNormal];
    [adView addSubview:closeButton];
    
}

- (void)adView:(GADBannerView *)view didFailToReceiveAdWithError:(GADRequestError *)error {
    NSLog(@"Failed to receive ad with error: %@", [error localizedFailureReason]);
}

- (void)adViewWillLeaveApplication:(GADBannerView *)adView {
    NSLog(@"用户触摸 Click-to-App-Store 或 Click-to-iTunes 横幅广告而转至后台或终止！");
}

@end
