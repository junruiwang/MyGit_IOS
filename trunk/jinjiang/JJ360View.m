//
//  JJ360View.m
//  jinjiang
//
//  Created by Jeff.Yan on 11-11-6.
//  Copyright 2011年 W+K. All rights reserved.
//
#import <CoreMotion/CoreMotion.h>

#import "JJ360View.h"



#import "JJ360VC.h"

#import "GlobalFunction.h"
#import "MainNC.h"
#import "NavigationView.h"
#import "jinjiangViewController.h"
//#import "WebTouchView.h"


#import "ControlView.h"


@implementation JJ360View

-(void)readDataFromFileFun:(NSString *)fileName{
    
    
    NSArray *pathsFile = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [pathsFile objectAtIndex:0];
    
    if (!documentsDirectory) {
        
        return;  
    }
    
    
    NSString *appFile = [documentsDirectory stringByAppendingPathComponent:fileName];
    
    NSFileManager *file_manager = [NSFileManager defaultManager];
    if (![file_manager fileExistsAtPath:appFile]){
        return;  
    }
    
    NSString *strData=[[NSString alloc] initWithContentsOfFile:appFile encoding:NSUTF8StringEncoding error:nil];
    
    if(strData==nil){
        
        
    }else{
        //NSLog(@"strData::::%@",strData);
        [webView loadHTMLString:strData baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
    }
    
    [strData release];
    
    
    
    
}
-(void)setRotate:(NSString *)rotate{
    if(temWebView){
        CGAffineTransform transform=CGAffineTransformRotate(CGAffineTransformIdentity, [rotate floatValue]);
        temWebView.transform=transform;
        d3dR=[rotate floatValue];
    }
}
static CGFloat rPi=180.0/3.14159265;

-(void)initMotion{
    if(motionManager){
        [motionManager stopDeviceMotionUpdates];
        [motionManager stopAccelerometerUpdates];
        [motionManager stopMagnetometerUpdates];
    }
    Release2Nil(motionManager);
    
    motionManager=[[CMMotionManager alloc] init];
    if(motionManager.isDeviceMotionAvailable){
        motionManager.deviceMotionUpdateInterval=1.0/30.0;
        [motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMDeviceMotion *motion,NSError*error)  
         {
             CMAttitude *attitude=motion.attitude;  
             // 
             // if(temWebView){
             CMRotationMatrix rotation = attitude.rotationMatrix;
             //fabs(attitude.roll)>0.3
             CGFloat yaw=attitude.yaw;//*rPi;
             CGFloat roll=attitude.roll;//*rPi;
             CGFloat pitch=attitude.pitch;
             
             CGFloat tx=rotation.m13*100;
             CGFloat ty=rotation.m23*100;
             CGFloat tz=rotation.m33*100;
             
             /*
              CGFloat tx2=rotation.m11*100;
              CGFloat ty2=rotation.m21*100;
              CGFloat tz2=rotation.m31*100;
              */
             /*
              CGFloat m11=rotation.m11;
              CGFloat m12=rotation.m12;
              CGFloat m13=rotation.m13;
              CGFloat m21=rotation.m21;
              CGFloat m22=rotation.m22;
              CGFloat m23=rotation.m23;
              CGFloat m31=rotation.m31;
              CGFloat m32=rotation.m32;
              CGFloat m33=rotation.m33;
              
              CGFloat ry=100*((m21*m13-m23*m11)/(m31*m23*m12-m31*m22*m13+m32*m21*m13-m32*m23*m11+m33*m22*m11-m33*m21*m12));
              */
             //CGFloat rx;
             
             // rx=atan2(sqrt(tz*tz+tx*tx),ty);
             
             // CGFloat ry=atan2(sqrt(tz*tz+tx*tx),ty);
             CGFloat rz=atan2(sqrt(ty*ty+tx*tx),tz);
             
             // rotation.m11*x+rotation.m12*y+rotation.m13*z=0;
             // rotation.m21*x+rotation.m22*y+rotation.m23*z=0;
             // rotation.m31*x+rotation.m32*y+rotation.m33*z=100;
             
             
             CGFloat yaw2=-yaw*rPi;//*cos(pitch)-roll*sin(pitch);
             
             CGFloat roll2=rz*rPi;//(roll*cos(pitch)+pitch*cos(roll))*rPi;
             
             //CGFloat pitch2=pitch*rPi;
             
             //NSLog(@"%f::%f::%f::%f:%f",tx,ty,tz,roll2,yaw2); 
             //roll2=atan(ty/100);
             
             // NSLog(@"%f::%f::%f::%f::%f",yaw*rPi,roll*rPi,pitch*rPi,yaw2,roll2); 
             //Yaw（左右摇摆）Roll（左右倾斜）、Pitch（前后倾斜）
             if(fabs(roll2)>30){
                 //webView
                 roll2=90-roll2;
                 ///*
                 
                 if(fabs(roll2)>90){
                     //roll=
                     yaw2+=180;
                     if(roll2>90)
                         roll2=-180+roll2;
                     if(roll<-90)
                         roll2=180+roll2;
                 }
                 //*/
                 //webView.userInteractionEnabled=NO;
                 //[self setRotate:pitch];
                 [self performSelectorOnMainThread:@selector(setRotate:) withObject:[NSString stringWithFormat:@"@f",pitch] waitUntilDone:NO];
                 [self performSelectorOnMainThread:@selector(stringByEvaluatingJavaScriptFromString:) withObject:[NSString stringWithFormat:@"lookAt(%f,%f);",yaw2, roll2] waitUntilDone:NO];
                 //[webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"lookAt(%f,%f);",yaw2, roll2]]; 
             }else{
                 //webView.userInteractionEnabled=YES;
                 [self performSelectorOnMainThread:@selector(setRotate:) withObject:[NSString stringWithFormat:@"@f",d3dR/3.0*2.0] waitUntilDone:NO];
                 //[self setRotate:d3dR/3.0*2.0];
                 //[webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"setTest(%d);",1]];
             }
             //}
             
         }];
    }
}
-(void)stringByEvaluatingJavaScriptFromString:(NSString *)str{
    if(temWebView){
        [temWebView stringByEvaluatingJavaScriptFromString:str];
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        openXY=NO;
        
        self.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"1_bg.png"]];
        motionManager=nil;
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            [self initMotion];
        
    }
    return self;
}

- (void)webViewDidStartLoad:(UIWebView *)webView2{
    if(webView)webView.alpha=0;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView2{
    
    if(webView)[GlobalFunction fadeInOut:webView to:1 time:0.4 hide:NO];
    temWebView=webView;
}


-(void)toScene:(NSString *)name{
    //if(webView){
    //[webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"toScene('%@');",name]];
    //}
    temWebView=nil;
    if(webView){
        [webView stopLoading];
        webView.delegate=nil;
        
    }
    RemoveRelease(webView);
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        webView = [[UIWebView alloc] initWithFrame:CGRectMake((1024-1280)/2, (768-1280)/2,1280, 1280)];//1280
    }else{
        webView = [[UIWebView alloc] initWithFrame:FULLRECT];//1280
    }
    
    
    webView.delegate=self;
    
    webView.backgroundColor=[UIColor blackColor];
    //[self readDataFromFileFun:@"test.html"];    
    
    NSString *filePath = [name stringByAppendingPathComponent:@"tour.html"];
    
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:filePath]]];
    
    
    webView.alpha=0;
    
    [self addSubview:webView];
    
}

// if(motionManager)[motionManager stopDeviceMotionUpdates];
//Release2Nil(motionManager);
-(void)clearMotion{
    if(webView){
        [webView stopLoading];
        webView.delegate=nil;
        
    }
    if(motionManager){
        [motionManager stopDeviceMotionUpdates];
        [motionManager stopAccelerometerUpdates];
        [motionManager stopMagnetometerUpdates];
    }
    Release2Nil(motionManager);
}
-(void)removeFromSuperview{
    // NSLog(@"motionManager:::removeFromSuperview::::::::::removeFromSuperview");
    temWebView=nil;
    [self clearMotion];
    [super removeFromSuperview];
    
}
-(void)safeRealse{
    RemoveRelease(webView);
}
- (void)dealloc
{
    
    temWebView=nil;
    NSLog(@"jj360 3dview dealloc");
    //NSLog(@"motionManager:::dealloc::::::::::dealloc::%d",[webView retainCount]);
    [self clearMotion];
    
    if(webView){
        [webView stopLoading];
        webView.delegate=nil;
        
    }
    NSLog(@"jj360 3dview dealloc 1");
    RemoveRelease(webView);
    NSLog(@"jj360 3dview dealloc 2");
    
    
    
    /*
     if(![NSThread isMainThread])
     {
     if([self respondsToSelector:@selector(safeRealse)])
     {
     [self performSelectorOnMainThread:@selector(safeRealse)
     withObject:nil
     waitUntilDone:NO];
     }
     }else{
     RemoveRelease(webView);
     }
     */
    
    
    [super dealloc];
}

@end
