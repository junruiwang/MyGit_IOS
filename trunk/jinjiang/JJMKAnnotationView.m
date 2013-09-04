//
//  JJMKAnnotationView.m
//  jinjiang
//
//  Created by Jeff.Yan on 11-11-5.
//  Copyright 2011年 W+K. All rights reserved.
//

#import "JJMKAnnotationView.h"
#import "GlobalFunction.h"
#import "JJMKAnnotation.h"

@implementation JJMKAnnotationView

@synthesize jjAnn;

static JJMKAnnotationView *selectAnn=nil;
-(void)killInfo{
    [self setSelected:NO animated:YES];
    //RemoveRelease(annInfoView);
}
-(void)setHighlighted:(BOOL)highlighted{
    [imageBtn setHighlighted:highlighted];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    UIView *view;
    if(annInfoView!=nil){
        CGPoint newPoint=CGPointMake(point.x-annInfoView.frame.origin.x, point.y-annInfoView.frame.origin.y);
        view=[annInfoView hitTest:newPoint withEvent:event];
        if(view!=nil)[GlobalFunction closeTouch];
        return(view);
    }else{
        
        return([super hitTest:point withEvent:event]);
    }
    
}


-(void)selectClick{
        
}
-(NSDictionary *)getDic{
     if(jjAnn!=nil){
         return jjAnn.dic;
     }
   
    return nil;

}
-(void)setSelected:(BOOL)selected{
     
    [super setSelected:selected];
    if(selected){
       
        if(selectAnn==self){
            return;
        }
        selectAnn=self;
        if(jjAnn!=nil){
            if(annInfoView!=nil){
                [annInfoView removeOut];
                Release2Nil(annInfoView);
            }
            annInfoView=[[AnnInfoView alloc] initWithDic:jjAnn.dic];
            [self addSubview:annInfoView];
        }
        [self setHighlighted:YES];
        //self.bounds=CGRectMake(-264, -134, 382+20, 149+20);
    }else{
        //*
        //NSLog(@"22");
        if(selectAnn==self){
            selectAnn=nil;
        }
        if(annInfoView!=nil){
            [annInfoView removeOut];
            Release2Nil(annInfoView);
        }
        [self setHighlighted:NO];
        // */
        //self.bounds=CGRectMake(-10, -10, 46, 55);
    }
}
-(void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];
}
-(void)moveIn{
    imageBtn.frame=CGRectMake(0, -500, 26, 35);
    [GlobalFunction moveView:imageBtn to:CGRectMake(0, 0, 26, 35) time:0.3f];//-13, -35, 26, 35
}
- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
    
        self.bounds=CGRectMake(-10, -10, 46, 55);
        self.backgroundColor = [UIColor clearColor];
        imageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        jjAnn=(JJMKAnnotation *)annotation;
        
       // NSLog(@"jjAnn::::::%@:::%@",jjAnn,jjAnn.dic);
        
        [imageBtn setImage:[UIImage imageNamed:@"5_make_out.png"] forState:UIControlStateNormal];
        [imageBtn setImage:[UIImage imageNamed:@"5_make_over.png"] forState:UIControlStateHighlighted];
        
        //[imageBtn addTarget:self action:@selector(selectClick) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:imageBtn];
    }
    
    return self;
}
- (void)dealloc
{
    if(selectAnn==self){
        selectAnn=nil;
    }
    if(annInfoView!=nil){
        [annInfoView removeOut];
        Release2Nil(annInfoView);
    }

    Remove2Nil(imageBtn);
    [super dealloc];
}
@end
