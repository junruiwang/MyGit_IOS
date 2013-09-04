//
//  MemberCardRightViewController.m
//  JinJiangTravelPlus
//
//  Created by Raphael.rong on 13-5-22.
//  Copyright (c) 2013年 JinJiang. All rights reserved.
//

#import "MemberCardRightViewController.h"
#import "FillMemberCardInfoViewController.h"
#import "MemberCardPriceParser.h"

@interface MemberCardRightViewController ()

@property (nonatomic, strong) NSString *price;
@property (nonatomic) BOOL haveEffectivePrice;

@end

@implementation MemberCardRightViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    ((FillMemberCardInfoViewController *)segue.destinationViewController).price = self.price;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self setTitle:@"购买享卡"];
    MemberCardPriceParser *mcPrice = [[MemberCardPriceParser alloc] init];
    mcPrice.delegate = self;
    mcPrice.serverAddress = kMemberCardPriceURL;
    [mcPrice start];
    [self showIndicatorView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)nextButtonPress:(id)sender {
    
    [self performSegueWithIdentifier:To_FILL_BUYER_INFO sender:self];
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - GDataXMLParserDelegate

- (void)parser:(GDataXMLParser *)parser DidParsedData:(NSDictionary *)data
{
    if ([parser isKindOfClass:[MemberCardPriceParser class]])
    {
        [self hideIndicatorView];
        self.price = [data objectForKey:@"price"];
    }
}

- (void)parser:(GDataXMLParser *)parser DidFailedParseWithMsg:(NSString *)msg errCode:(NSInteger)code
{
    if ([parser isKindOfClass:[MemberCardPriceParser class]]) {
        [self hideIndicatorView];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"信息" message:@"无法获取享卡价格，请检查网络连接" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        alertView.delegate = self;
        [alertView show];
    }
}
@end
