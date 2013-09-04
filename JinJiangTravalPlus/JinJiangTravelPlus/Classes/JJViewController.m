//
//  JJViewController.m
//  JinJiang
//
//  Created by Leon on 10/23/12.
//
//

#import "JJViewController.h"

@interface JJViewController ()

@end

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
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigation_bg.png"]];
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.962 alpha:1.000];
    //self.view.backgroundColor = [UIColor colorWithRed:252 green:252 blue:252 alpha:1];
    
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 8)];
    [imageView setImage:[UIImage imageNamed:@"bg_shadow.png"]];
    [self.view addSubview:imageView];

    [self addLeftBarButton:@"hotel-topbar-back.png"];
    [self addRightBarButton];
}

- (void)viewWillAppear:(BOOL)animated
{
    [UMAnalyticManager monitorViewPage:self.trackedViewName];
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
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
        [self.loadingIndicatorView.view setCenter:CGPointMake(self.view.center.x, 190)];
        [self.loadingIndicatorView startAnimating];
    }
    self.view.userInteractionEnabled = NO;
    [self.view addSubview:self.loadingIndicatorView.view];
}

- (void)hideIndicatorView
{
    self.view.userInteractionEnabled = YES;
    self.navigationController.navigationBar.userInteractionEnabled = YES;
    [self.loadingIndicatorView stopAnimating];
    [self.loadingIndicatorView.view removeFromSuperview];
    self.loadingIndicatorView = nil;
}

- (void)downloadData
{

}

- (void)addLeftBarButton:(NSString *) imageName
{
    //add left back button
    UIButton *backButton = [self generateNavButton:imageName action:@selector(backHome:)];
    backButton.frame = CGRectMake(0, 0, 48, 44);

    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = barButtonItem;
}

- (void)addRightBarButton
{
//    const unsigned int ww = 40 * btnAry.count;
//    UIToolbar *tools = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, ww, 44.01f)]; // 44.01 shifts it up 1px for some reason
//    tools.clearsContextBeforeDrawing = NO;
//    tools.clipsToBounds = NO;
//    tools.tintColor = [UIColor colorWithWhite:0.305f alpha:0.0f];
//    tools.barStyle = -1;
//    NSMutableArray *barButtonItems = [NSMutableArray array];
//    for (unsigned int i = 0; i < [btnAry count]; i++)
//    {
//        UIButton *btn = [btnAry objectAtIndex:i];
//        btn.frame = CGRectMake(0, 0, 40, 44);
//        UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
//        [barButtonItems addObject:barButtonItem];
//    }
//    [tools setItems:barButtonItems animated:NO];
    
    UIButton* telphoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [telphoneBtn setImage:[UIImage imageNamed:@"hotel-topbar-phone.png"] forState:UIControlStateNormal];
    [telphoneBtn setImage:[UIImage imageNamed:@"hotel-topbar-phone_press.png"] forState:UIControlStateHighlighted];
    [telphoneBtn addTarget:self action:@selector(call) forControlEvents:UIControlEventTouchUpInside];
    telphoneBtn.frame = CGRectMake(0, 0, 40, 44);
    
    UIBarButtonItem *fullBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:telphoneBtn];
    self.navigationItem.rightBarButtonItem = fullBarButtonItem;
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

- (UIButton *)generateNavButton:(NSString *)imageName action:(SEL)actionName
{
    UIButton* targetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [targetBtn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [targetBtn setShowsTouchWhenHighlighted:YES];
    [targetBtn addTarget:self action:actionName forControlEvents:UIControlEventTouchUpInside];

    return targetBtn;
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
    {   [self showAlertMessageWithOkCancelButton:kNetworkProblemAlertMessage title:nil tag:0 delegate:self];    }
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


@end
