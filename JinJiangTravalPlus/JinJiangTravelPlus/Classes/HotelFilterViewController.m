//
//  HotelFilterViewController.m
//  JinJiangTravelPlus
//
//  Created by 胡 桂祁 on 11/24/12.
//  Copyright (c) 2012 JinJiang. All rights reserved.
//

#import "HotelFilterViewController.h"
#import "ConditionTableDelegate.h"

@interface HotelFilterViewController ()

@end

@implementation HotelFilterViewController

- (void)initNavigateTableDelegate
{
    self.navigateTableDelegate = [[NavigateTableDelegate alloc] init];
    self.navigateTable.delegate = self.navigateTableDelegate;
    self.navigateTable.dataSource = self.navigateTableDelegate;
    self.navigateTableDelegate.handleSelectedNavigationDelegate = self;
}

- (void)initConditionTableDelegate
{
    self.conditionTableDelegate = [[ConditionTableDelegate alloc] init];
    self.conditionTableDelegate.conditionTableCellDelegate = self;
    self.conditionTableDelegate.areaListHandle = [[AreaListHandle alloc] init];
    self.conditionTableDelegate.areaListHandle.areaListHandleDelegate = self.conditionTableDelegate;
    [self.conditionTableDelegate.areaListHandle buildAreas];
    [self.conditionTable setDelegate:   self.conditionTableDelegate];
    [self.conditionTable setDataSource: self.conditionTableDelegate];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self initNavigateTableDelegate];
    [self initConditionTableDelegate];

    self.view.backgroundColor = [UIColor clearColor];
    [self.conditionTableView    setBackgroundColor:[UIColor clearColor]];
    [self.navigateTableView     setBackgroundColor:[UIColor clearColor]];
    [self.navigateTable     setSeparatorColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"dashed.png"]]];
    [self.conditionTable    setSeparatorColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"dashed.png"]]];
}

-(void)viewWillAppear:(BOOL)animated
{
    self.trackedViewName = @"酒店过滤条件页面";
    [super viewWillAppear:animated];
}

#pragma mark - NavigateTableDelegate --HandleSelectedNavigationDelegate --selectedNavigation
- (void)selectedNavigation :(HotelFilterNavigation *)hotelFilterNavigation
{
    [self showConditionView:hotelFilterNavigation.name];
    
    [[GAI sharedInstance].defaultTracker sendEventWithCategory:hotelFilterNavigation.name
                                                    withAction:hotelFilterNavigation.name
                                                     withLabel:hotelFilterNavigation.name
                                                     withValue:nil];
    [UMAnalyticManager eventCount:hotelFilterNavigation.name label:hotelFilterNavigation.name];
    
    [self.conditionTableDelegate setHotelFilterNavigation:hotelFilterNavigation];
    [self.conditionTable reloadData];
}

#pragma mark - ConditionTableDelegate --ConditionTableCellDelegate -selectedConditionValue

- (void)selectedConditionValue :(NSString *)str
{
//  NSLog(@"this is select conditionValue is %@", str);
    [self hideConditionView];
    [self.hotelFilterViewDelegate closeHotelFilterView];
    [self.navigateTable reloadData];
}

- (void)showConditionView :(NSString *)title
{
    [self.conditionView addContentView:self.conditionTableView];
    self.conditionView.title = title;
    CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.conditionView.frame = CGRectMake(50, 20.0, 285.0, screenRect.size.height + 20);
    }                completion:^(BOOL finished) {
        self.conditionView.hidden = NO;
    }];
}

- (void)hideConditionView
{
    CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.conditionView.frame = CGRectMake(320.0, 20.0, 285.0, screenRect.size.height + 20);
    }                completion:^(BOOL finished) {
        self.view.userInteractionEnabled = YES;
        self.navigationController.navigationBar.userInteractionEnabled = YES;
    }];
}

- (ConditionView *)conditionView
{
    if (!_conditionView)
    {
        CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
        _conditionView = [[ConditionView alloc] initWithFrame:CGRectMake(320, 20, 285.0, screenRect.size.height + 20)];
        [self.view.window addSubview:_conditionView];
        UISwipeGestureRecognizer *tapGR = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(hideConditionView)];
        tapGR.direction = UISwipeGestureRecognizerDirectionRight;
        [_conditionView addGestureRecognizer:tapGR];
    }
    return _conditionView;
}

#ifdef _FOR_DEBUG_

-(BOOL) respondsToSelector:(SEL)aSelector
{
    printf("SELECTOR: %s\n", [NSStringFromSelector(aSelector) UTF8String]);
    return [super respondsToSelector:aSelector];
}

#endif

@end
