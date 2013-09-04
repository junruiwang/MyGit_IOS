//
//  OrderBookSuccessNeedPayViewController.h
//  JinJiangTravelPlus
//
//  Created by 胡 桂祁 on 12/26/12.
//  Copyright (c) 2012 JinJiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JJViewController.h"
#import "PayerVerifyParser.h"
#import "UnionPaymentForm.h"
#import "PayerVerifyResult.h"
#import "PayController.h"
#import "ConditionView.h"
#import "SupportedBankListViewController.h"
#import "DepositBankCityListViewController.h"
#import "LoadPaymentAmountParser.h"

@interface YiLianPayViewController : JJViewController<PayControllerDelegate, DepositBankCityListViewControllerDelegate, UIActionSheetDelegate, UIAlertViewDelegate>
{
    UITapGestureRecognizer* singleTap;
}
//order info view
@property (nonatomic, weak) IBOutlet UILabel *title1;
@property (nonatomic, weak) IBOutlet UIView *orderInfoView;
@property (nonatomic, weak) IBOutlet UIImageView *splitLine1;

//progress bar view
@property (nonatomic, weak) IBOutlet UIView *progressBarView;
@property (nonatomic, weak) IBOutlet UIImageView *progressBarImgView;

//input view
@property (nonatomic, weak) IBOutlet UIScrollView *inputViewForWihte;
@property (nonatomic, weak) IBOutlet UIView *inputViewBlackBgView;
@property (nonatomic,weak)  IBOutlet UITextField *mobileTextField;
@property (nonatomic,weak)  IBOutlet UITextField *cardNoTextField;
@property (nonatomic, weak) IBOutlet UIImageView *splitLine2;
@property (nonatomic, strong) UILabel *openingBankNameLabel;
@property (nonatomic, strong) UITextField *openingBankNameTextField;
@property (nonatomic, strong) UILabel *openingBankIdNoLabel;
@property (nonatomic, strong) UITextField *openingBankIdNoField;
@property (nonatomic, strong) UILabel *openingBankPhoneLabel;
@property (nonatomic, strong) UITextField *openingBankPhoneField;
@property (nonatomic, strong) UILabel *openingBankCityNameLabel;
@property (nonatomic, strong) UITextField *openingBankCityNameField;
@property (nonatomic,strong)  UIButton *confirmPayButton;
@property (nonatomic,strong) PayerVerifyParser *verifyAndPaymentParser;
@property (nonatomic,strong) LoadPaymentAmountParser *loadPaymentAmountParser;
@property (nonatomic,strong) PayerVerifyForm *payerVerifyForm;
@property (nonatomic,strong) UnionPaymentForm *paymentForm;
@property (nonatomic,strong) PayerVerifyResult *payerVerifyResult;
@property (nonatomic,strong) PayController *payController;
@property (nonatomic,weak) IBOutlet UIButton *waitDeleteButton;
@property (nonatomic,weak) IBOutlet UIView *applyPayResultView;
@property (nonatomic,weak) IBOutlet UIButton *creditCardBtn;
@property (nonatomic,weak) IBOutlet UIButton *debitCardBtn;

@property (nonatomic,weak) IBOutlet UILabel *bookAmountLabel;
@property (nonatomic,weak) IBOutlet UILabel *paymentAmountLabel;
@property (nonatomic, strong) ConditionView *conditionView;
@property (nonatomic,strong) SupportedBankListViewController *supportedBankListController;
@property (nonatomic,strong) DepositBankCityListViewController *depositBankCityListController;



- (IBAction)textFieldDoneEditing:(id)sender;
- (IBAction)backgroudTap:(id)sender;
- (IBAction)pressCardTypeButton:(id)sender;
- (IBAction)showBankListView:(id)sender;
- (void)showSideCity:(id)sender;

@end
