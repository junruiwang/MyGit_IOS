//
//  BannerViewController.m
//  ChoiceCourse
//
//  Created by jerry on 13-3-28.
//
//

#import "BannerViewController.h"
#import "GAIDictionaryBuilder.h"

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
    self.view.backgroundColor = [UIColor colorWithWhite:0.962 alpha:1.000];
    self.navigationItem.hidesBackButton = YES;
    
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(backHome:)];
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

- (void)loadCustomBanner
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
//    request.testDevices = [NSArray arrayWithObjects: GAD_SIMULATOR_ID, nil];
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

- (void)addRightBarButton:(UIButton *) button
{
    button.frame = CGRectMake(0, 0, 40, 44);
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = barButtonItem;
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
                                  adView.frame.size.height - 49,
                                  adView.frame.size.width,
                                  adView.frame.size.height);
        
    } completion:^(BOOL finished) {
        UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        closeButton.frame = CGRectMake(280, 10, 40, 30);
        [closeButton addTarget:self action:@selector(closeBannerView) forControlEvents:UIControlEventTouchUpInside];
        [closeButton setImage:[UIImage imageNamed:@"ads_close.png"] forState:UIControlStateNormal];
        [adView addSubview:closeButton];
    }];
}

- (void)adView:(GADBannerView *)view didFailToReceiveAdWithError:(GADRequestError *)error {
    NSLog(@"Failed to receive ad with error: %@", [error localizedFailureReason]);
}

- (void)adViewWillLeaveApplication:(GADBannerView *)adView {
    //GA跟踪搜索按钮
    [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createEventWithCategory:@"用户触摸" action:@"Click-to-App-Store" label:@"横幅广告条" value:nil] build]];
}

@end
