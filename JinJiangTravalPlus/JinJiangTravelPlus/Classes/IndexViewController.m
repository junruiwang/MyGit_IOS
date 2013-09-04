//
//  IndexViewController.m
//  JinJiangTravalPlus
//
//  Created by 杨 栋栋 on 12-10-31.
//  Copyright (c) 2012年 Leon. All rights reserved.
//

#import "Constants.h"
#import "IndexViewController.h"
#import "BillListController.h"
#import "PromotionListController.h"
#import "AboutUsController.h"
#import "UserFeedbackController.h"
#import "WebViewController.h"
#import "HotelSearchViewController.h"
#import "HotelSearchMapController.h"
#import "LoginViewController.h"
#import "AccountInfoViewController.h"
#import "ReadShakeAwardConfigParser.h"
#import "LotteryNumHelper.h"
#import "ReadActivityConfigParser.h"
#import "ActiveConfig.h"
#import "ActivityDetailWebViewController.h"
#import "NSDataAES.h"

#define FIRST_VIEW_SCROLL_TAG 77

const unsigned int versionForceUpdateTag = 335;
const unsigned int versionUnForceUpdateTag = 338;

@interface IndexViewController ()

@property (nonatomic, assign) NSInteger numberOfPages;
@property (nonatomic, strong) WebViewController *webViewController;
@property (nonatomic, strong) ReadShakeAwardConfigParser *shakeAwardConfigParser;
@property (nonatomic, strong) ReadActivityConfigParser *readActivityConfigParser;
@property (nonatomic, assign) BOOL shakeAwardEnabled;
@property (nonatomic, copy) NSString *activeStatus;
@property (nonatomic, strong) ActiveConfig *activeConfig;

@property (nonatomic, strong) UIImageView *envelopeBottom;
@property (nonatomic, strong) UIImageView *envelope;
@property (nonatomic, strong) UIImageView *envelopeTop;
@property (nonatomic, strong) UILabel *activityName;

- (void)firstShowBanner;
- (void)showWebView:(NSDictionary *)notification;
- (void)start2use:(id)sender;
- (void)downloadVersion;

@end

@implementation IndexViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        //注册通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(markectingButtonClicked:)
                                                     name:@"PromotionsPushFinished" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showWebView:)
                                                     name:@"WebUrlPushFinished" object:nil ];
        _numberOfPages = 4;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImage* img = [[UIImage imageNamed:@"home_bg.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:20];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:img]];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:USER_DEVICE_5]) {
        self.viewForUserDevice5.hidden = NO;
        self.viewForUserDevice4.hidden = YES;
    } else {
        self.viewForUserDevice5.hidden = YES;
        self.viewForUserDevice4.hidden = NO;
    }
    
    self.envelopeBottom = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"envelop_bottom.png"]];
    self.envelope = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"envelop_content.png"]];
    self.envelopeTop = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"envelop_top.png"]];
    self.activityName = [[UILabel alloc] initWithFrame:self.envelope.frame];
    
    [self.activityName setBackgroundColor:[UIColor clearColor]];
    self.activityName.font = [UIFont systemFontOfSize:12.0];
    self.activityName.textColor = [UIColor colorWithRed:1.0 green:26.0/255.0 blue:0.0 alpha:1.0];
    self.activityName.textAlignment = NSTextAlignmentCenter;
    
    
    [self.activityButtonView addSubview:self.envelopeBottom];
    [self.activityButtonView addSubview:self.envelope];
    [self.envelope addSubview:self.activityName];
    [self.activityButtonView addSubview:self.envelopeTop];
    
    
    [self firstShowBanner];
    [self downloadVersion];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.trackedViewName = @"应用首页";
    [super viewWillAppear:animated];
    self.activityButtonView.hidden = YES;
    self.activityButton.enabled = NO;
    [self readShakeAwardConfig];
    [self readActivityConfig];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    [(UILabel*)[self.view viewWithTag:990] setText:@""];
    [(UILabel*)[self.view viewWithTag:991] setText:@""];
    
    [(UILabel*)[self.view viewWithTag:980] setText:@""];
    [(UILabel*)[self.view viewWithTag:981] setText:@""];
    
    CGPoint point = CGPointMake(60, -23.5);
    self.envelopeBottom.center = point;
    self.envelope.center = point;
    self.envelopeTop.center = point;
    
    if ([TheAppDelegate.userInfo checkIsLogin] == NO)
    {
        [(UILabel*)[self.view viewWithTag:990] setHidden:YES];
        [(UILabel*)[self.view viewWithTag:992] setHidden:YES];
        [(UILabel*)[self.view viewWithTag:993] setHidden:YES];
        [(UILabel*)[self.view viewWithTag:991] setText:@"您尚未登录"];
        
        [(UILabel*)[self.view viewWithTag:980] setHidden:YES];
        [(UILabel*)[self.view viewWithTag:982] setHidden:YES];
        [(UILabel*)[self.view viewWithTag:983] setHidden:YES];
        [(UILabel*)[self.view viewWithTag:981] setText:@"您尚未登录"];
    }
    else
    {
        NSString* name = TheAppDelegate.userInfo.fullName;
        if (name == nil || [name isEqualToString:@""])
        {   name = TheAppDelegate.userInfo.loginName;   }
        [(UILabel*)[self.view viewWithTag:992] setHidden:NO];
        [(UILabel*)[self.view viewWithTag:992] setText:name];
        
        [(UILabel*)[self.view viewWithTag:982] setHidden:NO];
        [(UILabel*)[self.view viewWithTag:982] setText:name];
        
        const unsigned int xx = [self.view viewWithTag:982].center.x;
        const unsigned int yy = 268;
        [(UILabel*)[self.view viewWithTag:982] setCenter:CGPointMake(xx, yy)];
        
        
        [self downloadActiveOrderList];
    }
}

- (WebViewController *)webViewController
{
    if (!_webViewController)
    {
        _webViewController = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil]
                              instantiateViewControllerWithIdentifier:@"WebViewController"];
    }
    return _webViewController;
}

- (IBAction)callPhone:(id)sender
{
    [[GAI sharedInstance].defaultTracker sendEventWithCategory:@"电话预订"
                                                    withAction:@"电话预订"
                                                     withLabel:@"电话预订按钮"
                                                     withValue:nil];
    [UMAnalyticManager eventCount:@"电话预订" label:@"电话预订按钮"];
    
    UIActionSheet *menu = [[UIActionSheet alloc] initWithTitle:@"电话预订" delegate:self cancelButtonTitle:@"取消"
                                        destructiveButtonTitle:nil otherButtonTitles:@"1010-1666", nil];
    [menu setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    [menu setAlpha:1];
    [menu showInView:self.view];
}

- (IBAction)memberCenter:(id)sender
{
    if ([TheAppDelegate.userInfo checkIsLogin]) {
        //跳转到会员中心
        [self performSegueWithIdentifier:@"indexToMember" sender:nil];
    } else {
        //跳转到登录
        TheAppDelegate.customEnumType = JJCustomTypeMember;
        [self performSegueWithIdentifier:@"login" sender:nil];
    }
}


- (IBAction)billButtonClicked:(id)sender
{
    if ([TheAppDelegate.userInfo checkIsLogin]) {
        //跳转到订单中心
        [self performSegueWithIdentifier:@"toBillList" sender:nil];
    } else {
        //跳转到登录
        TheAppDelegate.customEnumType = JJCustomTypeBill;
        [self performSegueWithIdentifier:@"login" sender:nil];
    }
}

- (IBAction)markectingButtonClicked:(id)sender
{
    [self performSegueWithIdentifier:@"promotionList" sender:nil];
    //    PromotionListController* con = [[PromotionListController alloc] init];
    //    [self.navigationController pushViewController:con animated:YES];
}

- (IBAction)aboutUsButtonClicked:(id)sender
{
    [self performSegueWithIdentifier:FROM_INDEX_TO_ABOUT_US sender:self];
}

- (IBAction)userFeedBackButtonClicked:(id)sender
{
    UserFeedbackController* con = (UserFeedbackController *)[[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil]
                                                             instantiateViewControllerWithIdentifier:@"UserFeedbackController"];
    [self.navigationController pushViewController:con animated:YES];
}

- (IBAction)nearbyHotelsClicked:(id)sender
{
    [self performSegueWithIdentifier:@"nearbyHotelsMap" sender:nil];
}

- (IBAction)jniiButtonClicked:(id)sender
{
    HotelSearchViewController* con = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil]
                                      instantiateViewControllerWithIdentifier:@"HotelSearchViewController"];
    Brand* brand = [[Brand alloc] initWithCode:@"JJINN" name:@"锦江之星" image:@"jinjiangstart.png"];
    TheAppDelegate.hotelSearchForm.hotelBrand = brand;
    [self.navigationController pushViewController:con animated:YES];
}


- (IBAction)searchHotelsClicked:(id)sender
{
    [self performSegueWithIdentifier:@"hotelSearch" sender:nil];
}

#pragma mark--shakeAwardClicked
-(IBAction)shakeAwardClicked:(id)sender{
    [UMAnalyticManager eventCount:@"点击摇一摇铵钮" label:@"点击摇一摇进入摇奖"];
    [[GAI sharedInstance].defaultTracker sendEventWithCategory:@"手机摇一摇"
                                                    withAction:@"点击摇一摇按钮进入摇奖页面"
                                                     withLabel:@"点击摇一摇按钮"
                                                     withValue:nil];
    [self shakeMobileBtnHandler];
}

-(IBAction)activityButtonClicked:(id)sender
{
    [self performSegueWithIdentifier:@"activityDetail" sender:self];
    
}

-(void)readShakeAwardConfig
{
    if(!_shakeAwardConfigParser){
        _shakeAwardConfigParser = [[ReadShakeAwardConfigParser alloc] init];
        _shakeAwardConfigParser.delegate = self;
    }
    [_shakeAwardConfigParser getShakeAwardConfig:@"0"];
}

- (void)readActivityConfig
{
    if (!self.readActivityConfigParser)
    {
        self.readActivityConfigParser = [[ReadActivityConfigParser alloc] init];
        self.readActivityConfigParser.serverAddress = kActivityConfigURL;
    }
    self.readActivityConfigParser.delegate = self;
    [self.readActivityConfigParser start];
}

- (const unsigned int)getVersionNumber:(NSString *)version
{
    if (version == nil)
    {
        return 0;
    }
    NSMutableString *versionString = [NSMutableString stringWithString:version];
    NSRange substr = [versionString rangeOfString:@"."];
    if (substr.location != NSNotFound)
    {
        NSRange substr2 = [versionString rangeOfString:@"." options:NSBackwardsSearch];
        if (substr2.location != substr.location)
        {
            [versionString replaceCharactersInRange:substr2 withString:@""];
        }
    }
    
    return (unsigned int)([versionString floatValue] * 100);
}

- (void)showWebView:(NSDictionary *)notification
{
    self.webViewController.title = (NSString *)[notification valueForKeyPath:@"object.aps.alert"];
    self.webViewController.url = [notification valueForKeyPath:@"object.url"];
    [self.navigationController pushViewController:self.webViewController animated:YES];
}

- (void)firstShowBanner
{
    NSString *alreadyRunKey = [NSString stringWithFormat:@"%@,%@", kClientVersion, FIRST];
    if (![[NSUserDefaults standardUserDefaults] boolForKey:alreadyRunKey])
    {
        NSInteger viewWidth = self.view.frame.size.width;
        NSInteger viewHeigh = self.view.frame.size.height;
        
        NSString* newImageName0;
        NSString* newImageName1;
        NSString* newImageName2;
        NSString* newImageName3;
        NSInteger yy = 360;
        if ([[NSUserDefaults standardUserDefaults] boolForKey:USER_DEVICE_5]) {
            newImageName0 = @"new_1_iphone5.jpg";
            newImageName1 = @"new_2_iphone5.jpg";
            
            newImageName2 = @"new_3_iphone5.jpg";
            newImageName3 = @"new_4_iphone5.jpg";
            yy = (470+88) - 168;
        } else {
            newImageName0 = @"new_1.jpg";
            newImageName1 = @"new_2.jpg";
            
            newImageName2 = @"new_3.jpg";
            newImageName3 = @"new_4.jpg";
            yy = 470 - 120;
        }
        UIScrollView* scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeigh)];
        [scroll setTag:FIRST_VIEW_SCROLL_TAG];
        [scroll setDelegate:self];
        [scroll setScrollsToTop:NO];
        [scroll setBackgroundColor:[UIColor clearColor]];
        [scroll setPagingEnabled:YES];
        [scroll setShowsHorizontalScrollIndicator:NO];
        [scroll setShowsVerticalScrollIndicator:NO];
        [scroll setContentSize:CGSizeMake(viewWidth * (self.numberOfPages + 1), viewHeigh)];
        
        UIImageView* viewx0 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeigh)];
        [viewx0 setBackgroundColor:[UIColor clearColor]];
        [viewx0 setImage:[UIImage imageNamed:newImageName0]];
        [scroll addSubview:viewx0];
        
        UIImageView* viewx1 = [[UIImageView alloc] initWithFrame:CGRectMake(viewWidth, 0, viewWidth, viewHeigh)];
        [viewx1 setBackgroundColor:[UIColor clearColor]];
        [viewx1 setImage:[UIImage imageNamed:newImageName1]];
        [scroll addSubview:viewx1];
        
        UIImageView* viewx2 = [[UIImageView alloc] initWithFrame:CGRectMake(viewWidth*2, 0, viewWidth, viewHeigh)];
        [viewx2 setBackgroundColor:[UIColor clearColor]];
        [viewx2 setImage:[UIImage imageNamed:newImageName2]];
        [scroll addSubview:viewx2];
        
        UIImageView* viewx3 = [[UIImageView alloc] initWithFrame:CGRectMake(viewWidth*3, 0, viewWidth, viewHeigh)];
        [viewx3 setBackgroundColor:[UIColor clearColor]];
        [viewx3 setImage:[UIImage imageNamed:newImageName3]];
        [scroll addSubview:viewx3];
        
        UIButton *start2use_Btn = [UIButton buttonWithType:UIButtonTypeCustom];
        if ([[NSUserDefaults standardUserDefaults] boolForKey:USER_DEVICE_5]) {
            [start2use_Btn setFrame:CGRectMake(320*3 + 180, 320 + 88, 140, 45)];
        } else {
            [start2use_Btn setFrame:CGRectMake(320*3 + 180, 320, 140, 45)];
        }
        [start2use_Btn setBackgroundImage:[UIImage imageNamed:@"start2use2.png"] forState:UIControlStateNormal];
        [start2use_Btn addTarget:self action:@selector(start2use:) forControlEvents:UIControlEventTouchUpInside];
        [scroll addSubview:start2use_Btn];
        
        [self.view addSubview:scroll];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:alreadyRunKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"hotelSearch"])
    {
        TheAppDelegate.hotelSearchForm.hotelBrand = nil;
    } else if ([segue.identifier isEqualToString:@"activityDetail"]) {
        ActivityDetailWebViewController* activityDetailWebViewController = segue.destinationViewController;
        NSString* uid = TheAppDelegate.userInfo.uid;
        NSString* httpBodyString = [NSString stringWithFormat:@"%@?clientVersion=%@&userId=%@&sign=%@", self.activeConfig.url, kClientVersion, uid, [[uid stringByAppendingFormat:kSecurityKey] MD5String]];
        
        activityDetailWebViewController.url = httpBodyString;
        activityDetailWebViewController.config = self.activeConfig;
    }
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://1010-1666"]];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Index Order Label

- (void)downloadVersion
{
    if (!self.clientVersionParser)
    {
        self.clientVersionParser = [[ClientVersionParser alloc] init];
        self.clientVersionParser.serverAddress = kClientVersionURL;
    }
    self.clientVersionParser.delegate = self;
    [self.clientVersionParser start];
}

- (void)downloadActiveOrderList
{
    {
        
        NSDate *time = [NSDate date];
        int entryDateFromTimeInterval = time.timeIntervalSince1970 - kSecondsPerDay * 90;
        
        NSString* entryDateFrom = [[KalDate dateFromNSDate:[NSDate dateWithTimeIntervalSince1970:entryDateFromTimeInterval]] chineseDescription];
        NSString* entryDateTo = [[KalDate dateFromNSDate:[NSDate date]] chineseDescription];
        
        if (!self.activeOrderListParser)
        {
            self.activeOrderListParser = [[ActiveOrderListParser alloc] init];
            self.activeOrderListParser.isHTTPGet = YES;
            self.activeOrderListParser.serverAddress = kUserActiveOrderListURL;
        }
        
        NSString* format = @"entryDateFrom=%@&entryDateTo=%@";
        [self.activeOrderListParser setRequestString:[NSString stringWithFormat:format, entryDateFrom, entryDateTo]];
        [self.activeOrderListParser setDelegate:self];
        [self.activeOrderListParser start];
    }
}

#pragma mark - GDataXMLParserDelegate
- (void)parser:(GDataXMLParser *)parser DidFailedParseWithMsg:(NSString *)msg errCode:(NSInteger)code
{
}

- (void)parser:(GDataXMLParser*)parser DidParsedData:(NSDictionary *)data
{
    if ([parser isKindOfClass:[ActiveOrderListParser class]])
    {
        [self handlerActiveOrderListParser:data];
    }
    else if ([parser isKindOfClass:[ClientVersionParser class]])
    {
        [self handlerClientVersionParser:data];
    } else if([parser isKindOfClass:[ReadShakeAwardConfigParser class]]){
        [self handlerReadShakeAwardConfigParser:data];
    } else if([parser isKindOfClass:[ReadActivityConfigParser class]]){
        self.activeConfig = data[@"activeConfig"];
        self.activityName.text = self.activeConfig.title;
        [self handlerActivityConfig];
    }
}

- (void)handlerClientVersionParser:(NSDictionary *)data {
    NSString *alreadyShow = [NSString stringWithFormat:@"%@_%@", kClientVersion, kVersionDescription];
    if (![[NSUserDefaults standardUserDefaults] boolForKey:alreadyShow])
    {
        TheAppDelegate.clientVersion = data[@"clientVersion"];
        const unsigned int version = [self getVersionNumber:TheAppDelegate.clientVersion.version];
        const unsigned int curnVer = [self getVersionNumber:kClientVersion];
        
        if (version > curnVer)
        {
            if ([TheAppDelegate.clientVersion.forceUpdate isEqualToString:@"Y"]) {
                NSString* message = TheAppDelegate.clientVersion.description;
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"您的软件版本已过期 请更新 " message:message delegate:self
                                                      cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                
                [alert setTag:versionForceUpdateTag];
                [alert show];
            } else {
                NSString* message = TheAppDelegate.clientVersion.description;
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"您的软件版本已过期 请更新 " message:message delegate:self
                                                      cancelButtonTitle:nil otherButtonTitles:@"立即更新", @"暂不更新", @"不在提醒", nil];
                [alert setTag:versionUnForceUpdateTag];
                [alert show];
            }
        }
    }
}

- (void)handlerActiveOrderListParser:(NSDictionary *)data {
    const unsigned int number = [[data objectForKey:@"unpaied"] intValue];
    NSMutableArray* orderList = [[NSMutableArray alloc] initWithArray:[data objectForKey:@"orderList"]];
    int showOrderNumber = [orderList count];
    
    if (showOrderNumber <= 0)
    {
        [(UILabel*)[self.view viewWithTag:990] setHidden:YES];
        [(UILabel*)[self.view viewWithTag:993] setHidden:YES];
        [(UILabel*)[self.view viewWithTag:991] setHidden:NO];
        [(UILabel*)[self.view viewWithTag:991] setText:@"您当前没有活跃订单"];
        
        [(UILabel*)[self.view viewWithTag:980] setHidden:YES];
        [(UILabel*)[self.view viewWithTag:983] setHidden:YES];
        [(UILabel*)[self.view viewWithTag:981] setHidden:NO];
        [(UILabel*)[self.view viewWithTag:981] setText:@"您当前没有活跃订单"];
    }
    else
    {
        if (number >= 1)
        {
            [(UILabel*)[self.view viewWithTag:990] setText:[NSString stringWithFormat:@"%d",number]];
            [(UILabel*)[self.view viewWithTag:991] setText:@"张订单待付款"];
            [(UILabel*)[self.view viewWithTag:990] setHidden:NO];
            [(UILabel*)[self.view viewWithTag:991] setHidden:NO];
            [(UILabel*)[self.view viewWithTag:993] setHidden:YES];
            
            [(UILabel*)[self.view viewWithTag:980] setText:[NSString stringWithFormat:@"%d",number]];
            [(UILabel*)[self.view viewWithTag:981] setText:@"张订单待付款"];
            [(UILabel*)[self.view viewWithTag:980] setHidden:NO];
            [(UILabel*)[self.view viewWithTag:981] setHidden:NO];
            [(UILabel*)[self.view viewWithTag:983] setHidden:YES];
        }
        else
        {
            NSString* checkDate = [NSString stringWithFormat:@"%@——%@",
                                   [data objectForKey:@"minCheckIn"],
                                   [data objectForKey:@"minCheckOut"]];
            [(UILabel*)[self.view viewWithTag:990] setHidden:YES];
            [(UILabel*)[self.view viewWithTag:993] setHidden:NO];
            [(UILabel*)[self.view viewWithTag:991] setHidden:NO];
            [(UILabel*)[self.view viewWithTag:993] setText:[data objectForKey:@"minHotel"]];
            [(UILabel*)[self.view viewWithTag:991] setText:checkDate];
            
            [(UILabel*)[self.view viewWithTag:980] setHidden:YES];
            [(UILabel*)[self.view viewWithTag:983] setHidden:NO];
            [(UILabel*)[self.view viewWithTag:981] setHidden:NO];
            [(UILabel*)[self.view viewWithTag:983] setText:[data objectForKey:@"minHotel"]];
            [(UILabel*)[self.view viewWithTag:981] setText:checkDate];
        }
    }
}

#pragma mark --readShakeAwardConfigParser
-(void) handlerReadShakeAwardConfigParser:(NSDictionary *)data
{
    NSString *status = [data objectForKey:kKeyStatus];
    const BOOL enabled =  [[data objectForKey:kKeyEnabled] boolValue];
    TheAppDelegate.shakeAwardDate = [data objectForKey:kKeyDateStr];
    self.shakeMobileButton.hidden = !enabled;
    self.shakeAwardEnabled = enabled;
    self.activeStatus = status;
}

-(void)shakeMobileBtnHandler
{
    if(!self.shakeAwardEnabled){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"活动已经结束了，请关注下次活动吧~" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    if ([TheAppDelegate.userInfo checkIsLogin] == YES)
    {
        [self performSegueWithIdentifier:FROM_INDEX_TOSHAKE sender:nil];
    }else{
        //跳转到登录
        TheAppDelegate.customEnumType = JJCustomTypeShakeAward;
        [self performSegueWithIdentifier:@"login" sender:nil];
    }
}

- (void)handlerActivityConfig
{
    if ([self.activeConfig.activeFlag isEqualToString:@"true"]) {
        self.activityButtonView.hidden = NO;
        self.activityButton.enabled = YES;
        [UIView animateWithDuration:1.0
                              delay:0.5
                            options:nil
                         animations:^{
                             self.envelopeBottom.transform = CGAffineTransformMakeTranslation(0, 47);
                             self.envelopeTop.transform = CGAffineTransformMakeTranslation(0, 47);
                         }
                         completion:^(BOOL finish){
                             [UIView animateWithDuration:1.0 animations:^{
                                 self.envelope.transform = CGAffineTransformMakeTranslation(0, 47);
                             }];
                             
                         }];
        
    } else {
        self.activityButtonView.hidden = YES;
        self.activityButton.enabled = NO;
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    UIScrollView* scrollView = (UIScrollView*)[self.view viewWithTag:FIRST_VIEW_SCROLL_TAG];
    if (scrollView.contentOffset.x <= 0) {
        [scrollView setContentOffset:CGPointMake(0, scrollView.contentOffset.y) animated:NO];
    }
}

// At the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    const unsigned int xx = scrollView.contentOffset.x;
    
    if (xx >= (1280 - 1))
    {
        [[self.view viewWithTag:FIRST_VIEW_SCROLL_TAG] setHidden:YES];
    }
}

- (void)start2use:(id)sender
{
    UIScrollView* scrollView = (UIScrollView*)[self.view viewWithTag:FIRST_VIEW_SCROLL_TAG];
    
    CGRect frame = scrollView.frame;
    frame.origin.x = frame.size.width * self.numberOfPages;
    frame.origin.y = 0;
    [scrollView scrollRectToVisible:frame animated:YES];
    
    [UIView beginAnimations:@"RemoveScrollView" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [[self.view viewWithTag:FIRST_VIEW_SCROLL_TAG] setAlpha:0];
    [UIView commitAnimations];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == versionForceUpdateTag) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:TheAppDelegate.clientVersion.updateUrl]];
    }
    
    if (alertView.tag == versionUnForceUpdateTag && buttonIndex == 0) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:TheAppDelegate.clientVersion.updateUrl]];
    } else if (alertView.tag == versionUnForceUpdateTag && buttonIndex == 2) {
        NSString *alreadyShow = [NSString stringWithFormat:@"%@_%@", kClientVersion, kVersionDescription];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:alreadyShow];
    }
    
}



- (void)willPresentAlertView:(UIAlertView *)alertView
{
    if (alertView.tag == versionForceUpdateTag || alertView.tag == versionUnForceUpdateTag)
    {
        UIView * view = [alertView.subviews objectAtIndex:2];
        if([view isKindOfClass:[UILabel class]])
        {
            UILabel* label = (UILabel*) view;
            label.textAlignment = UITextAlignmentLeft;
        }
    }
}

- (void)viewDidUnload {
    [self setCallButton:nil];
    [self setActivityButtonView:nil];
    [super viewDidUnload];
}
@end
