//
//  BrandListViewController.m
//  JinJiangTravalPlus
//
//  Created by jerry on 12-11-5.
//  Copyright (c) 2012年 Leon. All rights reserved.
//

#import "BrandListViewController.h"
#import "Brand.h"

@interface BrandListViewController ()

@property(nonatomic, strong) NSArray *hotelBrandArray;
@property (strong, nonatomic) NSIndexPath *lastIndexPath;

@end

@implementation BrandListViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.hotelBrandArray = [Brand getBrandList];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.brandTableView.separatorColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dashed.png"]];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

#pragma mark -
#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.hotelBrandArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CheckMarkCellIdentifier = @"CheckMarkCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CheckMarkCellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CheckMarkCellIdentifier];
    }
    const unsigned int row = [indexPath row];
    const unsigned int oldRow = [self.lastIndexPath row];
    Brand *brand = [self.hotelBrandArray objectAtIndex:row];
    UIImageView *brandImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 25, 25)];
    brandImage.image = [UIImage imageNamed:brand.brandImage];
    [cell addSubview:brandImage];
    UILabel *brandLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 10, 180, 25)];
    brandLabel.font = [UIFont systemFontOfSize:18];
    brandLabel.text = brand.brandName;
    [cell addSubview:brandLabel];
    
    cell.accessoryType = (row == oldRow && self.lastIndexPath != nil) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    const unsigned int newRow = [indexPath row];
    const unsigned int oldRow = (self.lastIndexPath != nil) ? [self.lastIndexPath row] : -1;
    Brand *brand = [self.hotelBrandArray objectAtIndex:newRow];
    if (newRow != oldRow)
    {
        UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
        newCell.accessoryType = UITableViewCellAccessoryCheckmark;

        UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:self.lastIndexPath];
        oldCell.accessoryType = UITableViewCellAccessoryNone;
        self.lastIndexPath = indexPath;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.delegate pickBrandDone:brand];
    [[tableView cellForRowAtIndexPath:indexPath] setSelected:NO];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

@end
