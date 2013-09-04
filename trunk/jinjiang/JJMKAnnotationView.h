//
//  JJMKAnnotationView.h
//  jinjiang
//
//  Created by Jeff.Yan on 11-11-5.
//  Copyright 2011年 W+K. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "JJMKAnnotation.h"
#import "AnnInfoView.h"

@interface JJMKAnnotationView : MKAnnotationView {
    UIButton *imageBtn;
    JJMKAnnotation *jjAnn;
    AnnInfoView *annInfoView;
}
@property  (nonatomic,assign)JJMKAnnotation *jjAnn;
-(void)killInfo;
-(void)moveIn;
-(NSDictionary *)getDic;
-(void)setSelected:(BOOL)selected;
@end
