//
//  TableSelectButton.m
//  JinJiangTravelPlus
//
//  Created by 胡 桂祁 on 3/13/13.
//  Copyright (c) 2013 JinJiang. All rights reserved.
//

#import "TableSelectButton.h"


@implementation TableSelectButton

- (id)initWithFrame:(CGRect)frame unSelectImgName:(NSString *)imgName1 selectImgName:(NSString *)imgName2
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.isChecked = NO;
        self.tag = 0;
        self.unSelectImgName = imgName1;
        self.selectImgName = imgName2;
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:imgName1]];
    }
    return self;
}

-(BOOL) isChecked
{
    return  self.tag%2==0?NO:YES;
}

-(void)resetSelectStatus
{
    self.isChecked = NO;
    self.tag = 0;
    self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:self.unSelectImgName]];
}

-(void)selectBtn
{
    self.isChecked = YES;
    self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:self.selectImgName]];
}

-(void)unSelectBtn
{
    self.isChecked = NO;
    self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:self.unSelectImgName]];
}

@end
