//
//  BannerViewController.m
//  ChoiceCourse
//
//  Created by jerry on 13-3-28.
//
//

#import "BannerViewController.h"
#import "GAIDictionaryBuilder.h"

#define ADMOB_BUTTON_CLOSE_TAG 180

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
    if (SYSTEM_VERSION <7.0f) {
        self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    }
    
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
    if (!self.adBanner) {
        //self.adBanner = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
        self.adBanner = [[GADBannerView alloc] initWithFrame:CGRectMake(0.0,
                                                                        self.view.frame.size.height,
                                                                        GAD_SIZE_320x50.width,
                                                                        GAD_SIZE_320x50.height)];
        self.adBanner.adUnitID = kSampleAdUnitID;
        self.adBanner.delegate = self;
        self.adBanner.rootViewController = self;
        [self.view addSubview:self.adBanner];
        
        
        self.admobCloseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.admobCloseBtn.tag = ADMOB_BUTTON_CLOSE_TAG;
        self.admobCloseBtn.frame = CGRectMake(269, 10, 50, 50);
        [self.admobCloseBtn addTarget:self action:@selector(closeBannerView) forControlEvents:UIControlEventTouchUpInside];
        [self.admobCloseBtn setImage:[UIImage imageNamed:@"adsmogo_close.png"] forState:UIControlStateNormal];
    }
    
    [self.adBanner loadRequest:[self createRequest]];
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
    
    CGFloat positionY = self.view.frame.size.height - adView.frame.size.height;
    if (SYSTEM_VERSION >=7.0f) {
        positionY = positionY - 49;
    }
    
    [UIView animateWithDuration:0.5 animations:^ {
        adView.frame = CGRectMake(0.0,
                                  positionY,
                                  adView.frame.size.width,
                                  adView.frame.size.height);
        
    } completion:^(BOOL finished) {
        if (![adView viewWithTag:ADMOB_BUTTON_CLOSE_TAG]) {
            [adView addSubview:self.admobCloseBtn];
        }
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
