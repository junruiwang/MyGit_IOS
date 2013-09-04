//
//  LoadingIndicator.m
//  
//
//  Created by Lipeng on 11-4-21.
//  Copyright 2011年 JinJiang. All rights reserved.
//

#import "LoadingIndicatorViewController.h"

static const NSInteger kChangeTextInterval = 3; // in seconds

@implementation LoadingIndicatorViewController

@synthesize textArray;
@synthesize loadingIndicatorText;
@synthesize activityIndicator;
@synthesize backView;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self = [super initWithCoder:aDecoder])
    {
        // Custom initialization
        isUpdateText = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
    self.coverBackView.frame = CGRectMake(0, 20, screenRect.size.width, screenRect.size.height + 20);

    CGRect frame = backView.frame;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:2];
    [UIView setAnimationRepeatCount:HUGE_VALF];
    backView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 0);
    [UIView commitAnimations];
    [activityIndicator startAnimating];
    if (self.textArray != nil)
    {   loadingIndicatorText.text = [self.textArray objectAtIndex:0];   }
}

- (void)showText:(NSString *)text
{
    loadingIndicatorText.text = text;
    //NSLog(@"%s %@", __FUNCTION__, text);

    if (isUpdateText == YES)
    {
        currentTextIndex++;
        if (currentTextIndex == [self.textArray count])
        {   currentTextIndex = 0;   }
        [self performSelector:@selector(showText:)
                   withObject:[self.textArray objectAtIndex:currentTextIndex]
                   afterDelay:kChangeTextInterval];
    }
}

// this method may be called before viewDidLoad, loadingIndicatorText is not connected to XIB.
- (void)showTextArray:(NSArray *)texts
{
    self.textArray = nil;
    self.textArray = [NSArray arrayWithArray:texts];
    if (loadingIndicatorText != nil)
    {   loadingIndicatorText.text = [self.textArray objectAtIndex:0];   }
}

- (void)startAnimating
{
    [activityIndicator startAnimating];
    if ([self.textArray count] > 1)
    {
        isUpdateText = YES;
        currentTextIndex = 1;
        [self performSelector:@selector(showText:)
                   withObject:[self.textArray objectAtIndex:currentTextIndex]
                   afterDelay:kChangeTextInterval];
    }
}

- (void)stopAnimating
{
    [activityIndicator stopAnimating];
    if (isUpdateText == YES)
    {
        [NSObject cancelPreviousPerformRequestsWithTarget:self
                                                 selector:@selector(showText:)
                                                   object:[self.textArray objectAtIndex:currentTextIndex]];
        isUpdateText = NO;
    }
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];

    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidUnload
{
    self.loadingIndicatorText = nil;
    self.activityIndicator = nil;
    self.backView = nil;
    [super viewDidUnload];
}

- (void)dealloc
{
    //NSLog(@"%s", __FUNCTION__);
    loadingIndicatorText = nil;
    activityIndicator = nil;
    backView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
    {
        if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight)
        {   return YES; }
        else
        {   return NO;  }
    }
    else
    {
        return (interfaceOrientation == UIInterfaceOrientationPortrait);
    }
}

@end
