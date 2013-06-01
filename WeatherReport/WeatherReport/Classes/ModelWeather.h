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
@property (nonatomic, copy)  NSString *_23img2;
@property (nonatomic, copy)  NSString *_24img3;
@property (nonatomic, copy)  NSString *_25img4;
@property (nonatomic, copy)  NSString *_26img5;
@property (nonatomic, copy)  NSString *_27img6;
@property (nonatomic, copy)  NSString *_28img7;
@property (nonatomic, copy)  NSString *_29img8;
@property (nonatomic, copy)  NSString *_30img9;
@property (nonatomic, copy)  NSString *_31img10;
@property (nonatomic, copy)  NSString *_32img11;
@property (nonatomic, copy)  NSString *_33img12;
//天气图标标题
@property (nonatomic, copy)  NSString *_34img_title1;
@property (nonatomic, copy)  NSString *_35img_title2;
@property (nonatomic, copy)  NSString *_36img_title3;
@property (nonatomic, copy)  NSString *_37img_title4;
@property (nonatomic, copy)  NSString *_38img_title5;
@property (nonatomic, copy)  NSString *_39img_title6;
@property (nonatomic, copy)  NSString *_40img_title7;
@property (nonatomic, copy)  NSString *_41img_title8;
@property (nonatomic, copy)  NSString *_42img_title9;
@property (nonatomic, copy)  NSString *_43img_title10;
@property (nonatomic, copy)  NSString *_44img_title11;
@property (nonatomic, copy)  NSString *_45img_title12;
//风速描述
@property (nonatomic, copy)  NSString *_46wind1;
@property (nonatomic, copy)  NSString *_47wind2;
@property (nonatomic, copy)  NSString *_48wind3;
@property (nonatomic, copy)  NSString *_49wind4;
@property (nonatomic, copy)  NSString *_50wind5;
@property (nonatomic, copy)  NSString *_51wind6;
//风速级别描述
@property (nonatomic, copy)  NSString *_52fl1;
@property (nonatomic, copy)  NSString *_53fl2;
@property (nonatomic, copy)  NSString *_54fl3;
@property (nonatomic, copy)  NSString *_55fl4;
@property (nonatomic, copy)  NSString *_56fl5;
@property (nonatomic, copy)  NSString *_57fl6;
//今日穿衣指数
@property (nonatomic, copy)  NSString *_58index;
@property (nonatomic, copy)  NSString *_59index_d;
@property (nonatomic, copy)  NSString *_60index48;
@property (nonatomic, copy)  NSString *_61index48_d;
//今日紫外线
@property (nonatomic, copy)  NSString *_62index_uv;
@property (nonatomic, copy)  NSString *_63index48_uv;
//今日洗车指数
@property (nonatomic, copy)  NSString *_64index_xc;
//今日旅游指数
@property (nonatomic, copy)  NSString *_65index_tr;
//今日舒适指数
@property (nonatomic, copy)  NSString *_66index_co;
//今日晨练指数
@property (nonatomic, copy)  NSString *_67index_cl;
//今日晾晒指数
@property (nonatomic, copy)  NSString *_68index_ls;
//今日过敏指数
@property (nonatomic, copy)  NSString *_69index_ag;

@end
