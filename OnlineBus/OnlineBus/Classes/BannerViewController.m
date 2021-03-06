//
//  BannerViewController.m
//  ChoiceCourse
//
//  Created by jerry on 13-3-28.
//
//

#import "BannerViewController.h"
#import <QuartzCore/QuartzCore.h>

#define ADMOB_BUTTON_CLOSE_TAG 180

@interface BannerViewController ()

- (void)dimissAlert:(UIView *)alertView;

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
//    self.view.backgroundColor = [UIColor colorWithWhite:0.962 alpha:1.000];
    self.view.backgroundColor = RGBCOLOR(230, 230, 230);
    if (SYSTEM_VERSION <7.0f) {
        self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    }
    [self generateBarButton];
    
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
        self.admobCloseBtn.frame = CGRectMake(280, 10, 27, 27);
        [self.admobCloseBtn addTarget:self action:@selector(closeBannerView) forControlEvents:UIControlEventTouchUpInside];
        [self.admobCloseBtn setImage:[UIImage imageNamed:@"ads_close"] forState:UIControlStateNormal];
    }
    
    [self.adBanner loadRequest:[self createRequest]];
}

- (GADRequest *)createRequest
{
    GADRequest *request = [GADRequest request];
    
    GADAdMobExtras *extras = [[GADAdMobExtras alloc] init];
    extras.additionalParameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:
     @"FFFFFF", @"color_bg",
     @"FFFFFF", @"color_bg_top",
     @"DDDDDD", @"color_border",
     @"808080", @"color_link",
     @"808080", @"color_text",
     @"008000", @"color_url",
     nil];
    
    [request registerAdNetworkExtras:extras];
    //Make the request for a test ad
//    request.testDevices = [NSArray arrayWithObjects: GAD_SIMULATOR_ID, nil];
    return request;
}


- (void)generateBarButton
{
    //add left button
    UIButton* leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    if (SYSTEM_VERSION <7.0f) {
        [leftBtn setImage:[UIImage imageNamed:@"hotel-topbar-back.png"] forState:UIControlStateNormal];
    } else {
        [leftBtn setImage:[UIImage imageNamed:@"navigationbar_back_os7"] forState:UIControlStateNormal];
        [leftBtn setImage:[UIImage imageNamed:@"navigationbar_back_highlighted_os7"] forState:UIControlStateHighlighted];
    }
    [leftBtn addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    leftBtn.frame = CGRectMake(10, 5, 30, 30);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
}

- (void)backButtonClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addRightBarButton:(UIButton *) button
{
    button.frame = CGRectMake(0, 0, 30, 30);
    
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

#pragma mark JsonParserDelegate
- (void)parser:(JsonParser*)parser DidFailedParseWithMsg:(NSString*)msg errCode:(NSInteger)code
{
    NSLog(@"系统发生错误，错误原因：%@，错误代码：%d",msg,code);
}

- (void)showAlertMessage:(NSString *)msg
{
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"信息提示"
                              message:msg
                              delegate:nil
                              cancelButtonTitle:@"确定"
                              otherButtonTitles:nil];
    [alertView show];
}

- (void)showAlertMessageWithOkCancelButton:(NSString *)msg tag:(NSInteger)tag delegate:(id)delegate
{
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"信息提示"
                              message:msg
                              delegate:delegate
                              cancelButtonTitle:@"取消"
                              otherButtonTitles:@"确定", nil];
    alertView.tag = tag;
    [alertView show];
}

- (void)dimissAlert:(UIView *)alertView
{
    if (alertView) {
        [alertView removeFromSuperview];
    }
}

// never show more than one auto dismiss alert at same time, it will cause crash
- (void)showAlertMessage:(NSString *)msg dismissAfterDelay:(NSTimeInterval)delay
{
    UIView *messageBoxView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 220.0f, 60.0f)];
    messageBoxView.backgroundColor = [UIColor blackColor];
    messageBoxView.alpha = 0.8;
    messageBoxView.layer.cornerRadius = 5;
    messageBoxView.layer.borderColor = [UIColor colorWithRed:215.0/255.0 green:215.0/255.0 blue:215.0/255.0 alpha:1.0].CGColor;
    messageBoxView.layer.borderWidth = 2.0;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 220.0f, 60.0f)];
    label.numberOfLines = 0; // if the text too long, the alert view should not be dismissed automatic.
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.font = [UIFont systemFontOfSize:14];
    label.text = msg;
    label.textAlignment = UITextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    [messageBoxView addSubview:label];
    [self.view addSubview:messageBoxView];
    messageBoxView.center = CGPointMake(self.view.center.x, 240);
    
    [self performSelector:@selector(dimissAlert:) withObject:messageBoxView afterDelay:delay];
}

@end
