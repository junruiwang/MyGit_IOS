//
//  PromotionViewController.m
//  JinJiangHotel
//
//  Created by Rong Hao on 13-9-2.
//  Copyright (c) 2013年 jinjiang. All rights reserved.
//

#import "PromotionViewController.h"
#import "UIImageView+WebCache.h"
#import "ShareToSNSManager.h"

@interface PromotionViewController ()

@property (nonatomic, strong) ShareToSNSManager *shareManager;

@end

@implementation PromotionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationBar.mainLabel.text = NSLocalizedString(@"promotioncenter", @"");
    self.promitionTable.delegate = self;
    self.promitionTable.dataSource = self;
    self.shareManager = [[ShareToSNSManager alloc] init];
    
    
    [self downloadData];
}

#pragma mark - 业务逻辑

- (void)downloadData
{
    if (!self.promotionsParser)
    {
        self.promotionsParser = [[PromotionsParser alloc] init];
        self.promotionsParser.isHTTPGet = YES;
        self.promotionsParser.serverAddress = kPromotionRequestURL;
    }
    
    NSMutableString *queryString = [NSMutableString string];
    [self.promotionsParser setRequestString:queryString];
    [self.promotionsParser setDelegate:self];
    [self.promotionsParser start];
    [self showIndicatorView];
}

- (void)parser:(GDataXMLParser*)parser DidParsedData:(NSDictionary *)data
{
    if ([parser isKindOfClass:[PromotionsParser class]])
    {
        self.promotionArray = [[NSMutableArray alloc] initWithArray:[data objectForKey:@"promotionArray"]];
        
        [self hideIndicatorView];
        [self.promitionTable reloadData];
    }
}

#pragma mark - tableView datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.promotionArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    PromotionCell *cell = (PromotionCell *)[tableView dequeueReusableCellWithIdentifier:PromotionCellID];
    
    if (cell == nil)
    {
        cell = [[PromotionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:PromotionCellID];
    }
    
    cell.delegate = self;
    cell.backgroundColor = [UIColor clearColor];
    Promotion *promotion = [self.promotionArray objectAtIndex:indexPath.row];
    cell.promotion = promotion;
    NSString *imURL = [promotion.smallBannerLink stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    [cell.promitionImageView setImageWithURL:[NSURL URLWithString:imURL]];
    cell.promotionTitleLabel.text = promotion.title;
    
    NSString *promotionBody = promotion.body;
    if (promotionBody.length > 30) {
        promotionBody = [NSString stringWithFormat:@"%@...", [promotionBody substringToIndex:30]];
    }
    
    cell.promotionDescriptionLabel.text = promotionBody;
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 251;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //todo
}



- (void)shareButtonClick:(PromotionCell *)sender
{
    
    [self.shareManager shareWithActionSheet:self shareImage:nil shareText:sender.promotion.shareDesc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setPromitionTable:nil];
    [super viewDidUnload];
}
@end
