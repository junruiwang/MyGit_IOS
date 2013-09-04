//
//  PriceRange.m
//  JinJiangTravelPlus
//
//  Created by huguiqi on 11/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

@implementation PriceRange

- (id)initWithMinPrice:(NSString *)minPrice maxPrice:(NSString *)maxPrice
{
    self = [super init];
    if (self) {
        _minPrice = minPrice;
        _maxPrice = maxPrice;
        _lsSelected = NO;
    }
    return self;
}

+ (NSArray *)getPriceList {
    PriceRange *noPrice = [[PriceRange alloc] initWithMinPrice:nil maxPrice:nil];
    noPrice.textShow = @"不限";
    PriceRange *priceRange1 = [[PriceRange alloc] initWithMinPrice:@"0" maxPrice:@"100"];
    priceRange1.textShow = [NSString stringWithFormat:@"%@元以下",priceRange1.maxPrice];
    PriceRange *priceRange2 = [[PriceRange alloc] initWithMinPrice:@"100" maxPrice:@"300"];
    priceRange2.textShow = [NSString stringWithFormat:@"%@元-%@元",priceRange2.minPrice,priceRange2.maxPrice];
    PriceRange *priceRange3 = [[PriceRange alloc] initWithMinPrice:@"300" maxPrice:@"500"];
    priceRange3.textShow = [NSString stringWithFormat:@"%@元-%@元",priceRange3.minPrice,priceRange3.maxPrice];
    PriceRange *priceRange4 = [[PriceRange alloc] initWithMinPrice:@"500" maxPrice:nil];
    priceRange4.textShow = [NSString stringWithFormat:@"%@元以上",priceRange4.minPrice];
    return  [NSArray arrayWithObjects:noPrice,priceRange1,priceRange2,priceRange3,priceRange4,nil];
}

- (BOOL) isDefault
{
    return [self.textShow isEqualToString:@"不限"];
}


@end
