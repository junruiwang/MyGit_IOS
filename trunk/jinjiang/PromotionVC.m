//
//  PromotionVC.m
//  jinjiang
//
//  Created by Jeff.Yan on 11-10-27.
//  Copyright 2011年 W+K. All rights reserved.
//

#import "PromotionVC.h"

#import "GlobalFunction.h"
#import "MainNC.h"
#import "NavigationView.h"
#import "jinjiangViewController.h"
#import "OmnitureManager.h"

#define PROMOTION_HEIGHT 192

@implementation PromotionVC

-(void)loadData{
    
    hTTPConnection=[[HTTPConnection alloc] init];
    hTTPConnection.delegate=self;
    [hTTPConnection sendRequest:PROMOTION_URL postData:nil type:nil];
    [self showLoading];
}
-(void)setData:(NSArray *)_data{
    if(viewList)[GlobalFunction removeViews:viewList];
    Release2Nil(data);
    Release2Nil(viewList);

    viewList=[[NSMutableArray alloc] init];
    
    data=[[NSArray alloc] initWithArray:_data];

    scrView.contentSize=CGSizeMake(1024, PROMOTION_HEIGHT*[data count]);

  	for (int i=0; i<5; i++)
	{
        if(i<[data count]){
            PromotionListCell *uv=[[PromotionListCell alloc] initWithFrame:CGRectMake(0, i*PROMOTION_HEIGHT, self.view.frame.size.width, PROMOTION_HEIGHT)];
            
            uv.tag=i;
            [uv setData:[data objectAtIndex:i] isInit:YES];
            
            [viewList addObject:uv];
            [scrView addSubview:uv];
            
            [uv release];
        }
        
	}
    [scrView scrollsToTop];

}
- (void)loadView
{

    [super loadView];
    
    data=nil;
    viewList=nil;
    self.view.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];       

 
    
    [self loadData];

}
- (void)viewDidLoad{
     [super viewDidLoad];
    
    NSMutableDictionary *vars = [NSMutableDictionary dictionary];
    [vars setValue:@"促销打折页面" forKey:@"pageName"];
    [vars setValue:@"特惠锦江" forKey:@"channel"];
    [OmnitureManager trackWithVariables:vars];
    
    RemoveRelease(scrView);
    
    scrView= [[UIScrollView alloc] initWithFrame:FULLRECT];
    scrView.delegate=self;

    scrView.showsHorizontalScrollIndicator = NO;
    scrView.showsVerticalScrollIndicator = NO;
    scrView.scrollsToTop = NO;
    scrView.userInteractionEnabled=YES;
  
    
    [self.view addSubview:scrView];
    
    if(data!=nil){
         [self setData:data];
    }
    
   
}
- (void)viewDidUnload{
    RemoveRelease(scrView);
    [super viewDidUnload];
}




-(void)cancel{
    if(hTTPConnection!=nil){
        hTTPConnection.delegate=nil;
        [hTTPConnection cancelDownload];
        Release2Nil(hTTPConnection);
    }
}
-(void)loadErr{
    [self hideLoading];
    NSLog(@"loadErr");
    [self cancel];
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"锦江" message:@"数据读取失败..." delegate:nil cancelButtonTitle:@"确定"otherButtonTitles:nil];
	[alert show];
	[alert release];
}

- (void)postHTTPDidFinish:(NSMutableData *)_data hc:(HTTPConnection *) _hc{
     [self hideLoading];
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSString *strData = [[NSString alloc] initWithData:_data encoding:NSUTF8StringEncoding];
    
    NSArray *d=[strData JSONValue];
    
    
  
    if(d){
        [self setData:d];
    }else{
        [self loadErr];
    }
    
    //NSLog(@"data:::::::%@",d);
    [strData release];
    [pool release];
    
    
    [self cancel];
    
}

- (void)postHTTPError:(HTTPConnection *) _hc{
    [self loadErr];
    
}
- (void)touchDownFun{
    isDown=YES;
}
- (void)touchUpFun{
    if(isDown){
        
        
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if(data!=nil && viewList!=nil){
        CGFloat pageWidth = scrollView.frame.size.width;
        CGFloat pageHeight = scrollView.frame.size.height;
       
        PromotionListCell *uv =[viewList objectAtIndex:0];
        PromotionListCell *uv2 =[viewList objectAtIndex:[viewList count]-1];

        if(uv.tag>0 && uv.frame.origin.y-scrollView.contentOffset.y>0){
            [viewList removeLastObject];
            [viewList insertObject:uv2 atIndex:0];
            uv2.frame=CGRectMake(0, uv.frame.origin.y-PROMOTION_HEIGHT, pageWidth, PROMOTION_HEIGHT);
            
            uv2.tag=uv.tag-1;
            [uv2 setData:[data objectAtIndex:uv2.tag] isInit:NO];
            [uv2.superview insertSubview:uv2 atIndex:0];
        }
        
        uv =[viewList objectAtIndex:0];
        uv2 =[viewList objectAtIndex:[viewList count]-1];
        
        if(uv2.tag<[data count]-1 && uv2.frame.origin.y-scrollView.contentOffset.y<pageHeight-PROMOTION_HEIGHT){
            [viewList removeObjectAtIndex:0];
            [viewList addObject:uv];
            uv.frame=CGRectMake(0, uv2.frame.origin.y+PROMOTION_HEIGHT, pageWidth, PROMOTION_HEIGHT);
            uv.tag=uv2.tag+1;
            [uv setData:[data objectAtIndex:uv.tag] isInit:NO];
            [uv.superview addSubview:uv];
            
        }

    }
    
    isDown=NO;
    
}

-(void)outFun{
    NSLog(@"outFun");
    cacheImage=[[UIImageView alloc] initWithImage:[GlobalFunction imageFromView:self.view]];
    [self.view addSubview:cacheImage];
    
    [self cancel];
    if(viewList)[GlobalFunction removeViews:viewList];
    Release2Nil(data);
    Release2Nil(viewList);
    RemoveRelease(scrView);
    
}
- (void)dealloc
{
    NSLog(@"promotion dealloc");
    RemoveRelease(cacheImage);
    
    //[self cancel];
    if(viewList)[GlobalFunction removeViews:viewList];
    Release2Nil(data);
    Release2Nil(viewList);
    RemoveRelease(scrView);
    [super dealloc];
    
}

@end
