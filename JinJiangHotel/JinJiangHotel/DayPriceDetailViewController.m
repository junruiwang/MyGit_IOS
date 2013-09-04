//
//  DayPriceDetailViewController.m
//  JinJiangTravelPlus
//
//  Created by 杨 栋栋 on 13-1-12.
//  Copyright (c) 2013年 JinJiang. All rights reserved.
//
//载入CoreGraphics.framework框架
#import "DayPriceDetailViewController.h"
#import "PayType.h"
#import "Constants.h"
#import "NSString+Categories.h"

@interface DayPriceDetailViewController ()

@end

@implementation DayPriceDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    
    [self initPageElementStyle];
    
    [self handleTotalPrice];
    
    [self handlePaymentPrice];
}

- (void)initPageElementStyle
{    
    if ([self getAddtionalChargel] == 0) {
        self.addtionalChargeLabel.text = [NSString stringWithFormat:@"￥0"];
    } else {
        self.addtionalChargeLabel.text = [NSString stringWithFormat:@"￥%d", [self getAddtionalChargel]];
    }
    
    [[self.view layer] setShadowOffset:CGSizeMake(2, 2)];
    [[self.view layer] setShadowRadius:6];
    [[self.view layer] setShadowOpacity:1];
    [[self.view layer] setShadowColor:[UIColor grayColor].CGColor];
    
    if (self.couponAmount.integerValue <= 0) {
        self.couponLabel.text =  @"-￥0";
    } else {
        self.couponLabel.text = [NSString stringWithFormat:@"-￥%@",self.couponAmount];
    }
}

- (void)handleTotalPrice
{
    if (self.couponAmount.integerValue > 0) {
        NSUInteger totalPrice =  self.orderPriceConfirm.totalPrice.integerValue - self.couponAmount.integerValue;
        self.totalPriceLabel.text = [NSString stringWithFormat:@"￥%d", totalPrice];
    } else {
        self.totalPriceLabel.text = [NSString stringWithFormat:@"￥%@", self.orderPriceConfirm.totalPrice];
    }
    
    if (self.totalPriceLabel.text.length >=5 ) {
        self.totalPriceLabel.font = [UIFont systemFontOfSize:20.0];
    }
}

- (void)handlePaymentPrice
{
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    self.payType = [self.payType stringByTrimmingCharactersInSet:whitespace];
    
    if (self.payType == nil || [self.payType isEqualToString:@""] || [self.payType isEqualToString:@"PAYMENTING"]) {
        self.paymentPriceLabel.text = [NSString stringWithFormat:@"￥%d", 0];
    } else if ([self.payType isEqualToString:@"GUARANTEE"]) {
        NSUInteger paymentPrice = 0;
        if (self.couponAmount.integerValue > 0) {
            paymentPrice = [self getGuaranteeAmount] - self.couponAmount.integerValue;
            self.paymentPriceLabel.text = [NSString stringWithFormat:@"￥%d", paymentPrice];
        } else {
            self.paymentPriceLabel.text = [NSString stringWithFormat:@"￥%d", [self getGuaranteeAmount]];
        }
        
    } else if ([self.payType isEqualToString:@"PREPAYMENT"]) {
        NSUInteger paymentPrice = 0;
        if (self.couponAmount.integerValue > 0) {
            paymentPrice = [self getPrepaymentAmount] - self.couponAmount.integerValue;
            self.paymentPriceLabel.text = [NSString stringWithFormat:@"￥%d", paymentPrice];
        } else {
            self.paymentPriceLabel.text = [NSString stringWithFormat:@"￥%d", [self getPrepaymentAmount]];
        }
    }
    
    if ([self.paymentPriceLabel.text isEqualToString:@"￥0"]) {
        self.paymentPriceLabel.text = @"￥0";
    }
}

- (const unsigned int) getAddtionalChargel
{
    unsigned int addtionalChargelDayPrice = 0;
    
    for (unsigned int i = 0; i < self.orderPriceConfirm.payTypeList.count; i ++ )
    {
        PayType *payType = self.orderPriceConfirm.payTypeList[i];
        if ([payType.name isEqualToString:self.payType])
        {
            addtionalChargelDayPrice = payType.totalChargePrice.integerValue;
            return addtionalChargelDayPrice;
        }
    }
    return addtionalChargelDayPrice;
}


- (const unsigned int) getGuaranteeAmount
{
    unsigned int guaranteeAmount = 0;
    
    for (unsigned int i = 0; i < self.orderPriceConfirm.payTypeList.count; i ++ )
    {
        PayType *payType = self.orderPriceConfirm.payTypeList[i];
        
        if ([payType.name isEqualToString:@"GUARANTEE"])
        {
            guaranteeAmount = payType.amount.integerValue;
            return guaranteeAmount;
        }
    }
    return guaranteeAmount;
}

- (const unsigned int) getPrepaymentAmount
{
    unsigned int prepaymentAmount = 0;
    
    for (unsigned int i = 0; i < self.orderPriceConfirm.payTypeList.count; i ++ )
    {
        PayType *payType = self.orderPriceConfirm.payTypeList[i];
        
        if ([payType.name isEqualToString:@"PREPAYMENT"])
        {
            prepaymentAmount = payType.amount.integerValue;
            return prepaymentAmount;
        }
    }
    return prepaymentAmount;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.orderPriceConfirm.dayPriceDetailList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.orderPriceConfirm.dayPriceDetailList count] == 0)
    {
        return nil;
    }
    
    const unsigned int row = [indexPath row];
    DayPriceDetail* dayPriceDetail = [self.orderPriceConfirm.dayPriceDetailList objectAtIndex:row];
    static NSString* CellIdentifier = @"CityCell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    UIView *backgrdView = [[UIView alloc] initWithFrame:cell.frame];
    
    int _rowIndex = row;
    _rowIndex++;
    if (_rowIndex++ % 2 == 0) {
        backgrdView.backgroundColor = RGBCOLOR(255, 247, 221);
    }
    cell.backgroundView = backgrdView;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
    cell.textLabel.textColor = RGBCOLOR(160.0f, 140.0f, 25.0f);
    cell.textLabel.text = dayPriceDetail.date;
    cell.textLabel.text = [NSString stringWithFormat:@" %@", dayPriceDetail.date];
    
    cell.detailTextLabel.backgroundColor = [UIColor clearColor];
    cell.detailTextLabel.font = [UIFont fontWithName:@"Georgia" size:15];
    cell.detailTextLabel.textColor = RGBCOLOR(67.0f, 67.0f, 67.0f);
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"  ￥%d  ", dayPriceDetail.roomPrice.integerValue * self.roomCount];
    
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction) closeDayPriceDetailView
{
    [self.delegate closeDayPriceDetailView];
}
@end
