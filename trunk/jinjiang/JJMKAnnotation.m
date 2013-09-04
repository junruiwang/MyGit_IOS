//
//  JJMKAnnotation.m
//  jinjiang
//
//  Created by Jeff.Yan on 11-11-5.
//  Copyright 2011年 W+K. All rights reserved.
//

#import "JJMKAnnotation.h"
#import <objc/runtime.h>

@implementation JJMKAnnotation

@synthesize title,subtitle,dic,theCoordinate;

- (CLLocationCoordinate2D)coordinate;
{
    return theCoordinate; 
    
    
}
- (void)dealloc
{
    
    self.dic=nil;
    title=nil;
    subtitle=nil;
    
    [super dealloc];
}
-(id)initWithInfo:(NSDictionary *)_dic{
    self=[super init];
    if(self!=nil){
      
        
        CLLocationCoordinate2D _theCoordinate;
        NSLog(@"dic:::::::%@",_dic);
        _theCoordinate.latitude=[[_dic objectForKey:@"HotelLatitude"] floatValue];//31.230393;
        _theCoordinate.longitude=[[_dic objectForKey:@"HotelLongitude"] floatValue];//121.473704;
       theCoordinate=_theCoordinate;

        self.dic=_dic;
        title=[_dic objectForKey:@"HotelName"];
        subtitle=[_dic objectForKey:@"HotelAddress"];
         NSLog(@"--------------");
    }
    return(self);
}
-(id)initWithInfo:(CLLocationCoordinate2D)_theCoordinate setTitle:(NSString *)_tt setSub:(NSString *)_ss{
    self=[super init];
    if(self!=nil){
        theCoordinate=_theCoordinate;
        self.dic=nil;
        title=_tt;
        subtitle=_ss;
        
    }
    return(self);
}

// required if you set the MKPinAnnotationView's "canShowCallout" property to YES


@end