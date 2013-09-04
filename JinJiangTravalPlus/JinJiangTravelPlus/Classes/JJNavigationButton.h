//
//  JJNavigationButton.h
//  JinJiangTravelPlus
//
//  Created by Raphael.rong on 13-4-23.
//  Copyright (c) 2013年 JinJiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "JJHotel.h"

@interface JJNavigationButton : UIButton

- (void)clickToNavigation:(JJHotel *)hotel;
@end
