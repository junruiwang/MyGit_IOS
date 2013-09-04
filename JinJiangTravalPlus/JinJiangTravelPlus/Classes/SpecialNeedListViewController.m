//
//  SpecialNeedListViewController.m
//  JinJiangTravelPlus
//
//  Created by 杨 栋栋 on 13-7-16.
//  Copyright (c) 2013年 JinJiang. All rights reserved.Big bed room non-smoking room high-rise room adjoining room
//

#import "SpecialNeedListViewController.h"
#import "SpecialNeed.h"
#import "TableSelectButton.h"

@interface SpecialNeedListViewController ()

@property (nonatomic, strong) SpecialNeed *specialNeed;

@property (nonatomic, strong) NSMutableArray *tableButtonArray;

@end

@implementation SpecialNeedListViewController

- (void)initSpecialNeedListAndTableView
{
    self.tableButtonArray = [[NSMutableArray alloc] initWithCapacity:5];
    SpecialNeed *bigBedRoom = [[SpecialNeed alloc] initWithCodeAndName:@"bigBedRoom" name:@"大床房"];
    SpecialNeed *noneSmokingRoom = [[SpecialNeed alloc] initWithCodeAndName:@"noneSmokingRoom" name:@"无烟房"];
    SpecialNeed *highRiseRoom = [[SpecialNeed alloc] initWithCodeAndName:@"highRiseRoom" name:@"高层房"];
    SpecialNeed *adjoiningRoom = [[SpecialNeed alloc] initWithCodeAndName:@"adjoiningRoom" name:@"相邻房"];
    
    if ( self.roomCount < 2) {
        self.specialNeedListTableView.frame = CGRectMake(self.specialNeedListTableView.frame.origin.x, self.specialNeedListTableView.frame.origin.y, self.specialNeedListTableView.frame.size.width, 180);
        self.specialNeedList = [[NSArray alloc] initWithObjects:bigBedRoom, noneSmokingRoom, highRiseRoom, nil];
    } else {
        self.specialNeedListTableView.frame = CGRectMake(self.specialNeedListTableView.frame.origin.x, self.specialNeedListTableView.frame.origin.y, self.specialNeedListTableView.frame.size.width, 230);
        self.specialNeedList = [[NSArray alloc] initWithObjects:bigBedRoom, noneSmokingRoom, highRiseRoom,  adjoiningRoom, nil];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor clearColor];
    
    self.specialNeedListTableView.backgroundColor = [UIColor clearColor];
    
    [self initSpecialNeedListAndTableView];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self initSpecialNeedListAndTableView];
    
    [self.specialNeedListTableView reloadData];
}

#pragma mark -
#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.specialNeedList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SpecialNeedListCellIdentifier";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:CellIdentifier];
         [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }

    const unsigned int row = [indexPath row];

    SpecialNeed  *specialNeed = [self.specialNeedList objectAtIndex:row];

    TableSelectButton *selectButton = [[TableSelectButton alloc] initWithFrame:CGRectMake(20, 10, 25, 25) unSelectImgName:@"unCheck_coupon_frame.png" selectImgName:@"check_coupon_pressed.png"];
    selectButton.currentIndex = indexPath.row;
    

    for (int i = 0; i < self.selectedSpecialNeedArray.count; i ++) {

        NSString *code = (NSString *) [self.selectedSpecialNeedArray objectAtIndex:i];
        
        if ([specialNeed.code isEqualToString:code]) {
            
            [selectButton selectBtn];
            
            selectButton.tag ++;
        }
    }

    [self.tableButtonArray addObject:selectButton];
    [selectButton addTarget:self action:@selector(clickSelectCoupon:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside ];
    [cell addSubview:selectButton];

    UILabel *specialNameTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 15, 80, 15)];
    specialNameTextLabel.text = [NSString stringWithFormat:@"%@",specialNeed.name];
    specialNameTextLabel.font = [UIFont systemFontOfSize:14];
    [cell.contentView addSubview:specialNameTextLabel];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

#pragma mark -  UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TableSelectButton *eventButton = [self.tableButtonArray objectAtIndex:indexPath.row];

    [eventButton isChecked] ? [eventButton unSelectBtn] : [eventButton selectBtn];

    eventButton.tag ++;
}

- (void) clickSelectCoupon : (id) sender
{
    TableSelectButton *eventButton = (TableSelectButton *) sender;

   [eventButton isChecked] ? [eventButton unSelectBtn] : [eventButton selectBtn];

    eventButton.tag ++;
}

- (IBAction) clickOkButton : (id) sender
{
    self.selectedSpecialNeeds  = [NSMutableString stringWithCapacity:1];

    self.selectedSpecialNeedArray = [[NSMutableArray alloc] initWithCapacity:5];
    
    
    for (int i = 0; i < self.tableButtonArray.count; i++)
    {
        TableSelectButton *button = (TableSelectButton *) [self.tableButtonArray objectAtIndex:i];

        if ([button isChecked])
        {
            SpecialNeed *specialNeed = (SpecialNeed *) [self.specialNeedList objectAtIndex:i];
            self.selectedSpecialNeeds = [self.selectedSpecialNeeds stringByAppendingFormat:@"%@%@", specialNeed.name, @","];
            [self.selectedSpecialNeedArray addObject:specialNeed.code];
        }
    }
    if (self.selectedSpecialNeeds.length >= 1) {
        [self.delegate didDeterminSpecialNeeds:[self.selectedSpecialNeeds substringToIndex:self.selectedSpecialNeeds.length - 1]];
    } else {
        [self.delegate didDeterminSpecialNeeds:@""];
    }

}
@end
