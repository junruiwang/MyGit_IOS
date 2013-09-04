//
//  HotelBookingViewController.h
//  JinJiangHotel
//
//  Created by jerry on 13-8-21.
//  Copyright (c) 2013年 jinjiang. All rights reserved.
//
#import <AddressBookUI/AddressBookUI.h>
#import <AddressBook/AddressBook.h>
#import "JJViewController.h"
#import "HotelBookForm.h"
#import "HotelPriceConfirmForm.h"
#import "KalManager.h"
#import "DayPriceDetailViewController.h"
#import "PayTypeListViewController.h"
#import "UsableCouponListViewController.h"

@interface HotelBookingViewController : JJViewController <UIScrollViewDelegate, KalManagerDelegate, DayPriceDetailViewControllerDelegate, PayTypeListDelegate, SelectUsableCouponDelegate, ABPeoplePickerNavigationControllerDelegate>

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;

@property (nonatomic, weak) IBOutlet UIImageView *faceHotelImage;
@property (nonatomic, weak) IBOutlet UILabel *roomCountLabel;
@property (nonatomic, weak) IBOutlet UIButton *roomCountSubBtn;
@property (nonatomic, weak) IBOutlet UIButton *roomCountAddBtn;

@property (nonatomic, weak) IBOutlet UILabel *checkInDateLabel;
@property (nonatomic, weak) IBOutlet UILabel *checkOutDateLabel;
@property (nonatomic, weak) IBOutlet UILabel *checkInWeekDayLabel;
@property (nonatomic, weak) IBOutlet UILabel *checkOutWeekDayLabel;

@property (nonatomic, weak) IBOutlet UILabel *totalAmountLabel;
@property (nonatomic, weak) IBOutlet UILabel *payAmountLabel;

@property (nonatomic, weak) IBOutlet UIButton *totalPriceContainerView;

@property (nonatomic, weak) IBOutlet UITextField *checkPersonNameOne;
@property (nonatomic, weak) IBOutlet UITextField *checkPersonNameTwo;
@property (nonatomic, weak) IBOutlet UITextField *checkPersonNameThree;

@property (nonatomic, weak) IBOutlet UITextField *contactPersonName;
@property (nonatomic, weak) IBOutlet UITextField *contactPersonPhone;
@property (nonatomic, weak) IBOutlet UILabel *couponInfoLabel;
@property (nonatomic, weak) IBOutlet UILabel *payTypeLabel;

@property (nonatomic, weak) IBOutlet UILabel *payTypeDescLable;
@property (nonatomic, weak) IBOutlet UILabel *cancelPolicyDescLabel;

@property (nonatomic, weak) IBOutlet UIView *personInfoView;
@property (nonatomic, weak) IBOutlet UIView *bottomView;

@property (nonatomic, weak) IBOutlet UIImageView *couponImageView;
@property (nonatomic, weak) IBOutlet UIView *couponView;
@property (nonatomic, weak) IBOutlet UIView *payTypeView;
@property (nonatomic, weak) IBOutlet UIView *policyView;

@property (nonatomic, weak) IBOutlet UIButton *bookBtn;

@property (nonatomic, strong) HotelBookForm *hotelBookForm;
@property (nonatomic, strong) HotelPriceConfirmForm *orderPriceConfirmForm;

@property(nonatomic, strong) KalManager *kalManager;

- (IBAction)roomCountSubBtnClicked:(id)sender;
- (IBAction)roomCountAddBtnClicked:(id)sender;

- (IBAction)datePickerClicked:(id)sender;

- (IBAction)keyboardNextPress:(UITextField *)textField;
- (IBAction)keyboardEditingDidBegin:(UITextField *)textField;

- (IBAction)couponButtonClicked:(id)sender;

- (IBAction)selectedCouponClicked:(id)sender;

- (IBAction)payTypeButtonClicked:(id)sender;

- (IBAction)bookingHotelClicked:(id)sender;

- (IBAction)addContact:(UIButton *)sender;

@end
