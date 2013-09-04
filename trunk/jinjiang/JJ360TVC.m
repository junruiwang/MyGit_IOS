//
//  JJ360TVC.m
//  jinjiang
//
//  Created by Jeff.Yan on 11-11-14.
//  Copyright 2011年 W+K. All rights reserved.
//

#import "JJ360TVC.h"
#import "GlobalFunction.h"
#import "JJ360.h"
#import "OmnitureManager.h"

#define JJCELLIMAGECRET CGRectMake(0, 0, 233,95 )
#define JJCELLCRET CGRectMake(0, 0, 236, 95)

@interface JJ360TVC()

@property (nonatomic, retain) JJFile *jj360;

@end

@implementation JJ360TVC

@synthesize jj360 = _jj360;

static JJ360TVC *selectTvc=nil;

-(void)cellClicked{
    switch (self.jj360.state) {
        case JJFileStateComplete:
//            pauseTxt.hidden = YES;
            [self selectEd:YES a:YES];
            break;
        case JJFileStatePrepare:
        {
            NSMutableDictionary *vars = [NSMutableDictionary dictionary];
            [vars setValue:@"360°展示" forKey:@"channel"];
            [OmnitureManager trackCustomLinkWithLinkname:[NSString stringWithFormat:@"%@", [self.jj360.title stringByReplacingOccurrencesOfString:@"\n" withString:@""]] variables:vars];
            [self.jj360 startDownload];
            break;
        }
        case JJFileStatePause:
            _progressView.hidden = NO;
            pauseTxt.text = @"下载中";
//            pauseTxt.hidden = YES;
            [self.jj360 startDownload];
            break;
        case JJFileStateDownloading:
            _progressView.hidden = NO;
            pauseTxt.text = @"暂 停";
//            pauseTxt.hidden = NO;
            [self.jj360 pauseDownload];
            break;
        case JJFileStateFailed:
            pauseTxt.text = @"下载中";
//            pauseTxt.hidden = NO;
            [self.jj360 startDownload];
            break;
    }
}

-(void)selectFun:(BOOL)b  a:(BOOL)a{
    if(b){
        if(selectTvc!=nil){
            [selectTvc selectEd:NO a:a];
        }
        selectTvc=self;
        if(a){
            if(outView)[GlobalFunction fadeInOut:outView to:0 time:0.4 hide:NO];
            if(overView) [GlobalFunction fadeInOut:overView to:1 time:0.4 hide:NO];
        }else{
            if(outView)outView.alpha=0;
            if(overView) overView.alpha=1;
        }
        
    }else{
        if(a){
            if(outView)[GlobalFunction fadeInOut:outView to:1 time:0.4 hide:NO];
            if(overView) [GlobalFunction fadeInOut:overView to:0 time:0.4 hide:NO];
        }else{
            if(outView)outView.alpha=1;
            if(overView)overView.alpha=0;
        }
        
        
    }
}
-(void)selectEd:(BOOL)b a:(BOOL)a{
    [super selectEd:b a:a];
    if(b){
        
    }else{
        
    }
}
-(void)setData:(id)d index:(NSInteger)si{
    [super setData:d index:si];

    self.jj360 = d;
    self.jj360.delegate = self;
    
    [GlobalFunction removeSubviews:self];
    //RemoveRelease(overView);
    //RemoveRelease(outView);
    UIImage *image;
    image = self.jj360.coverImage;
    
    //image=[UIImage imageWithContentsOfFile:@"c1.png"];
    //c1.png
    //NSLog(@"file::%@",[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:[d objectForKey:@"image"]]);
    
    _ui=[[UIImageView alloc] initWithImage:image];
    _ui.frame=JJCELLIMAGECRET;
    [self addSubview:_ui];
    
    outView=[[UIImageView alloc] initWithImage:[GlobalFunction createWireFrmaeImage:233 ht:95 r:1 cr:90 cg:90 cb:90 ca:1]];
    
    
    
    overView=[[UIImageView alloc] initWithImage:[GlobalFunction createWireFrmaeImage:236 ht:95 r:3 cr:255 cg:255 cb:255 ca:1]];
    overView.alpha=0;
    
    //NSLog(@":::%@",[d objectForKey:@"name"]);
    titleTxt.text = self.jj360.title;
    // UIView *temView=[UIView
    
    RemoveRelease(txtBg);
    txtBg=[[UIView alloc] initWithFrame:CGRectMake(0, 50, 233, 45)];
    txtBg.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    
    txtBg.userInteractionEnabled=NO;
    titleTxt.userInteractionEnabled=NO;
    
    [self addSubview:txtBg];
    [self addSubview:titleTxt];
    
    [self addSubview:outView];
    [self addSubview:overView];
    
    [self addSubview:_progressView];
    [self addSubview:pauseTxt];
    switch (self.jj360.state) {
        case JJFileStateComplete:
            _progressView.hidden = YES;
            break;
        case JJFileStatePause:
            _progressView.progress = (float)self.jj360.progress/100;
            _progressView.hidden = NO;
            pauseTxt.text = @"暂停";
//            pauseTxt.hidden = NO;
            break;
        case JJFileStatePrepare:
            _progressView.hidden = YES;
            pauseTxt.text = @"点击下载";
            break;
        default:
            break;
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        titleTxt=[[UILabel alloc] initWithFrame:CGRectMake(12, frame.size.height-44, frame.size.width-40, 46)];
        titleTxt.textColor=[UIColor whiteColor];
        titleTxt.backgroundColor=[UIColor clearColor];
        titleTxt.numberOfLines=2;
        titleTxt.font = [UIFont fontWithName:@"STHeitiTC-Medium" size:14];
        titleTxt.textColor=[UIColor whiteColor];
        
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(20, 75, 200, 9)];        
        pauseTxt = [[UILabel alloc] initWithFrame:CGRectMake(0, 23, frame.size.width, 50)];
        pauseTxt.textAlignment = UITextAlignmentCenter;
        pauseTxt.text = @"";
        pauseTxt.font = [UIFont boldSystemFontOfSize:20];
        pauseTxt.textColor = [UIColor whiteColor];
        pauseTxt.backgroundColor = [UIColor clearColor];
//        pauseTxt.hidden = YES;
       // pauseTxt.font = 
    }
    return self;
}

- (void)dealloc
{
    NSLog(@"jj360 tvc dealloc");
    RemoveRelease(txtBg);
    RemoveRelease(titleTxt);
    RemoveRelease(_progressView);
    RemoveRelease(pauseTxt);
    RemoveRelease(_ui);
    [_jj360 release]; _jj360 = nil;
    if(selectTvc==self){
        selectTvc=nil;
    }
    [super dealloc];
}

#pragma mark - JJFileDownloadDelegate

- (void)jjFileStartDownload:(JJFile *)file
{
    pauseTxt.text = @"下载中";
//    pauseTxt.hidden = NO;
    _progressView.hidden = NO;
}

- (void)jjFileDownloadChanged:(JJFile *)file
{
    _progressView.progress = (float)(file.progress)/100;
}

- (void)jjFileDownloadComplete:(JJFile *)file
{
//    pauseTxt.hidden = YES;
    pauseTxt.text = @"";
    _progressView.hidden = YES;
    NSString *titleTip = [file.title stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"《%@》下载完成！", titleTip] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertView show];
    [alertView release];
    _ui.image = file.coverImage;
}

- (void)jjFile:(JJFile *)file downloadFailedWithError:(NSError *)error
{
    NSLog(@"%@", error.localizedDescription);    
    pauseTxt.text = @"下载失败";
//    pauseTxt.hidden = NO;
}

@end
