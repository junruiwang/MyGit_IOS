//
//  JJ360VC.m
//  jinjiang
//
//  Created by Jeff.Yan on 11-10-27.
//  Copyright 2011年 W+K. All rights reserved.
//

#import "JJ360VC.h"
#import "MovPlayerView.h"
#import "GlobalFunction.h"
#import "MainNC.h"
#import "NavigationView.h"
#import "jinjiangViewController.h"
#import "WebTouchView.h"
#import "JJ360View.h"
#import "JJ360TVC.h"
#import "OmnitureManager.h"

@interface JJ360VC()

@property (nonatomic, retain) NSMutableArray *jj360Array;

@property (nonatomic, retain) NSMutableArray *movArray;

-(void)cancel:(HTTPConnection *) _hc;
-(void)loadErr:(HTTPConnection *)_hc;
-(void)cancel;

@end

@implementation JJ360VC

@synthesize jj360Array = _jj360Array;

@synthesize movArray = _movArray;

-(void)removeReleaseJJ360View{
    RemoveRelease(jj360View);
}

-(void)showPage:(NSInteger)i{
    
    if(i!=index){
        if(index>=0 && index<[btns count]){
            UIButton *btn=[btns objectAtIndex:index];
            btn.selected=NO;
            btn.userInteractionEnabled=YES;
        }
        index=i;
        if(index>=0 && index<[btns count]){
            UIButton *btn=[btns objectAtIndex:index];
            btn.selected=YES;
//            btn.userInteractionEnabled=NO;
        }
        if(index==0){
            if(movPlayView!=nil){
                movPlayView.alpha=0;
                [movPlayView clear];
                //[movPlayView clear];
                //[GlobalFunction fadeInOut:movPlayView to:0 time:0.4 target:movPlayView action:@selector(clear)];
            }
            RemoveRelease(movPlayView);
            //Release2Nil(movPlayView);
            if(jj360View==nil){
                jj360View=[[JJ360View alloc] initWithFrame:FULLRECT];
                jj360View.alpha=0;
            }
            [self.view insertSubview:jj360View atIndex:0];
            [GlobalFunction fadeInOut:jj360View to:1 time:0.4 hide:NO];
            
        }else{
            if(jj360View!=nil){
                jj360View.alpha=0;
                //[GlobalFunction fadeInOut:jj360View to:0 time:0.4 hide:YES];
            }
            //if(jj360View){
            //  [jj360View clearMotion];
            //}
            //NSLog(@"jj360View:::relase:1");
            [self performSelectorOnMainThread:@selector(removeReleaseJJ360View) withObject:nil waitUntilDone:NO];
            //RemoveRelease(jj360View);
            //NSLog(@"jj360View:::relase:2");
            
            if(movPlayView==nil){
                movPlayView=[[MovPlayerView alloc] initWithFrame:FULLRECT];
                movPlayView.alpha=0;
            }
            [self.view insertSubview:movPlayView atIndex:0];
            [GlobalFunction fadeInOut:movPlayView to:1 time:0.4 hide:NO];
        }
        
    }
}
-(void)setTouchMode:(NSInteger)mode point:(CGPoint)point{
    if(mode==0){
        [super setTouchMode:mode point:point];
        //[webView stringByEvaluatingJavaScriptFromString:@"setTest();"]; 
        //}else if(mode==-2){
        // [self startDrag:point];
    }
}

- (void)loadView
{
    
    [super loadView];
    self.view.frame=FULLRECT;
    self.view.backgroundColor=[UIColor blackColor];
    index=-1;
    
    
    
}

- (void)viewDidLoad{
    [super viewDidLoad];
    NSMutableDictionary *vars = [NSMutableDictionary dictionary];
    [vars setValue:@"360度全景页面" forKey:@"pageName"];
    [vars setValue:@"全景锦江" forKey:@"channel"];
    [OmnitureManager trackWithVariables:vars];

    controlView.closeAuto = YES;
    self.jj360Array = [[[NSMutableArray alloc] init] autorelease];
    self.movArray = [[[NSMutableArray alloc] init] autorelease];
    RemoveRelease(t3dLeft);
    RemoveRelease(movLeft);
    
    if(jj360View){
        [jj360View clearMotion];
    }
    RemoveRelease(jj360View);
    RemoveRelease(movPlayView);
    
    
    ControlTopView *temTop;
    
    temTop=[[ControlTopView alloc] initWithFrame:TOPRECT];
    
    
    [GlobalFunction addImage:temTop name:@"top_bg.png" rect:CGRectMake(234*3, 0, 1024-234*3, TOPFULLHEIGHT)];
    
    
    UIButton *but;
    
    but=[ControlView getTopButtom:0 width:233];
    but.tag=100;
    [btns addObject:but];
    [GlobalFunction addImage:but name:@"4_title_btn_0.png" point:CGPointMake(16, 10)];
    
    //
    
    [but addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [temTop addSubview:but];
    [GlobalFunction addImage:temTop name:@"top_w_line.png" rect:CGRectMake(233, 0, 1, TOPHEIGHT)];
    
    but=[ControlView getTopButtom:234 width:233];
    but.tag=101;
    [btns addObject:but];
    [GlobalFunction addImage:but name:@"4_title_btn_1.png" point:CGPointMake(16, 10)];
    
    [but addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [temTop addSubview:but];
    [GlobalFunction addImage:temTop name:@"top_w_line.png" rect:CGRectMake(233+234, 0, 1, TOPHEIGHT)];
    
    but=[ControlView getTopButtom:234*2 width:233];
    but.tag=102;
    [btns addObject:but];
    [GlobalFunction addImage:but name:@"6_title_btn_2.png" point:CGPointMake(16, 10)];
    
    [but addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [temTop addSubview:but];
    [GlobalFunction addImage:temTop name:@"top_w_line.png" rect:CGRectMake(233+234*2, 0, 1, TOPHEIGHT)];
    
    
    [controlView addTop:temTop];
    [temTop release];
    
    
    //ControlLeftView *t3dLeft;
    
    //ControlLeftView *movLeft;
    
    
    
    movLeft=[[LeftScrollView alloc] initWithFrame:CGRectMake(234, TOPHEIGHT, 233+3, 768-TOPHEIGHT)];
    
    
    t3dLeft=[[LeftScrollView alloc] initWithFrame:CGRectMake(0, TOPHEIGHT, 233+3, 768-TOPHEIGHT)];
    
    t3dLeft.isBottom=YES;
    
    //[t3dLeft addSubview:leftScrollView];
    t3dLeft.bgView.frame=CGRectMake(0, 0, 233, t3dLeft.bgView.frame.size.height);
    movLeft.bgView.frame=CGRectMake(0, 0, 233, movLeft.bgView.frame.size.height);
    
    movLeft.delegate=self;
    t3dLeft.delegate=self;
    
    [controlView addLeft:t3dLeft];
    
    [controlView addLeft:movLeft];
    
    
    //NSMutableArray *t3dArr=[[NSMutableArray alloc] init];
    
    //95 210
    //
    
    //    NSString *ns=[[NSString alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"t3d" ofType:@"vam"] encoding:NSUTF8StringEncoding error:nil];
    //    
    //    if(ns == nil) {
    //        
    //        
    //    }else{
    //        NSArray  *dic=[ns JSONValue];
    //        //NSLog(@"::::%@::%d",dic,[dic count]);
    //        [t3dLeft setData:dic cc:@"JJ360TVC" _sh:95];
    //    }
    //    [ns release];
    
    [self get360s];
    
    [self getMovies];
    
//    NSString *ns2=[[NSString alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"mov" ofType:@"vam"] encoding:NSUTF8StringEncoding error:nil];
//    
//    if(ns2 == nil) {
//        
//        
//    }else{
//        NSArray  *dic=[ns2 JSONValue];
//        //NSLog(@"::::%@",dic);
//        [movLeft setData:dic cc:@"JJ360TVC" _sh:95];
//    }
//    [ns2 release];
    
    [controlView showTop:0];
    [controlView showLeft:0];
    
    [self.view addSubview:controlView];
    
    [self showPage:0];
    
    //    [jj360View toScene:@"f360/s0/tour.html"];
    
}
- (void)viewDidUnload{
    if(jj360View){
        [jj360View clearMotion];
    }
    RemoveRelease(t3dLeft);
    RemoveRelease(movLeft);
    
    RemoveRelease(jj360View);
    RemoveRelease(movPlayView);
    
    [super viewDidUnload];
}

- (void)get360s
{
    _360_hTTPConnection=[[HTTPConnection alloc] init];
    _360_hTTPConnection.delegate=self;
    [_360_hTTPConnection sendRequest:JJ360_URL postData:nil type:nil];
    [self showLoading];
    //    NSData *_data = [@"[]" dataUsingEncoding:NSUTF8StringEncoding];
    //    [self postHTTPDidFinish:(NSMutableData *)_data hc:_360_hTTPConnection];
}

- (void) getMovies
{
    _mov_hTTPConnection=[[HTTPConnection alloc] init];
    _mov_hTTPConnection.delegate=self;
    [_mov_hTTPConnection sendRequest:MOVIE_URL postData:nil type:nil];
    [self showLoading];
}

-(void)selectViewMain1:(NSString *)path{
    
    [self showPage:0];
    //NSLog(@"3d::::%@",[dic objectForKey:@"url"]);
    [jj360View toScene:path];
    
}
-(void)selectViewMain2:(NSString *)path{
    
    [self showPage:1];
    //NSLog(@"play::::%@",[dic objectForKey:@"url"]);
    [movPlayView play:path];
}
//[self performSelectorOnMainThread:@selector(showPage:) withObject:@"1" waitUntilDone:NO];
-(void)selectView:(LeftScrollView *)leftScrollView index:(NSInteger)index dic:(id)dic{
    //NSLog(@":::leftScrollView:::::%@",leftScrollView);
    
    if(leftScrollView==t3dLeft){
        //NSLog(@"1---performSelectorOnMainThread:::");
        JJ360 *jj360 = (JJ360 *)dic;
        [self performSelectorOnMainThread:@selector(selectViewMain1:) withObject:jj360.filePath waitUntilDone:NO];
    }else if(leftScrollView==movLeft){
        if(jj360View){
            [jj360View clearMotion];
        } 
        JJMovie *jjmovie = (JJMovie *)dic;
        [self performSelector:@selector(selectViewMain2:) withObject:[jjmovie.filePath stringByAppendingPathComponent:@"princess.mp4"]afterDelay:0.1];
        //NSLog(@"2---performSelectorOnMainThread:::");
        //[self performSelectorOnMainThread:@selector(selectViewMain2:) withObject:dic waitUntilDone:NO]; 
    }
    [controlView showHide];
}


-(void)btnClicked:(id)sender {
    UIButton *btn = (UIButton *)sender;
    NSInteger ii=btn.tag;
    switch (ii) {
        case 100:
            [[btns objectAtIndex:1] setSelected:NO];
            btn.selected = YES;
            [controlView showLeft:0];
            break;
        case 101:
            [[btns objectAtIndex:0] setSelected:NO];
            btn.selected = YES;
            [controlView showLeft:1];
            break;
        case 102:
            [jinjiangViewController showShare:0];
            break;
    }
    //if(jj360View){
    //  cacheImage=[[UIImageView alloc] initWithImage:[GlobalFunction imageFromView:jj360View]];
    //[self.view addSubview:cacheImage];
    //}
}
-(void)outFun{
    // /*
    //cacheImage=[[UIImageView alloc] initWithImage:[GlobalFunction imageFromView:self.view]];
    //[self.view addSubview:cacheImage];
    //    if(jj360View){
    //        [jj360View clearMotion];
    //    }
    //    if(movPlayView!=nil){
    //        [movPlayView clear];
    //    }
    //    
    //    RemoveRelease(t3dLeft);
    //    RemoveRelease(movLeft);
    //    
    //    RemoveRelease(jj360View);
    //    RemoveRelease(movPlayView);
    //    
    //    self.view.backgroundColor=[UIColor clearColor];
    
    // */
}

- (void)dealloc
{
    NSLog(@"JJ360 dealloc");
    if(jj360View){
        [jj360View clearMotion];
    }
    RemoveRelease(cacheImage);
    
    RemoveRelease(t3dLeft);
    RemoveRelease(movLeft);
    
    RemoveRelease(jj360View);
    RemoveRelease(movPlayView);
    [_jj360Array release]; _jj360Array = nil;
    [_movArray release]; _movArray = nil;
    
    [super dealloc];
    
}

#pragma mark - HTTPConnection delegate

- (void)postHTTPDidFinish:(NSMutableData *)_data hc:(HTTPConnection *) _hc
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSString *strData = [[NSString alloc] initWithData:_data encoding:NSUTF8StringEncoding];
    
    NSArray *d=[strData JSONValue];
    
    if(d){
        if (_hc == _360_hTTPConnection) {
            [self.jj360Array removeAllObjects];
            for (NSDictionary *dict in d) {
                int jj360Id = [[dict objectForKey:@"id"] intValue];
                NSString *title = [dict objectForKey:@"title"];
                NSString *coverImageURL = [dict objectForKey:@"coverimage"];
                NSString *fileURL = [dict objectForKey:@"file"];
                int fileSize = [[dict objectForKey:@"filesize"] intValue];
                JJ360 *jj360 = [[JJ360 alloc] initWithRootPath:JJ360_PATH fileId:jj360Id title:title coverImageURL:coverImageURL fileURL:fileURL fileSize:fileSize];
                jj360.delegate = self;
                [self.jj360Array addObject:jj360];
            }
            [t3dLeft setData:self.jj360Array cc:@"JJ360TVC" _sh:95];
        } else {
            [self.movArray removeAllObjects];
            for (NSDictionary *dict in d) {
                int jj360Id = [[dict objectForKey:@"id"] intValue];
                NSString *title = [dict objectForKey:@"title"];
                NSString *coverImageURL = [dict objectForKey:@"coverimage"];
                NSString *fileURL = [dict objectForKey:@"file"];
                int fileSize = [[dict objectForKey:@"filesize"] intValue];
                JJMovie *jjmovie = [[JJMovie alloc] initWithRootPath:MOVIE_PATH fileId:jj360Id title:title coverImageURL:coverImageURL fileURL:fileURL fileSize:fileSize];
                jjmovie.delegate = self;
                [self.movArray addObject:jjmovie];
            }
            [movLeft setData:self.movArray cc:@"JJ360TVC" _sh:95];
        }
        [self cancel:_hc];
    }else{
        [self loadErr:_hc];
    }
    
    
    //NSLog(@"data:::::::%@",d);
    [strData release];
    [pool release];
    [self hideLoading];
}

- (void)postHTTPError:(HTTPConnection *) _hc{
    [self loadErr:_hc];
}

-(void)cancel:(HTTPConnection *) _hc
{
    if(_hc!=nil){
        _hc.delegate=nil;
        [_hc cancelDownload];
        Release2Nil(_hc);
    }
}

-(void)cancel
{
    if(_360_hTTPConnection!=nil){
        _360_hTTPConnection.delegate=nil;
        [_360_hTTPConnection cancelDownload];
        Release2Nil(_360_hTTPConnection);
    } else if (_mov_hTTPConnection !=nil) {
        _mov_hTTPConnection.delegate=nil;
        [_mov_hTTPConnection cancelDownload];
        Release2Nil(_mov_hTTPConnection);
    }
}

-(void)loadErr:(HTTPConnection *)_hc
{
    [self hideLoading];
    NSLog(@"loadErr");
    [self cancel:_hc];
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"锦江" message:@"数据读取失败..." delegate:nil cancelButtonTitle:@"确定"otherButtonTitles:nil];
	[alert show];
	[alert release];
}

@end
