//
//  ModelWeather.h
//  WeatherReport
//
//  Created by 汪君瑞 on 13-5-19.
//  Copyright (c) 2013年 jerry. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModelWeather : NSObject
//当日状况
@property (nonatomic, copy)  NSString *_1city;
@property (nonatomic, copy)  NSString *_2cityid;
@property (nonatomic, copy)  NSString *_3time;
@property (nonatomic, copy)  NSString *_4temp;
@property (nonatomic, copy)  NSString *_5WD;
@property (nonatomic, copy)  NSString *_6WS;
@property (nonatomic, copy)  NSString *_7SD;
@property (nonatomic, copy)  NSString *_8date_y;
@property (nonatomic, copy)  NSString *_9week;
//摄氏温度区间
@property (nonatomic, copy)  NSString *_10temp1;
@property (nonatomic, copy)  NSString *_11temp2;
@property (nonatomic, copy)  NSString *_12temp3;
@property (nonatomic, copy)  NSString *_13temp4;
@property (nonatomic, copy)  NSString *_14temp5;
@property (nonatomic, copy)  NSString *_15temp6;
//天气信息
@property (nonatomic, copy)  NSString *_16weather1;
@property (nonatomic, copy)  NSString *_17weather2;
@property (nonatomic, copy)  NSString *_18weather3;
@property (nonatomic, copy)  NSString *_19weather4;
@property (nonatomic, copy)  NSString *_20weather5;
@property (nonatomic, copy)  NSString *_21weather6;
//天气图标
@property (nonatomic, copy)  NSString *_22img1;
@property (nonatomic, copy)  NSString *_23img3;
@property (nonatomic, copy)  NSString *_24img5;
@property (nonatomic, copy)  NSString *_25img7;
@property (nonatomic, copy)  NSString *_26img9;
@property (nonatomic, copy)  NSString *_27img11;
//风速描述
@property (nonatomic, copy)  NSString *_28wind1;
@property (nonatomic, copy)  NSString *_29wind2;
@property (nonatomic, copy)  NSString *_30wind3;
@property (nonatomic, copy)  NSString *_31wind4;
@property (nonatomic, copy)  NSString *_32wind5;
@property (nonatomic, copy)  NSString *_33wind6;
//风速级别描述
@property (nonatomic, copy)  NSString *_34fl1;
@property (nonatomic, copy)  NSString *_35fl2;
@property (nonatomic, copy)  NSString *_36fl3;
@property (nonatomic, copy)  NSString *_37fl4;
@property (nonatomic, copy)  NSString *_38fl5;
@property (nonatomic, copy)  NSString *_39fl6;
//今日穿衣指数
@property (nonatomic, copy)  NSString *_40index_d;
//今日紫外线
@property (nonatomic, copy)  NSString *_41index_uv;
//今日洗车指数
@property (nonatomic, copy)  NSString *_42index_xc;
//今日旅游指数
@property (nonatomic, copy)  NSString *_43index_tr;
//今日舒适指数
@property (nonatomic, copy)  NSString *_44index_co;
//今日晨练指数
@property (nonatomic, copy)  NSString *_45index_cl;
//今日晾晒指数
@property (nonatomic, copy)  NSString *_46index_ls;
//今日过敏指数
@property (nonatomic, copy)  NSString *_47index_ag;

@end
