//
//  JJNavigationButton.m
//  JinJiangTravelPlus
//
//  Created by Raphael.rong on 13-4-23.
//  Copyright (c) 2013年 JinJiang. All rights reserved.
//

#import "JJNavigationButton.h"
#import <MapKit/MapKit.h>

@implementation JJNavigationButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
//        [self setBackgroundImage:[UIImage imageNamed:@"passbook_btn.png"] forState:UIControlStateNormal];
    }
    return self;
}

- (void)clickToNavigation:(JJHotel *)hotel
{
    if (hotel) {
        if ([[NSUserDefaults standardUserDefaults] floatForKey:USER_DEVICE_VERSION] < 6.0){
            UIApplication *app = [UIApplication sharedApplication];
            NSString *daddr = [NSString stringWithFormat:@"%f,%f", hotel.coordinate.latitude, hotel.coordinate.longitude];
            NSString *saddr = [NSString stringWithFormat:@"%f,%f", TheAppDelegate.locationInfo.currentPoint.latitude, TheAppDelegate.locationInfo.currentPoint.longitude];
            NSString *mapsURL = [NSString stringWithFormat:@"http://maps.apple.com/maps?saddr=%@&daddr=%@",saddr, daddr];
            [app openURL:[NSURL URLWithString:mapsURL]];
//            [[UIApplication sharedApplication] openURL:]];
        } else {
            MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:hotel.coordinate addressDictionary:nil];
            MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
            mapItem.name = hotel.name;
            mapItem.phoneNumber = hotel.telphone;
            NSArray *mapItemArray = @[ mapItem ];
            NSDictionary *launchOpt = @{ MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving };
            [MKMapItem openMapsWithItems:mapItemArray launchOptions:launchOpt];
        }
    }
}

@end
