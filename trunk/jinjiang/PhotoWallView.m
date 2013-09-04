//
//  PhotoWallView.m
//  jinjiang
//
//  Created by Jeff.Yan on 11-11-22.
//  Copyright 2011年 W+K. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "PhotoWallView.h"
#import "PhotoWallOneUC.h"
#import "PhotoListView.h"
#import "MagzineView.h"
#import "GlobalFunction.h"
#import "PhotoWallOneView.h"

#define ZOOM_MIN 0.5
#define ZOOM_MAX 2.5
#define PHOTO_ONE_WIDTH 1024.0
#define PHOTO_ONE_HEIGHT 768.0

#define PHOTO_ONE_WIDTH2 576.0

#define ROTATE_ANGLE M_PI/2.0

#define PHOTO_SPACE 12.0

#define MOVE_TIME 0.6
@implementation PhotoWallView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1];
        
        
        photoWall=[[UIScrollView alloc] initWithFrame:FULLRECT];
        photoWall.showsHorizontalScrollIndicator=NO;
        photoWall.showsVerticalScrollIndicator=NO;
        photoWall.delegate=self;
        photoWall.pagingEnabled=YES;
        
        
        listView=[[PhotoListView alloc] initWithFrame:CGRectMake(0, 768-139, 1024, 139)];
        listView.delegate=self;
        //listView
        
        [self addSubview:photoWall];
        
        [self addSubview:listView];
        
    }
    return self;
}


-(void)setShow:(NSInteger)i{
    _index=i;
    [listView setShow:i];
    
}
-(void)setSelect{
    CGFloat xx=photoWall.contentOffset.x;
    
    [self setShow:round(xx/1024)];
}
-(void)toShow:(NSInteger)i{
    isMove=YES;
    [photoWall setContentOffset:CGPointMake(i*1024, 0) animated:YES];
}
-(void)checkShow{
    NSArray *temList=data.fileList;
    CGFloat xx=photoWall.contentOffset.x;
    PhotoWallOneView *p1;
    PhotoWallOneView *p2;
    NSInteger ii;
    p1=[listArray objectAtIndex:0];
    
    //PhotoWallOneUC *p2=[listArray objectAtIndex:0];
    while ((p1.frame.origin.x-xx)>0 && p1.tag>0){
        
        ii=p1.tag-1;
        
        p2=[listArray objectAtIndex:[listArray count]-1];
        
        p2.tag=ii;
        //[p2 setData:[temList objectAtIndex:ii] index:ii];
        p2.frame=CGRectMake(ii*1024, 0, 1024, 768);
        [p2 setUrl:[data.filePath stringByAppendingPathComponent:[temList objectAtIndex:ii]]];
        //p2.image=nil;
        //p2.image=[[UIImage alloc] initWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:[[temList objectAtIndex:ii] objectForKey:@"image"]]];
        [listArray removeLastObject];
        [listArray insertObject:p2 atIndex:0];
        
        // NSLog(@"11:::%@",[[temList objectAtIndex:ii] objectForKey:@"image"]);
        
        p1=[listArray objectAtIndex:0];
    }
    p1=[listArray objectAtIndex:[listArray count]-1];
    while((p1.frame.origin.x-xx)<0 && p1.tag<aNum-1){
        ii=p1.tag+1;
        
        p2=[listArray objectAtIndex:0];
        p2.tag=ii;
        //[p2 setData:[temList objectAtIndex:ii] index:ii];
        p2.frame=CGRectMake(ii*1024, 0, 1024, 768);
        [p2 setUrl:[data.filePath stringByAppendingPathComponent:[temList objectAtIndex:ii]]];
        //p2.image=[[UIImage alloc] initWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:[[temList objectAtIndex:ii] objectForKey:@"image"]]];
        // NSLog(@"22:::%@",[[temList objectAtIndex:ii] objectForKey:@"image"]);
        
        [listArray removeObjectAtIndex:0];
        [listArray addObject:p2];
        p1=[listArray objectAtIndex:[listArray count]-1];
    }
    for(NSInteger i=0;i<[listArray count];i++){
        p1=[listArray objectAtIndex:i];
        if(p1.tag>=0 && p1.tag<aNum){
            if(isMove && _index!=p1.tag){
                
                [p1 showSmall];
                //p1.image=[[UIImage alloc] initWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:[PhotoWallOneUC getSmallFile:[[temList objectAtIndex:p1.tag] objectForKey:@"image"]]]];
            }else{
                [p1 showBig]; 
                //p1.image=[[UIImage alloc] initWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:[[temList objectAtIndex:p1.tag] objectForKey:@"image"]]];
            }
        }
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    isMove=NO;
    if(!decelerate){
        [self setSelect];
        //[self checkShow];
    }
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self setSelect];
    //[self checkShow];
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    //NSLog(@"scrollViewDidEndScrollingAnimation");
    [self setSelect];
    isMove=NO;
    //for(NSInteger i=0;i<[listArray count];i++){
    // UIImageView *p=[listArray objectAtIndex:i];
    // p.image=nil;
    //}
    [self checkShow];
    //[photoWall setNeedsDisplay];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //NSLog(@"scrollViewDidScroll");
    //[self setSelect];
    [self checkShow];
}
-(void)selectPo:(NSInteger)index{
    _index=index;
    [self toShow:index];
}

-(void)setData:(Magzine *)d{
    _index=-1;
    Release2Nil(data);
    Release2Nil(listArray);
    isMove=NO;
    listArray=[[NSMutableArray alloc] init];
    
    data=[d retain];
    
    NSArray *temList=data.fileList;
    aNum=[temList count];
    
    photoWall.contentSize=CGSizeMake(aNum*1024, 768);
    
    for(NSInteger i=0;i<2;i++){
        if(i>=aNum){
            break;
        }
        PhotoWallOneView *iv=[[PhotoWallOneView alloc] initWithFrame:CGRectMake(i*1024, 0, 1024, 768)];
        iv.tag=i;
        [iv setUrl:[data.filePath stringByAppendingPathComponent:[temList objectAtIndex:i]]];
        [iv showBig];
        //iv.image=[[UIImage alloc] initWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:[[temList objectAtIndex:i] objectForKey:@"image"]]];
        //[po setData:[temList objectAtIndex:i] index:i];
        [photoWall addSubview:iv];
        [listArray addObject:iv];
        
        [iv release];
    }
    
    [listView setData:data];
    
    CGFloat xx=photoWall.contentOffset.x;
    [self setShow:round(xx/1024)];
    
}
-(void)showHideBottom{
    if(listView)[listView showHideBottom];
}
-(void)back{
    if([self.superview isKindOfClass:[MagzineView class]]){
        [(MagzineView *)self.superview showPage:0 index:0];
    }
}
- (void)dealloc
{
    NSLog(@"photoWall dealloc");
    Release2Nil(data);
    Release2Nil(listArray);
    RemoveRelease(photoWall);
    RemoveRelease(listView);
    [super dealloc];
}

@end
