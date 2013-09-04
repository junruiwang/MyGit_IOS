//
//  LeftScrollView.m
//  jinjiang
//
//  Created by Jeff.Yan on 11-11-14.
//  Copyright 2011年 W+K. All rights reserved.
//

#import "LeftScrollView.h"
#import "GlobalFunction.h"


@implementation LeftScrollView

@synthesize delegate,bgView,isBottom;



-(void)setData:(NSArray *)_data cc:(NSString *)cc _sh:(CGFloat)_sh{
    
    [GlobalFunction removeViews:viewList];
    Release2Nil(data);
    Release2Nil(viewList);
    RemoveRelease(scrView);
    selectId=-1;
    scrView= [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, fullFrame.size.width, fullFrame.size.height)];
    scrView.delegate=self;
    
    scrView.pagingEnabled = NO;
    //scrView.contentSize = CGSizeMake(scrView.frame.size.width, scrView.frame.size.height);
    scrView.showsHorizontalScrollIndicator = NO;
    scrView.showsVerticalScrollIndicator = NO;
    scrView.scrollsToTop = NO;
    scrView.userInteractionEnabled=YES;
    viewList=[[NSMutableArray alloc] init];
    
    [self addSubview:scrView];
    
    data=[[NSArray alloc] initWithArray:_data];
    
    //NSLog(@"setData:::%@::%@",data,_data);
    
    cellClass=NSClassFromString(cc);
    
    sh=_sh;
    
    CGFloat th=sh*[data count];
    scrView.delegate=self;
    scrView.contentSize = CGSizeMake(fullFrame.size.width, th);
   
	[scrView scrollsToTop];
    
    NSInteger num=ceil(fullFrame.size.height/sh)+1;
    
    
    if([data count]<num && th<=fullFrame.size.height){
        if(!isBottom)
        self.showRect=CGRectMake(fullFrame.origin.x, fullFrame.origin.y, fullFrame.size.width, th);
        scrView.frame=CGRectMake(0, 0, scrView.frame.size.width,th);
        
        num=[data count];
    }else if([data count]<num){
        
      num=[data count];
    }else{
        if(!isBottom)
        self.showRect=fullFrame;
        scrView.frame=CGRectMake(0, 0, fullFrame.size.width, fullFrame.size.height);
    }
    
    if(!isBottom)
    bgView.frame=CGRectMake(0, 0, bgView.frame.size.width, self.frame.size.height);
    
	for (int i=0; i<num; i++)
	{
        if(i<[data count]){
            LeftViewCell *uv=[[cellClass alloc] initWithFrame:CGRectMake(0, i*sh, fullFrame.size.width, sh)];
            uv.delegate=self;
            uv.tag=i;
            [uv setData:[data objectAtIndex:i] index:-1];
        
            [viewList addObject:uv];
            [scrView addSubview:uv];

            [uv release];
        }
        
	}
}
-(void)selectView:(LeftViewCell *)lvc{
    //NSLog(@":::selectView:::%@::%d",lvc,lvc.tag);
    selectId=lvc.tag;
    if(delegate!=nil){
        [delegate selectView:self index:lvc.tag dic:[data objectAtIndex:lvc.tag]];
    }
}
- (void)touchDownFun{
    isDown=YES;
}
- (void)touchUpFun{
    if(isDown){
       
        
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if(self.superview){
        [RootWindowUI closeOpen:YES];
       [(ControlView *)self.superview  stopStartHide:YES];
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if(self.superview){
        [RootWindowUI closeOpen:NO];
        [(ControlView *)self.superview  stopStartHide:NO];
    }

}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //[controlView stopStartHide:NO];
    if(data!=nil && viewList!=nil){
        CGFloat pageWidth = scrollView.frame.size.width;
        CGFloat pageHeight = scrollView.frame.size.height;

    //CGFloat yy=scrollView.contentOffset.y;
	//NSInteger page= floor((scrollView.contentOffset.y - sh / 2) / sh) + 1;
        LeftViewCell *uv =[viewList objectAtIndex:0];
        LeftViewCell *uv2;
    //if(yy>0 && yy<([data count]-1)*sh){
       // NSLog(@"::::%d::%d",uv.tag,uv2.tag);
        while(uv.tag>0 && uv.frame.origin.y-scrollView.contentOffset.y>0){
            uv2 =[viewList objectAtIndex:[viewList count]-1];
            [viewList removeLastObject];
            [viewList insertObject:uv2 atIndex:0];
            uv2.frame=CGRectMake(0, uv.frame.origin.y-sh, pageWidth, sh);
            
            uv2.tag=uv.tag-1;
            [uv2 setData:[data objectAtIndex:uv2.tag] index:selectId];
            uv =[viewList objectAtIndex:0];
        }
        
        
        uv2 =[viewList objectAtIndex:[viewList count]-1];
        
        while(uv2.tag<[data count]-1 && uv2.frame.origin.y-scrollView.contentOffset.y<pageHeight-sh){
            uv =[viewList objectAtIndex:0];
            [viewList removeObjectAtIndex:0];
            [viewList addObject:uv];
            uv.frame=CGRectMake(0, uv2.frame.origin.y+sh, pageWidth, sh);
            uv.tag=uv2.tag+1;
            [uv setData:[data objectAtIndex:uv.tag] index:selectId];
            [viewList objectAtIndex:[viewList count]-1];
            uv2 =[viewList objectAtIndex:[viewList count]-1];
        }
    //}
    }

    isDown=NO;
    
}
- (id)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    if (self) {
        isBottom=NO;
        // Initialization code
       // self.backgroundColor =[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.6f];
        bgView=[[UIView alloc] init];
        bgView.frame=CGRectMake(0, 0, self.frame.size.width, frame.size.height);
        bgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        bgView.userInteractionEnabled=NO;
        [self addSubview:bgView];
        fullFrame=frame;
        
        selectId=-1;
        
        data=nil;
        viewList=nil;
        scrView=nil;
        
                 
    }
    return self;
}


- (void)dealloc
{
    NSLog(@"leftScroll dealloc");
    [GlobalFunction removeViews:viewList];
    Release2Nil(data);
    Release2Nil(viewList);
    RemoveRelease(bgView);
    RemoveRelease(scrView);

    [super dealloc];
}

@end
