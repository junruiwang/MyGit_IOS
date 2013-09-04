//
//  SearchResultTVC.h
//  jinjiang
//
//  Created by Jeff.Yan on 11-11-16.
//  Copyright 2011年 W+K. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "LeftViewCell.h"

@interface SearchResultTVC : LeftViewCell {
    NSDictionary *data;
    UILabel *nameTxt;
    UILabel *infoTxt;
}
@end
