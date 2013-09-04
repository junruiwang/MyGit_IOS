//
//  PromotionListController.m
//  JinJiangTravelPlus
//
//  Created by 吕 硕 on 13-1-6.
//  Copyright (c) 2013年 JinJiang. All rights reserved.
//

#import "PromotionListController.h"
#import "Promotion.h"
#import "PromotionView.h"
#import "UIImageView+WebCache.h"
#import "PromotionWebController.h"
#import "HotelDetailsViewController.h"
#import "HotelSearchViewController.h"
#import "RegistViewController.h"
#import "ActivationViewController.h"

#define SET_FRAME(ARTICLEX) x = ARTICLEX.frame.origin.x + increase;\
                                        if(x < 0) x = pageWidth * 2;\
                                        if(x > pageWidth * 2) x = 0.0f;\
                                        [ARTICLEX setFrame:CGRectMake(x, \
                                                ARTICLEX.frame.origin.y,\
                                                ARTICLEX.frame.size.width,\
                                                ARTICLEX.frame.size.height)]

const unsigned int promotionViewWidth = 320;
const unsigned int callActionSheetTag = 990;
const unsigned int web_ActionSheetTag = 988;
const unsigned int start_tag = 999900;


@interface PromotionListController ()

- (void)callPhone:(id)sender;
- (void)gotoWebSite:(id)sender;
- (void)allArticlesMoveRight:(CGFloat)pageWidth;
- (void)allArticlesMoveLeft:(CGFloat)pageWidth;
- (void)setFrame:(UIView*)view1 andIncrease:(float)increase andPageWidth:(float)pageWidth;
- (void)setRightPageControl;

@end

@implementation PromotionListController

@synthesize promotionsParser;
@synthesize hotelOverviewParser;
@synthesize promotionViewArray;
@synthesize promotionArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.trackedViewName = @"酒店促销信息页面";
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:@"营销中心"];

    [self.bigScrollView setDelegate:self];

    [self.view addSubview:self.pageControl];
    
    [self downloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 业务逻辑

- (void)downloadData
{
    if (!self.promotionsParser)
    {
        self.promotionsParser = [[PromotionsParser alloc] init];
        self.promotionsParser.isHTTPGet = YES;
        self.promotionsParser.serverAddress = kPromotionRequestURL;
    }

    NSMutableString *queryString = [NSMutableString string];
    [self.promotionsParser setRequestString:queryString];
    [self.promotionsParser setDelegate:self];
    [self.promotionsParser start];
    [self showIndicatorView];
}

- (void)parser:(GDataXMLParser*)parser DidParsedData:(NSDictionary *)data
{
    if ([parser isKindOfClass:[PromotionsParser class]])
    {
        NSMutableArray* array = [[NSMutableArray alloc] initWithArray:[data objectForKey:@"promotionArray"]];
        [self setPromotionArray:[[NSMutableArray alloc] initWithArray:array]];
        const unsigned int pages = [self.promotionArray count];
        [self.pageControl setNumberOfPages:pages];
        [self.pageControl setCurrentPage:0];

        const unsigned int scrollWidth = pages * promotionViewWidth + 30;
        const unsigned int scrollHeigh = self.bigScrollView.frame.size.height;
        [self.bigScrollView setContentSize:CGSizeMake(scrollWidth, scrollHeigh)];
        self.promotionViewArray = [[NSMutableArray alloc] initWithCapacity:pages];

        for (unsigned int ii = 0; ii < pages; ii++)
        {
            Promotion* promotion = (Promotion*)[self.promotionArray objectAtIndex:ii];

            const unsigned int xx = ii * promotionViewWidth;
            const CGRect frame = CGRectMake(xx, 0, promotionViewWidth, 416);
            PromotionView* promotionView0 = [[PromotionView alloc] initWithFrame:frame];
            [promotionView0 setBackgroundColor:[UIColor clearColor]];
            [promotionView0 setTag:start_tag + ii];
            if (promotion.largeBannerLink != nil && [promotion.largeBannerLink isEqualToString:@""] == NO)
            {
//                  add by analyse
                NSString *imURL = [promotion.smallBannerLink stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                UIImageView* img = [[UIImageView alloc] initWithFrame:CGRectMake(14, 16, 292, 192)];
                [img setImageWithURL:[NSURL URLWithString:imURL]];
                
                [promotionView0 addSubview:img];
                
                [promotionView0 addTextInfo:promotion];
            }

            UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setFrame:CGRectMake(0, 0, 320, 138)];[btn setBackgroundColor:[UIColor clearColor]];
            [btn addTarget:self action:@selector(gotoWebSite:) forControlEvents:UIControlEventTouchUpInside];
            [promotionView0 addSubview:btn];

            gotoWeb = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoWebSite:)];
            [self.view addGestureRecognizer:gotoWeb];

            [self.bigScrollView addSubview:promotionView0];
            [self.promotionViewArray addObject:promotionView0];
        }

        [self hideIndicatorView];
    }
    else if  ([parser isKindOfClass:([HotelOverviewParser class])])
    {
        JJHotel* hotelInfo = [data objectForKey:@"hotel"];  kPrintfInfo;

        HotelDetailsViewController* detailVC = (HotelDetailsViewController *) [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil]
                                                                               instantiateViewControllerWithIdentifier:@"HotelDetailsViewController"];
        [detailVC setHotel:hotelInfo];[detailVC setIsFromOrder:YES];[detailVC downloadData];
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //[self.promotionViewArray removeAllObjects];
    [self.view removeGestureRecognizer:gotoWeb];
}

#pragma mark - UIScrollViewDelegate

- (void)loadScrollViewWithPage:(int)page
{
    const unsigned int pages = self.pageControl.numberOfPages;

    if (page < 0)
    {   return; }
    if (page >= pages)
    {   return; }
}


- (IBAction)changePage:(id)sender
{
    UIScrollView* scrollView = self.bigScrollView;
    const unsigned int page = self.pageControl.currentPage;

    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];

	// update the scroll view to the appropriate page
    CGRect frame = scrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [scrollView scrollRectToVisible:frame animated:YES];

	// Set the boolean used when scrolls originate from the UIPageControl. See scrollViewDidScroll: above.
    _pageControlUsed = YES;
}

// At the begin of scroll dragging, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    _pageControlUsed = NO;
}

- (void)setRightPageControl
{
    const unsigned int xx = self.bigScrollView.contentOffset.x;
    unsigned int tag = start_tag;

    for (UIView* view in self.promotionViewArray)
    {
        const unsigned int x = view.center.x;
        if (x == 160 + xx)
        {   tag = view.tag - start_tag; break;  }
    }
    [self.pageControl setCurrentPage:tag];
}

// At the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _pageControlUsed = NO;

    CGFloat pageWidth = scrollView.frame.size.width;

    const unsigned int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;

    if (self.promotionViewArray.count >= 3)
    {
        if (page == 0)
        {
            [self allArticlesMoveRight:pageWidth];
            CGPoint p = CGPointZero;p.x = pageWidth;
            [scrollView setContentOffset:p animated:NO];
            [self setRightPageControl];
        }
        else if (page > 1)
        {
            [self allArticlesMoveLeft:pageWidth];
            CGPoint p = CGPointZero;p.x = pageWidth;
            [scrollView setContentOffset:p animated:NO];
            [self setRightPageControl];
        }
        else
        {
            [self setRightPageControl];
        }
    }
    
    //add GA and UM
    Promotion *pr = [self.promotionArray objectAtIndex:page];
    [self analysisScrollView:pr.title];
}


-(void)analysisScrollView:(NSString *)title
{
    [[GAI sharedInstance].defaultTracker sendEventWithCategory:@"酒店促销信息页面"
                                                    withAction:[NSString stringWithFormat:@"滑动查看页面:%@",title]
                                                     withLabel:[NSString stringWithFormat:@"查看促销页面:%@",title]
                                                     withValue:nil];
    
    [UMAnalyticManager eventCount:@"酒店促销信息页面" label:[NSString stringWithFormat:@"滑动查看页面:%@",title]];
}


-(void)analysisGotoWebView:(NSString*) title
{
    [[GAI sharedInstance].defaultTracker sendEventWithCategory:@"酒店促销信息页面"
                                                    withAction:[NSString stringWithFormat:@"点击去看看页面:%@",title]
                                                     withLabel:[NSString stringWithFormat:@"点击去看看页面:%@",title]
                                                     withValue:nil];
    
    [UMAnalyticManager eventCount:@"酒店促销信息页面" label:[NSString stringWithFormat:@"点击去看看页面:%@",title]];
}


- (void)allArticlesMoveRight:(CGFloat)pageWidth
{
    if (self.promotionViewArray.count >= 3)
    {
        const unsigned int ii = self.promotionViewArray.count;
        UIView *tmpView = [self.promotionViewArray objectAtIndex:ii-1];
        [self.promotionViewArray removeLastObject];
        [self.promotionViewArray insertObject:tmpView atIndex:0];

        float increase = pageWidth;

        for (UIView* view1 in self.promotionViewArray)
        {
            [self setFrame:view1 andIncrease:increase andPageWidth:pageWidth];
        }
    }
}

- (void)allArticlesMoveLeft:(CGFloat)pageWidth
{
    if (self.promotionViewArray.count >= 3)
    {
        UIView *tmpView = [self.promotionViewArray objectAtIndex:0];
        [self.promotionViewArray addObject:tmpView];
        [self.promotionViewArray removeObjectAtIndex:0];
        unsigned int ii = 1;

        UIView* tmp4 = [self.promotionViewArray objectAtIndex:0];
        CGRect frame4 = tmp4.frame; frame4.origin.x = 0 * pageWidth;// ii++;
        [tmp4 setFrame:frame4]; const unsigned int tag4 = tmp4.tag;

        UIView* tmp0 = [self.promotionViewArray objectAtIndex:1];
        CGRect frame0 = tmp0.frame; frame0.origin.x = ii * pageWidth; ii++;
        [tmp0 setFrame:frame0]; const unsigned int tag0 = tmp0.tag;

        UIView* tmp1 = [self.promotionViewArray objectAtIndex:2];
        CGRect frame1 = tmp1.frame; frame1.origin.x = ii * pageWidth; ii++;
        [tmp1 setFrame:frame1]; const unsigned int tag1 = tmp1.tag;

        for (UIView* tmpViewX in self.promotionViewArray)
        {
            const unsigned int ttag = tmpViewX.tag;
            if (ttag != tag0 && ttag != tag1 && ttag >= start_tag && tag4 != ttag)
            {
                const unsigned int ww = tmpViewX.frame.size.width;
                const unsigned int hh = tmpViewX.frame.size.height;
                [tmpViewX setFrame:CGRectMake(ii*pageWidth, 0, ww, hh)];ii++;
            }
        }
    }
}

- (void)setFrame:(UIView*)view1 andIncrease:(float)increase andPageWidth:(float)pageWidth
{
    float x = view1.frame.origin.x + increase;
    if(x < 0)   {   x = pageWidth * self.pageControl.numberOfPages - 1;  }
    if(x > pageWidth * self.pageControl.numberOfPages - 1)  {   x = 0.0f;   }

    [view1 setFrame:CGRectMake(x, view1.frame.origin.y, view1.frame.size.width, view1.frame.size.height)];
}

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    if (self.promotionViewArray.count == 2)
    {
        if (_pageControlUsed)
        {
            return;
        }

        CGFloat pageWidth = self.bigScrollView.frame.size.width;
        const unsigned int page = floor((self.bigScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        [self.pageControl setCurrentPage:page];

        [self loadScrollViewWithPage:page - 1];
        [self loadScrollViewWithPage:page];
        [self loadScrollViewWithPage:page + 1];
    }
}

#pragma mark - UIActionSheetDelegate

- (void)gotoWebSite:(id)sender
{
    UIActionSheet *menu = [[UIActionSheet alloc] initWithTitle:@"活动详情" delegate:self cancelButtonTitle:@"取消"
                                        destructiveButtonTitle:nil otherButtonTitles:@"去看看", nil];
    [menu setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    [menu setAlpha:1];[menu setTag:web_ActionSheetTag];[menu showInView:self.view];
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0 && actionSheet.tag == web_ActionSheetTag)
    {
        
        const unsigned int ii = self.pageControl.currentPage;NSLog(@"%d", ii);
        Promotion* pro = ((Promotion*)[self.promotionArray objectAtIndex:ii]);
        //todo add ga and UM
        [self analysisGotoWebView:pro.title];
        
        NSString* picURL = @"";
        if ([pro.bannerLink rangeOfString:@"JPG"].location!= NSNotFound  ||
            [pro.bannerLink rangeOfString:@"jpg"].location!= NSNotFound  ||
            [pro.bannerLink rangeOfString:@"png"].location!= NSNotFound  ||
            [pro.bannerLink rangeOfString:@"PNG"].location!= NSNotFound  ||
            [pro.bannerLink rangeOfString:@"gif"].location!= NSNotFound  ||
            [pro.bannerLink rangeOfString:@"GIF"].location!= NSNotFound  ||
            [pro.bannerLink rangeOfString:@"JPEG"].location!= NSNotFound ||
            [pro.bannerLink rangeOfString:@"jpeg"].location!= NSNotFound)
        {
            picURL = pro.bannerLink;
        }
        else if ([pro.smallBannerLink rangeOfString:@"JPG"].location!= NSNotFound  ||
                 [pro.smallBannerLink rangeOfString:@"jpg"].location!= NSNotFound  ||
                 [pro.smallBannerLink rangeOfString:@"png"].location!= NSNotFound  ||
                 [pro.smallBannerLink rangeOfString:@"PNG"].location!= NSNotFound  ||
                 [pro.smallBannerLink rangeOfString:@"gif"].location!= NSNotFound  ||
                 [pro.smallBannerLink rangeOfString:@"GIF"].location!= NSNotFound  ||
                 [pro.smallBannerLink rangeOfString:@"JPEG"].location!= NSNotFound ||
                 [pro.smallBannerLink rangeOfString:@"jpeg"].location!= NSNotFound)
        {
            picURL = pro.smallBannerLink;
        }
        else if ([pro.largeBannerLink rangeOfString:@"JPG"].location!= NSNotFound  ||
                 [pro.largeBannerLink rangeOfString:@"jpg"].location!= NSNotFound  ||
                 [pro.largeBannerLink rangeOfString:@"png"].location!= NSNotFound  ||
                 [pro.largeBannerLink rangeOfString:@"PNG"].location!= NSNotFound  ||
                 [pro.largeBannerLink rangeOfString:@"gif"].location!= NSNotFound  ||
                 [pro.largeBannerLink rangeOfString:@"GIF"].location!= NSNotFound  ||
                 [pro.largeBannerLink rangeOfString:@"JPEG"].location!= NSNotFound ||
                 [pro.largeBannerLink rangeOfString:@"jpeg"].location!= NSNotFound)
        {
            picURL = pro.largeBannerLink;
        }

        if (pro.category == PromotionCategoryWeblink)
        {
            PromotionWebController* con = [[PromotionWebController alloc] init];
            [con setUrl:[NSURL URLWithString:[pro webLink]]];
            [self.navigationController pushViewController:con animated:YES];
        }
        else if(pro.category == PromotionCategoryHotel)
        {
            if (!self.hotelOverviewParser)
            {
                self.hotelOverviewParser = [[HotelOverviewParser alloc] init];
                self.hotelOverviewParser.isHTTPGet = NO;
                self.hotelOverviewParser.serverAddress = [kHotelOverviewURL stringByAppendingPathComponent:
                                                          [NSString stringWithFormat:@"%d", [pro productId]]];
            }

            self.hotelOverviewParser.delegate = self;
            [self.hotelOverviewParser start];
        }
        else if(pro.category == PromotionCategoryRegister)
        {
            if ([TheAppDelegate.userInfo checkIsLogin])
            {
                PromotionWebController* con = [[PromotionWebController alloc] init];
                [con setUrl:[NSURL URLWithString:picURL]];
                [self.navigationController pushViewController:con animated:YES];
            }
            else
            {
                RegistViewController* con = (RegistViewController*) [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil]
                                                                     instantiateViewControllerWithIdentifier:@"RegistViewController"];
                [self.navigationController pushViewController:con animated:YES];
            }
        }
        else if(pro.category == PromotionCategoryActivate)
        {
            if ([TheAppDelegate.userInfo checkIsLogin])
            {
                PromotionWebController* con = [[PromotionWebController alloc] init];
                [con setUrl:[NSURL URLWithString:picURL]];
                [self.navigationController pushViewController:con animated:YES];
            }
            else
            {
                ActivationViewController* con = (ActivationViewController*) [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil]
                                                                             instantiateViewControllerWithIdentifier:@"ActivationViewController"];
                [self.navigationController pushViewController:con animated:YES];
            }
        }
        else if(pro.category == PromotionCategoryHotelSearch)
        {
            HotelSearchViewController* con = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil]
                                              instantiateViewControllerWithIdentifier:@"HotelSearchViewController"];
            TheAppDelegate.hotelSearchForm.hotelBrand = nil;
            [self.navigationController pushViewController:con animated:YES];
        }
        else if(pro.category == PromotionCategoryJINNSearch)
        {
            HotelSearchViewController* con = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil]
                                              instantiateViewControllerWithIdentifier:@"HotelSearchViewController"];
            Brand* brand = [[Brand alloc] initWithCode:@"JJINN" name:@"锦江之星" image:@"jinjiangstart.png"];
            TheAppDelegate.hotelSearchForm.hotelBrand = brand;
            [self.navigationController pushViewController:con animated:YES];
        }
        else if(pro.category == PromotionCategoryPicture)
        {
            PromotionWebController* con = [[PromotionWebController alloc] init];
            [con setUrl:[NSURL URLWithString:picURL]]; NSLog(@"picURL = %@", picURL);
            [self.navigationController pushViewController:con animated:YES];
        }
        else if(pro.category == PromotionCategoryUnknown)
        {
            kPrintfInfo;[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://1010-1666"]];
        }
    }
}

- (void)viewDidUnload {
    [self setBigScrollView:nil];
    [self setPageControl:nil];
    [super viewDidUnload];
}
@end
