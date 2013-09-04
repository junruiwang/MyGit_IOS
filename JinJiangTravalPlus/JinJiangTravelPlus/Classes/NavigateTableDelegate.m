//
// Created by huguiqi on 11/24/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "NavigateTableDelegate.h"
#import "KalPrivate.h"
#import "HotelFilterNavigation.h"
#import "Constants.h"
#import "PriceRange.h"
#import "StarLevel.h"

@implementation NavigateTableDelegate

- (id)init
{
    if (self = [super init])
    {
        HotelFilterNavigation *price = [[HotelFilterNavigation alloc] initWithNameAndCode :@"价格" code:PRICE_CODE];
        HotelFilterNavigation *brand = [[HotelFilterNavigation alloc] initWithNameAndCode :@"品牌" code:BRAND_CODE];
        HotelFilterNavigation *star = [[HotelFilterNavigation alloc] initWithNameAndCode :@"星级" code:STAR_CODE];
        HotelFilterNavigation *area = [[HotelFilterNavigation alloc] initWithNameAndCode :@"区域" code:AREA_CODE];
        self.navigationArray = [NSArray arrayWithObjects: price,brand, star, area, nil];
    }
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (int)isNotSelectedArea:(NSString *)area
{
    return (area == nil || [@"" isEqualToString:area] || [@"全部区域" isEqualToString:area]);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//  cell.textLabel.font = [UIFont systemFontOfSize:18];
    const unsigned int row = indexPath.row;
    HotelFilterNavigation *navigation = [self.navigationArray objectAtIndex:row];
//  [self grayColorStyleForCell:cell];
    cell.textLabel.textColor = [UIColor grayColor];
    cell.detailTextLabel.textColor = [UIColor blackColor];
    cell.detailTextLabel.textAlignment = NSTextAlignmentCenter;
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14.0];
    switch (row)
    {
        case 0:
        {
            [self cellForRowOfPriceRange:cell navigation:navigation];
            break;
        }
        case 1:
        {
            [self cellForRowOfBrand:cell navigation:navigation];
            break;
        }
        case 2:
        {
            [self cellForRowOfStarLevel:cell navigation:navigation];
            break;
        }
        case 3:
        {
            [self cellForRowOfArea:cell navigation:navigation];
            break;
        }
    }

    return cell;
}

- (void)cellForRowOfArea:(UITableViewCell *)cell navigation:(HotelFilterNavigation *)navigation
{
    NSString *area = TheAppDelegate.hotelSearchForm.area;
    cell.imageView.image = [UIImage imageNamed:@"filter_district.png"];
    [self setDefaultTextLabel:cell navigation:navigation defaultValue:@""];
    if (![self isNotSelectedArea:area])
    {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@    ", area];
    }
}

- (void)cellForRowOfStarLevel:(UITableViewCell *)cell navigation:(HotelFilterNavigation *)navigation
{
    StarLevel *starLevel = TheAppDelegate.hotelSearchForm.starLevel;
    cell.imageView.image = [UIImage imageNamed:@"filter_star.png"];
    [self setDefaultTextLabel:cell navigation:navigation defaultValue:@""];    
    if (starLevel.isSelected)
    {
        starLevel.isSelected = YES;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@    ", starLevel.textShow];
    }
}

- (void)cellForRowOfBrand:(UITableViewCell *)cell navigation:(HotelFilterNavigation *)navigation
{
    Brand *brand = TheAppDelegate.hotelSearchForm.hotelBrand;
    
    for (id tempView in cell.contentView.subviews)
    {   [tempView removeFromSuperview]; }

    cell.imageView.image = [UIImage imageNamed:@"filter_brand.png"];
    [self setDefaultTextLabel:cell navigation:navigation defaultValue:@""];

    if (brand.isSelected)
    {
        brand.isSelected = YES;
        NSString *brandName = brand.brandName;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", brandName];

//      NSLog(@"detailtextlabel x is %d", cell.detailTextLabel.frame.origin.x);
        float basicX = 152.0;
        float widthCoefficient;

        if (brand.brandName.length == 4)
        {   widthCoefficient = brand.brandName.length * 1.0;    }
        else if (brand.brandName.length == 5)
        {   widthCoefficient = brand.brandName.length * 3.6;    }
        else
        {   widthCoefficient = brand.brandName.length * 5.0;    }
        float brandX = basicX - widthCoefficient;

        //todo will repleace new png
        UIImageView *brandImageView = [[UIImageView alloc] initWithFrame:CGRectMake(brandX, 10.0, 25.0, 25.0)];
        if ([brand.brandCode isEqualToString:@"JJHOTEL"])
        {
            brandImageView.image = [UIImage imageNamed:@"jinjianghotel.png"];
        }
        else if ([brand.brandCode isEqualToString:@"SHANGYUE"])
        {
            brandImageView.image = [UIImage imageNamed:@"shangyue.png"];
        }
        else if ([brand.brandCode isEqualToString:@"JJINN"])
        {
            brandImageView.image = [UIImage imageNamed:@"jinjiangstart.png"];
        }
        else if ([brand.brandCode isEqualToString:@"BESTAY"])
        {
            brandImageView.image = [UIImage imageNamed:@"baishikuaijie.png"];
        }
        else if ([brand.brandCode isEqualToString:@"BYL"])
        {
            brandImageView.image = [UIImage imageNamed:@"baiyulan.png"];
        }
        else if ([brand.brandCode isEqualToString:@"JG"])
        {
            brandImageView.image = [UIImage imageNamed:@"jinguangkuaijie.png"];
        }

        [cell.contentView addSubview:brandImageView];
    }

}

- (void)cellForRowOfPriceRange:(UITableViewCell *)cell navigation:(HotelFilterNavigation *)navigation
{
    PriceRange *priceRange = TheAppDelegate.hotelSearchForm.priceRange;
    cell.imageView.image = [UIImage imageNamed:@"filter_price.png"];
    [self setDefaultTextLabel:cell navigation:navigation defaultValue:@"不限"];
    if (priceRange.lsSelected)
    {
        priceRange.lsSelected = YES;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@    ", priceRange.textShow];
    }
}

- (void)setDefaultTextLabel:(UITableViewCell *)cell
                 navigation:(HotelFilterNavigation *)navigation
               defaultValue:(NSString*) defaultValue
{
    cell.detailTextLabel.text = @"";
    cell.textLabel.text = [NSString stringWithFormat:@"%@", navigation.name];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    const unsigned int row = indexPath.row;
    HotelFilterNavigation *navigation = [self.navigationArray objectAtIndex:row];
    [self.handleSelectedNavigationDelegate selectedNavigation:navigation];
    [[tableView cellForRowAtIndexPath:indexPath] setSelected:NO];
}

@end