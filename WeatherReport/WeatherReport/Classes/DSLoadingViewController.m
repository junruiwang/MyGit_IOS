//
//  IndexViewController.h
//  WeatherReport
//
//  Created by jerry on 13-4-24.
//  Copyright (c) 2013年 jerry. All rights reserved.
//

#import "DSLoadingViewController.h"
#import "AppDelegate.h"

@implementation DSLoadingViewController

#pragma mark - View lifecycle methods

- (void)loadView
{
    [super loadView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    bgImageView.backgroundColor = [UIColor clearColor];
    bgImageView.image = [UIImage imageNamed:@"loading.png"];
    [self.view addSubview:bgImageView];
    
    _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(150, 400, 20, 20)];
    _activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    _activityIndicatorView.hidesWhenStopped = YES;
    [_activityIndicatorView startAnimating];
    [self.view addSubview:_activityIndicatorView];
    
    [self performSelector:@selector(loadingDone) withObject:nil afterDelay:1];    // 假设加载3秒中
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)loadingDone
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [(AppDelegate *)[UIApplication sharedApplication].delegate loadMainView];
    [_activityIndicatorView stopAnimating];
}

@end
