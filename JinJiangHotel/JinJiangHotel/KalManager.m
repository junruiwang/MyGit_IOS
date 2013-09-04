//
//  KalManager.m
//  JinJiangTravelPlus
//
//  Created by Leon on 11/20/12.
//  Copyright (c) 2012 JinJiang. All rights reserved.
//

#import "KalManager.h"
#import "JJNavigationBar.h"

@interface KalManager()

@property (nonatomic, weak) UIViewController *containerVC;


//date picker
@property (nonatomic, strong) KalViewController *kalCalendar;
@property (nonatomic, strong) UIView *datePickerView;
@property (nonatomic, strong) JJNavigationBar *navigationBar;
//@property (nonatomic, strong) UINavigationBar *datePickerViewNavBar;
//@property (nonatomic, strong) UINavigationItem *datePickerViewNavItem;

@end

@implementation KalManager

- (id)initWithViewController:(UIViewController *)viewController
{
    if (self = [super init]) {
        self.containerVC = viewController;
        self.datePickerView = [[UIView alloc] initWithFrame:CGRectMake(-320, 0, 320, self.containerVC.view.frame.size.height)];
        self.navigationBar = [[JJNavigationBar alloc] initNavigationBarWithStyle:JJDefaultBarStyle];
        
        [self.datePickerView addSubview:self.navigationBar];
        
        [self pickerStyle];
    }
    return self;
}

- (void)pickerStyle
{
    self.navigationBar.mainLabel.text = NSLocalizedStringFromTable(@"pick date", @"SearchHotel", @"");
    [self.navigationBar addRightBarButton:@"submit.png"];
    self.navigationBar.rightButton.frame = CGRectMake(193, 13, 60, 24);
    [self.navigationBar.backButton addTarget:self action:@selector(pickCancel) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationBar.rightButton addTarget:self action:@selector(pickDone) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationBar.rightButton setTitle:NSLocalizedString(@"Done", @"") forState:UIControlStateNormal];
    self.navigationBar.rightButton.titleLabel.font = [UIFont systemFontOfSize:12.0];
}

#pragma mark -
#pragma mark Date picker
- (void)pickDate
{
    self.containerVC.view.userInteractionEnabled = YES;
    self.containerVC.navigationController.navigationBar.userInteractionEnabled = NO;
    
    if (self.kalCalendar == nil) {
        KalViewController *cal = nil;
        cal = [[KalViewController alloc] initWithSelectedDate:[TheAppDelegate.hotelSearchForm.checkinDate NSDate]];
        self.kalCalendar = cal;
        [self.kalCalendar setDateRangeMin:[NSDate date] Max:[[NSDate date] dateByAddingTimeInterval:kSecondsThreeMonth + kSecondsPerDay] MaxSelectDays:kMaxStayDays];
        self.kalCalendar.dataSource =  [SimpleKalDataSource dataSource];
//        SimpleKalDataSource *kalDataSource = self.kalCalendar.dataSource;
//        [kalDataSource showHintText:NSLocalizedStringFromTable(@"not more than 14 days", @"SearchHotel", @"")];
        self.kalCalendar.calendarDelegate = self;
        self.kalCalendar.view.frame = CGRectMake(0, 50, 320, self.containerVC.view.frame.size.height - 50);
        [self.datePickerView addSubview: self.kalCalendar.view];
    }
    [self.kalCalendar setCheckInDate:[TheAppDelegate.hotelSearchForm.checkinDate NSDate] CheckOutDate:[TheAppDelegate.hotelSearchForm.checkoutDate NSDate]];
    
    UILabel *hintLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.containerVC.view.frame.size.height - 20, 320, 20)];
    hintLabel.backgroundColor = RGBCOLOR(54, 54, 54);
    hintLabel.text = NSLocalizedStringFromTable(@"not more than 14 days", @"SearchHotel", @"");
    hintLabel.font = [UIFont boldSystemFontOfSize:12];
    hintLabel.textAlignment = NSTextAlignmentCenter;
    hintLabel.textColor = [UIColor whiteColor];
    
    [self.datePickerView addSubview: hintLabel];
    [self.containerVC.view addSubview: self.datePickerView];
    
    self.datePickerView.frame = CGRectMake(-320, 0, 320, self.containerVC.view.frame.size.height);
    // start the slide up animation
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    
    // we need to perform some post operations after the animation is complete
    [UIView setAnimationDelegate:self];
    self.datePickerView.frame = CGRectMake(0, 0, 320, self.containerVC.view.frame.size.height);
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
    
    //start the slide down animation
    [UIView animateWithDuration:0.3 animations:^{
        self.datePickerView.frame = CGRectMake(-320, 0, 320, self.containerVC.view.frame.size.height);
    } completion:^(BOOL finished) {
        self.kalCalendar = nil;
        [self.datePickerView removeFromSuperview];
        self.containerVC.view.userInteractionEnabled = YES;
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
        self.navigationBar.mainLabel.text = [NSString stringWithFormat:@"%@%d%@",
                                    NSLocalizedStringFromTable(@"live", @"SearchHotel", @""),
                                    self.nightNums,
                                    NSLocalizedStringFromTable(@"night", @"SearchHotel", @"")];
    } else {
        self.navigationBar.mainLabel.text = NSLocalizedString(@"slide to select", @"");
    }
}

@end
