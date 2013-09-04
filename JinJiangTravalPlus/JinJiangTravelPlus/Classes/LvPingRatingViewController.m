//
//  LvPingRatingViewController.m
//  JinJiangTravelPlus
//
//  Created by jerry on 12-12-12.
//  Copyright (c) 2012年 JinJiang. All rights reserved.
//
#import "Constants.h"
#import "LvPingRatingViewController.h"
#import "LvPingRatingTableCell.h"
#import "LvPingUserRating.h"
#import "JJUnderlineButton.h"

@interface LvPingRatingViewController ()

@end

@implementation LvPingRatingViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];

    if (self)
    {

    }

    return self;
}

- (void)viewDidLoad
{
    self.trackedViewName = @"酒店概览驴评页面";
    [super viewDidLoad];
    //self.tableView.separatorColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dashed.png"]];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.lvPingHotelRating.userRatings count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        static NSString *CellIdentifier = @"LvPingTitleTableViewCell";

        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }

        [[cell viewWithTag:101] removeFromSuperview];
        
        UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(20, 8, 290, 47)];
        titleView.tag = 101;

        UILabel *hotelRateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 1, 80, 18)];
        hotelRateLabel.font = [UIFont systemFontOfSize:14];
        hotelRateLabel.textColor = RGBCOLOR(50, 157, 209);

        hotelRateLabel.text = [NSString stringWithFormat:@"评分 %@分",self.lvPingHotelRating.hotelRate];
        hotelRateLabel.backgroundColor = [UIColor clearColor];
        [titleView addSubview:hotelRateLabel];

        UILabel *hotelRankLabel = [[UILabel alloc] initWithFrame:CGRectMake(92, 1, 120, 18)];
        hotelRankLabel.font = [UIFont systemFontOfSize:14];
        hotelRankLabel.textColor = RGBCOLOR(50, 157, 209);
        hotelRankLabel.text = [NSString stringWithFormat:@"口碑排名 %@",self.lvPingHotelRating.hotelRank];
        hotelRankLabel.backgroundColor = [UIColor clearColor];
        [titleView addSubview:hotelRankLabel];

        UILabel *resourceLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 23, 112, 13)];
        resourceLabel1.font = [UIFont systemFontOfSize:10];
        resourceLabel1.textColor = [UIColor darkGrayColor];
        resourceLabel1.text = @"以下评论内容来自";
        resourceLabel1.backgroundColor = [UIColor clearColor];
        [titleView addSubview:resourceLabel1];

        JJUnderlineButton *regulationsBtnTop1 = [JJUnderlineButton buttonWithType:UIButtonTypeCustom];
        regulationsBtnTop1.frame = CGRectMake(68, 23, 60, 13);
        [regulationsBtnTop1 setTitle:@"驴评网" forState:UIControlStateNormal];
        [regulationsBtnTop1 addTarget:self action:@selector(more:) forControlEvents:UIControlEventTouchUpInside];
        [regulationsBtnTop1 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        regulationsBtnTop1.titleLabel.font = [UIFont systemFontOfSize:10];
        [titleView addSubview:regulationsBtnTop1];

        UILabel *resourceLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(116, 23, 90, 13)];
        resourceLabel2.font = [UIFont systemFontOfSize:10];
        resourceLabel2.textColor = [UIColor darkGrayColor];
        resourceLabel2.text = [NSString stringWithFormat:@",此处仅显示%d条,",[self.lvPingHotelRating.userRatings count]];
        resourceLabel2.backgroundColor = [UIColor clearColor];
        [titleView addSubview:resourceLabel2];

        JJUnderlineButton *regulationsBtnTop2 = [JJUnderlineButton buttonWithType:UIButtonTypeCustom];
        regulationsBtnTop2.frame = CGRectMake(192, 23, 100, 13);
        [regulationsBtnTop2 setTitle:@"点此查看全部点评>>" forState:UIControlStateNormal];
        [regulationsBtnTop2 addTarget:self action:@selector(more:) forControlEvents:UIControlEventTouchUpInside];
        [regulationsBtnTop2 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        regulationsBtnTop2.titleLabel.font = [UIFont systemFontOfSize:10];
        [titleView addSubview:regulationsBtnTop2];

        [cell addSubview:titleView];

        cell.backgroundColor = [UIColor lightTextColor];
        return cell;
    }
    else
    {
        static NSString *CellIdentifier = @"LvPingRatingTableViewCell";
        LvPingRatingTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[LvPingRatingTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        LvPingUserRating *userRating = self.lvPingHotelRating.userRatings[indexPath.row - 1];
        CGSize stringSize = [userRating.content sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(295, 800)
                                               lineBreakMode:UILineBreakModeWordWrap];
        cell.content.lineBreakMode = UILineBreakModeWordWrap;
        cell.content.numberOfLines = 0;
        cell.content.frame = CGRectMake(4, 4, 295, stringSize.height);
        cell.content.text = userRating.content;
        const int x0 = cell.wdate.frame.origin.x;
        const int y0 = cell.content.frame.origin.y + cell.content.frame.size.height + 10;
        const unsigned int w0 = cell.wdate.frame.size.width;
        const unsigned int h0 = cell.wdate.frame.size.height;
        cell.wdate.frame = CGRectMake(x0, y0, w0, h0);

        const int y1 = cell.content.frame.origin.y + cell.content.frame.size.height + 10;
        const unsigned int w1 = cell.linkName.frame.size.width;
        const unsigned int h1 = cell.linkName.frame.size.height;
        cell.linkName.frame = CGRectMake(cell.linkName.frame.origin.x, y1, w1, h1);
        const int y2 = cell.content.frame.origin.y + cell.content.frame.size.height + 10;
        const unsigned int w2 = cell.nickName.frame.size.width;
        const unsigned int h2 = cell.nickName.frame.size.height;
        cell.nickName.frame = CGRectMake(cell.nickName.frame.origin.x, y2, w2, h2);
        cell.nickName.text = [userRating.nickName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        cell.wdate.text = userRating.wdate;

        //    UIView *tempView = [[UIView alloc] init];
        //    cell.backgroundView = tempView;
        cell.backgroundColor = [UIColor lightTextColor];

        return cell;
    }
}

- (void) more : (id) sender
{
    [self.navigationController pushViewController:self.webViewController animated:YES];
}

- (WebViewController *)webViewController
{
    if (!_webViewController) {
        _webViewController = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil]
                              instantiateViewControllerWithIdentifier:@"WebViewController"];
        _webViewController.url = self.lvPingHotelRating.hotelUrl;
    }
    return _webViewController;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        return 47;
    }
    else
    {
        LvPingUserRating *userRating = self.lvPingHotelRating.userRatings[indexPath.row - 1];
        CGSize stringSize = [userRating.content sizeWithFont:[UIFont systemFontOfSize:14]
                                           constrainedToSize:CGSizeMake(295, 800)
                                               lineBreakMode:UILineBreakModeWordWrap];
        return 32 + stringSize.height;
    }
}

@end
