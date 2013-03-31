//
//  UIAViewController.m
//  UIA
//
//  Created by sk on 11-7-28.
//  Copyright 2011 sk. All rights reserved.
//

#import "IndexViewController.h"
#import"MyImageView.h"

#define RADIUS 100.0
#define PHOTONUM 5
#define PHOTOSTRING @"icon"
#define TAGSTART 1000
#define TIME 1.5
#define SCALENUMBER 1.25
int array [PHOTONUM][PHOTONUM] ={
	{0,1,2,3,4},
	{4,0,1,2,3},
	{3,4,0,1,2},
	{2,3,4,0,1},
	{1,2,3,4,0}
};

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
CATransform3D rotationTransform1[PHOTONUM];

@implementation IndexViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        self.trackedViewName = @"公交查询首页";
    }
    return self;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor clearColor];
	UIImageView *backview = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"121.png"]];
	backview.center = CGPointMake(backview.center.x, backview.center.y - 10);
	backview.alpha = 0.8;
	[self.view addSubview:backview];
    [self loadImageViews];
    [self loadCustomBanner];
}

-(void)loadImageViews
{
    NSArray *textArray = [NSArray arrayWithObjects:@"公交查询",@"关于我们",@"天气预报",@"旅游胜地",@"地图导航",nil];
    
	float centery = self.view.center.y - 70;
	float centerx = self.view.center.x;
    
	for (int i = 0;i<PHOTONUM;i++ )
	{
		float tmpy =  centery + RADIUS*cos(2.0*M_PI *i/PHOTONUM);
		float tmpx =	centerx - RADIUS*sin(2.0*M_PI *i/PHOTONUM);
		MyImageView *addImageView =	[[MyImageView alloc]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@%d",PHOTOSTRING,i]] text:[textArray objectAtIndex:i]];
        addImageView.frame = CGRectMake(0.0, 0.0,120,140);
		[addImageView setdege:self];
		addImageView.tag = TAGSTART + i;
		addImageView.center = CGPointMake(tmpx,tmpy);
		rotationTransform1[i] = CATransform3DIdentity;
		
		float Scalenumber = fabs(i - PHOTONUM/2.0)/(PHOTONUM/2.0);
		if (Scalenumber<0.3)
		{
			Scalenumber = 0.4;
		}
		CATransform3D rotationTransform = CATransform3DIdentity;
		rotationTransform = CATransform3DScale (rotationTransform, Scalenumber*SCALENUMBER,Scalenumber*SCALENUMBER, 1);
		addImageView.layer.transform=rotationTransform;
		[self.view addSubview:addImageView];
		
	}
	currenttag = TAGSTART;
}

-(void)clickUp:(NSInteger)tag
{
    //GA跟踪搜索按钮
    [[GAI sharedInstance].defaultTracker sendEventWithCategory:@"uiAction" withAction:@"buttonPress" withLabel:@"查询按钮" withValue:nil];
    
	if(currenttag == tag)
	{
		UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"点击" message: @"添加自己的处理" delegate:nil  cancelButtonTitle:@"OK" otherButtonTitles:nil];
		av.tag=110;
		[av show];	
		return;
	}
	int t = [self getblank:tag];
	int i = 0;
	for (i = 0;i<PHOTONUM;i++ ) 
	{
		
		UIImageView *imgview = (UIImageView*)[self.view viewWithTag:TAGSTART+i];
		[imgview.layer addAnimation:[self moveanimation:TAGSTART+i number:t] forKey:@"position"];
		[imgview.layer addAnimation:[self setscale:TAGSTART+i clicktag:tag] forKey:@"transform"];
	}
	currenttag = tag;
}


-(CAAnimation*)setscale:(NSInteger)tag clicktag:(NSInteger)clicktag
{
	int i = array[clicktag - TAGSTART][tag - TAGSTART];
	int i1 = array[currenttag - TAGSTART][tag - TAGSTART];
	float Scalenumber = fabs(i - PHOTONUM/2.0)/(PHOTONUM/2.0);
	float Scalenumber1 = fabs(i1 - PHOTONUM/2.0)/(PHOTONUM/2.0);
	if (Scalenumber<0.3) 
	{
		Scalenumber = 0.4;
	}
	CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"transform"];
	animation.duration = TIME;
	animation.repeatCount =1;
	
	
   CATransform3D dtmp = CATransform3DScale(rotationTransform1[tag - TAGSTART],Scalenumber*SCALENUMBER, Scalenumber*SCALENUMBER, 1.0);
	animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DScale(rotationTransform1[tag - TAGSTART],Scalenumber1*SCALENUMBER,Scalenumber1*SCALENUMBER, 1.0)];
	animation.toValue = [NSValue valueWithCATransform3D:dtmp ];
	animation.autoreverses = NO;	
	animation.removedOnCompletion = NO;
	animation.fillMode = kCAFillModeForwards;
	
	return animation;
}

-(CAAnimation*)moveanimation:(NSInteger)tag number:(NSInteger)num
{
	// CALayer
	UIImageView *imgview = (UIImageView*)[self.view viewWithTag:tag];
    CAKeyframeAnimation* animation;
    animation = [CAKeyframeAnimation animation];	
	CGMutablePathRef path = CGPathCreateMutable();
	CGPathMoveToPoint(path, NULL,imgview.layer.position.x,imgview.layer.position.y);
	
	int p =  [self getblank:tag];
    
	float f = 2.0*M_PI  - 2.0*M_PI *p/PHOTONUM;
	float h = f + 2.0*M_PI *num/PHOTONUM;
	float centery = self.view.center.y - 50;
	float centerx = self.view.center.x;
	float tmpy =  centery + RADIUS*cos(h);
	float tmpx =	centerx - RADIUS*sin(h);
	imgview.center = CGPointMake(tmpx,tmpy);
	
	CGPathAddArc(path,nil,self.view.center.x, self.view.center.y - 50,RADIUS,f+ M_PI/2,f+ M_PI/2 + 2.0*M_PI *num/PHOTONUM,0);	
	animation.path = path;
	CGPathRelease(path);
	animation.duration = TIME;
	animation.repeatCount = 1;
 	animation.calculationMode = @"paced"; 	
	return animation;
}


-(NSInteger)getblank:(NSInteger)tag
{
	if (currenttag>tag) 
	{
		return currenttag - tag;
	}
	else 
	{
		return PHOTONUM  - tag + currenttag;
	}

}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

@end
