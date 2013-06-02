//
//  WeatherForecastViewController.h
//  WeatherReport
//
//  Created by jerry on 13-4-24.
//  Copyright (c) 2013年 jerry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BannerViewController.h"
#import "BaseParser.h"
#import "CityManagerViewController.h"

@interface WeatherForecastViewController : BannerViewController<BaseParserDelegate, UIScrollViewDelegate, CityManagerControllerDelegate>

@property (nonatomic, assign) float screenWidth;
@property (nonatomic, assign) float screenHeight;
@property (nonatomic, strong) NSMutableArray *remainCityModel;
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIScrollView *bottomScrollView;
@property (nonatomic, strong) UILabel *cityLabel;

@end
