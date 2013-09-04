//
//  AboutUsController.m
//  JinJiangTravelPlus
//
//  Created by 吕 硕 on 13-1-8.
//  Copyright (c) 2013年 JinJiang. All rights reserved.
//

#import "AboutUsController.h"
#import "UserFeedbackController.h"
#import <QuartzCore/QuartzCore.h>
#import "ShareToSNSManager.h"

const unsigned int callAction_SheetTag = 990;
const unsigned int com_action_SheetTag = 970;
const unsigned int rateButtonTag = 890;
const unsigned int rate1Btn_TAG_ = 888;
const unsigned int shareButtonTag = 880;
const unsigned int actionSheetTag = 777;
const unsigned int hideButton_Tag = 747;

@interface AboutUsController ()

@property(nonatomic, strong) ShareToSNSManager *shareToSNSManager;

- (void)rateButtonClicked:(id)sender;
- (void)shareButtonClicked:(id)sender;
- (void)hideCoverView;

@end

@implementation AboutUsController

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (tapHide2 && _iOS_version >= 5.88)
    {   [self.navigationController.view removeGestureRecognizer:tapHide2];  }
}

- (void)viewWillAppear:(BOOL)animated
{
    self.trackedViewName = @"关于页面";
    
    [super viewWillAppear:animated];
    if (tapHide2 && _iOS_version >= 5.88)
    {   [self.navigationController.view addGestureRecognizer:tapHide2]; }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _iOS_version = [[[UIDevice currentDevice] systemVersion] floatValue];
    _shareToSNSManager = [[ShareToSNSManager alloc] init];
    // Do any additional setup after loading the view.
    [self setTitle:@"关于锦江旅行家"];
    
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:USER_DEVICE_5]) {
        self.contentView.frame = CGRectMake(0, 0, 320, 360+88);
        self.contentImageView.frame = CGRectMake(0, 0, 320, 320+88);
        self.aboutUsText.frame = CGRectMake(10, 0, 300, 345+88);
    }

    NSString* message = @"上海锦江国际电子商务有限公司\n\n       上海锦江国际电子商务有限公司是锦江国际集团投资控股的下属企业。锦江国际集团是中国规模最大的综合性旅游企业集团之一，以酒店管理与投资、旅行服务及相关运输服务为主营业务，注册资本20亿元，直接或间接控股4家上市公司，合资经营多家品牌公司，“锦江”品牌价值逾140亿元。截至2011年12月，锦江国际集团投资和管理861家酒店，客房总数达12.5万余间／套，在全球酒店集团中排名第9位，列亚洲第一；同时，作为中国旅行社行业的龙头企业之一，锦江国际集团拥有上海国旅、上海锦旅、上海旅行社等多家国际、国内旅行社, 营业网点近70家，位列全国百强旅行社第3位和上海地区首位；此外，锦江国际集团还拥有一万多辆中高档汽车，列上海同业中综合接待能力第一。目前，锦江国际集团与美国万豪、希尔顿、洲际，加拿大费尔蒙特，法国索菲特等世界著名酒店集团以及日本三井、JTB,美国YELLOW ROADWAY,英国HRG,瑞士理诺士等20多家全球知名企业集团建立了广泛的合资合作关系，合资组建了锦江德尔互动有限公司、州际（中国）有限公司、锦江费尔蒙特酒店管理公司和锦江国际理诺士酒店管理学院等多家知名企业。\n       上海锦江国际电子商务有限公司2011年1月注册成功，注册资金1亿。公司依托于锦江国际集团雄厚的产业资源，并在锦江品牌优势的基础上，从事酒店、旅游、租车及相关产品网络销售，并对锦江国际集团核心产业实施有效整合，发挥资源联动效应，打造统一电子商务平台。同时，公司将以互联网技术为核心，引进社会资源，全方位开拓电子商务，把锦江电子商务网站打造成为国内最具有价值的旅游电子商务平台。\n       上海锦江国际电子商务有限公司将以成为锦江国际集团创新成长中心、IT支持中心、决策参考中心、数据集成中心、会员管理中心、客户服务中心、网络营销中心为奋斗目标，不断开拓创新，奋勇前进。\n\n上海锦江国际电子商务有限公司为消费者打造三大主要产品：\n\n“锦江旅行家”商务旅行预订网站——“锦江旅行家”，为旅行加更多\n       为您提供星级酒店、锦江之星、国内及境外旅游、机票、车辆租赁等全方位商务旅行在线预订平台；\n\n“锦江礼享+”锦江国际会员俱乐部——礼遇千里，智享人生\n       为您提供个性化会员关怀服务以及锦江国际专享优惠；\n\n“锦江e卡通”消费储值卡——体验多元消费 品味都市生活\n       为您提供锦江国际集团旗下企业以及全国各地特色商户刷卡消费，并支持公共事业缴费、手机充值等多样化在线支付服务。";

    [self.aboutUsText setText:message];
    [self hideCoverView];
}

- (void)hideCoverView
{
    [self.coverView setHidden:YES];
    [rate1 setHidden:YES];
    [cret1 setHidden:YES];
    [[self.view viewWithTag:hideButton_Tag] setHidden:YES];
}

- (void)showCoverView
{
    [self.coverView setHidden:NO];
    [rate1 setHidden:NO];[cret1 setHidden:NO];
    [[self.view viewWithTag:hideButton_Tag] setHidden:NO];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)wantToRateButtonPressed:(id)sender {
    
    [self showCoverView];
}
- (IBAction)toRatePressed:(id)sender {
    [self hideCoverView];
    [[GAI sharedInstance].defaultTracker sendEventWithCategory:@"关于我们"
                                                    withAction:@"点击评分"
                                                     withLabel:@"关于页面我要评分按钮"
                                                     withValue:nil];
    [UMAnalyticManager eventCount:@"点击评分" label:@"关于页面我要评分按钮"];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kCommentUrl]];
}
- (IBAction)critizePressed:(id)sender {
    [self hideCoverView];
    
    [[GAI sharedInstance].defaultTracker sendEventWithCategory:@"关于我们"
                                                    withAction:@"点击反馈"
                                                     withLabel:@"关于页面用户反馈按钮"
                                                     withValue:nil];
    [UMAnalyticManager eventCount:@"点击反馈" label:@"关于页面用户反馈按钮"];
    
    [self performSegueWithIdentifier:FROM_ABOUT_TO_FEED_BACK sender:self];
}


- (IBAction)tapToHideCoverView:(id)sender {
    
    [self hideCoverView];
}


- (void)rateButtonClicked:(id)sender
{
    const int ttag = [(UIView*)sender tag];

    if (ttag == rateButtonTag)
    {
    }
    else if (rate1Btn_TAG_ == ttag)
    {
    }
    else if ((rate1Btn_TAG_+1) == ttag)
    {
    }
}
- (IBAction)shareButtonPressed:(id)sender {
    
    [[GAI sharedInstance].defaultTracker sendEventWithCategory:@"关于我们"
                                                    withAction:@"点击分享"
                                                     withLabel:@"关于页面分享按钮"
                                                     withValue:nil];
    [UMAnalyticManager eventCount:@"点击分享" label:@"关于页面用户反馈按钮"];
    
    [self.shareToSNSManager shareWithActionSheet:self shareImage:[UIImage imageNamed:@"icon.png"] shareText:[NSString stringWithFormat:@"哇塞，这个软件是商旅必备神器啊--锦江旅行家，订酒店超快超方便，下个试试吧！%@", kAppStoreUrl]];
}

- (void)shareButtonClicked:(id)sender
{
}

- (void)viewDidUnload {
    [self setAboutUsText:nil];
    [self setCoverView:nil];
    [super viewDidUnload];
}
@end
