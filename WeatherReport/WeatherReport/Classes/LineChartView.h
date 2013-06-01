//
//  LineChartView.h
//  WeatherReport
//
//  Created by jerry on 13-4-24.
//  Copyright (c) 2013年 jerry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "ModelWeather.h"

@interface LineChartView : UIView

//横竖轴距离间隔
@property (assign) NSInteger hInterval;
@property (assign) NSInteger vInterval;

@property (nonatomic, strong) NSArray *vDesc;

@property(nonatomic, strong) ModelWeather *weather;
@property(nonatomic, strong) NSMutableArray *dateAryDesc;
@property(nonatomic, strong) NSMutableArray *weekAryDesc;

@property(nonatomic, strong) NSMutableArray *lowTempAry;
@property(nonatomic, strong) NSMutableArray *highTempAry;



//点信息
@property (nonatomic, strong) NSArray *array;

@end
