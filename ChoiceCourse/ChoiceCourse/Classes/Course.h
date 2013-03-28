//
//  Course.h
//  ChoiceCourse
//
//  Created by 汪君瑞 on 12-11-6.
//  Copyright (c) 2012年 jerry. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Course : NSObject


@property(nonatomic, copy) NSString *courseName;
@property(nonatomic, copy) NSString *bookable;
@property(nonatomic, copy) NSString *type_name;
@property(nonatomic, copy) NSString *type_image;
@property(nonatomic, copy) NSString *courseSpeaker;
@property(nonatomic, copy) NSString *courseStartTime;
@property(nonatomic, copy) NSString *maxTraineeAmount;
@property(nonatomic, copy) NSString *enrollEndTime;
@property(nonatomic, copy) NSString *courseDescription;


@property(nonatomic, copy) NSString *startDate;
@property(nonatomic, copy) NSString *endDate;

@end
