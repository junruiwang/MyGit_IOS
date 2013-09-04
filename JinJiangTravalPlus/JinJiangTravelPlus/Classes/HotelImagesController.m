//
//  HotelImagesController.m
//  JinJiangTravelPlus
//
//  Created by 吕 硕 on 12-12-17.
//  Copyright (c) 2012年 JinJiang. All rights reserved.
//

#define bigScrollViewTag 999
#define smlScrollViewTag 777

const unsigned int buttonStartTag = 87;
float _firstX;
float _firstY;

#import "HotelImagesController.h"
#import "UIImageView+WebCache.h"
#import "UIViewController+Categories.h"
#import "Constants.h"

@interface HotelImagesController ()

- (void)tapImageBig;
- (void)twoFingerPinch:(UIPinchGestureRecognizer *)recognizer;
- (void)twoFingersRotate:(UIRotationGestureRecognizer *)recognizer;
- (void)handelPan:(UIPanGestureRecognizer*)gestureRecognizer;

@end

@implementation HotelImagesController

@synthesize hotelId = _hotelId;
@synthesize hotelOverviewParser = _hotelOverviewParser;
@synthesize bigScrollView = _bigScrollView;
@synthesize smlScrollView = _smlScrollView;
@synthesize imageURLarray = _imageURLarray;
@synthesize titleStrArray = _titleStrArray;
@synthesize imagesArray = _imagesArray;
@synthesize pageControl = _pageControl;
@synthesize numberLabel = _numberLabel;
@synthesize titleLabel = _titleLabel;
@synthesize bigImgView = _bigImgView;
@synthesize titleLabel2;

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.trackedViewName = @"酒店图片页面";
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    _bigImageShowing = NO;
    [super viewDidLoad];[self setTitle:@"酒店图片"];
    [self.view setBackgroundColor:[UIColor blackColor]];
	// Do any additional setup after loading the view.

    const CGRect frame0 = CGRectMake(0, 305, 320, 20); _index = 0;
    self.pageControl = [[UIPageControl alloc] initWithFrame:frame0];
    [self.pageControl addTarget:self action:@selector(changePage:)
               forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.pageControl];

    self.titleLabel = [[UILabel alloc] init];
    [self.titleLabel setFrame:CGRectMake(5, 268, 230, 20)];
    [self.titleLabel setTextAlignment:UITextAlignmentLeft];
    [self.titleLabel setText:@""];
    [self.titleLabel setLineBreakMode:NSLineBreakByCharWrapping];
    [self.titleLabel setTextColor:[UIColor whiteColor]];
    [self.titleLabel setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.titleLabel];

    self.titleLabel2 = [[UILabel alloc] init];
    [self.titleLabel2 setFrame:CGRectMake(5, 285, 310, 20)];
    [self.titleLabel2 setTextAlignment:UITextAlignmentLeft];
    [self.titleLabel2 setText:@""];
    [self.titleLabel2 setLineBreakMode:NSLineBreakByCharWrapping];
    [self.titleLabel2 setTextColor:[UIColor whiteColor]];
    [self.titleLabel2 setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.titleLabel2];

    self.numberLabel = [[UILabel alloc] init];
    [self.numberLabel setFrame:CGRectMake(35, 268, 280, 20)];
    [self.numberLabel setTextAlignment:UITextAlignmentRight];
    [self.numberLabel setText:@""];
    [self.numberLabel setTextColor:[UIColor whiteColor]];
    [self.numberLabel setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.numberLabel];

    const unsigned int ww = self.view.frame.size.width;
    const unsigned int hh = self.view.frame.size.height;
    self.bigScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ww, hh)];
    [self.bigScrollView setBackgroundColor:[UIColor clearColor]];
    [self.bigScrollView setPagingEnabled:YES];
    [self.bigScrollView setShowsHorizontalScrollIndicator:NO];
    [self.bigScrollView setShowsVerticalScrollIndicator:NO];
    [self.bigScrollView setScrollsToTop:NO];
    [self.bigScrollView setDelegate:self];
    [self.view addSubview:self.bigScrollView];

//    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]
//                                   initWithTarget:self action:@selector(tapImageBig)];
//    [self.view addGestureRecognizer:tap];

    CGRect frame1 = CGRectMake(0, 12, ww, 240);
    self.bigImgView = [[UIImageView alloc] initWithFrame:frame1];
    [self.bigImgView setImage:nil];[self.bigImgView setHidden:(!_bigImageShowing)];
    [self.bigImgView setBackgroundColor:[UIColor clearColor]];
    [self.bigImgView setCenter:CGPointMake(ww/2, hh/2)];
    [self.view addSubview:self.bigImgView];

    if (!pinchImg)
    {   pinchImg = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(twoFingerPinch:)];    }
    if (!imgRotate)
    {   imgRotate = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(twoFingersRotate:)];  }
    if (!imgPanGes)
    {   imgPanGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handelPan:)];  }
}

-(void)tapImageBig
{
    _bigImageShowing = !_bigImageShowing;

    const unsigned int ww = self.view.frame.size.width;
    const unsigned int hh = self.view.frame.size.height;
    const unsigned int ii = self.pageControl.currentPage;
    CGRect frame1 = CGRectMake(0, 12, ww, 240);
    
    [self.navigationController setNavigationBarHidden:_bigImageShowing animated:YES];

    [self.bigScrollView setHidden:_bigImageShowing];
    [self.titleLabel setHidden:_bigImageShowing];
    [self.titleLabel2 setHidden:_bigImageShowing];
    [self.numberLabel setHidden:_bigImageShowing];
    
    [self.bigImgView setHidden:(!_bigImageShowing)];
    [self.bigImgView setImageWithURL:[NSURL URLWithString:[self.imageURLarray objectAtIndex:ii]]];
    [self.bigImgView setFrame:frame1];[self.bigImgView setCenter:CGPointMake(ww/2, hh/2)];
    [self.bigImgView setTransform:CGAffineTransformMakeRotation(0)];

    if (_bigImageShowing)
    {
        if (!pinchImg)
        {   pinchImg = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(twoFingerPinch:)];    }
        [self.view addGestureRecognizer:pinchImg];

        if (!imgRotate)
        {   imgRotate = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(twoFingersRotate:)];  }
        [self.view addGestureRecognizer:imgRotate];

        if (!imgPanGes)
        {   imgPanGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handelPan:)];  }
        [self.view addGestureRecognizer:imgPanGes];
    }
    else
    {
        [self.view removeGestureRecognizer:pinchImg];
        [self.view removeGestureRecognizer:imgRotate];
        [self.view removeGestureRecognizer:imgPanGes];
    }
}

- (void)twoFingerPinch:(UIPinchGestureRecognizer *)recognizer
{
    const unsigned int h = self.view.frame.size.height*2;
    const float scale = recognizer.scale;// * 0.2;
    const unsigned int centerX = self.bigImgView.center.x;
    const unsigned int centerY = self.bigImgView.center.y;
    const unsigned int ww = self.bigImgView.frame.size.width;
    const unsigned int hh = self.bigImgView.frame.size.height;
    const float wh = ((float)(((float)(ww)) / ((float)(hh))));

    unsigned int www = ((unsigned int)(((float)(ww)) * scale));
    unsigned int hhh = ((unsigned int)(((float)(hh)) * scale));

    if (www <= 320) {   www = 320;  hhh = 240;  }
    if (hhh >= h) { hhh = h; www = ((unsigned int)(wh * ((float)(h)))); }

    CGRect frame1 = self.bigImgView.frame;
    frame1.size.width = www; frame1.size.height = hhh;
    [self.bigImgView setFrame:frame1];
    [self.bigImgView setCenter:CGPointMake(centerX, centerY)];
}

- (void)handelPan:(UIPanGestureRecognizer*)gestureRecognizer
{
    const unsigned int h = self.view.frame.size.height;
    
    CGPoint translatedPoint = [gestureRecognizer translationInView:self.view];
    
    if([gestureRecognizer state] == UIGestureRecognizerStateBegan)
    {
        _firstX = [self.bigImgView center].x;
        _firstY = [self.bigImgView center].y;
    }
    
    int x = _firstX + translatedPoint.x;
    int y = _firstY + translatedPoint.y;
    
    const unsigned int ww = self.bigImgView.frame.size.width;
    const unsigned int hh = self.bigImgView.frame.size.height;
    const int xx = x - (ww / 2), yy = y - (hh / 2);
    
    if (xx >= 0) {  x = (ww / 2);   }
    if (yy >= 0) {  y = (hh / 2);   }
    if (xx + ww <= 320) {   x = 320 - (ww / 2); }
    if (yy + hh <= h-1) {   y = h   - (hh / 2); }
    
    if (ww <= 320)  {   x = 160;    }
    if (hh <= h+0)  {   y = h / 2;  }
    
//    commit by analyse
//    translatedPoint = CGPointMake(x, y);
    [self.bigImgView setCenter:CGPointMake(x, y)];
}

- (void)twoFingersRotate:(UIRotationGestureRecognizer *)recognizer
{
    NSLog(@"Rotation in degrees since last change: %f", [recognizer rotation] * (180 / M_PI));
//    if ([recognizer rotation] * (180 / M_PI) > 0)
//    {
//        CGAffineTransform trans = self.bigImgView.transform;
//        CGAffineTransform newTans = CGAffineTransformRotate(trans, M_PI/2);
//        [self.bigImgView setTransform:newTans];
//    }
//    else
//    {
//        CGAffineTransform trans = self.bigImgView.transform;
//        CGAffineTransform newTans = CGAffineTransformRotate(trans, -M_PI/2);
//        [self.bigImgView setTransform:newTans];
//    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - xml data

- (void)downloadData
{
    if (!self.hotelOverviewParser)
    {
        self.hotelOverviewParser = [[HotelOverviewParser alloc] init];
        self.hotelOverviewParser.isHTTPGet = NO;
        self.hotelOverviewParser.serverAddress = [kHotelOverviewURL stringByAppendingPathComponent:
                                                  [NSString stringWithFormat:@"%d", self.hotelId]];
    }

    self.hotelOverviewParser.delegate = self;
    [self.hotelOverviewParser start];
    [self showIndicatorView];
}

- (void)parser:(GDataXMLParser *)parser DidParsedData:(NSDictionary *)data
{
    NSString* images = [data objectForKey:@"images"];
    unsigned int pages;

    if ([images rangeOfString:@"null"].location != NSNotFound)
    {   [self backAction:nil];    }

    if ([[images componentsSeparatedByString:@","] count] <= 1)
    {
        return;
    }
    else if ([[images componentsSeparatedByString:@";"] count] >= 2 && [[images componentsSeparatedByString:@","] count] > 2)
    {
        NSArray* titleAndURLs = [images componentsSeparatedByString:@";"];
        pages = [titleAndURLs count];
        [self.numberLabel setText:[NSString stringWithFormat:@"< 1 / %d >", pages]];
        [self setImageURLarray: [[NSMutableArray alloc] initWithCapacity:pages]];
        [self setTitleStrArray: [[NSMutableArray alloc] initWithCapacity:pages]];

        const unsigned int scrollWidth = self.bigScrollView.frame.size.width;
        const unsigned int scrollHeigh = self.bigScrollView.frame.size.height;
        [self.pageControl setNumberOfPages:pages]; [self.pageControl setCurrentPage:0];
        [self.bigScrollView setContentSize:CGSizeMake(scrollWidth * pages, scrollHeigh)];

        for(unsigned int ii = 0; ii < pages; ii++)
        {
            NSString* titleAndURL = [titleAndURLs objectAtIndex:ii];
            NSString* title = [[titleAndURL componentsSeparatedByString:@","] objectAtIndex:0];
            NSString* imURL = [[titleAndURL componentsSeparatedByString:@","] objectAtIndex:1];
            
//            commit by analyse
//            imURL = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,// URL Encodeing
//                                                                                 (CFStringRef)imURL, nil, nil, kCFStringEncodingUTF8);
            
//            add by analyse
            imURL = [imURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            [self.imageURLarray addObject:imURL];   [self.titleStrArray addObject:title];

            CGRect frame1 = CGRectMake(0, 12, scrollWidth, 240);
            frame1.origin.x = ii * scrollWidth;
            UIImageView* viewx = [[UIImageView alloc] initWithFrame:frame1];
            [viewx setBackgroundColor:[UIColor clearColor]];
            [viewx setImageWithURL:[NSURL URLWithString:[self.imageURLarray objectAtIndex:ii]]];

            [self.bigScrollView addSubview:viewx];
        }
    }
    else if ([[images componentsSeparatedByString:@","] count] == 2)
    {
        pages = 1;
        [self setImageURLarray: [[NSMutableArray alloc] initWithCapacity:pages]];
        [self setTitleStrArray: [[NSMutableArray alloc] initWithCapacity:pages]];

        NSString* title = [[images componentsSeparatedByString:@","] objectAtIndex:0];
        NSString* imURL = [[images componentsSeparatedByString:@","] objectAtIndex:1];
        
//        commit by analyse
//        imURL = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,// URL Encodeing
//                                                (CFStringRef)imURL, nil, nil, kCFStringEncodingUTF8);
        
//        add by analyse
        imURL = [imURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [self.imageURLarray addObject:imURL];   [self.titleStrArray addObject:title];

        const unsigned int ww = self.bigScrollView.frame.size.width;
        UIImageView* viewx = [[UIImageView alloc] initWithFrame:
                              CGRectMake(0, 0, ww, 240)];
        [viewx setBackgroundColor:[UIColor clearColor]];
        [viewx setImageWithURL:[NSURL URLWithString:imURL]];
        [self.bigScrollView addSubview:viewx];
        [self.numberLabel setText:@"< 1 / 1 >"];
    }

    [self hideIndicatorView];   [self.pageControl setHidden:YES];

    NSString* title = [self.titleStrArray objectAtIndex:0];
    if (title.length >= 12)
    {
        const unsigned int s = (title.length/2) + 1;
        [self.titleLabel setText:[title substringToIndex:s]];
        [self.titleLabel2 setText:[title substringFromIndex:(s+1)]];
    }
    else
    {
        [self.titleLabel setText:title];
        [self.titleLabel2 setText:@""];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)loadScrollViewWithPage:(int)page
{
    const unsigned int pages = self.pageControl.numberOfPages;

    if (page < 0)       {   return; }
    if (page >= pages)  {   return; }
    // replace the placeholder
}

- (IBAction)changePage:(id)sender
{
    UIScrollView* scrollView = self.bigScrollView;
    UIPageControl* pageControl = self.pageControl;
    const unsigned int page = pageControl.currentPage;

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

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    
    UIPageControl* pageControl = self.pageControl;
    UIScrollView* scrollView = self.bigScrollView;

    // We don't want a "feedback loop" between the UIPageControl and the scroll delegate in
    // which a scroll event generated from the user hitting the page control triggers updates from
    // the delegate method. We use a boolean to disable the delegate logic when the page control is used.
    if (_pageControlUsed)   {   return; }

    // Switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = scrollView.frame.size.width;
    const unsigned int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    [pageControl setCurrentPage:page]; //NSLog(@"%@", [self.imageURLarray objectAtIndex:page]);
    NSString* title = [self.titleStrArray objectAtIndex:page];
    if (title.length >= 12)
    {
        const unsigned int s = (title.length/2) + 1;
        [self.titleLabel setText:[title substringToIndex:s]];
        [self.titleLabel2 setText:[title substringFromIndex:(s+1)]];
    }
    else
    {
        [self.titleLabel setText:title];
        [self.titleLabel2 setText:@""];
    }
    [self.numberLabel setText:[NSString stringWithFormat:@"< %d / %d >", (page + 1), self.pageControl.numberOfPages]];

    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
}

// At the begin of scroll dragging, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    _pageControlUsed = NO;
}

// At the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _pageControlUsed = NO;
}

@end
