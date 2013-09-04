//
//  FillMemberCardInfoViewController.h
//  JinJiangTravelPlus
//
//  Created by Raphael.rong on 13-5-22.
//  Copyright (c) 2013年 JinJiang. All rights reserved.
//

#import "JJViewController.h"
#import "BuyCardForm.h"

@interface FillMemberCardInfoViewController : JJViewController <UIPickerViewDataSource, UIPickerViewDelegate, UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UITextField *userNameFiled;
@property (weak, nonatomic) IBOutlet UITextField *idNumberField;
@property (weak, nonatomic) IBOutlet UITextField *postCodeLabel;
@property (weak, nonatomic) IBOutlet UITextField *addressField;
@property (weak, nonatomic) IBOutlet UIButton *idTypeButton;
@property (weak, nonatomic) IBOutlet UIButton *locationCodeButton;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *truePriceLabel;

@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *certiTypeLabel;
@property (nonatomic, strong) BuyCardForm *buyCardForm;
@property (nonatomic, strong) NSString *price;
@end
