//
//  ShareView.m
//  jinjiang
//
//  Created by Jeff.Yan on 11-11-9.
//  Copyright 2011年 W+K. All rights reserved.
//

#import "ShareView.h"
#import "GlobalFunction.h"

#import "ModalWebVC.h"

#define SinaWeiBoSDKDemo_APPKey @"1673355945"

#define SinaWeiBoSDKDemo_APPSecret @"01b7bb0f948517c8ec619afc6da01ba3"

#if !defined(SinaWeiBoSDKDemo_APPKey)
#error "You must define SinaWeiBoSDKDemo_APPKey as your APP Key"
#endif

#if !defined(SinaWeiBoSDKDemo_APPSecret)
#error "You must define SinaWeiBoSDKDemo_APPSecret as your APP Secret"
#endif

#define OUTRECT CGRectMake(0, -768, 1024, 768)
#define INITRECT CGRectMake(0, 768, 1024, 768)


#define SHARE_COPY0 @"我正在体验“全景锦江”酒店酒店360°展示，精雕细琢的客房细节，美轮美奂的立体空间效果，尽在我的“锦江⁺ app”，想了解锦江酒店实景、想欣赏不同的酒店风格吗，那就马上和我一样拥有“锦江⁺ app”吧！"

#define SHARE_COPY1 @"我正在浏览“礼享锦江”最新一期的期刊电子杂志，当季最hot的旅游热点，时下最流行的旅游风尚，尽在我的“锦江⁺ app”，享受高品质的精致生活、探索未知的奇妙世界，和我一样拥有“锦江⁺ app”吧！"

#define SHARE_COPY2 @"我正在使用“发现锦江”寻找能够满足我需求的品质酒店，精确的地理定位，详实的周边讯息，尽在我的“锦江⁺ app”，甄选最合适的睡眠空间，安享最便利的住宿地点，和我一样拥有 “锦江⁺ app”吧！"

#define SHARE_COPY3 @"我正在挑选“特惠锦江”为我带来的酒店、旅游、租车、机票等推荐产品，独家贴心的超值惊喜，真心实意的增值回馈，尽在我的“锦江⁺ app”，不断优化旅行支出，越级畅享高品质产品服务，和我一样拥有 “锦江⁺ app”吧！"

#define SHARE_COPY4 @"我正在通过“了解锦江”熟悉锦江国际（集团）有限公司，锦江国际集团是中国规模最大的综合性旅游企业集团之一，以酒店管理与投资、旅行服务及相关运输服务为主营业务…想了解更多详细内容，和我一样拥有 ““锦江⁺ app””吧！"

#define EMAIL_TITLE @"我正在使用“锦江⁺ app”，一款很好很强大的的旅游出行类app，很不错噢~"

#define SHARE_LINK @"http://www.jinjiang.com/"

static NSArray *copys=nil;


@implementation ShareView
-(void)showView:(NSInteger)ii{
    if(cutTxt){
        [cutTxt resignFirstResponder];
        cutTxt=nil;
    }
    if(showIndex!=ii){
        showIndex=ii;
        if(ii==0){
            [GlobalFunction moveView:btnsView to:CGRectMake(542-170, 272, 170+171, 133) time:0.4];
            [GlobalFunction moveView:shareView to:INITRECT time:0.4];
        }else if(ii==1){
            [GlobalFunction moveView:btnsView to:CGRectMake(542-170, -500, 170+171, 133) time:0.4];
            [GlobalFunction moveView:shareView to:FULLRECT time:0.4];
        }
    }
}
///

- (void)shareSina
{
	if( weibo )
	{
        weibo.delegate = nil;
        
		[weibo release];
		weibo = nil;
	}
	weibo = [[WeiBo alloc]initWithAppKey:SinaWeiBoSDKDemo_APPKey 
						   withAppSecret:SinaWeiBoSDKDemo_APPSecret];
	weibo.delegate = self;
	[weibo startAuthorize];
}
-(void)openURL:(NSURL*)url{
    ModalWebVC *webView=[[ModalWebVC alloc] init];
    webView.delegate=self;
    [webView loadUrlNSURL:url];
    [jinjiangViewController modalUV:webView];
    [webView release];
}
- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType{
    if( [weibo handleOpenURL:[request URL]]){
        [jinjiangViewController dismissUV];
        return NO;
    }

    return YES;
}
- (void)weiboDidLogin
{
    
    
	/*
	UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil 
													   message:@"用户验证已成功！" 
													  delegate:nil 
											 cancelButtonTitle:@"确定" 
											 otherButtonTitles:nil];
	[alertView show];
	[alertView release];
     */
    [self showView:1];
}

- (void)weiboLoginFailed:(BOOL)userCancelled withError:(NSError*)error
{
	UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"用户验证失败！"  
													   message:userCancelled?@"用户取消操作":[error description]  
													  delegate:nil
											 cancelButtonTitle:@"确定" 
											 otherButtonTitles:nil];
	[alertView show];
	[alertView release];
}

- (void)weiboDidLogout
{
	
	/*
	UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil 
													   message:@"用户已成功退出！" 
													  delegate:nil 
											 cancelButtonTitle:@"确定" 
											 otherButtonTitles:nil];
	[alertView show];
	[alertView release];
    */
    
}



- (void)request:(WBRequest *)request didFailWithError:(NSError *)error
{
	UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"新浪微博" message:[NSString stringWithFormat:@"发送失败：%@",[error description] ] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
	[alert show];
	[alert release];
}

- (void)request:(WBRequest *)request didLoad:(id)result
{
    
    
	UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"新浪微博" message:[NSString stringWithFormat:@"发送成功！" ] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
	NSString *urlString = request.url;
	if ([urlString rangeOfString:@"statuses/public_timeline"].location !=  NSNotFound)
	{
		alert.message = @"获取成功";
		NSLog(@"%@",result);
	}
	[alert show];
	[alert release];
	[weibo dismissSendView];
    
    [self showView:0];
}

#pragma mark WBSendView CALLBACK_API
- (void)sendViewWillAppear:(WBSendView*)sendView
{
	NSLog(@"sendview will appear.");
}

- (void)sendViewDidLoad:(WBSendView*)sendView
{
	NSLog(@"sendview did load.");
}

- (void)sendViewWillDisappear:(WBSendView*)sendView
{
	NSLog(@"sendview will disappear.");
}

- (void)sendViewDidDismiss:(WBSendView*)sendView
{
	NSLog(@"sendview did dismiss.");
}

////////////////////



- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    UIView *hit=nil;
    hit=[super hitTest:point withEvent:event];
    if(hit!=nil){
        [GlobalFunction closeTouch];
    }
    return hit;
}

-(IBAction) btnClicked:(id)sender {
    UIButton *btn = (UIButton *)sender;
    NSInteger index=btn.tag;
     if(index==100){
         [self shareSina];
     }else if(index==101){

         [jinjiangViewController emailSend:EMAIL_TITLE content:[copys objectAtIndex:dataIndex] path:SHARE_LINK];

     }else if(index==102){
         [self showView:0];
     }else if(index==103){
         if(weibo)
         [weibo postWeiboRequestWithText:[NSString stringWithFormat:@"%@ %@",shareTxt.text,SHARE_LINK] andImage:nil andDelegate:self];
         
     }else if(index==-1){
         [GlobalFunction fadeInOut:self to:0 time:0.4 hide:YES];
     }
      
}
- (id)initWithFrame:(CGRect)frame withData:(NSInteger)index
{
    self = [super initWithFrame:frame];
    if (self) {
        if(copys==nil){
            copys=[[NSArray alloc] initWithObjects:SHARE_COPY0,SHARE_COPY1,SHARE_COPY2,SHARE_COPY3,SHARE_COPY4, nil];
        }

        
        dataIndex=index;
        showIndex=-1;
        self.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        
        btnsView=[[UIView alloc] initWithFrame:CGRectMake(542-170, 1000, 170+171, 133)];
        shareView=[[UIView alloc] initWithFrame:INITRECT];
        
        UIButton *sinaBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        UIButton *emailBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [sinaBtn setImage:[UIImage imageNamed:@"share_sina.png"] forState:UIControlStateNormal];
        [emailBtn setImage:[UIImage imageNamed:@"share_email.png"] forState:UIControlStateNormal];
        sinaBtn.tag=100;
        emailBtn.tag=101;
        self.tag=-1;
        [sinaBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [emailBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        /*
        [GlobalFunction addImage:self name:@"share_line.png" rect:CGRectMake(542, 272, 1, 133)];
        
        sinaBtn.frame=CGRectMake(542-170, 272, 170, 133);
        emailBtn.frame=CGRectMake(543, 272, 174, 133);
        */
        
        [GlobalFunction addImage:btnsView name:@"share_line.png" rect:CGRectMake(170, 0, 1, 133)];
        
        sinaBtn.frame=CGRectMake(0, 0, 170, 133);
        emailBtn.frame=CGRectMake(171, 0, 174, 133);
       
        
        
        [btnsView addSubview:sinaBtn];
        [btnsView addSubview:emailBtn];
        
        
        [GlobalFunction addImage:shareView name:@"share_pop.png" rect:CGRectMake(292, 210, 476, 226)];

        UIButton *closeBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [closeBtn setImage:[UIImage imageNamed:@"share_close.png"] forState:UIControlStateNormal];
        closeBtn.tag=102;
        [closeBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
         closeBtn.frame=CGRectMake(743, 198, 33, 34);
        
        UIButton *shareBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [shareBtn setImage:[UIImage imageNamed:@"share_btn.png"] forState:UIControlStateNormal];
        shareBtn.tag=103;
        [shareBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        shareBtn.frame=CGRectMake(460, 360, 136, 49);
        
        [shareView addSubview:shareBtn];
        [shareView addSubview:closeBtn];

        
        //shareTxt
        shareTxt = [[UITextView alloc] initWithFrame:CGRectMake(320, 235, 413, 100)];
        shareTxt.textColor = [UIColor blackColor];
        shareTxt.font = [UIFont fontWithName:@"STHeitiTC-Medium" size:14];// [UIFont systemFontOfSize:17.0];
        shareTxt.backgroundColor = [UIColor clearColor];
        shareTxt.autocorrectionType = UITextAutocorrectionTypeNo;	// no auto correction support
        shareTxt.keyboardType = UIKeyboardTypeDefault;	// use the default type input method (entire keyboard)
        shareTxt.returnKeyType = UIReturnKeySend;
        shareTxt.autocapitalizationType=UITextAutocapitalizationTypeNone;
        shareTxt.delegate=self;
        shareTxt.scrollEnabled=NO;
        
        shareTxt.text=[copys objectAtIndex:dataIndex];
        
        //btnsView.bounds=CGRectMake(542-170, 272, 170+175, 133);
        //shareView.bounds=CGRectMake(272, 190,496, 246);
        //btnsView.backgroundColor=[UIColor clearColor];
        //shareView.userInteractionEnabled=NO;
        //btnsView.clipsToBounds=YES;
        //shareView.clipsToBounds=YES;
        
        [shareView addSubview:shareTxt];
        
        [self addSubview:btnsView];
        [self addSubview:shareView];
        
        self.alpha=0;

        //320 245
        
        [GlobalFunction fadeInOut:self to:1 time:0.4 hide:NO];
        [self showView:0];
        // Initialization code
    }
    return self;
}
- (void)textViewDidBeginEditing:(UITextView *)textView{
     if(cutTxt)[cutTxt resignFirstResponder];
    cutTxt=textView;
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    if(cutTxt)[cutTxt resignFirstResponder];
    cutTxt=nil;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {

    if (textView.contentSize.height > 104) {
        textView.text = [textView.text substringToIndex:[textView.text length]-1];
        return NO;
    }
    return YES;
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

    Release2Nil(weibo);
    RemoveRelease(shareTxt);
    RemoveRelease(btnsView);
    RemoveRelease(shareView);
    [super dealloc];
}

@end
