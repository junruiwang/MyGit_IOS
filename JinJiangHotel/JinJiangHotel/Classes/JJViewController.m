//
//  JJViewController.m
//  JinJiang
//
//  Created by Leon on 10/23/12.
//
//
#import "Constants.h"
#import "JJViewController.h"

@implementation JJViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *backgroundName = self.view.frame.size.height > 480 ? @"bg_5.png" : @"bg.png";
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:backgroundName]];
    
    [self initNavigationBarWithStyle:JJDefaultBarStyle];
}

- (void)initNavigationBarWithStyle:(JJNavigationBarStyle)barStyle
{
    self.navigationBar = [[JJNavigationBar alloc] initNavigationBarWithStyle:barStyle];
    self.navigationBar.delegate = self;
    [self.view addSubview:self.navigationBar];
    [self.view bringSubviewToFront:self.navigationBar];
}

- (void)viewWillAppear:(BOOL)animated
{
    [UMAnalyticManager monitorViewPage:self.trackedViewName];
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [UMAnalyticManager monitorQuitViewPage:self.trackedViewName];
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

- (void)showIndicatorView
{
    if (self.loadingIndicatorView == nil)
    {
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        self.loadingIndicatorView = [board instantiateViewControllerWithIdentifier:@"LoadingIndicatorViewController"];
        [self.loadingIndicatorView.view setCenter:CGPointMake(self.view.center.x, self.view.center.y)];
        [self.loadingIndicatorView startAnimating];
    }
//    self.view.userInteractionEnabled = NO;
    self.navigationController.navigationBar.userInteractionEnabled = NO;
    [self.view addSubview:self.loadingIndicatorView.view];
}

- (void)hideIndicatorView
{
//    self.view.userInteractionEnabled = YES;
    self.navigationController.navigationBar.userInteractionEnabled = YES;
    [self.loadingIndicatorView stopAnimating];
    [self.loadingIndicatorView.view removeFromSuperview];
    self.loadingIndicatorView = nil;
}

- (void)downloadData
{

}

- (void)backHome:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)call
{
    UIActionSheet *menu = [[UIActionSheet alloc] initWithTitle:@"电话预订" delegate:self cancelButtonTitle:@"取消"
                                        destructiveButtonTitle:nil otherButtonTitles:@"1010-1666", nil];
    [menu setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    [menu setAlpha:1.0f];
    [menu showInView:self.view];
}

- (void)backToController:(Class)className
{
    
    NSArray *viewControlelrs = self.navigationController.viewControllers;
    for (JJViewController *jjvc in viewControlelrs) {
        if ([jjvc isKindOfClass:className]) {
            
            [self.navigationController popToViewController:jjvc animated:YES];
            break;
        }
    }
}

- (void)parser:(GDataXMLParser *)parser DidFailedParseWithMsg:(NSString *)msg errCode:(NSInteger)code
{
    [self hideIndicatorView];
    if(code == -1 || code == 10000)
        
    {
        [self showAlertMessageWithOkCancelButton:kNetworkProblemAlertMessage title:nil tag:0 delegate:self];
    }
    else
    {   [self showAlertMessageWithOkButton:msg title:nil tag:0 delegate:nil];   }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    switch (alertView.tag)
    {
        case 0:
        {
            if(buttonIndex == 1)
            {   [self downloadData];    }
            break;
        }
        default:
            break;
    }
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {   [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://1010-1666"]];   }
}


int prewTag ;  //编辑上一个UITextField的TAG,需要在XIB文件中定义或者程序中添加，不能让两个控件的TAG相同
float prewMoveY; //编辑的时候移动的高度
// 下面两个方法是为了防止TextFiled让键盘挡住的方法
/**
 开始编辑UITextField的方法
 */
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect textFrame =  textField.frame;
    float textY = textFrame.origin.y+textFrame.size.height;
    float bottomY = self.containerView.frame.size.height - textY;
    if(bottomY >= 216)  //判断当前的高度是否已经有216，如果超过了就不需要再移动主界面的View高度
    {
        prewTag = -1;
        return;
    }
    prewTag = textField.tag;
    float moveY = 216 - bottomY;
    prewMoveY = moveY;

    NSTimeInterval animationDuration = 0.2f;
    CGRect frame = self.containerView.frame;
    frame.origin.y -=moveY;//view的Y轴上移
    frame.size.height +=moveY; //View的高度增加
    [UIView beginAnimations:@"ResizeView" context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    self.containerView.frame = frame;
    [UIView commitAnimations];//设置调整界面的动画效果
}

//
/**
 结束编辑UITextField的方法，让原来的界面还原高度
 */
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if(prewTag == -1) //当编辑的View不是需要移动的View
    {
        return;
    }
    float moveY ;
    NSTimeInterval animationDuration = 0.2f;
    CGRect frame = self.containerView.frame;
    if(prewTag == textField.tag) //当结束编辑的View的TAG是上次的就移动
    {   //还原界面
        moveY =  prewMoveY;
        frame.origin.y +=moveY;
        frame.size. height -=moveY;
        self.containerView.frame = frame;
    }
    //self.view移回原位置
    [UIView beginAnimations:@"ResizeView" context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    self.containerView.frame = frame;
    [UIView commitAnimations];
    [textField resignFirstResponder];
}

- (void)backButtonPressed
{
    [self backHome:NULL];
}

@end
