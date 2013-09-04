//
//  UsableCouponListViewController.m
//  JinJiangHotel
//
//  Created by jerry on 13-8-29.
//  Copyright (c) 2013年 jinjiang. All rights reserved.
//

#import "UsableCouponListViewController.h"
#import "CouponRule.h"

#define CHECK_COUPONS_BUTTON_TAG 345

@interface UsableCouponListViewController ()

- (void)showComponentViews:(CouponRuleView *) ruleView;
- (void)didButtonIsAvailable:(CouponRuleView *) ruleView;
- (void)hideComponentViews:(CouponRuleView *) ruleView;

@end

@implementation UsableCouponListViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    [self drawCouponsView];
	// Do any additional setup after loading the view.
}

- (void)drawCouponsView
{
    if (self.couponList && self.couponList.count >0) {
        int rows = self.couponList.count;
        self.couponsView.frame = CGRectMake(self.couponsView.frame.origin.x, self.couponsView.frame.origin.y, self.couponsView.frame.size.width, self.couponsView.frame.size.height * rows);
        
        for (int i=0; i<rows; i++) {
            CouponRule *couponRule = [self.couponList objectAtIndex:i];
            
            CouponRuleView *ruleView = [[CouponRuleView alloc] initWithFrame:CGRectMake(0, 45*i, 242, 45)];
            ruleView.couponRule = couponRule;
            ruleView.currentIndex = i;
            ruleView.couponAmountLabel.text = [NSString stringWithFormat:@"%d元", couponRule.couponAmount];
            ruleView.couponCountLabel.text = @"1";
            ruleView.delegate = self;
            ruleView.tag = (CHECK_COUPONS_BUTTON_TAG + i);
            [self.couponsView addSubview:ruleView];
            if (i > 0) {
                UIImageView *arrowView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 45*i, 242, 1)];
                arrowView.image = [UIImage imageNamed:@"booking_arrow_cell"];
                [self.couponsView addSubview:arrowView];
            }
            if ((self.useCoupon.couponIndex == i) && (self.useCoupon.couponAmount == couponRule.couponAmount)) {
                ruleView.couponCountLabel.text = [NSString stringWithFormat:@"%d",self.useCoupon.useCouponNum];
                [self showComponentViews:ruleView];
                [self didButtonIsAvailable:ruleView];
            }
        }
        
    } else {
        self.couponsView.hidden = YES;
    }
}

- (void)showComponentViews:(CouponRuleView *) ruleView
{
    ruleView.selectedArrow.hidden = NO;
    ruleView.subImageView.hidden = NO;
    ruleView.addImageView.hidden = NO;
    ruleView.numberImageView.hidden = NO;
    ruleView.couponCountLabel.hidden = NO;
    ruleView.subButton.hidden = NO;
    ruleView.addButton.hidden = NO;
}

- (void)hideComponentViews:(CouponRuleView *) ruleView
{
    ruleView.selectedArrow.hidden = YES;
    ruleView.subImageView.hidden = YES;
    ruleView.addImageView.hidden = YES;
    ruleView.numberImageView.hidden = YES;
    ruleView.couponCountLabel.hidden = YES;
    ruleView.subButton.hidden = YES;
    ruleView.addButton.hidden = YES;
}

- (void)didButtonIsAvailable:(CouponRuleView *) ruleView
{
    int num = [ruleView.couponCountLabel.text intValue];
    if (num == 1) {
        ruleView.subButton.enabled = NO;
    } else {
        ruleView.subButton.enabled = YES;
    }
    
    CouponRule *couponRule = ruleView.couponRule;
    if (num >= couponRule.couponMaxNum) {
        ruleView.addButton.enabled = NO;
    } else {
        ruleView.addButton.enabled = YES;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CouponRuleViewDelegate
- (void)checkButtonHandler:(CouponRuleView *) couponRuleView
{
    if (couponRuleView.selectedArrow.hidden) {
        for (int i=0; i<self.couponList.count; i++) {
            CouponRuleView *ruleView = (CouponRuleView *)[self.couponsView viewWithTag:(CHECK_COUPONS_BUTTON_TAG + i)];
            [self hideComponentViews:ruleView];
        }
        [self showComponentViews:couponRuleView];
        [self didButtonIsAvailable:couponRuleView];
        [self rebuildUseCoupon:couponRuleView];
    } else {
        [self hideComponentViews:couponRuleView];
        self.useCoupon = nil;
    }
}
- (void)subButtonHandler:(CouponRuleView *) couponRuleView
{
    NSInteger currentCount = [couponRuleView.couponCountLabel.text intValue] ;
    if (currentCount <= 1) {
        return;
    }
    currentCount--;
    couponRuleView.couponCountLabel.text = [NSString stringWithFormat:@"%d",currentCount];
    [self didButtonIsAvailable:couponRuleView];
    [self rebuildUseCoupon:couponRuleView];
}
- (void)addButtonHandler:(CouponRuleView *) couponRuleView
{
    NSInteger currentCount = [couponRuleView.couponCountLabel.text intValue] ;
    if (currentCount >= couponRuleView.couponRule.couponMaxNum) {
        return;
    }
    currentCount++;
    couponRuleView.couponCountLabel.text = [NSString stringWithFormat:@"%d",currentCount];
    [self didButtonIsAvailable:couponRuleView];
    [self rebuildUseCoupon:couponRuleView];
}

- (void)rebuildUseCoupon:(CouponRuleView *) couponRuleView
{
    UseCoupon *coupon = [[UseCoupon alloc] init];
    coupon.couponName = couponRuleView.couponRule.couponRuleName;
    coupon.couponAmount = couponRuleView.couponRule.couponAmount;
    coupon.useCouponNum = [couponRuleView.couponCountLabel.text intValue];
    coupon.couponIndex = couponRuleView.currentIndex;
    self.useCoupon = coupon;
    [self buildCodeList:couponRuleView.couponRule];
}

- (void)buildCodeList:(CouponRule *) couponRule
{
    NSString *codeList = @"";
    for (unsigned int i=0; i<self.useCoupon.useCouponNum; i++)
    {
        if ([codeList isEqualToString:@""])
        {
            codeList = [couponRule.codeList objectAtIndex:i];
            continue;
        }
        codeList =[codeList stringByAppendingFormat:@",%@",[couponRule.codeList objectAtIndex:i]];
    }
    self.useCoupon.codeList = codeList;
}

- (IBAction)selectedButtonClicked:(id)sender
{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(buildUseCoupon:)])
    {
        [self.delegate buildUseCoupon:self.useCoupon];
    }
}

@end
