//
//  PhotoListView.m
//  jinjiang
//
//  Created by zi cheng on 11-12-22.
//  Copyright (c) 2011年 W+K. All rights reserved.
//

#import "PhotoListView.h"

#import "PhotoWallOneUC.h"

#import "GlobalFunction.h"

#define CELLWIDTH 90
#define CELLWIDTH_PACE 102
#define LIST_WIDTH_MAX 906
#define SHOW_LIST_RECT CGRectMake(0, 629, 1024, 139)
#define HIDE_LIST_RECT CGRectMake(0, 768, 1024, 139)
@implementation PhotoListView

@synthesize delegate;
-(void)showHideBottom{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(showHideBottom) object:nil];
    if(isShow){
        isShow=NO;
        [GlobalFunction moveView:self to:HIDE_LIST_RECT time:0.3];
    }else{
        isShow=YES;
        [GlobalFunction moveView:self to:SHOW_LIST_RECT time:0.3];
        [self performSelector:@selector(showHideBottom) withObject:nil afterDelay:3.8f];
    }
}
-(void)showBottom{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(showHideBottom) object:nil];
    if(isShow){
        isShow=NO;
    }
    [self showHideBottom];
}
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    if(!self.userInteractionEnabled)return nil;
    UIView *hit=nil;
    NSArray *nr=self.subviews;
    for (NSInteger i=0;i<[nr count];i++){
        UIView *temView=[nr objectAtIndex:i];
        CGPoint temPoint=[self convertPoint:point toView:temView];
        
        hit= [temView hitTest:temPoint withEvent:event];
        if(hit!=nil){
            [GlobalFunction closeTouch];
            return hit;
        }
    }
    return nil;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [GlobalFunction addImage:self name:@"6_s12_bg.png"];
        listView=[[UIScrollView alloc] initWithFrame:CGRectMake(59, 62, LIST_WIDTH_MAX, 68)];
        
        listView.showsHorizontalScrollIndicator=NO;
        listView.showsVerticalScrollIndicator=NO;
        listView.delegate=self;
        
        listView.pagingEnabled=NO;
        
        [self addSubview:listView];
        
        UIButton *uv=[UIButton buttonWithType:UIButtonTypeCustom];
        uv.frame = CGRectMake(766,0, 106, 50);
        uv.tag=100;
        [GlobalFunction addImage:uv name:@"6_1_2_t_btn1.png" point:CGPointMake(12,12)];
        [self addSubview:uv];
        
        [uv addTarget:self action:@selector(clickHander:) forControlEvents:UIControlEventTouchUpInside];
        
        uv=[UIButton buttonWithType:UIButtonTypeCustom];
        uv.frame = CGRectMake(874,0, 150, 50);
        uv.tag=101;
        [GlobalFunction addImage:uv name:@"6_1_2_t_btn2.png" point:CGPointMake(12,12)];
        [self addSubview:uv];
        
        [uv addTarget:self action:@selector(clickHander:) forControlEvents:UIControlEventTouchUpInside];
        
        
        uv=[UIButton buttonWithType:UIButtonTypeCustom];
        [uv setImage:[UIImage imageNamed:@"6_1_2_l_btn.png"] forState:UIControlStateNormal];
        uv.frame = CGRectMake(8,72, 40, 49);
        uv.tag=102;
        
        [self addSubview:uv];
        
        [uv addTarget:self action:@selector(clickHander:) forControlEvents:UIControlEventTouchUpInside];
        
        
        uv=[UIButton buttonWithType:UIButtonTypeCustom];
        uv.frame = CGRectMake(1024-8-40,72, 40, 49);
        uv.tag=103;
        [uv setImage:[UIImage imageNamed:@"6_1_2_r_btn.png"] forState:UIControlStateNormal];
        
        [self addSubview:uv];
        
        [uv addTarget:self action:@selector(clickHander:) forControlEvents:UIControlEventTouchUpInside];
        
        titleTxt=[[UILabel alloc] initWithFrame:CGRectMake(60, 12, 600, 30)];
        titleTxt.textColor=[UIColor whiteColor];
        titleTxt.backgroundColor=[UIColor clearColor];
        titleTxt.font = [UIFont fontWithName:@"STHeitiTC-Medium" size:18];
        
        [self addSubview:titleTxt];
        
    }
    return self;
}
-(IBAction) clickHander:(id)sender {
    UIButton *btn = (UIButton *)sender;
    NSInteger ti;
    if(btn.tag==100){
        [jinjiangViewController showShare:1];
    }else if(btn.tag==101){
        if(delegate){
            [delegate back];
        }
    }else if(btn.tag==102){
        if(delegate){
            ti=[PhotoWallOneUC selectIndex]-1;
            if(ti>=0)
                [delegate selectPo:ti];
        }
    }else if(btn.tag==103){
        if(delegate){
            ti=[PhotoWallOneUC selectIndex]+1;
            if(ti<aNum)
                [delegate selectPo:ti];
        }
    }
    
    
}

-(void)setData:(Magzine *)d{
    data=[d retain];
    _index=-1;
    [self showBottom];
    isClick=NO;
    Release2Nil(listArray);
    listArray=[[NSMutableArray alloc] init];
    NSArray *temList=data.fileList;
    titleTxt.text=data.title;
    aNum=[temList count];
    CGFloat ww=(aNum)*CELLWIDTH_PACE-12;
    if(ww<0)ww=0;
    listView.contentSize=CGSizeMake(ww, 68);
    for(NSInteger i=0;i<10;i++){
        if(i>=aNum){
            break;
        }
        PhotoWallOneUC *po=[[PhotoWallOneUC alloc] initWithFrame:CGRectMake(i*CELLWIDTH_PACE, 0, 90, 68)];
        po.delegate=self;
        [po setData:[data.filePath stringByAppendingPathComponent:[temList objectAtIndex:i]] index:i];
        [listView addSubview:po];
        [listArray addObject:po];
        [po release];
    }
    
}
-(void)setShow:(NSInteger)i{
    [self showBottom];
    [PhotoWallOneUC selectIndex:i];
    for(NSInteger ii=0;ii<[listArray count];ii++){
        PhotoWallOneUC *po=[listArray objectAtIndex:ii];
        if(po.index==i){
            [po selectEd:YES];
        }
    }
    if(_index!=i){
        CGFloat xx=(i-4)*CELLWIDTH_PACE;
        
        if(xx<0){
            xx=0;
        }
        if(xx>listView.contentSize.width-listView.frame.size.width){
            xx=listView.contentSize.width-listView.frame.size.width; 
        }
        [listView setContentOffset:CGPointMake(xx, 0) animated:YES];
    }
    _index=i;
}
-(void)selectPo:(NSInteger)index{
    isClick=YES;
    if(delegate)
        [delegate selectPo:index];
    isClick=NO;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{ 
    //LIST_WIDTH_MAX
    NSArray *temList=data.fileList;
    
    
    CGFloat xx=scrollView.contentOffset.x;
    PhotoWallOneUC *p1;
    PhotoWallOneUC *p2;
    NSInteger ii;
    p1=[listArray objectAtIndex:0];
    //PhotoWallOneUC *p2=[listArray objectAtIndex:0];
    while(p1.index>0 && (p1.frame.origin.x-xx)>0){
        ii=p1.index-1;
        p2=[listArray objectAtIndex:[listArray count]-1];
        [p2 setData:[data.filePath stringByAppendingPathComponent:[temList objectAtIndex:ii]] index:ii];
        p2.frame=CGRectMake(ii*CELLWIDTH_PACE, 0, 90, 68);
        
        [listArray removeLastObject];
        [listArray insertObject:p2 atIndex:0];
        
        p1=[listArray objectAtIndex:0];
    }
    p1=[listArray objectAtIndex:[listArray count]-1];
    while((p1.index<aNum-1) && (p1.frame.origin.x-xx)<LIST_WIDTH_MAX-CELLWIDTH){
        ii=p1.index+1;
        p2=[listArray objectAtIndex:0];
        [p2 setData:[data.filePath stringByAppendingPathComponent:[temList objectAtIndex:ii]] index:ii];
        p2.frame=CGRectMake(ii*CELLWIDTH_PACE, 0, 90, 68);
        
        [listArray removeObjectAtIndex:0];
        [listArray addObject:p2];
        p1=[listArray objectAtIndex:[listArray count]-1];
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if(!decelerate){
    }
}

- (void)dealloc
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(showHideBottom) object:nil];
    Release2Nil(data);
    Release2Nil(listArray);
    RemoveRelease(listView);
    RemoveRelease(titleTxt);
    [super dealloc];
}


@end
