//
//  HotelOverviewViewController.m
//  JinJiangTravelPlus
//
//  Created by Leon on 11/19/12.
//  Copyright (c) 2012 JinJiang. All rights reserved.
//

#import "HotelOverviewViewController.h"
#import "Constants.h"
#import <QuartzCore/QuartzCore.h>

#define kMinCellHeight 30

@interface HotelOverviewViewController ()

@end

@implementation HotelOverviewViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
    _hotelInfo = [[NSMutableDictionary alloc] init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated
{
    self.trackedViewName = @"酒店概览页面酒店介绍";
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)downloadData
{
    if (!self.hotelOverviewParser)
    {
        self.hotelOverviewParser = [[HotelOverviewParser alloc] init];
        self.hotelOverviewParser.isHTTPGet = NO;
        self.hotelOverviewParser.serverAddress = [kHotelOverviewURL stringByAppendingPathComponent:
                                                  [NSString stringWithFormat:@"%d", self.hotelId]];
    }
    
    self.hotelOverviewParser.delegate = self;
    [self.hotelOverviewParser start];
    [self showIndicatorView];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case 0: {   return [self.hotelInfo[@"description"][@"height"] floatValue];  }
        case 1: {   return [self.hotelInfo[@"policyInfo"][@"height"] floatValue];   }
        case 2: {   return [self.hotelInfo[@"diningFacilities"][@"height"] floatValue]; }
        case 3: {   return [self.hotelInfo[@"locationInfo"][@"height"] floatValue]; }
        default:{   return kMinCellHeight;   }
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section)
    {
        case 0: {   return @"酒店简介"; }
        case 1: {   return @"酒店政策"; }
        case 2: {   return @"餐饮设施"; }
        case 3: {   return @"酒店周边"; }
        default:{   return @"";         }
    }
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    NSString *sectionTitle = [self tableView:tableView titleForHeaderInSection:section];
//    UILabel *label = [[UILabel alloc] init];
//    label.frame = CGRectMake(11, 0, 300, 24);
//    label.backgroundColor = [UIColor clearColor];
//    label.textColor = [UIColor darkGrayColor];
//    label.shadowOffset = CGSizeMake(0.0, 1.0);
//    label.font = [UIFont boldSystemFontOfSize:16];
//    label.text = sectionTitle;
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 20)];
//    view.backgroundColor = [UIColor clearColor];
//
//    [view addSubview:label];
//    return view;
//}

- (float)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 15;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OverviewTableViewCell"];
    UIView *backView = cell.backgroundView;
    cell.backgroundView = [[UIView alloc] initWithFrame:backView.frame];

    CALayer *subLayer = [CALayer layer];
    subLayer.backgroundColor = [UIColor whiteColor].CGColor;
    subLayer.cornerRadius = 5;
    subLayer.borderColor = [UIColor colorWithRed:215.0/255.0 green:215.0/255.0 blue:215.0/255.0 alpha:1.0].CGColor;
    subLayer.borderWidth = 1;
    
    // Configure the cell...
    UILabel *descLabel = (UILabel *)[cell.contentView viewWithTag:1000];
    UIColor *textColor = [UIColor colorWithRed:85.0/255.0 green:85.0/255.0 blue:85.0/255.0 alpha:1.0];
    switch (indexPath.section)
    {
        case 0:
        {
            const unsigned int hh = (unsigned int)[self.hotelInfo[@"description"][@"height"] floatValue];
            descLabel.frame = CGRectMake(10, 0, 280, hh);
            descLabel.text = self.hotelInfo[@"description"][@"value"];
            descLabel.textColor = textColor;
            subLayer.frame = CGRectMake(0, 0, 302, hh);
            [cell.backgroundView.layer addSublayer:subLayer];
            break;
        }
        case 1:
        {
            const unsigned int hh = (unsigned int)[self.hotelInfo[@"policyInfo"][@"height"] floatValue];
            descLabel.frame = CGRectMake(10, 0, 280, hh);
            descLabel.text = self.hotelInfo[@"policyInfo"][@"value"];
            descLabel.textColor = textColor;
            subLayer.frame = CGRectMake(0, 0, 302, hh);
            [cell.backgroundView.layer addSublayer:subLayer];
            break;
        }
        case 2:
        {
            const unsigned int hh = (unsigned int)[self.hotelInfo[@"diningFacilities"][@"height"] floatValue];
            descLabel.frame = CGRectMake(10, 5, 280, hh);
            descLabel.text = self.hotelInfo[@"diningFacilities"][@"value"];
            descLabel.textColor = textColor;
            subLayer.frame = CGRectMake(0, 0, 302, hh+10);
            [cell.backgroundView.layer addSublayer:subLayer];
            break;
        }
        case 3:
        {
            const unsigned int hh = (unsigned int)[self.hotelInfo[@"locationInfo"][@"height"] floatValue];
            descLabel.frame = CGRectMake(10, 0, 280, hh);
            NSString *locationInfo = self.hotelInfo[@"locationInfo"][@"value"];
            descLabel.text = [locationInfo stringByReplacingOccurrencesOfString:@"#" withString:@""];
            descLabel.textColor = textColor;
            subLayer.frame = CGRectMake(0, 0, 302, hh);
            [cell.backgroundView.layer addSublayer:subLayer];
            break;
        }
        default:
            break;
    }
    
    return cell;
}

- (void)parser:(GDataXMLParser *)parser DidParsedData:(NSDictionary *)data
{
    [data enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop)
     {
         if ([obj isKindOfClass:[NSString class]])
         {
             NSString *value = (NSString *)obj;
             value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
             float height = kMinCellHeight;
             if (value || ![value isEqualToString:@""])
             {
                 CGSize stringSize = [value sizeWithFont:[UIFont systemFontOfSize:14]
                                       constrainedToSize:CGSizeMake(280, 800) lineBreakMode:UILineBreakModeWordWrap];
                 if (stringSize.height > height)
                 {   height = stringSize.height; }
             }
             [self.hotelInfo setObject:@{@"value":value, @"height":@(height)} forKey:key];
         }
     }];
    [self.tableView reloadData];
    [self hideIndicatorView];
}

@end
