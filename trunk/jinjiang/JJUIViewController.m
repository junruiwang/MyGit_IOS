//
//  JJUIViewController.m
//  jinjiang
//
//  Created by Jeff.Yan on 11-10-27.
//  Copyright 2011年 W+K. All rights reserved.
//

#import "JJUIViewController.h"
#import "MainNC.h"
#import "TouchPointObj.h"
#import "NavigationView.h"

#import "GlobalFunction.h"
#import "LoadingView.h"

@implementation JJUIViewController

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
   
    if(interfaceOrientation==UIInterfaceOrientationPortrait || interfaceOrientation==UIInterfaceOrientationPortraitUpsideDown){
       
        return NO;
    }else{
        if(interfaceOrientation==UIInterfaceOrientationLandscapeLeft){
            isLeft=NO;
        }else{
            isLeft=YES;
        }
        return YES;
    }
    
}
/*
 struct TouchPoint {
 CGPoint origin;
 NSInteger time;
 };
 typedef struct TouchPoint TouchPoint;
 */



-(void)outFun{
    NSLog(@"outFun");
}




- (void)loadView
{
    [super loadView];
    
    //NSLog(@"loadView::loadView");
   
    loading=nil;
    
    isLeft=NO;
    
    touchMode=0;
    tounchNum=0;
    paths=nil;
    temKeys=nil;
    
    
    self.view.multipleTouchEnabled=YES;
    
    self.view.clipsToBounds=YES;
    
    
}
- (void)viewDidLoad{
    btns=[[NSMutableArray alloc] init];
    RemoveRelease(controlView);
    controlView=[[ControlView alloc] initWithFrame:FULLRECT];
    
    [super viewDidLoad];
}
- (void)viewDidUnload{
    
    if(loading)[loading stop];
    RemoveRelease(loading);
    RemoveRelease(controlView);
    if(btns)[GlobalFunction removeViews:btns];
    Release2Nil(btns);
    [super viewDidUnload];
}
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    NSLog(@"didReceiveMemoryWarning");
    
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

//

- (void)dealloc
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    if(btns)[GlobalFunction removeViews:btns];
    Release2Nil(btns);
    Release2Nil(paths);
    Release2Nil(temKeys);
   
    
    if(loading)[loading stop];
    RemoveRelease(loading);
    RemoveRelease(controlView);
    
    RemoveRelease(cacheImage);
    
    [super dealloc];
    
}
-(void)setTouchMode:(NSInteger)mode{
    [self setTouchMode:mode point:CGPointMake(0, 0)];
}


-(void)setTouchMode:(NSInteger)mode point:(CGPoint)point{
    if(mode==0){
        [controlView showHide];
    }
}
-(void)touch1Delay{
    
}
-(void)touch2Delay{
    //NSLog(@"touch2Delay");
    if(paths!=nil){
        if([paths count]==2){
            NSArray *na=[paths allValues];
            CGFloat dis=0;
            for(NSInteger i=0;i<[na count];i++){
                dis=0;
                // NSLog(@"touch2Delay:::%d",[[na objectAtIndex:i] count]);
                for(NSInteger n=0;n<[[na objectAtIndex:i] count];n++){
                    //dis=0;
                    if(n>0){
                        TouchPointObj *p0=[[na objectAtIndex:i] objectAtIndex:n-1];
                        TouchPointObj *p1=[[na objectAtIndex:i] objectAtIndex:n];
                        dis+=[TouchPointObj calculateDis:p1.origin p0:p0.origin];
                       // NSLog(@"dis::::%f",dis );
                        if(dis>30){
                            return;
                        }
                    }
                    
                }
            }
            touchMode=2;
            [MainNC checkDelayMode:2];
            //[self endTouch];
        }
    }
}
-(void)startDelay:(NSMutableDictionary *)nd{
    if([nd count]==1){
        [self performSelector:@selector(touch1Delay) withObject:nil afterDelay:1.2f];
    }else if([nd count]==2){
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(touch1Delay) object:nil];
        NSArray *na0=[[nd allValues] objectAtIndex:0];
        NSArray *na1=[[nd allValues] objectAtIndex:1];
        TouchPointObj *p0=[na0 objectAtIndex:0];
        TouchPointObj *p1=[na1 objectAtIndex:0];
        
        if(fabs(p1.time-p0.time)<200){
           // NSLog(@"start touch2222");
            [self performSelector:@selector(touch2Delay) withObject:nil afterDelay:2.0f];
        }else{
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(touch1Delay) object:nil];
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(touch2Delay) object:nil];
            //[NSObject cancelPreviousPerformRequestsWithTarget:self];
        }
    }else  if([nd count]>2){
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(touch1Delay) object:nil];
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(touch2Delay) object:nil];
        //[NSObject cancelPreviousPerformRequestsWithTarget:self];
    }
}

-(void)checkMoveTouch:(NSSet *)touches{
    
}
-(void)checkEndTouch{
    
}
/////touch
-(void)addTouches:(NSSet *)touches{
    if(paths==nil){
        paths=[[NSMutableDictionary alloc] init];
    }
    if(temKeys==nil){
        temKeys=[[NSMutableDictionary alloc] init];
    }
    
    NSArray *ts=[touches allObjects];
    UITouch *temTouch=nil;
    NSMutableArray *temArr=nil;
    NSArray *temKey;
    NSString *key;
    TouchPointObj *startPoint;
    
    for(NSInteger i=0;i<[ts count];i++){
        temTouch=(UITouch *)[ts objectAtIndex:i];
        temKey=[temKeys allKeysForObject:temTouch];
        if([temKey count]>0){
            key=[temKey objectAtIndex:0];
        }else{
            key=Int2Str([[temKeys allValues] count]);
            tounchNum++;
            temArr=[[NSMutableArray alloc] init];
            //NSLog(@"addTouches::%@",key);
            [temKeys setObject:temTouch forKey:key];
            [paths setObject:temArr forKey:key];
            Release2Nil(temArr);
        }
        
        temArr=[paths objectForKey:key];
        startPoint=[[TouchPointObj alloc] init];
        startPoint.touch=temTouch;
        startPoint.origin=[temTouch locationInView:self.view];
        startPoint.time=temTouch.timestamp;
        
        [temArr addObject:startPoint];
        [startPoint release];
    }
    
}

-(BOOL)removeTouches:(NSSet *)touches{
    if(paths==nil || temKeys==nil){
        Release2Nil(paths);
        Release2Nil(temKeys);
        return YES;
    }
    
    NSArray *ts=[touches allObjects];
    UITouch *temTouch=nil;
    NSMutableArray *temArr=nil;
    NSArray *temKey;
    NSString *key;
    
    TouchPointObj *startPoint;
    
    for(NSInteger i=0;i<[ts count];i++){
        temTouch=(UITouch *)[ts objectAtIndex:i];
        temKey=[temKeys allKeysForObject:temTouch];
        if([temKey count]>0){
            key=[temKey objectAtIndex:0];
            startPoint=[[TouchPointObj alloc] init];
            temArr=[paths objectForKey:key];
            startPoint.touch=temTouch;
            startPoint.origin=[temTouch locationInView:self.view];
            startPoint.time=temTouch.timestamp;
            
            [temArr addObject:startPoint];
            [startPoint release];
            tounchNum--;
        }else{
            
        }
        
        
    }
    if(tounchNum<=0){
        
        return YES;
    }
    return NO;
}

- (void)touchesBeganFun:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self setTouchMode:-1];
    [self addTouches:touches];
    [self startDelay:paths];
}

- (void)touchesMovedFun:(NSSet *)touches withEvent:(UIEvent *)event {
    [self checkMoveTouch:touches];
    [self addTouches:touches];
    
}

- (void)touchesEndedFun:(NSSet *)touches withEvent:(UIEvent *)event {
    [self checkEndTouch];
    if([self removeTouches:touches]){
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(touch1Delay) object:nil];
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(touch2Delay) object:nil];
        if(touchMode==0)
            [MainNC checkPaths:paths];
        tounchNum=0;
        Release2Nil(paths);
        Release2Nil(temKeys);
        touchMode=0;
    }
}


- (void)touchesCancelledFun:(NSSet *)touches withEvent:(UIEvent *)event{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(touch1Delay) object:nil];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(touch2Delay) object:nil];
    //[NSObject cancelPreviousPerformRequestsWithTarget:self];
    tounchNum=0;
    Release2Nil(paths);
    Release2Nil(temKeys);
    //
}

////
-(void)showLoading{
    if(!loading){
        loading=[[LoadingView alloc] initWithFrame:FULLRECT];
        [self.view addSubview:loading];
         [loading start];
        loading.alpha=0;
        [GlobalFunction fadeInOut:loading to:1.0 time:0.6 hide:NO];
    }
}

-(void)showLoadingAtIndex:(int)index
{
    if(!loading){
        loading=[[LoadingView alloc] initWithFrame:FULLRECT];
        [self.view insertSubview:loading atIndex:index];
        [loading start];
        loading.alpha=0;
        [GlobalFunction fadeInOut:loading to:1.0 time:0.6 hide:NO];
    }
}

-(void)hideLoading{
    if(loading){
        [loading stop];
        [GlobalFunction fadeInOut:loading to:0.0 time:0.6 hide:YES];
        Release2Nil(loading);
    }
}


@end
