//
//  PayTypeListViewController.m
//  JinJiangHotel
//
//  Created by jerry on 13-8-27.
//  Copyright (c) 2013年 jinjiang. All rights reserved.
//

#import "PayTypeListViewController.h"
#import "PayTypeButton.h"

#define CHECK_PAYTYPE_BUTTON_TAG 555

@interface PayTypeListViewController ()

@end

@implementation PayTypeListViewController

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
    [self drawPayTypeView];
	// Do any additional setup after loading the view.
}

- (void)drawPayTypeView
{
    if (self.payTypeList && self.payTypeList.count >0) {
        int rows = self.payTypeList.count;
        self.payTypeView.frame = CGRectMake(self.payTypeView.frame.origin.x, self.payTypeView.frame.origin.y, self.payTypeView.frame.size.width, self.payTypeView.frame.size.height * rows);
        
        for (int i=0; i<rows; i++) {
            PayType *payType = [self.payTypeList objectAtIndex:i];
            PayTypeButton *payTypeButton = [PayTypeButton buttonWithType:UIButtonTypeCustom];
            payTypeButton.tag = (CHECK_PAYTYPE_BUTTON_TAG + i);
            [payTypeButton addTarget:self action:@selector(selectedRowClicked:) forControlEvents:UIControlEventTouchUpInside];
            payTypeButton.frame = CGRectMake(0, 45*i, 242, 45);
            payTypeButton.payType = payType;
            payTypeButton.mainTitleLabel.text = payType.label;
            payTypeButton.subTitleLabel.text = payType.description;
            [self.payTypeView addSubview:payTypeButton];
            if (i > 0) {
                UIImageView *arrowView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 45*i, 242, 1)];
                arrowView.image = [UIImage imageNamed:@"booking_arrow_cell"];
                [self.payTypeView addSubview:arrowView];
            }
            
            if ([self.selectedPayType.name isEqualToString:payType.name]) {
                payTypeButton.selectedArrow.hidden = NO;
            }
        }
        
    } else {
        self.payTypeView.hidden = YES;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)selectedButtonClicked:(id)sender
{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(selectedPayType:)])
    {
        [self.delegate selectedPayType:self.selectedPayType];
    }
}

- (void)selectedRowClicked:(id)sender
{
    for (int i=0; i<self.payTypeList.count; i++) {
        PayTypeButton *tmpButton = (PayTypeButton *)[self.payTypeView viewWithTag:(CHECK_PAYTYPE_BUTTON_TAG + i)];
        tmpButton.selectedArrow.hidden = YES;
    }
    
    PayTypeButton *payTypeButton = (PayTypeButton *)sender;
    payTypeButton.selectedArrow.hidden = NO;
    self.selectedPayType = payTypeButton.payType;
}

@end
