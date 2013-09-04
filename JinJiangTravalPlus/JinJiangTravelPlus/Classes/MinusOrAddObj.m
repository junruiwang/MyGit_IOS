//
//  MinusOrAddButton.m
//  JinJiangTravelPlus
//
//  Created by huguiqi on 13-1-10.
//  Copyright (c) 2013年 JinJiang. All rights reserved.
//

#import "MinusOrAddObj.h"

@implementation MinusOrAddObj

-(id)init
{
    self = [super init];
    UILabel* useSizeTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(195, 15, 15, 15)];
    [useSizeTextLabel setFont:[UIFont systemFontOfSize:15]];
    [useSizeTextLabel setTextColor:[UIColor grayColor]];
    _couponSizeLabel = useSizeTextLabel;

    _minusButton = [[MinusOrAddButton alloc] initWithFrame:CGRectMake(160, 5, 30, 30)];
    [_minusButton setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"minus-press.png"]]];
    [_minusButton setCouponSizeLabel:_couponSizeLabel];
    [_minusButton setHidden:YES];

    _addButton = [[MinusOrAddButton alloc] initWithFrame:CGRectMake(210, 5, 30, 30)];
    [_addButton setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"add-disabled.png"]]];
    [_addButton setCouponSizeLabel:_couponSizeLabel];
    [_addButton setHidden:YES];

    return self;
}

- (void)showMinusOrAddObj
{
    [self.minusButton   setHidden:NO];
    [self.addButton     setHidden:NO];
    [self.couponSizeLabel setTextColor:[UIColor blackColor]];
}

- (void)hiddenMinusOrAddObj
{
    [self.minusButton   setHidden:YES];
    [self.addButton     setHidden:YES];
    [self.couponSizeLabel setTextColor:[UIColor grayColor]];
}

-(void)makeMinusOrAddBtnDark
{
    if([self.couponSizeLabel.text intValue] == 1)
    {
        UIColor* color = [UIColor colorWithPatternImage:[UIImage imageNamed:@"minus-disabled.png"]];
        [self.minusButton setBackgroundColor:color];
    }
}

-(void)disabledMinusBtn
{
    self.minusButton.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"minus-disabled.png"]];
    if(self.minusButton.tag !=1){
        self.addButton.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"add-press.png"]];
    }
}

-(void)enableAddButton
{
    self.addButton.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"add-press.png"]];
}

-(void)disabledAddBtn
{
    self.addButton.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"add-disabled.png"]];
    if (self.addButton.tag !=1) {
        self.minusButton.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"minus-press.png"]];
    }
}

@end
