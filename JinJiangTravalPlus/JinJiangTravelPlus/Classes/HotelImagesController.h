//
//  HotelImagesController.h
//  JinJiangTravelPlus
//
//  Created by 吕 硕 on 12-12-17.
//  Copyright (c) 2012年 JinJiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HotelOverviewParser.h"
#import "JJViewController.h"

@interface HotelImagesController : JJViewController<UIScrollViewDelegate>
{
    int _hotelId, _index;
    BOOL _pageControlUsed;
    BOOL _bigImageShowing;
    HotelOverviewParser* _hotelOverviewParser;
    UIScrollView*   _smlScrollView;
    UIScrollView*   _bigScrollView;
    UIPageControl*  _pageControl;
    UILabel*        _numberLabel;
    UILabel*        _titleLabel;
    UIImageView*    _bigImgView;
    NSMutableArray* _imageURLarray;
    NSMutableArray* _titleStrArray;
    NSMutableArray* _imagesArray;

    UIPinchGestureRecognizer* pinchImg;
    UIRotationGestureRecognizer* imgRotate;
    UIPanGestureRecognizer* imgPanGes;
}
@property(nonatomic) int hotelId;
@property(nonatomic, strong)HotelOverviewParser* hotelOverviewParser;
@property(nonatomic, strong)UIScrollView*   bigScrollView;
@property(nonatomic, strong)UIScrollView*   smlScrollView;
@property(nonatomic, strong)UIImageView*    bigImgView;
@property(nonatomic, strong)UIPageControl*  pageControl;
@property(nonatomic, strong)NSMutableArray* imageURLarray;
@property(nonatomic, strong)NSMutableArray* titleStrArray;
@property(nonatomic, strong)NSMutableArray* imagesArray;
@property(nonatomic, strong)UILabel* titleLabel;
@property(nonatomic, strong)UILabel* titleLabel2;
@property(nonatomic, strong)UILabel* numberLabel;

- (IBAction)changePage:(id)sender;

@end
