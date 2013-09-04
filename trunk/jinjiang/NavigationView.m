//
//  NavigationView.m
//  jinjiang
//
//  Created by Jeff.Yan on 11-10-27.
//  Copyright 2011年 W+K. All rights reserved.
//

#import "NavigationView.h"
#import "GlobalFunction.h"
#import "jinjiangViewController.h"
#import "MainNC.h"

@implementation NavigationView

@synthesize isShow,isOff;

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    UIView *hit=nil;
    hit=[super hitTest:point withEvent:event];
    if(hit!=nil){
        [GlobalFunction closeTouch];
    }
    return hit;
}
-(void)setButtom:(UIButton *)uv t:(NSInteger)t{
    
    uv.frame = CGRectMake(0, 61*t, 169, 59);
    [uv setImage:[UIImage imageNamed:@"m_bg.png"] forState:UIControlStateNormal];
    [uv setImage:[UIImage imageNamed:@"m_bg_s.png"] forState:UIControlStateSelected];
    [uv addTarget:self action:@selector(tabbarBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    //UIImageView *mc=[[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"m_c%d.png",t]]];
    /*
    if(t==6){
         mc.frame=CGRectMake(17, 15, mc.frame.size.width, mc.frame.size.height);
    }else if(t==4){
         mc.frame=CGRectMake(17, 15, mc.frame.size.width, mc.frame.size.height);
    }else
     */
    //mc.frame=CGRectMake(15, 15, mc.frame.size.width, mc.frame.size.height);
    
    //[uv addSubview:mc];
    //[mc release];
    [GlobalFunction addImage:uv name:[NSString stringWithFormat:@"m_c%d.png",t]];
    
    [btns addObject:uv];
    
    [self addSubview:uv];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        pageIndex=-1;
        
        btns=[[NSMutableArray alloc] init];
        
        tabbarBtn01=[UIButton buttonWithType:UIButtonTypeCustom];
        tabbarBtn01.tag=2;
        [self setButtom:tabbarBtn01 t:0];
        
       
        tabbarBtn02=[UIButton buttonWithType:UIButtonTypeCustom];
        tabbarBtn02.tag=3;
        [self setButtom:tabbarBtn02 t:1];
        
        
        tabbarBtn03=[UIButton buttonWithType:UIButtonTypeCustom];
        tabbarBtn03.tag=4;
        [self setButtom:tabbarBtn03 t:2];
        
        
        tabbarBtn04=[UIButton buttonWithType:UIButtonTypeCustom];
        tabbarBtn04.tag=5;
        [self setButtom:tabbarBtn04 t:3];
        
        tabbarBtn05=[UIButton buttonWithType:UIButtonTypeCustom];
        tabbarBtn05.tag=6;
        [self setButtom:tabbarBtn05 t:4];
        
        tabbarBtn06=[UIButton buttonWithType:UIButtonTypeCustom];
        tabbarBtn06.tag=7;
        [self setButtom:tabbarBtn06 t:5];
        
        tabbarBtn07=[UIButton buttonWithType:UIButtonTypeCustom];
        tabbarBtn07.tag=1;
        [self setButtom:tabbarBtn07 t:6];
        
   
    }
    return self;
}
-(void)select:(NSInteger)index mode:(NSInteger)mode{
    //NSLog(@"select::::::");
    UIButton *ub;
    if(pageIndex!=index){
        for(NSInteger i=0;i<[btns count];i++){
            ub=[btns objectAtIndex:i] ;
            if([ub tag]==pageIndex){
                ub.selected=NO;
            }
        }
        pageIndex=index;
        [MainNC toShowPage:index mode:mode];
        for(NSInteger i=0;i<[btns count];i++){
            ub=[btns objectAtIndex:i] ;
            if([ub tag]==pageIndex){
                 ub.selected=YES;
                //NSLog(@":::::::%d",ub.selected);
            }
        }
    }
}
-(void)reSetList:(NSArray *)arr{
     UIButton *ub;
    for(NSInteger i=0;i<[arr count];i++){
        ub=[btns objectAtIndex:[[arr objectAtIndex:i] intValue]] ;
        ub.frame = CGRectMake(0, 61*(i+1), 169, 59);
    }
}
+(void)reSetList:(NSArray *)arr{
    [[NavigationView sharedInstance] reSetList:arr];
}
+(void)select:(NSInteger)index mode:(NSInteger)mode{
    
    NavigationView *nv=[NavigationView sharedInstance];
    [nv select:index mode:mode];
}
-(IBAction) tabbarBtnClicked:(id)sender {
    UIButton *btn = (UIButton *)sender;
    NSInteger index=btn.tag;
    [self select:index mode:0];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

//120

-(void)autoHide{
    [NavigationView showHide:YES];
    //[NavigationView offOut:NO];
}
-(void)autoOff{
    [NavigationView offOut:NO];
}
+ (void)show2Hide{
    NavigationView *nav=[NavigationView sharedInstance];
    [NavigationView showHide:nav.isShow];
}
+ (void)off2Out{
    NavigationView *nav=[NavigationView sharedInstance];
    [NavigationView offOut:nav.isOff];
}
+ (void)showHide:(BOOL)b{
    [NavigationView showHide:b autoHide:NO];
}
+ (void)showHide:(BOOL)b autoHide:(BOOL)ah{
    //[NSObject cancelPreviousPerformRequestsWithTarget:self];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(autoHide) object:nil];
    NavigationView *nav=[NavigationView sharedInstance];
    if(b){
        nav.isShow=NO;
        [GlobalFunction fadeInOut:nav to:0.0f time:0.4f hide:YES];
    }else{
        nav.isShow=YES;
        [[[jinjiangViewController sharedInstance] view] addSubview:nav];
        [GlobalFunction fadeInOut:nav to:1.0f time:0.4f hide:NO];
        if(ah)
        [nav performSelector:@selector(autoHide) withObject:nil afterDelay:3.4f];
    }
    
}

+ (void)offOut:(BOOL)b{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(autoOff) object:nil];
     NavigationView *nav=[NavigationView sharedInstance];
    if(b){
         nav.isOff=NO;
        [GlobalFunction moveView:nav to:CGRectMake(855,171, 169, 425) time:0.4f];
         [nav performSelector:@selector(autoOff) withObject:nil afterDelay:3.4f];
    }else{
        nav.isOff=YES;
        [GlobalFunction moveView:nav to:CGRectMake(855+117,171, 169, 425) time:0.4f];  
        
    }
}

+ (void)showHide:(BOOL)b m:(BOOL)m{
     [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(autoHide) object:nil];
    NavigationView *nav=[NavigationView sharedInstance];
    if(m){
        [NavigationView showHide:b];
    }else{
        if(b){
            nav.isShow=NO;
            [nav removeFromSuperview];
            nav.alpha=0;
        }else{
            nav.isShow=YES;
            [[[jinjiangViewController sharedInstance] view] addSubview:nav];
            nav.alpha=1;
        }
    }
    
}
+ (void)offOut:(BOOL)b m:(BOOL)m{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(autoOff) object:nil];
    NavigationView *nav=[NavigationView sharedInstance];
    if(m){
        [NavigationView offOut:b];
    }else{
        if(b){
            nav.isOff=NO;
            nav.frame=CGRectMake(855,202, 169, 425);
        }else{
             nav.isOff=YES;
            nav.frame=CGRectMake(855+114,202, 169, 425); 
            
             [nav performSelector:@selector(off2Out) withObject:nil afterDelay:3.4f];
        }
    }
}

static NavigationView *_instance = nil;

+ (id)sharedInstance
{
   
    @synchronized(self)
    {
        if (_instance == nil) {//856, 145  768-364
            _instance = [[NavigationView alloc] initWithFrame:CGRectMake(855,171, 169, 425)];//[[NavigationView alloc] init]; 
            //366＋59
            //_instance.backgroundColor=[UIColor colorWithRed:0.478f green:0.478f blue:0.478f alpha:1.0f];
            [NavigationView showHide:YES m:NO];
        }
    }
    return _instance;
}

+ (void)shareRelease
{
    if (_instance != nil) {
        [_instance release];
        _instance=nil;
    }
}


- (void)dealloc
{
    Release2Nil(btns);
    [super dealloc];
}

@end
