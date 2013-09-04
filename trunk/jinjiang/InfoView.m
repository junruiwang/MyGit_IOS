//
//  InfoView.m
//  jinjiang
//
//  Created by Jeff.Yan on 11-11-8.
//  Copyright 2011年 W+K. All rights reserved.
//

#import "InfoView.h"
#import "InfoItemView.h"

#import "GlobalFunction.h"

@implementation InfoView
-(void)reSetMove{
    isMove=NO;
}
-(void)showPage:(NSInteger)ii{
    if(ii==0){
        [GlobalFunction fadeInOut:viewNext to:0 time:0.6 hide:YES];
        
        toIndex=-1;
        
        if(isMove){
            return;
        }
        for(NSInteger i=0;i<[menuList count];i++){
            //NSLog(@"[menuList objectAtIndex:i]::%@",[menuList objectAtIndex:i]);
            UIView *uv=[menuList objectAtIndex:i];
            if([uv isKindOfClass:[InfoItemView class]]){
                [uv performSelector:@selector(cubeMoveIn) withObject:nil afterDelay:i*0.16];
            }else{
                [GlobalFunction fadeInOut:uv to:1.0 time:0.6 delay:i*0.16 hide:NO];
                [self addSubview:uv];
                
            }
            
            //[[menuList objectAtIndex:i] performSelector:@selector(cubeMoveIn) withObject:nil afterDelay:i*0.16];
        }
        [self performSelector:@selector(reSetMove) withObject:nil afterDelay:[menuList count]*0.16+0.6];
        isMove=YES;
        if(controlView){
            [controlView showTop:0];
        }
    }else{
        
    }
}
-(void)setControlView:(ControlView *)cl{
    controlView=cl;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        isMove=NO;
        // Initialization code
        //[GlobalFunction addImage:self name:@"8_0.png" rect:FULLRECT];
        self.backgroundColor=[UIColor whiteColor];
        menuList=[[NSMutableArray alloc] init];
        
        InfoItemView *tem=[[InfoItemView alloc] initWithFrame:CGRectMake(53, 62, 916, 281) index:0];
        [menuList addObject:tem];
        [self addSubview:tem];
        tem.tag=100;
        [tem addTarget:self action:@selector(clickFun:) forControlEvents:UIControlEventTouchUpInside];
        [tem release];
        
        UIImageView *copyView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"8_s1_bg.png"]];
        copyView.frame=CGRectMake(53, 373, 909, 220);
         [menuList addObject:copyView];
        [self addSubview:copyView];
        [copyView release];
        
        UIButton *but=[UIButton buttonWithType:UIButtonTypeCustom];
        
        [but setImage:[UIImage imageNamed:@"8_s1_btn.png"] forState:UIControlStateNormal];
        but.frame=CGRectMake(53, 630, 119, 47);
        but.bounds=but.frame;
        but.tag=101;
        [but addTarget:self action:@selector(clickFun:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:but];
        [menuList addObject:but];
        
        
        //8_s1_bg
        
        //51 62
        
        UIImageView *s2=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"8_s12_bg.png"]];
        viewNext=[[UIScrollView alloc] initWithFrame:FULLRECT];
        [viewNext addSubview:s2];
        viewNext.contentSize=s2.frame.size;
        
        [s2 release];
        viewNext.alpha=0;
        //
    }
    return self;
}
-(void)toShowPage{
    //toIndex
    isMove=NO;
    [self addSubview:viewNext];
    [GlobalFunction fadeInOut:viewNext to:1 time:0.6 hide:NO];
}
-(void)selectEd:(NSInteger)ci{
    toIndex=ci;
    if(isMove){
        return;
    }
    for(NSInteger i=0;i<[menuList count];i++){
        UIView *uv=[menuList objectAtIndex:i];
        if([uv isKindOfClass:[InfoItemView class]]){
            [uv performSelector:@selector(cubeMoveOut) withObject:nil afterDelay:i*0.16];
        }else{
           [GlobalFunction fadeInOut:uv to:0.0 time:0.6 delay:i*0.16 hide:YES];
        }
    }
    [self performSelector:@selector(toShowPage) withObject:nil afterDelay:[menuList count]*0.16+0.6];
    
    
    isMove=YES;
    if(controlView){
        [controlView showTop:1];
    }
}
-(void)clickFun:(id)sender{
    NSLog(@"clickFun:::%@",sender);
    InfoItemView *im=(InfoItemView*)sender;
    if(im){
        [self selectEd:0];
        //NSInteger ci=im.tag-100;
    
        //[im cubeMoveOut];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)dealloc
{
    NSLog(@"info dealloc");
    RemoveRelease(viewNext);
    Release2Nil(menuList);
    [super dealloc];
}

@end
