//
//  TableSelectButton.h
//  JinJiangTravelPlus
//
//  Created by 胡 桂祁 on 3/13/13.
//  Copyright (c) 2013 JinJiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableSelectButton : UIButton

@property (nonatomic) BOOL isChecked;
@property (nonatomic) unsigned int currentIndex;
@property (nonatomic,copy) NSString *unSelectImgName;
@property (nonatomic,copy) NSString *selectImgName;

-(void)resetSelectStatus;
-(void)selectBtn;
-(void)unSelectBtn;

- (id)initWithFrame:(CGRect)frame unSelectImgName:(NSString *)imgName1 selectImgName:(NSString *)imgName2;

@end
