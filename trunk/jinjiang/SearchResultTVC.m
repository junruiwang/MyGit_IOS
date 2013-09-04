//
//  SearchResultTVC.m
//  jinjiang
//
//  Created by Jeff.Yan on 11-11-16.
//  Copyright 2011年 W+K. All rights reserved.
//

#import "SearchResultTVC.h"
#import "GlobalFunction.h"

@implementation SearchResultTVC

#define SEARCHRESULTCELLIMAGECRECT CGRectMake(0, 0, 348,95 )
#define SEARCHRESULTCELLCRECT CGRectMake(0, 0, 348, 95)

#define CellOutColor [UIColor colorWithRed:1 green:1 blue:1 alpha:1]
#define CellOverColor [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1]

static SearchResultTVC *selectTvc=nil;
-(void)selectFun:(BOOL)b  a:(BOOL)a{
    if(b){
        if(selectTvc!=nil){
            [selectTvc selectEd:NO a:a];
        }
        selectTvc=self;
        if(a){
            //NSLog(@"outView1:::::%@",outView);
            [GlobalFunction fadeInOut:outView to:1 time:0.3 hide:NO];
            nameTxt.textColor=CellOverColor;
            infoTxt.textColor=CellOverColor;
        }else{
            outView.alpha=1;
        }
        //if(delegate){
        //  [delegate selectView:self];
        //}
    }else{
        if(a){
            //NSLog(@"outView2:::::%@",outView);
            [GlobalFunction fadeInOut:outView to:0 time:0.3 hide:NO];
            nameTxt.textColor=CellOutColor;
            infoTxt.textColor=CellOutColor;
        }else{
            outView.alpha=0;
        }
        
        
    }
}

-(void)selectEd:(BOOL)b a:(BOOL)a{
    [super selectEd:b a:a];
}
-(void)setData:(id)d index:(NSInteger)si{
    if(overView!=nil){
        [(LoadImageView*)overView clear]; 
        
    }
    RemoveRelease(outView);
    RemoveRelease(overView);
    RemoveRelease(nameTxt);
    RemoveRelease(infoTxt);
    
    Release2Nil(data);
    NSLog(@"setData dealloc %d",[d retainCount]);
    data=[d retain];
    [GlobalFunction removeSubviews:self];
    
    UIView *bgView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 350, 115)];
    bgView.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
    
    
    outView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"5_list_bg_o.png"]];
    outView.frame=CGRectMake(10, -10, 381, 143);
    outView.alpha=0;
    
    
    
    NSLog(@"data:::::::%@",data);
    
    
    LoadImageView* tem=[[LoadImageView alloc] initWithFrame:CGRectMake(0, 0, 162, 115)];
    tem.backgroundColor=[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1];
    overView=tem;
    [tem loadImage:[data objectForKey:@"HotelImgUrl"]];
    
    
    bgView.userInteractionEnabled=NO;
    outView.userInteractionEnabled=NO;
    overView.userInteractionEnabled=NO;
    
    
    nameTxt=[[UILabel alloc] initWithFrame:CGRectMake(172, 12, 160, 34)];
    nameTxt.backgroundColor=[UIColor clearColor];
    nameTxt.font = [UIFont fontWithName:@"STHeitiTC-Medium" size:16];
    nameTxt.textColor = CellOutColor;
    nameTxt.numberOfLines=2;
    nameTxt.text=[data objectForKey:@"HotelName"];
    nameTxt.userInteractionEnabled=NO;
    
    //[GlobalFunction initLabelLeft:[data objectForKey:@"HotelName"] frame:CGRectMake(172, 15, 160, 22) size:22];
    //infoTxt=[GlobalFunction initLabelLeft:[data objectForKey:@"HotelAddress"] frame:CGRectMake(172, 32, 150, 70) size:14 lines:0];
    
    infoTxt=[[UILabel alloc] initWithFrame:CGRectMake(172, 32, 150, 70)];
    infoTxt.backgroundColor=[UIColor clearColor];
    infoTxt.font = [UIFont fontWithName:@"STHeitiTC-Medium" size:12];
    infoTxt.textColor = CellOutColor;
    infoTxt.numberOfLines=2;
    infoTxt.text=[data objectForKey:@"HotelAddress"];
    infoTxt.userInteractionEnabled=NO;
    
    
    [self addSubview:bgView];
    
    
    [self addSubview:outView];
    [self addSubview:overView];
    
    [self addSubview:nameTxt];
    [self addSubview:infoTxt];
    
    
    [bgView release];
    
    if(si==self.tag){
        [self selectFun:YES a:NO];
    }else{
        [self selectFun:NO a:NO];
    }
    NSLog(@"--------------------");
    // UIView *temView=[UIView
    
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        data=nil;
    }
    return self;
}


- (void)dealloc
{
    if(selectTvc==self){
        selectTvc=nil;
    }
    if(overView!=nil){
        [(LoadImageView*)overView clear]; 
        
    }
    NSLog(@"SearchResultTVC dealloc %d",[data retainCount]);
    RemoveRelease(nameTxt);
    RemoveRelease(infoTxt);
    Release2Nil(data);
    [super dealloc];
}

@end
