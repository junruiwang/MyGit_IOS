//
//  JJMKAnnotation.h
//  jinjiang
//
//  Created by Jeff.Yan on 11-11-5.
//  Copyright 2011年 W+K. All rights reserved.
//

#import <Foundation/Foundation.h> 
#import <MapKit/MKAnnotation.h> 


@interface JJMKAnnotation:NSObject<MKAnnotation> {
    NSString *title;
    NSString *subtitle;
    NSDictionary *dic;
    CLLocationCoordinate2D theCoordinate;
}
@property (nonatomic, readonly, copy) NSString *title;
@property (nonatomic, readonly, copy) NSString *subtitle;
@property  (nonatomic,retain)NSDictionary *dic;
@property  (nonatomic,assign)CLLocationCoordinate2D theCoordinate;
-(id)initWithInfo:(CLLocationCoordinate2D)_theCoordinate setTitle:(NSString *)_tt setSub:(NSString *)_ss;

-(id)initWithInfo:(NSDictionary *)_dic;

- (CLLocationCoordinate2D)coordinate;

@end
