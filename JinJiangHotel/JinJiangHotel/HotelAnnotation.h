//
//  HotelAnnotation.h
//  storyboardTest
//
//  Created by 胡 桂祁 on 8/26/13.
//  Copyright (c) 2013 huguiqi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "JJHotel.h"

@interface HotelAnnotation : NSObject<MKAnnotation>

@property(nonatomic) CLLocationCoordinate2D theCoordinate;
@property(nonatomic,strong) JJHotel *hotel;
@property (nonatomic, strong) UIImage *topImage;





@end
