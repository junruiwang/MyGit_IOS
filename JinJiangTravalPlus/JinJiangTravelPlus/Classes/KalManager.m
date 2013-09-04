//
//  KalManager.m
//  JinJiangTravelPlus
//
//  Created by Leon on 11/20/12.
//  Copyright (c) 2012 JinJiang. All rights reserved.
//

#import "KalManager.h"

@interface KalManager()

@property (nonatomic, weak) UIViewController *containerVC;


//date picker
@property (nonatomic, strong) KalViewController *kalCalendar;
@property (nonatomic, strong) UIView *datePickerView;
@property (nonatomic, strong) UINavigationBar *datePickerViewNavBar;
@property (nonatomic, strong) UINavigationItem *datePickerViewNavItem;

@end

@implementation KalManager

- (id)initWithViewController:(UIViewController *)viewController
{
    if (self = [super init]) {
        self.containerVC = viewController;
        self.datePickerView = [[UIView alloc] initWithFrame:CGRectMake(0, -350, 320, 350)];
        self.datePickerViewNavBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        self.datePickerViewNavItem = [[UINavigationItem alloc] initWithTitle:@""];
        self.datePickerViewNavBar.items = @[self.datePickerViewNavItem];
        [self.datePickerView addSubview:self.datePickerViewNavBar];
        
        [self pickerStyle];
    }
    return self;
}

- (void)pickerStyle
{
    [self.datePickerViewNavBar setBackgroundImage:[[UIImage imageNamed:@"navBarBlueBg.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:0]];
    if (self.datePickerViewNavItem.leftBarButtonItem == nil || self.datePickerViewNavItem.rightBarButtonItem == nil) {
        UIButton *btn;
        btn = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 100.0, 60.0, 30.0)];
        [btn setBackgroundImage:[UIImage imageNamed:@"blueBtn.png"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"blueBtnPressed.png"] forState:UIControlStateHighlighted];
        [btn.titleLabel setFont:[UIFont systemFontOfSize: 14]];
        [btn setTitle:@"取消" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(pickCancel) forControlEvents:UIControlEventTouchUpInside];
        self.datePickerViewNavItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
        
        btn = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 200.0, 60.0, 30.0)];
        [btn setBackgroundImage:[UIImage imageNamed:@"blueBtn.png"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"blueBtnPressed.png"] forState:UIControlStateHighlighted];
        [btn.titleLabel setFont:[UIFont systemFontOfSize: 14]];
        [btn setTitle:NSLocalizedString(@"完成", nil) forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(pickDone) forControlEvents:UIControlEventTouchUpInside];
        self.datePickerViewNavItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    }
}

#pragma mark -
#pragma mark Date picker
- (void)pickDate
{
    self.containerVC.view.userInteractionEnabled = NO;
    self.containerVC.navigationController.navigationBar.userInteractionEnabled = NO;
    
    if (self.kalCalendar == nil) {
        KalViewController *cal = nil;
        cal = [[KalViewController alloc] initWithSelectedDate:[TheAppDelegate.hotelSearchForm.checkinDate NSDate]];
        self.kalCalendar = cal;
        self.datePickerViewNavItem.title = @"选择日期";
        [self.kalCalendar setDateRangeMin:[NSDate date] Max:[[NSDate date] dateByAddingTimeInterval:kSecondsThreeMonth + kSecondsPerDay] MaxSelectDays:kMaxStayDays];
        self.kalCalendar.dataSource =  [SimpleKalDataSource dataSource];
        SimpleKalDataSource *kalDataSource = self.kalCalendar.dataSource;
        [kalDataSource showHintText:@"最多只能选择14天"];
        self.kalCalendar.calendarDelegate = self;
        self.kalCalendar.view.frame = CGRectMake(0, 44, 320, 350);
        [self.datePickerView addSubview: self.kalCalendar.view];
    }
    [self.kalCalendar setCheckInDate:[TheAppDelegate.hotelSearchForm.checkinDate NSDate] CheckOutDate:[TheAppDelegate.hotelSearchForm.checkoutDate NSDate]];
    [self.containerVC.view.window addSubview: self.datePickerView];
    
    CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
    CGSize pickerSize = CGSizeMake(320, 390);
    const int y0 = screenRect.origin.y + screenRect.size.height;
    const unsigned int w0 = pickerSize.width;
    const unsigned int h0 = pickerSize.height;
    self.datePickerView.frame = CGRectMake(0, y0, w0, h0);
    // start the slide up animation
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    
    // we need to perform some post operations after the animation is complete
    [UIView setAnimationDelegate:self];
    const int y1 = screenRect.origin.y + screenRect.size.height - pickerSize.height;
    const unsigned int w1 = pickerSize.width;
    const unsigned int h1 = pickerSize.height;
    self.datePickerView.frame = CGRectMake(0, y1, w1, h1);
    [UIView commitAnimations];
}

- (void)pickDone
{
    [self hideDatePickerView];
    NSDate *minDate = nil;
    NSDate *maxDate = nil;
    [self.kalCalendar getDateRangeMin:&minDate Max:&maxDate];
    if (minDate == nil || maxDate == nil) return;
    
    if ([self.delegate respondsToSelector:@selector(manager:didSelectMinDate:maxDate:)]) {
        if (self.nightNums > 0) {
            TheAppDelegate.hotelSearchForm.nightNums = self.nightNums;
        }
        [self.delegate manager:self didSelectMinDate:minDate maxDate:maxDate];
    }
}

- (void)pickCancel
{
    [self hideDatePickerView];
}

- (void)hideDatePickerView {
    // compute the start frame
    CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
    CGSize pickerSize = [self.datePickerView sizeThatFits:CGSizeZero];
    self.datePickerView.frame = CGRectMake(0, screenRect.origin.y + screenRect.size.height - pickerSize.height, pickerSize.width, pickerSize.height);
    
    //start the slide down animation
    [UIView animateWithDuration:0.3 animations:^{
        self.datePickerView.frame = CGRectMake(0, screenRect.origin.y + screenRect.size.height, pickerSize.width, pickerSize.height);
    } completion:^(BOOL finished) {
        self.kalCalendar = nil;
        [self.datePickerView removeFromSuperview];
        self.containerVC.view.userInteractionEnabled = YES;
        self.containerVC.navigationController.navigationBar.userInteractionEnabled = YES;
    }];
}

#pragma mark -
#pragma mark KalCalendar delegate
- (void)didSelectDate:(NSDate *)date {
    
    NSDate *minDate = nil;
    NSDate *maxDate = nil;
    [self.kalCalendar getDateRangeMin:&minDate Max:&maxDate];
    if (minDate != nil && maxDate != nil) {
        self.nightNums = ([maxDate timeIntervalSinceDate: minDate] + 1) / kSecondsPerDay;
        self.datePickerViewNavItem.title = [NSString stringWithFormat:@"入住%d晚", self.nightNums];
    } else {
        self.datePickerViewNavItem.title = @"划动选择日期";
    }
}

@end
