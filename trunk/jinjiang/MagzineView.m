//
//  MagzineView.m
//  jinjiang
//
//  Created by Jeff.Yan on 11-11-7.
//  Copyright 2011年 W+K. All rights reserved.
//

#import "MagzineView.h"


#import "ClubVC.h"

#import "GlobalFunction.h"
#import "MainNC.h"
#import "NavigationView.h"
#import "jinjiangViewController.h"
#import "FlowCoverView.h"

@interface MagzineView()

@property (nonatomic, retain) NSMutableArray *magzines;

-(void)cancel;
-(void)loadErr;

@end

@implementation MagzineView

@synthesize magzines = _magzines;
@synthesize clubVC = _clubVC;

-(void)setCTView:(ControlView *)cv ctv:(ControlTopView *)_ctv{
    controlView=cv;
    ctv=_ctv;
}
-(void)showPage:(NSInteger)i index:(NSInteger)_i{
    if(i==0){
        
        
        // if(photoWallView){
        // [photoWallView removeFromSuperview];
        // }
        RemoveRelease(photoWallView);
        if(flowCoverView==nil){
            //386 513
            flowCoverView=[[AFOpenFlowView alloc] initWithFrame:FULLRECT];
            flowCoverView.viewDelegate=self;
            for (int i=0; i<self.magzines.count; i++) {
                Magzine *magzine = [self.magzines objectAtIndex:i];
                [flowCoverView setImage:magzine.coverImage forIndex:i];
            }
            [flowCoverView setNumberOfImages:self.magzines.count];
        }
        if(flowSider==nil){
            flowSider=[[UISlider alloc] initWithFrame:CGRectMake(86, 686, 863, 20)];
            flowSider.backgroundColor = [UIColor clearColor];
            flowSider.value=0;
            flowSider.minimumValue=0.0;
            flowSider.maximumValue=1.0;
            [flowSider setThumbImage:[UIImage imageNamed:@"6_s11_sc_btn.png"] forState:UIControlStateNormal];
            [flowSider setMinimumTrackImage:[UIImage imageNamed:@"6_s11_sc.png"] forState:UIControlStateNormal];
            [flowSider setMaximumTrackImage:[UIImage imageNamed:@"6_s11_sc.png"] forState:UIControlStateNormal];
            flowSider.userInteractionEnabled=NO;
            //6_s11_sc
            
        }
        [self addSubview:flowCoverView];
        [self addSubview:flowSider];
        flowCoverView.alpha=0;
        flowSider.alpha=0;
        [GlobalFunction fadeInOut:flowCoverView to:1 time:0.3 hide:NO];
        [GlobalFunction fadeInOut:flowSider to:1 time:0.3 delay:0.1 hide:NO];
        [NavigationView showHide:NO autoHide:NO];
        [controlView showTop:0];
    }else{
        
        // if(flowCoverView){
        // [flowCoverView removeFromSuperview];
        // }
//        RemoveRelease(flowSider);
//        RemoveRelease(flowCoverView);
        if(photoWallView==nil){
            photoWallView=[[PhotoWallView alloc] initWithFrame:FULLRECT];
        }
        [self addSubview:photoWallView];
        [photoWallView setData:[self.magzines objectAtIndex:_i]];
        photoWallView.alpha=0;
        [GlobalFunction fadeInOut:photoWallView to:1 time:0.3 hide:NO];
        
        [NavigationView showHide:YES autoHide:NO];
        [controlView showTop:1];
        
        
    }
}
-(void)showPage:(NSInteger)i{
    [self showPage:i index:0];
}
-(void)showHideBottom{
    if(photoWallView)[photoWallView showHideBottom];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        flowCoverView=nil;
        photoWallView=nil;
        flowSider=nil;
        [GlobalFunction addImage:self name:@"6_m_bg.png" rect:FULLRECT atIndex:0];
        _magzines = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)getMagzines
{
    _hTTPConnection=[[HTTPConnection alloc] init];
    _hTTPConnection.delegate=self;
    [_hTTPConnection sendRequest:MAGZINE_URL postData:nil type:nil];
    [self.clubVC showLoadingAtIndex:0];
}

- (void)dealloc
{
    NSLog(@"magzine dealloc");
    if(flowCoverView)flowCoverView.viewDelegate=nil;
    RemoveRelease(flowSider);
    RemoveRelease(flowCoverView);
    RemoveRelease(photoWallView);
    [_magzines release]; _magzines = nil;
    [super dealloc];
}

#pragma mark - HTTPConnection delegate

- (void)postHTTPDidFinish:(NSMutableData *)_data hc:(HTTPConnection *) _hc
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSString *strData = [[NSString alloc] initWithData:_data encoding:NSUTF8StringEncoding];
    
    NSArray *d=[strData JSONValue];
    
    if(d){    
        [self.magzines removeAllObjects];

        for (NSDictionary *dict in d) {
            int magzineId = [[dict objectForKey:@"id"] intValue];
            NSString *title = [dict objectForKey:@"title"];
            NSString *coverImageURL = [dict objectForKey:@"coverimage"];
            NSString *fileURL = [dict objectForKey:@"file"];
            NSArray *fileList = [dict objectForKey:@"filelist"];
            int fileSize = [[dict objectForKey:@"filesize"] intValue];
            Magzine *magzine = [[Magzine alloc] initWithRootPath:MAGZINE_PATH fileId:magzineId title:title coverImageURL:coverImageURL fileURL:fileURL fileSize:fileSize fileList:fileList];
            magzine.delegate = self;
            [self.magzines addObject:magzine];
        }
        [self showPage:0 index:0];
    }else{
        [self loadErr];
    }
    
    //NSLog(@"data:::::::%@",d);
    [strData release];
    [pool release];
    
    [self cancel];
    [self.clubVC hideLoading];
}

- (void)postHTTPError:(HTTPConnection *) _hc{
    [self loadErr];
}

-(void)cancel
{
    if(_hTTPConnection!=nil){
        _hTTPConnection.delegate=nil;
        [_hTTPConnection cancelDownload];
        Release2Nil(_hTTPConnection);
    }
}

-(void)loadErr
{
    [self.clubVC hideLoading];
    NSLog(@"loadErr");
    [self cancel];
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"锦江" message:@"数据读取失败..." delegate:nil cancelButtonTitle:@"确定"otherButtonTitles:nil];
	[alert show];
	[alert release];
}

#pragma mark - OpenFlowViewDelegate

- (void)openFlowView:(AFOpenFlowView *)openFlowView selectionDidChange:(int)index
{
	NSLog(@"selectionDidChange index = %d",index);
    if(flowSider){
        flowSider.value=(index/(CGFloat)([self.magzines count]-1));
    }
}

- (void)openFlowView:(AFOpenFlowView *)openFlowView selectIndex:(int)index
{
    Magzine *magzine = [self.magzines objectAtIndex:index];
    switch (magzine.state) {
        case JJFileStateComplete:
            [self showPage:1 index:index];
            break;
        case JJFileStatePrepare:
            [magzine startDownload];
            break;
        case JJFileStateFailed:
            [magzine startDownload];
            [flowCoverView setImage:magzine.coverImage forIndex:index];
            break;
        case JJFileStatePause:
            [magzine startDownload];
            [flowCoverView setImage:magzine.coverImage forIndex:index];            
            break;
        case JJFileStateDownloading:
            [magzine pauseDownload];
            [flowCoverView setImage:magzine.coverImage forIndex:index];
            break;
        default:
            break;
    }
}

#pragma mark - JJFileDownloadDelegate

- (void)jjFileStartDownload:(JJFile *)file
{
    int index = [self.magzines indexOfObject:file];
    [flowCoverView setImage:[GlobalFunction combineImage:file.coverImage withProgress:[UIImage imageNamed:@"progress_0.png"]] forIndex:index];
    [flowCoverView setImage:file.coverImage forIndex:index];
}

- (void)jjFileDownloadChanged:(JJFile *)file
{
    int index = [self.magzines indexOfObject:file];
    [flowCoverView setImage:file.coverImage forIndex:index];
}

- (void)jjFileDownloadComplete:(JJFile *)file
{
    int index = [self.magzines indexOfObject:file];
    [flowCoverView setImage:file.coverImage forIndex:index];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"《%@》下载完成！", file.title] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertView show];
    [alertView release];
}

- (void)jjFile:(JJFile *)file downloadFailedWithError:(NSError *)error
{
    NSLog(@"%@", error.localizedDescription);
    int index = [self.magzines indexOfObject:file];
    [flowCoverView setImage:file.coverImage forIndex:index];
}

@end
