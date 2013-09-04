//
//  StarLevel.h
//  JinJiangTravelPlus
//
//  Created by huguiqi on 11/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//



@interface StarLevel : NSObject

@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *textShow;
@property BOOL isSelected;
- (id)initWithCode:(NSString *)code textShow:(NSString *)textShow;
+(NSArray *)getStarLevelList;
- (BOOL) isDefault;
@end
