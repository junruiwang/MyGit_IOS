//
//  ConditionTableDelegate.m
//  JinJiangTravelPlus
//
//  Created by 胡 桂祁 on 11/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ConditionTableDelegate.h"
#import "HotelFilterNavigation.h"
#import "AreaInfo.h"

@interface ConditionTableDelegate ()
@end

@implementation ConditionTableDelegate

- (id)init {
    self = [super init];
    if (self) {
        NSArray *priceList = [PriceRange getPriceList];
        NSArray *brandList = [Brand getBrandList];
        NSArray *startList = [StarLevel getStarLevelList];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:priceList, PRICE_CODE, brandList, BRAND_CODE, startList, STAR_CODE, nil];
        self.dic = dic;
    }
    return self;
}

- (void)setAreaList :(NSMutableArray *)areaList {
    if(areaList && [areaList count] && ![((AreaInfo *)areaList [0]).name isEqualToString:@"全部区域"]){
        AreaInfo *area = [[AreaInfo alloc] initWithName:@"全部区域"];
        [areaList insertObject:area atIndex:0];
    }
    [self.dic setValue:areaList forKey:AREA_CODE];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [(NSArray *) [self.dic objectForKey:self.hotelFilterNavigation.code] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//    if (cell == nil)
//    {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//    }
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.textLabel.font = [UIFont systemFontOfSize:18];
    const unsigned int row = indexPath.row;
    NSString *tagertKey = self.hotelFilterNavigation.code;
    id idObj = [(NSArray *) [self.dic objectForKey:tagertKey] objectAtIndex:row];

    if ([self isBrand])
    {
        Brand *brand = (Brand *)idObj;

        UIImageView *brandImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 25, 25)];
        brandImage.image = [UIImage imageNamed:brand.brandImage];
        [cell addSubview:brandImage];

        UILabel *brandLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 10, 180, 25)];
        brandLabel.font = [UIFont systemFontOfSize:18];
        brandLabel.text = brand.brandName;
        [cell addSubview:brandLabel];

//        cell.textLabel.text = brand.brandName;
        return cell;
    }

    cell.imageView.image = nil;
    if ([self isArea])
    {
        AreaInfo *area = (AreaInfo *)idObj;
        cell.textLabel.text = area.name;
        return cell;
    }
    if ([self isPrice])
    {
        PriceRange *priceRange = (PriceRange *) idObj;
        cell.textLabel.text = priceRange.textShow;
        return cell;
    }

    if ([self isStar])
    {
        StarLevel *starLevel = (StarLevel *) idObj;
        cell.textLabel.text = starLevel.textShow;
        return cell;
    }
    NSString *cellText = idObj;
    cell.textLabel.text = cellText;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[tableView cellForRowAtIndexPath:indexPath] setSelected:NO];
    const unsigned int row = [indexPath row];
    NSString *tagertKey = self.hotelFilterNavigation.code;
    id idObj = [(NSArray *) [self.dic objectForKey:tagertKey] objectAtIndex:row];

    if ([self isPrice])
    {
        TheAppDelegate.hotelSearchForm.priceRange = (PriceRange *)idObj;

        if ([((PriceRange *)idObj).textShow rangeOfString:@"不限"].location != NSNotFound)
        {   TheAppDelegate.hotelSearchForm.priceRange = nil; }

        if (![TheAppDelegate.hotelSearchForm.priceRange isDefault])
        {   TheAppDelegate.hotelSearchForm.priceRange.lsSelected = YES; }
        [self.conditionTableCellDelegate selectedConditionValue:idObj];

        return;
    }

    if ([self isStar])
    {
        TheAppDelegate.hotelSearchForm.starLevel = (StarLevel *)idObj;

        if ([((StarLevel *)idObj).textShow rangeOfString:@"不限"].location != NSNotFound)
        {   TheAppDelegate.hotelSearchForm.starLevel = nil; }

        if (![TheAppDelegate.hotelSearchForm.starLevel isDefault])
        {   TheAppDelegate.hotelSearchForm.starLevel.isSelected = YES;  }

        [self.conditionTableCellDelegate selectedConditionValue:idObj];

        return;
    }

    if ([self isBrand])
    {
        TheAppDelegate.hotelSearchForm.hotelBrand = (Brand *)idObj;

        if ([((Brand *)idObj).brandName isEqualToString:@"全部品牌"])
        {   TheAppDelegate.hotelSearchForm.hotelBrand = nil;    }

        if (![TheAppDelegate.hotelSearchForm.hotelBrand isDefault])
        {   TheAppDelegate.hotelSearchForm.hotelBrand.isSelected = YES; }

        [self.conditionTableCellDelegate selectedConditionValue:((Brand *)idObj).brandName];

        return;
    }
    if ([self isArea])
    {
        TheAppDelegate.hotelSearchForm.area = ((AreaInfo *)idObj).name;

        if ([((AreaInfo *)idObj).name rangeOfString:@"全部"].location != NSNotFound)
        {   TheAppDelegate.hotelSearchForm.area = nil; }

        [self.conditionTableCellDelegate selectedConditionValue:idObj];

        return;
    }
}

- (BOOL)isArea
{
    return self.hotelFilterNavigation.code != nil && [self.hotelFilterNavigation.code isEqualToString:AREA_CODE];
}

- (BOOL)isBrand
{
    return self.hotelFilterNavigation.code != nil && [self.hotelFilterNavigation.code isEqualToString:BRAND_CODE];
}

- (BOOL)isPrice
{
    return self.hotelFilterNavigation.code != nil && [self.hotelFilterNavigation.code isEqualToString:PRICE_CODE];
}

- (BOOL)isStar
{
    return self.hotelFilterNavigation.code != nil && [self.hotelFilterNavigation.code isEqualToString:STAR_CODE];
}

@end
