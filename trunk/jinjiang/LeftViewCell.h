//
//  LeftViewCell.h
//  jinjiang
//
//  Created by Jeff.Yan on 11-11-14.
//  Copyright 2011年 W+K. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LeftViewCellDelegate;

@interface LeftViewCell : UIControl {
    UIView *overView;
    UIView *outView;
    id <LeftViewCellDelegate> delegate;
}
@property (nonatomic, assign) id <LeftViewCellDelegate> delegate;
-(void)selectEd:(BOOL)b a:(BOOL)a;
-(void)selectEd:(BOOL)b;
-(void)setData:(id)d index:(NSInteger)si;
@end
@protocol LeftViewCellDelegate
-(void)selectView:(LeftViewCell *)lvc;
@end