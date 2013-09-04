//
//  HomeVC.m
//  jinjiang
//
//  Created by Jeff.Yan on 11-10-27.
//  Copyright 2011年 W+K. All rights reserved.
//

#import "HomeVC.h"

#import "GlobalFunction.h"
#import "MainNC.h"
#import "NavigationView.h"
#import "jinjiangViewController.h"


#import "TouchPointObj.h"

#import "MenuItemVW.h"


@implementation HomeVC

-(void)reSetLevel{
    NSMutableArray *__indexArray=[MenuItemVW getIndexArray];
    for (NSInteger i=[menuList count]-1; i>=0; i--)
    {
        MenuItemVW *mi=[menuList objectAtIndex:i];
        [__indexArray replaceObjectAtIndex:i withObject:Int2Str(mi.tag+1)];
        [menuView addSubview:mi];
        
    }
     [NavigationView reSetList:__indexArray];
}

-(void)toShowPage{
    NSLog(@"toShowPage2");
    [NavigationView select:toIndex mode:1];
}
-(void)cubeMoveOut{
    if(isMove){
        return;
    }
   // NSInteger ss=floor(menuView.contentOffset.x/255);
    //[menuList count]
    if(menuList){
        for (NSInteger i=0; i<[menuList count]; i++)//4+ss
        {
            [[menuList objectAtIndex:i] performSelector:@selector(cubeMoveOut:) withObject:[NSString stringWithFormat:@"%f",(menuView.contentOffset.x)] afterDelay:i*0.16];
        }
        [self performSelector:@selector(toShowPage) withObject:nil afterDelay:[menuList count]*0.16+0.6];
      
       
        self.view.userInteractionEnabled=NO;
        [RootWindowUI closeOpen:YES];
         NSLog(@"toShowPage:toShowPage");
    }
    isMove=YES;
}

- (void)loadView
{
    [super loadView];
    
    //1_help
    isMove=NO;
    toIndex=-2;
    moveMi=nil;
    skipScoll=NO;
    
    menuList=[[NSMutableArray alloc] init];
    
    menuView=[[UIScrollView alloc] initWithFrame:FULLRECT];
    
    
    for (NSInteger i=0; i<5; i++)
    {
        
        MenuItemVW *mi=[MenuItemVW initWithIndex:i];
        mi.menuItemDelegate=self;
        [menuList addObject:mi];
        [mi release];
        // [menuView addSubview:mi];
        
    }
    [self reSetLevel];
    menuView.delegate=self;
    menuView.contentSize = CGSizeMake(257*5-4, 768);
    
    [self.view addSubview:menuView];
    
    
    menuView.userInteractionEnabled=NO;
    
    //[self performSelector:@selector(cubeMoveOut) withObject:nil afterDelay:1];
}

- (void)viewDidLoad{
    
    [super viewDidLoad];
}
- (void)viewDidUnload{
  
    [super viewDidUnload];
}

- (void)select:(NSInteger)index{
    toIndex=index+3;
    [self cubeMoveOut];
    /*
     switch (index) {
     case 0:
     toIndex=3;
     break;
     case 1:
     toIndex=4;
     break;
     case 2:
     toIndex=5;
     break;
     case 3:
     toIndex=6;
     break;
     case 4:
     toIndex=7;
     break;
     case 5:
     toIndex=0;
     break;
     default:
     break;
     }
     */
}



/////touch

-(void)startDrag:(TouchPointObj *) tp{
    if(isMove)return;
    if(moveMi==nil){
        cacheTouchPointObj=tp;
        NSInteger ii=floor((menuView.contentOffset.x+tp.origin.x)/255);
        //NSLog(@"ii:::%d",ii);
        moveMi=[menuList objectAtIndex:ii];
        [menuView addSubview:moveMi];
        cachePoint.x=tp.origin.x-moveMi.frame.origin.x;
        cachePoint.y=0;
        for (NSInteger i=0; i<[menuList count]; i++)
        {
            MenuItemVW *mi=[menuList objectAtIndex:i];
            if(moveMi==mi){
                [GlobalFunction fadeInOut:mi to:1.0f time:0.3f hide:NO];
            }else{
                [GlobalFunction fadeInOut:mi to:0.6f time:0.3f hide:NO];
            }
        }
       
    }
}
-(void)onDrag:(CGPoint) tp{
    if(isMove)return;
    if(moveMi!=nil){
        moveMi.frame=CGRectMake(tp.x-cachePoint.x,moveMi.frame.origin.y,moveMi.frame.size.width,moveMi.frame.size.height);
        NSInteger ii=round((moveMi.frame.origin.x+menuView.contentOffset.x)/255);
        if(ii<0){
            ii=0;
        }
        if(ii>4){
            ii=4;
        }
        [menuList removeObject:moveMi];
        [menuList insertObject:moveMi atIndex:ii];
        
        for (NSInteger i=0; i<[menuList count]; i++)
        {
            MenuItemVW *mi=[menuList objectAtIndex:i];
            if(moveMi==mi){
                
            }else{
                [GlobalFunction moveView:mi to:CGRectMake(i*257, 0, 253, 768) time:0.3f];
            }
        }
       
    }
}

-(void)stopDrag{
    if(moveMi!=nil){
        for (NSInteger i=0; i<[menuList count]; i++)
        {
            MenuItemVW *mi=[menuList objectAtIndex:i];
            [GlobalFunction fadeInOut:mi to:1 time:0.4f hide:NO];
            [GlobalFunction moveView:mi to:CGRectMake(i*257, 0, 253, 768) time:0.3f];
        }
    }
    [self reSetLevel];
    cacheTouchPointObj=nil;
    moveMi=nil;
}

/////touch
-(void)setTouchMode:(NSInteger)mode point:(CGPoint)point{
    if(isMove)return;
    if(mode==0){
         NSMutableArray *__indexArray=[MenuItemVW getIndexArray];
        NSInteger ii=floor((menuView.contentOffset.x+point.x)/255);
        [self select:[[__indexArray objectAtIndex:ii] intValue]-1];
        //}else if(mode==-2){
        // [self startDrag:point];
    }
}
-(void)touch1Delay{
    if(isMove)return;
    //NSLog(@"touch1Delay:::");
    if(paths!=nil){
         //NSLog(@"touch2Delay:::");
        if([paths count]==1){
            //NSLog(@"touch3Delay:::");
            NSArray *na=[[paths allValues] objectAtIndex:0];
            TouchPointObj *p0=[na objectAtIndex:0];
            TouchPointObj *p1=[na objectAtIndex:[na count]-1];
            CGFloat dis=[TouchPointObj calculateDis:p1.origin p0:p0.origin];
            //NSLog(@"touch4Delay:::%f",dis);
            if(dis>20){
                return;
            }
            dis=0;
            for(NSInteger n=0;n<[na count];n++){
                //dis=0;
                if(n>0){
                    p0=[na objectAtIndex:n-1];
                    p1=[na objectAtIndex:n];
                    dis+=[TouchPointObj calculateDis:p1.origin p0:p0.origin];
                    //NSLog(@"touch5Delay:::%f::%f",dis,[TouchPointObj calculateRotate:p1.origin p0:p0.origin]);
                    if(dis>30){
                        return;
                    }
                }
                
            }
            touchMode=1;
            [self startDrag:[na objectAtIndex:0]];
            //[self setTouchMode:-2 point:[[na objectAtIndex:0] origin]];
            //[self endTouch];
        }
    }
}

-(void)checkMoveTouch:(NSSet *)touches{
    if(isMove)return;
    NSArray *na;
    if(touchMode==0 && !skipScoll){
        if([paths count]==1){
            na=[[paths allValues] objectAtIndex:0];
            if([na count]>=2){
                CGFloat dis=0;
                CGFloat tr=0;
                
                for(NSInteger i=0;i<[na count];i++){
                    if(i>0){
                        TouchPointObj *p0=[na objectAtIndex:i-1];
                        TouchPointObj *p1=[na objectAtIndex:i];
                        dis+=[TouchPointObj calculateDis:p0.origin p0:p1.origin];
                        
                    }
                }
                TouchPointObj *p0=[na objectAtIndex:0];
                TouchPointObj *p1=[na objectAtIndex:[na count]-1];
                if(dis>30){
                    tr=[TouchPointObj calculateRotate:p1.origin p0:p0.origin];
                    //NSLog(@"::::::%f",tr);
                    if((tr>70 && tr<110)||(tr>250 && tr<290)){
                        touchMode=3; 
                        cachePoint.x=[[na objectAtIndex:0] origin].x+menuView.contentOffset.x;
                        //NSLog(@"::::::::::::::%f",menuView.contentOffset.x);
                        
                    }
                    skipScoll=YES;
                }
                
            }
            
        }
        
        
    }
    if(touchMode==1){
        NSArray *na=[touches allObjects];
        for(NSInteger n=0;n<[na count];n++){
            if([na objectAtIndex:n]==cacheTouchPointObj.touch){
                
                [self onDrag:[[na objectAtIndex:n] locationInView:self.view]];
            }
        }
    }
    if(touchMode==3){
        na=[[paths allValues] objectAtIndex:0];
        [menuView setContentOffset:CGPointMake(cachePoint.x-[[na objectAtIndex:([na count]-1)] origin].x,0) animated:NO];
    }
    //NSLog(@"touchMode::%d",touchMode);
    //NSArray *na0=[[paths allValues] objectAtIndex:0];
    //NSArray *na1=[[paths allValues] objectAtIndex:1];
    
}
-(void)scoll2End{
    NSInteger ii=round(menuView.contentOffset.x/255);
    ii=fmin(1, ii);
    ii=fmax(0, ii);
    [menuView setContentOffset:CGPointMake(ii*255,0) animated:YES];
}
-(void)checkEndTouch{
    [self scoll2End];
    skipScoll=NO;
    [self stopDrag];
}
-(void)outFun{
    NSLog(@"homeVc outFun");
    cacheImage=[[UIImageView alloc] initWithImage:[GlobalFunction imageFromView:self.view]];
    [self.view addSubview:cacheImage];
    //NSLog(@"menuList:::%d",[menuList retainCount]);
    if(menuList)[GlobalFunction removeViews:menuList];
    RemoveRelease(menuView);
    Release2Nil(menuList);
}

- (void)dealloc
{
    NSLog(@"homeVc dealloc");
    if(menuList)[GlobalFunction removeViews:menuList];
    RemoveRelease(cacheImage);
    RemoveRelease(menuView);
    Release2Nil(menuList);
    [super dealloc];
    
}

@end
