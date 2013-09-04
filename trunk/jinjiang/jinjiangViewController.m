//
//  jinjiangViewController.m
//  jinjiang
//
//  Created by Jeff.Yan on 11-10-26.
//  Copyright 2011年 W+K. All rights reserved.
//

#import "jinjiangViewController.h"
#import "NavigationView.h"
#import "MainNC.h"
#import "ModalWebVC.h"
#import "GlobalFunction.h"
#import "VersionHandle.h"
#import "Version.h"

@interface jinjiangViewController()
{
    VersionHandle *versionHandle;
}
@end

@implementation jinjiangViewController

- (void)dealloc
{
    [NavigationView shareRelease];
    [MainNC shareRelease];
    [versionHandle release];
    [super dealloc];
    
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    
    if(interfaceOrientation==UIInterfaceOrientationPortrait || interfaceOrientation==UIInterfaceOrientationPortraitUpsideDown){
        return NO;
    }else{
        return YES;
    }
    
}
-(void)messageShow:(NSString *)str{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"锦江旅行⁺" message:[NSString stringWithFormat:str] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
	[alert show];
	[alert release];
}

- (void)loadView
{
    [super loadView];
    [GlobalFunction addImage:self.view name:@"1_bg.png"];
    versionHandle = [[VersionHandle alloc] init];
    [versionHandle load];
   
}



-(void)showShare:(NSInteger)index{
    ShareView *shareView=[[ShareView alloc] initWithFrame:FULLRECT withData:index];
    [self.view addSubview:shareView];
    [shareView release];
}
-(void)showLeaderView{
    PopLeaderView *popLeaderView=[[PopLeaderView alloc] initWithFrame:FULLRECT];
    [self.view addSubview:popLeaderView];
    [popLeaderView release];
}

-(void)modalUV:(UIViewController *)uv{
    if(parentVC==nil){
        [self presentModalViewController:uv animated:YES];
        parentVC=uv;
    }
    
}
-(void)dismissUV{
    if(parentVC!=nil){
        parentVC=nil;
        [self dismissModalViewControllerAnimated:YES];
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    
    switch (result) { 
        case MFMailComposeResultCancelled: 
             [self dismissModalViewControllerAnimated:YES];
            //[self messageShow:@"郵件已取消！"];
            break; 
        case MFMailComposeResultSaved: 
            [self messageShow:@"邮件已保存！"];
             [self dismissModalViewControllerAnimated:YES];
            break; 
        case MFMailComposeResultSent: 
            [self messageShow:@"邮件发送成功！"];
             [self dismissModalViewControllerAnimated:YES];
            break; 
        case MFMailComposeResultFailed: 
            [self messageShow:@"邮件发送失败！"];
            break; 
    } 
    [self dismissModalViewControllerAnimated:YES]; 

}
+(void)emailSend:(NSString *)email{
    jinjiangViewController *_instance=[jinjiangViewController sharedInstance];
    [_instance emailSend:email];
}
-(void)emailSend:(NSString *)email{
    
    if ([MFMailComposeViewController canSendMail]) {
        
        MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
        picker.mailComposeDelegate = self; 

        [picker setToRecipients:[NSArray arrayWithObjects:email, nil]];
        [picker setSubject:@""];
        //Dear，
        //下载地址：www.jinjiang.com
        NSString *emailBody =@"";
        
        [picker setMessageBody:emailBody isHTML:YES]; 
        picker.navigationBar.barStyle = UIBarStyleBlack;
        [self presentModalViewController:picker animated:YES];
        [picker release];
    }else{
       [self messageShow:@"不能发送邮件!"];
    }
    
    
}
-(void)emailSend:(NSString *)title content:(NSString *)content path:(NSString *)path{

    if ([MFMailComposeViewController canSendMail]) {

        MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
        picker.mailComposeDelegate = self; 
 
        [picker setSubject:title];
        //Dear，
        //下载地址：www.jinjiang.com
        NSString *emailBody =[NSString stringWithFormat:@"<meta http-equive=\"Content-Type\" content=\"text/html;charset=UTF-8\">Dear，<br/>%@<br/><a href=\"%@\">下载地址：%@</a><br/><br/><br/>", content,path, path];

        [picker setMessageBody:emailBody isHTML:YES]; 
        picker.navigationBar.barStyle = UIBarStyleBlack;
        [self presentModalViewController:picker animated:YES];
        [picker release];
    }else{
        [self messageShow:@"不能发送邮件!"];
    } 
     
    
}
+(void)emailSend:(NSString *)title content:(NSString *)content path:(NSString *)path{
   // NSLog(@"!!!!!111");
    jinjiangViewController *_instance=[jinjiangViewController sharedInstance];
    // NSLog(@"!!!!!111222");
   // NSLog(@"_instance:::::%@",_instance);
   //  NSLog(@"!!!!!111333");
    [_instance emailSend:title content:content path:path];
    // NSLog(@"!!!!!111444");
}

+(void)showShare:(NSInteger)index{
    jinjiangViewController *_instance=[jinjiangViewController sharedInstance];
    [_instance showShare:index];
}
+(void)showLeaderView{
    jinjiangViewController *_instance=[jinjiangViewController sharedInstance];
    [_instance showLeaderView];
}
//-(void)showLeaderView

+(void)modalUV:(UIViewController *)uv{
    [RootWindowUI closeOpen:YES];
    jinjiangViewController *_instance=[jinjiangViewController sharedInstance];
    [_instance modalUV:uv];
}
+(void)dismissUV{
   
    [RootWindowUI closeOpen:NO];
    jinjiangViewController *_instance=[jinjiangViewController sharedInstance];
    [_instance dismissUV];
}

+(void)toLink:(NSString *)url{
    ModalWebVC *webView=[[ModalWebVC alloc] init];
    [webView loadUrl:url];
    [jinjiangViewController modalUV:webView];
    [webView release];
    
}

static jinjiangViewController *_instance = nil;
+(void)shareRelease
{
    Release2Nil(_instance);
}

+ (id)sharedInstance
{
    @synchronized(self)
    {
        if (_instance == nil) {
            _instance =[[jinjiangViewController alloc] init]; 
            _instance.view.frame=CGRectMake(0, 0, 1024, 768);
            
            //_instance.view.backgroundColor=[UIColor colorWithRed:0.478f green:0.478f blue:0.478f alpha:1.0f];
            
            NavigationView *navView = [NavigationView sharedInstance];
            MainNC *nc=[MainNC sharedInstance];
            
            //[_instance addContentUV];
            //[_instance addPopUV];
            [_instance.view addSubview:nc.view];
            [_instance.view addSubview:navView];
            
           // [nc release];
            
            //navView.hidden=YES;
            //[[CGController sharedInstance] initShow:navView root:_instance];
            
        }
    }
    return _instance;
}


@end
