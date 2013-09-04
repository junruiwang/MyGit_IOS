//
//  SlideViewController.m
//  IPAD
//
//  Created by he yongzheng on 11-9-27.
//  Copyright 2011年 JinJiang. All rights reserved.
//

#import "SlideViewController.h"

const CGFloat kScreenHeight	= 460;
const CGFloat kScreenWidth	= 320;
const CGFloat kScrollSpaceWidth	= 50;

@interface SlideViewController ()

- (void)freeOutlets;
- (void)addImagesToView;

@end

@implementation SlideViewController

@synthesize scrollView;
@synthesize imageArray;
@synthesize nextPageBtn;
@synthesize delegate;
@synthesize previousPageBtn;
@synthesize pageController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        self.imageArray = [NSMutableArray arrayWithCapacity:1];
    }
    return self;
}

- (void)freeOutlets
{
    self.scrollView = nil;
    self.pageController = nil;
    self.previousPageBtn = nil;
    self.nextPageBtn = nil;
}

- (void)dealloc
{
    [self freeOutlets];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];

    // Release any cached data, images, etc that aren't in use.
}

- (IBAction)closeView:(id)sender
{
    if (self.delegate != nil && [delegate respondsToSelector:@selector(closeTipsView)])
    {   [delegate closeTipsView];   }
}

- (IBAction)nextPage:(id)sender
{
    [scrollView setContentOffset:CGPointMake((pageController.currentPage + 1) * kScreenWidth, 0) animated:YES];
}

- (IBAction)previousPage:(id)sender
{
    [scrollView setContentOffset:CGPointMake((pageController.currentPage - 1) * kScreenWidth, 0) animated:YES];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.view setBackgroundColor:[UIColor viewFlipsideBackgroundColor]];
	// 1. setup the scrollview for multiple images and add it to the view controller
	//
	// note: the following can be done in Interface Builder, but we show this in code for clarity
	[scrollView setBackgroundColor:[UIColor blackColor]];
	[scrollView setCanCancelContentTouches:NO];
	scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
	scrollView.clipsToBounds = YES;		// default is NO, we want to restrict drawing within our scrollview
	scrollView.scrollEnabled = YES;
    [previousPageBtn setHidden:YES];
    if (self.imageArray.count > 0)
    {   [self addImagesToView]; }
    [self.view bringSubviewToFront:previousPageBtn];
    [self.view bringSubviewToFront:nextPageBtn];
}

- (void)ShowImages:(NSArray *)imageNames
{
    if (imageNames == nil)
    {   return; }

    if (self.imageArray.count > 0)
    {   [self.scrollView scrollRectToVisible:CGRectMake(0, 0, kScreenWidth, kScreenHeight) animated:NO];    }
    else
    {
        [self.imageArray addObjectsFromArray:imageNames];
        [self addImagesToView];
    }
}

- (void)addImagesToView
{
    if (imageArray == nil || imageArray.count == 0)
    {   return; }

    CGFloat curXLoc = 0;
    for (unsigned int i = 0; i < imageArray.count; i++)
    {
        UIImage *image = [UIImage imageNamed:[imageArray objectAtIndex:i]];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];

        CGRect rect;
        rect.origin = CGPointMake(curXLoc, 0);
        curXLoc += kScreenWidth;
        rect.size.height = kScreenHeight;
        rect.size.width = kScreenWidth;
        imageView.frame = rect;
        imageView.tag = i + 1;
        [scrollView addSubview:imageView];
    }
	[scrollView setContentSize:CGSizeMake((imageArray.count * kScreenWidth), [scrollView bounds].size.height)];
    pageController.numberOfPages = imageArray.count;    

    // fade in the first image
    [scrollView viewWithTag:1].alpha = 0;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.6];
    [scrollView viewWithTag:1].alpha = 1.0;
    [UIView commitAnimations];
}

- (void)viewDidUnload
{
    [self freeOutlets];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scroll
{
    if (scroll.contentOffset.x < 0)
    {   return; }
    // this method will be called many times while scrolling, if is about to close view, ignore other calling.
    if (isPageClosing == NO
        && pageController.currentPage == (imageArray.count - 1)
        && scroll.contentOffset.x > (imageArray.count - 1) * kScreenWidth + kScrollSpaceWidth)
    {
        isPageClosing = YES;
        [self closeView:scroll];
    }
    else
    {
        const unsigned int page = floor(scroll.contentOffset.x / scrollView.frame.size.width);
        [pageController setCurrentPage:page];
        if (page == 0)
        {   [previousPageBtn setHidden:YES];    }
        else 
        {   [previousPageBtn setHidden:NO];     }
    }
}

@end
