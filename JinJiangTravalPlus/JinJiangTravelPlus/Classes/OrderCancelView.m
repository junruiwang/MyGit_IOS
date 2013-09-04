//
//  OrderCancelView.m
//  JinJiangTravelPlus
//
//  Created by 吕 硕 on 12-12-27.
//  Copyright (c) 2012年 JinJiang. All rights reserved.
//

#import "OrderCancelView.h"
#import <QuartzCore/QuartzCore.h>
#import "JJDashLine.h"

const unsigned int buttonTag = 9090;
const unsigned int imageTag = 90990;
const unsigned int xx = 21;
const unsigned int ww = 300;

@implementation OrderCancelView

@synthesize orderCancelParser;
@synthesize delegate;
@synthesize orderNo;
@synthesize orderID;
@synthesize closeBtn;
@synthesize btn5;
@synthesize backBtn;
@synthesize cancelBtn;
@synthesize otherReason;


- (void)setCancelPolicyText:(NSString *)cancelPolicyText
{
    _cancelPolicyText = cancelPolicyText;
    self.cancelPolicyDescLabel.text = [NSString stringWithFormat:@"取消政策:%@", cancelPolicyText];
}

- (void)setHidden:(BOOL)hidden
{
    [super setHidden:hidden];

    if (hidden == YES)
    {
        [self.otherReason setHidden:YES];
        [self.closeBtn setHidden:YES];
    }
}

- (id)init
{
    self = [super init];
    if (self)
    {
        [self setFrame:CGRectMake(0, 0, 300, 295)];
        [self setBackgroundColor:[UIColor whiteColor]];

        const float rr = 6.0f / 255.0f;
        const float gg = 109.0f / 255.0f;
        const float bb = 199.0f / 255.0f;


        UILabel* title = [[UILabel alloc] init];
        [title setFrame:CGRectMake(0, 12, ww, 20)];
        [title setFont:[UIFont boldSystemFontOfSize:18]];
        [title setBackgroundColor:[UIColor clearColor]];
        [title setTextAlignment:NSTextAlignmentCenter];
        [title setTextColor:[UIColor colorWithRed:rr green:gg blue:bb alpha:1]];
        [title setText:@"取消订单"];
        [self addSubview:title];
        
        JJDashLine *dashLineUpper = [[JJDashLine alloc] init];
        dashLineUpper.frame = CGRectMake(10, 36, ww, 1);
        [self addSubview:dashLineUpper];

        self.closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.closeBtn setFrame:CGRectMake(212, 12, 56, 20)];
        [self.closeBtn setBackgroundImage:[UIImage imageNamed:@"blueBtn.png"] forState:UIControlStateNormal];
        [self.closeBtn setBackgroundImage:[UIImage imageNamed:@"blueBtnPressed.png"] forState:UIControlStateHighlighted];
        [self.closeBtn setTitle:@"关闭" forState:UIControlStateNormal];
        [self.closeBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
        [self.closeBtn addTarget:self action:@selector(returnButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.closeBtn setHidden:YES];[self addSubview:self.closeBtn];

        UILabel* lab21 = [[UILabel alloc] init];
        [lab21 setFrame:CGRectMake(xx, 47, 200, 18)];
        [lab21 setFont:[UIFont systemFontOfSize:16]];
        [lab21 setBackgroundColor:[UIColor clearColor]];
        [lab21 setTextAlignment:NSTextAlignmentLeft];
        [lab21 setTextColor:[UIColor blackColor]];
        [lab21 setText:@"我懒得说"];
        [self addSubview:lab21];
        
        UIImageView* img1 = [[UIImageView alloc] init];
        [img1 setFrame:CGRectMake(ww-xx-18, 47, 18, 18)];
        [img1 setImage:[UIImage imageNamed:@"check-frame_c.png"]];
        [img1 setTag:imageTag+1];[self addSubview:img1];

        UILabel* lab22 = [[UILabel alloc] init];
        [lab22 setFrame:CGRectMake(xx, 77, 200, 18)];
        [lab22 setFont:[UIFont systemFontOfSize:16]];
        [lab22 setBackgroundColor:[UIColor clearColor]];
        [lab22 setTextAlignment:NSTextAlignmentLeft];
        [lab22 setTextColor:[UIColor blackColor]];
        [lab22 setText:@"行程改变"];
        [self addSubview:lab22];

        UIImageView* img2 = [[UIImageView alloc] init];
        [img2 setFrame:CGRectMake(ww-xx-18, 77, 18, 18)];
        [img2 setImage:[UIImage imageNamed:@"check-frame_c.png"]];
        [img2 setTag:imageTag+2];[self addSubview:img2];

        UILabel* lab23 = [[UILabel alloc] init];
        [lab23 setFrame:CGRectMake(xx, 107, 200, 18)];
        [lab23 setFont:[UIFont systemFontOfSize:16]];
        [lab23 setBackgroundColor:[UIColor clearColor]];
        [lab23 setTextAlignment:NSTextAlignmentLeft];
        [lab23 setTextColor:[UIColor blackColor]];
        [lab23 setText:@"不想预付费用"];
        [self addSubview:lab23];

        UIImageView* img3 = [[UIImageView alloc] init];
        [img3 setFrame:CGRectMake(ww-xx-18, 107, 18, 18)];
        [img3 setImage:[UIImage imageNamed:@"check-frame_c.png"]];
        [img3 setTag:imageTag+3];[self addSubview:img3];

        UILabel* lab24 = [[UILabel alloc] init];
        [lab24 setFrame:CGRectMake(xx, 137, 200, 18)];
        [lab24 setFont:[UIFont systemFontOfSize:16]];
        [lab24 setBackgroundColor:[UIColor clearColor]];
        [lab24 setTextAlignment:NSTextAlignmentLeft];
        [lab24 setTextColor:[UIColor blackColor]];
        [lab24 setText:@"服务体验不好"];
        [self addSubview:lab24];

        UIImageView* img4 = [[UIImageView alloc] init];
        [img4 setFrame:CGRectMake(ww-xx-18, 137, 18, 18)];
        [img4 setImage:[UIImage imageNamed:@"check-frame_c.png"]];
        [img4 setTag:imageTag+4];[self addSubview:img4];

        UILabel* lab25 = [[UILabel alloc] init];
        [lab25 setFrame:CGRectMake(xx, 167, 200, 18)];
        [lab25 setFont:[UIFont systemFontOfSize:16]];
        [lab25 setBackgroundColor:[UIColor clearColor]];
        [lab25 setTextAlignment:NSTextAlignmentLeft];
        [lab25 setTextColor:[UIColor blackColor]];
        [lab25 setText:@"其他"];
        [self addSubview:lab25];

        UIImageView* img5 = [[UIImageView alloc] init];
        [img5 setFrame:CGRectMake(ww-xx-18, 167, 18, 18)];
        [img5 setImage:[UIImage imageNamed:@"check-frame_c.png"]];
        [img5 setTag:imageTag+5];[self addSubview:img5];

        UIButton* btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn1 setFrame:CGRectMake(0, 47, 278, 18)];
        [btn1 setBackgroundColor:[UIColor clearColor]];
        [btn1 setBackgroundImage:nil forState:UIControlStateNormal];
        [btn1 setBackgroundImage:nil forState:UIControlStateHighlighted];
        [btn1 setTitle:@"" forState:UIControlStateNormal];
        [btn1 setTitle:@"" forState:UIControlStateHighlighted];
        [btn1 setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        [btn1 setTitleColor:[UIColor clearColor] forState:UIControlStateHighlighted];
        [btn1 addTarget:self action:@selector(selectReason:) forControlEvents:UIControlEventTouchUpInside];
        [btn1 setTag:buttonTag+1];[self addSubview:btn1];

        UIButton* btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn2 setFrame:CGRectMake(0, 77, 278, 18)];
        [btn2 setBackgroundColor:[UIColor clearColor]];
        [btn2 setBackgroundImage:nil forState:UIControlStateNormal];
        [btn2 setBackgroundImage:nil forState:UIControlStateHighlighted];
        [btn2 setTitle:@"" forState:UIControlStateNormal];
        [btn2 setTitle:@"" forState:UIControlStateHighlighted];
        [btn2 setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        [btn2 setTitleColor:[UIColor clearColor] forState:UIControlStateHighlighted];
        [btn2 addTarget:self action:@selector(selectReason:) forControlEvents:UIControlEventTouchUpInside];
        [btn2 setTag:buttonTag+2];[self addSubview:btn2];

        UIButton* btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn3 setFrame:CGRectMake(0, 107, 278, 18)];
        [btn3 setBackgroundColor:[UIColor clearColor]];
        [btn3 setBackgroundImage:nil forState:UIControlStateNormal];
        [btn3 setBackgroundImage:nil forState:UIControlStateHighlighted];
        [btn3 setTitle:@"" forState:UIControlStateNormal];
        [btn3 setTitle:@"" forState:UIControlStateHighlighted];
        [btn3 setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        [btn3 setTitleColor:[UIColor clearColor] forState:UIControlStateHighlighted];
        [btn3 addTarget:self action:@selector(selectReason:) forControlEvents:UIControlEventTouchUpInside];
        [btn3 setTag:buttonTag+3];[self addSubview:btn3];
        
        UIButton* btn4 = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn4 setFrame:CGRectMake(0, 137, 278, 18)];
        [btn4 setBackgroundColor:[UIColor clearColor]];
        [btn4 setBackgroundImage:nil forState:UIControlStateNormal];
        [btn4 setBackgroundImage:nil forState:UIControlStateHighlighted];
        [btn4 setTitle:@"" forState:UIControlStateNormal];
        [btn4 setTitle:@"" forState:UIControlStateHighlighted];
        [btn4 setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        [btn4 setTitleColor:[UIColor clearColor] forState:UIControlStateHighlighted];
        [btn4 addTarget:self action:@selector(selectReason:) forControlEvents:UIControlEventTouchUpInside];
        [btn4 setTag:buttonTag+4];[self addSubview:btn4];

        self.btn5 = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.btn5 setFrame:CGRectMake(0, 167, 278, 18)];
        [self.btn5 setBackgroundColor:[UIColor clearColor]];
        [self.btn5 setBackgroundImage:nil forState:UIControlStateNormal];
        [self.btn5 setBackgroundImage:nil forState:UIControlStateHighlighted];
        [self.btn5 setTitle:@"" forState:UIControlStateNormal];
        [self.btn5 setTitle:@"" forState:UIControlStateHighlighted];
        [self.btn5 setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        [self.btn5 setTitleColor:[UIColor clearColor] forState:UIControlStateHighlighted];
        [self.btn5 addTarget:self action:@selector(selectReason:) forControlEvents:UIControlEventTouchUpInside];
        [self.btn5 setTag:buttonTag+5];[self addSubview:self.btn5];
        
        JJDashLine *dashLineLower = [[JJDashLine alloc] init];
        dashLineLower.frame = CGRectMake(10, 196, ww, 1);
        [self addSubview:dashLineLower];
        
        UIImageView *cancelPolicyIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cancel_icon@2x.png"]];
        cancelPolicyIcon.frame = CGRectMake(xx, 206, 12, 12);
        [self addSubview:cancelPolicyIcon];
        
        
        self.cancelPolicyDescLabel = [[UITextView alloc] initWithFrame:CGRectMake(xx + 10, 197, ww - 60, 28)];
        self.cancelPolicyDescLabel.font = [UIFont systemFontOfSize:12];
        self.cancelPolicyDescLabel.scrollEnabled = NO;
        [self.cancelPolicyDescLabel setEditable:NO];
        self.cancelPolicyDescLabel.textColor = [UIColor colorWithRed:243.0/255.0 green:152.0/255.0 blue:0.0 alpha:1.0];
        [self.cancelPolicyDescLabel setBackgroundColor:[UIColor clearColor]];
        [self.cancelPolicyDescLabel setTextAlignment:NSTextAlignmentLeft];
        [self addSubview:self.cancelPolicyDescLabel];
        
        self.backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.backBtn setFrame:CGRectMake(xx, 248, 124, 38)];
        [self.backBtn setBackgroundColor:[UIColor clearColor]];
        [self.backBtn setBackgroundImage:[UIImage imageNamed:@"btn.png"] forState:UIControlStateNormal];
        [self.backBtn setTitle:@"我点错了" forState:UIControlStateNormal];
        [self.backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.backBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:21]];
        [self.backBtn addTarget:self action:@selector(returnButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.backBtn];

        self.cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.cancelBtn setFrame:CGRectMake(300-xx-124, 248, 124, 38)];
        [self.cancelBtn setBackgroundColor:[UIColor clearColor]];
        [self.cancelBtn setBackgroundImage:[UIImage imageNamed:@"btn.png"] forState:UIControlStateNormal];
        [self.cancelBtn setTitle:@"确定取消" forState:UIControlStateNormal];
        [self.cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.cancelBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:21]];
        [self.cancelBtn addTarget:self action:@selector(cancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.cancelBtn];

        self.otherReason = [[UITextView alloc] init];
        [self.otherReason setFrame:CGRectMake(xx, 47, 258, 108)];
        [self.otherReason setHidden:YES];
        [self.otherReason.layer setCornerRadius:2];
        [self.otherReason.layer setMasksToBounds:YES];
        [self.otherReason.layer setBorderColor:[UIColor colorWithRed:rr green:gg blue:bb alpha:1].CGColor];
        [self.otherReason.layer setBorderWidth:1.0f];
        [self addSubview:self.otherReason];
    }
    return self;
}

- (void)uiKeyboardWillShow:(NSNotification*)notification
{
    if(notification)
    {
        const unsigned int hh = [[[[UIApplication sharedApplication] windows] objectAtIndex:0] frame].size.height;
        const unsigned int yy = (hh / 2) - 38;
        if ([[NSUserDefaults standardUserDefaults] boolForKey:USER_DEVICE_5] == NO)
        {   [self setCenter:CGPointMake(self.center.x, yy - 74)];   }
    }
}

- (void)uiKeyboardWillHide:(NSNotification*)notification
{
    if(notification)
    {
        const unsigned int hh = [[[[UIApplication sharedApplication] windows] objectAtIndex:0] frame].size.height;
        const unsigned int yy = (hh / 2) - 38;
        if ([[NSUserDefaults standardUserDefaults] boolForKey:USER_DEVICE_5] == NO)
        {   [self setCenter:CGPointMake(self.center.x, yy)];    }
    }
}

- (void)returnButtonClicked:(id)sender
{
    if (self.otherReason.hidden == NO && [self.otherReason isFirstResponder])
    {
        [self.otherReason resignFirstResponder];
        return;
    }
    else if(self.otherReason.hidden == NO && [self.otherReason isFirstResponder] == NO)
    {
        [self.otherReason setHidden:YES];
        [self.closeBtn setHidden:YES];
        [self dismissCancelReason];
        return;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(orderCancelView:didReturnToController:)])
    {
        [self dismissCancelReason];
        [self.delegate orderCancelView:self didReturnToController:nil];
    }

    [self setHidden:YES];
}


- (void)dismissCancelReason
{
    for (unsigned int i = imageTag + 1; i <= imageTag + 5; i++)
    {
        UIImageView* imgView = (UIImageView*)[self viewWithTag:i];
        [imgView setImage:[UIImage imageNamed:@"check-frame_c.png"]];
    }
    selectedReason = 0;
}


- (void)cancelButtonClicked:(id)sender
{
    if (selectedReason == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"信息提示" message:@"请选择取消订单的原因"
                                                           delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    } else {
        [self cancelOrder:self.orderNo];
    }
}

- (void)cancelOrder:(NSString*)orderNumber
{
    NSString* reason;
    switch (selectedReason)
    {
        case 1:
        {   reason = @"TRIPCHANGE";     break;  }
        case 2:
        {  reason = @"WEATHER";         break;  }
        case 3:
        {   reason = @"REPEAT_BOOKING"; break;  }
        case 4:
        {   reason = @"OTHER_BRAND";    break;  }
        case 5:
        {   reason = @"OTHER";          break;  }
        default:
        {  break;   }
    }

    if (!self.orderCancelParser)
    {
        self.orderCancelParser = [[OrderCancelParser alloc] init];
        self.orderCancelParser.isHTTPGet = NO;
        self.orderCancelParser.serverAddress = kHotelOrderCancelURL;
    }

    NSString* format = @"orderId=%@&orderNo=%@&reason=%@";
    NSString* queryString = [NSString stringWithFormat:format, self.orderID, self.orderNo, reason];
    if(selectedReason == 5)
    {  queryString = [queryString stringByAppendingFormat:@"&otherReason=%@", self.otherReason.text];    }
    [self.orderCancelParser setRequestString:queryString];
    [self.orderCancelParser setDelegate:self];   [self.orderCancelParser start];

    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(orderCancelView:willCancelOrder:)])
    {
        [self.delegate orderCancelView:self willCancelOrder:nil];
    }
}

- (void)selectReason:(id)sender
{
    selectedReason = ((UIButton*)(sender)).tag - buttonTag;

    for (unsigned int i = imageTag + 1; i <= imageTag + 5; i++)
    {
        UIImageView* imgView = (UIImageView*)[self viewWithTag:i];
        [imgView setImage:[UIImage imageNamed:@"check-frame_c.png"]];
    }

    const unsigned int imgTag = imageTag + selectedReason;
    UIImageView* imgView = (UIImageView*)[self viewWithTag:imgTag];
    [imgView setImage:[UIImage imageNamed:@"check_c.png"]];

    if (selectedReason == 5)
    {
        [self.otherReason setHidden:NO];[self.closeBtn setHidden:NO];
        [self.otherReason becomeFirstResponder];[self.otherReason setText:@""];
    }
}

- (void)parser:(GDataXMLParser*)parser DidParsedData:(NSDictionary *)data
{
    NSString* message = [data objectForKey:@"message"];
    if (self.delegate && [self.delegate respondsToSelector:@selector(orderCancelView:didCancelOrder:)])
    {
        [self.delegate orderCancelView:self didCancelOrder:message];
    }
}

@end
