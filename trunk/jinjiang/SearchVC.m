//
//  SearchVC.m
//  jinjiang
//
//  Created by Jeff.Yan on 11-10-27.
//  Copyright 2011年 W+K. All rights reserved.
//

#import <CoreLocation/CLLocationManager.h>

#import "SearchVC.h"

#import "GlobalFunction.h"
#import "MainNC.h"
#import "NavigationView.h"
#import "jinjiangViewController.h"

#import "LoadingView.h"

#import "RootWindowUI.h"

#import "ControlView.h"

#import "JJMKAnnotationView.h"
#import "JJMKAnnotation.h"

#import "HTTPConnection.h"
#import "DataFileConnection.h"
#import "OmnitureManager.h"

@implementation SearchVC

#define DATA_URL @"http://www.jinjiang.com/hotel/queryHotelData"

#define _Def_check_data(d) ((d!=nil && [d objectForKey:@"Status"]!=nil && ![d isKindOfClass:[NSString class]] && ![d isKindOfClass:[NSNull class]] && [d isKindOfClass:[NSDictionary class]])?[[d objectForKey:@"Status"] intValue]:0)


-(BOOL)checkNullData:(NSDictionary *)dic key:(NSString *)key{
    if([dic objectForKey:key] && ![[dic objectForKey:key] isEqualToString:@"null"]  && ![[dic objectForKey:key] isEqualToString:@""]  && ![[dic objectForKey:key] isEqualToString:@"NULL"]  && ![[dic objectForKey:key] isEqualToString:@"Null"]){
        return YES;   
    }
    return NO;   
    
}
-(void)setBtn:(NSInteger)i{
    UIButton *btn;
    
   // NSLog(@"setBtn:::%d",i);
    index=i;
    if(i==0){
        [GlobalFunction moveView:lineView to:CGRectMake(222, 0, 1, TOPHEIGHT) time:0.3];
        btn=[btns objectAtIndex:1];
        btn.userInteractionEnabled=YES;
        btn.selected=NO;
        
        [GlobalFunction moveView:btn to:CGRectMake(223, 0, 60, TOPFULLHEIGHT) time:0.3];
        
        //222  lineView.frame=CGRectMake(222, 0, 1, TOPHEIGHT);
        
        btn=[btns objectAtIndex:0];
        btn.userInteractionEnabled=NO;
        btn.selected=YES;
        
        [GlobalFunction moveView:btn to:CGRectMake(0, 0, 222, TOPFULLHEIGHT) time:0.3];
        
        
        searchTxt.userInteractionEnabled=YES;
        [GlobalFunction fadeInOut:searchTxt to:1.0 time:0.3 hide:NO];
        [GlobalFunction fadeInOut:seachBg to:1.0 time:0.3 hide:NO];
        
    }else{
        [GlobalFunction moveView:lineView to:CGRectMake(60, 0, 1, TOPHEIGHT) time:0.3];
        
        btn=[btns objectAtIndex:0];
        btn.userInteractionEnabled=YES;
        btn.selected=NO;
        
        [GlobalFunction moveView:btn to:CGRectMake(0, 0, 60, TOPFULLHEIGHT) time:0.3];
        
        btn=[btns objectAtIndex:1];
        btn.userInteractionEnabled=NO;
        btn.selected=YES;
        
        [GlobalFunction moveView:btn to:CGRectMake(61, 0, 222, TOPFULLHEIGHT) time:0.3];
        
        //seachBg
        searchTxt.userInteractionEnabled=NO;
        [GlobalFunction fadeInOut:searchTxt to:0.0 time:0.3 hide:NO];
        [GlobalFunction fadeInOut:seachBg to:0.0 time:0.3 hide:NO];
    }
}

-(BOOL)checkStr:(NSDictionary *)dic str:(NSString *)str{
    NSInteger t;
    if([self checkNullData:dic key:@"HotelName"]){
    t =[[dic objectForKey:@"HotelName"] rangeOfString:str].location;
    
    if(t!= NSNotFound){
        return YES; 
    }
    }
    if([self checkNullData:dic key:@"HotelAddress"]){
    t =[[dic objectForKey:@"HotelAddress"] rangeOfString:str].location;  
    
    if(t!= NSNotFound){
        return YES;
    }
    }
    
    if([self checkNullData:dic key:@"CityName"]){
    t =[[dic objectForKey:@"CityName"] rangeOfString:str].location;   
    
    if(t!= NSNotFound){
         return YES;
    }
    }
    
    if([self checkNullData:dic key:@"PhoneNum"]){
    t =[[dic objectForKey:@"PhoneNum"] rangeOfString:str].location;  
    if(t!= NSNotFound){
        return YES;
    }
    }
    
    if([self checkNullData:dic key:@"HotelType"]){
    t =[[dic objectForKey:@"HotelType"] rangeOfString:str].location;
    if(t!= NSNotFound){
        return YES;
    }
    }
    return NO;
}
-(void)seach:(NSString *)str{
   
    if(searchData==nil){
        return;
    }
    NSMutableArray *arr=[[NSMutableArray alloc] init];
    
    if(str==nil || [str isEqualToString:@""]){
        [searchResultBar setData:searchData cc:@"SearchResultTVC" _sh:116];
        [controlView showLeft:0];
        [self setBtn:0];
    }else{
        //NSInteger t;
        for(NSInteger i=0;i<[searchData count]; i++){
            NSDictionary *dic=[searchData objectAtIndex:i];
            if([self checkStr:dic str:str]){
                [arr addObject:dic];
            }
            /*
            t =[[dic objectForKey:@"HotelName"] rangeOfString:str].location;
       
            if(t!= NSNotFound){
                [arr addObject:dic];
                continue;
            }
            t =[[dic objectForKey:@"HotelAddress"] rangeOfString:str].location;  
         
            if(t!= NSNotFound){
                [arr addObject:dic];
                continue;
            }
            t =[[dic objectForKey:@"CityName"] rangeOfString:str].location;   
        
            if(t!= NSNotFound){
                [arr addObject:dic];
                continue;
            }
            t =[[dic objectForKey:@"PhoneNum"] rangeOfString:str].location;  
            if(t!= NSNotFound){
                [arr addObject:dic];
                continue;
            }
            t =[[dic objectForKey:@"HotelType"] rangeOfString:str].location;
            if(t!= NSNotFound){
                [arr addObject:dic];
                continue;
            }
            */
        //isEqualToString
        //[searchData objectAtIndex:i];
        }
        if([arr count]<=0){
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"锦江" message:@"没有搜索到结果，请选择其他类型或关键字。" delegate:nil cancelButtonTitle:@"确定"otherButtonTitles:nil];
        [alert show];
        [alert release];
        }else{
            isData=YES;
           [searchResultBar setData:arr cc:@"SearchResultTVC" _sh:116]; 
            [controlView showLeft:0];
            [self setBtn:0];
        }
        
    }
    //
    
    //
    [arr release];
    //return [arr autorelease];
}

-(void )seach:(NSString *)str cityName:(NSString *)cityName  typeName:(NSString *)typeName{
  
    if(searchData==nil){
        return;
    }
    BOOL s1=NO;
    BOOL s2=NO;
    BOOL s3=NO;
    if(str==nil || [str isEqualToString:@""])s1=YES;
    
    if(cityName==nil || [cityName isEqualToString:@"全部"] || [cityName isEqualToString:@""])s2=YES;
    if(typeName==nil || [typeName isEqualToString:@"全部"] || [typeName isEqualToString:@""])s3=YES;

    
    NSMutableArray *arr=[[NSMutableArray alloc] init];
    
   // NSInteger t;
    NSInteger t2;
    
    BOOL isStr=NO;
    
    
    for(NSInteger i=0;i<[searchData count]; i++){
        NSDictionary *dic=[searchData objectAtIndex:i];
        if(!s1){
            isStr=[self checkStr:dic str:str];
            //t =[[dic objectForKey:@"HotelName"] rangeOfString:str].location;
        }
        if(s1 && s2 && s3){
            [arr addObject:dic];
            continue;
            
        }else if(s1 && s2 && [self checkNullData:dic key:@"HotelType"]){
              t2 =[[dic objectForKey:@"HotelType"] rangeOfString:typeName].location;
            if(t2!= NSNotFound){
                [arr addObject:dic];
                continue;
            }
        }else if(s1 && s3  && [self checkNullData:dic key:@"CityName"]){
            
            if([cityName isEqualToString:[dic objectForKey:@"CityName"]]){
                [arr addObject:dic];
                continue;
            }
        }else if(s3 && s2){
            if(isStr){
                [arr addObject:dic];
                continue;
            }

        }else if(s1   && [self checkNullData:dic key:@"HotelType"]   && [self checkNullData:dic key:@"CityName"]){
             t2 =[[dic objectForKey:@"HotelType"] rangeOfString:typeName].location;
            
            if(t2!= NSNotFound && [cityName isEqualToString:[dic objectForKey:@"CityName"]]){
                [arr addObject:dic];
                continue;
            }
        }else if(s2   && [self checkNullData:dic key:@"HotelType"]){
              t2 =[[dic objectForKey:@"HotelType"] rangeOfString:typeName].location;
            if(t2!= NSNotFound && isStr){
                [arr addObject:dic];
                continue;
            }
        }else if(s3   && [self checkNullData:dic key:@"CityName"]){
            if([typeName isEqualToString:[dic objectForKey:@"CityName"]] && isStr){
                [arr addObject:dic];
                continue;
            }  
        }else if(  [self checkNullData:dic key:@"HotelType"]   && [self checkNullData:dic key:@"CityName"]){
              t2 =[[dic objectForKey:@"HotelType"] rangeOfString:typeName].location;
            if(isStr && t2!= NSNotFound && [cityName isEqualToString:[dic objectForKey:@"CityName"]]){
                [arr addObject:dic];
                continue;
            }
        
        }
       
    }
    if([arr count]<=0){
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"锦江" message:@"没有搜索到结果，请选择其他类型或关键字。" delegate:nil cancelButtonTitle:@"确定"otherButtonTitles:nil];
        [alert show];
        [alert release];
    }else{
        isData=YES;
        [searchResultBar setData:arr cc:@"SearchResultTVC" _sh:116];
        [controlView showLeft:0];
        [self setBtn:0];
    }
    [arr release];
}
-(void)cancel{
    if(hTTPConnection!=nil){
        hTTPConnection.delegate=nil;
        [hTTPConnection cancelDownload];
        Release2Nil(hTTPConnection);
    }
}

-(void)loadErr{
    NSLog(@"loadErr");
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"锦江" message:@"数据读取失败..." delegate:nil cancelButtonTitle:@"确定"otherButtonTitles:nil];
	[alert show];
	[alert release];
    
    [self cancel];
    //controlView.userInteractionEnabled=YES;
}
-(void)showMe{
    CLLocationCoordinate2D theCoordinate;
    
    theCoordinate.latitude=myCoordinate.latitude;
    theCoordinate.longitude=myCoordinate.longitude;
    
    isSelect=YES;
    [myMapView setCenterCoordinate:theCoordinate animated:YES];
    isSelect=NO;

    //[myMapView setCenterCoordinate:myCoordinate animated:YES];
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    //NSLog(@"didFailWithError::didFailWithError");
    if(myBtn){
        myBtn.userInteractionEnabled=NO;
    }
}
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    //NSLog(@"locationManager::locationManager");
    myCoordinate=newLocation.coordinate;
    if(myBtn){
        myBtn.userInteractionEnabled=YES;
    }
}

-(void)moveMapTo:(NSDictionary *)dic{ 
    if(myMapView!=nil){
        CLLocationCoordinate2D theCoordinate;
        
        theCoordinate.latitude=[[dic objectForKey:@"HotelLatitude"] floatValue];
        theCoordinate.longitude=[[dic objectForKey:@"HotelLongitude"] floatValue];
        
        
        isSelect=YES;
        [myMapView setCenterCoordinate:theCoordinate animated:YES];
        isSelect=NO;
    }
    
    
}
-(void)addAnnotation:(NSMutableDictionary *)dic{ //(NSString *)title lat:(CGFloat)lat log:(CGFloat)log{
    if(myMapView!=nil){
        JJMKAnnotation *mapann;
        
        mapann=[[JJMKAnnotation alloc] initWithInfo:dic]; 
        
        [myMapView addAnnotation:mapann];
        
        [dic setValue:mapann forKey:@"annotaion"];
        
        [mapann release];
    }
    
    
}

-(void)loadData:(NSString *)var1{
    [self cancel];
    NSMutableDictionary *httpData=[[NSMutableDictionary alloc] init];
    
    [httpData setObject:var1 forKey:@"IPadqueryWords"];
    [httpData setObject:@"3000" forKey:@"pagination.rows"];
    
    hTTPConnection=[[HTTPConnection alloc] init];
    hTTPConnection.delegate=self;
    [hTTPConnection sendRequest:DATA_URL postData:httpData type:nil];
    
    [httpData release];
    [self showLoading];
}
-(void)loadData:(NSString *)var1 var2:(NSString *)var2 var3:(NSString *)var3{
    [self cancel];
    NSMutableDictionary *httpData=[[NSMutableDictionary alloc] init];
    [httpData setObject:var1 forKey:@"cityName"]; 
    [httpData setObject:var2 forKey:@"hotelTypes"]; 
    [httpData setObject:var3 forKey:@"hotelName"]; 
    hTTPConnection=[[HTTPConnection alloc] init];
    hTTPConnection.delegate=self;
    [hTTPConnection sendRequest:DATA_URL postData:httpData type:nil];
    
    [httpData release];
    [self showLoading];
}
- (void)postHTTPDidFinish:(NSMutableData *)_data hc:(HTTPConnection *) _hc{
    [self hideLoading];
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSString *strData = [[NSString alloc] initWithData:_data encoding:NSUTF8StringEncoding];
    NSLog(@"strData:::::::%@",strData);
    NSDictionary *data=[strData JSONValue];
    
    
    
    //NSLog(@"data:::::::%@",data);
    
    [strData release];
     NSInteger ii=_Def_check_data(data);
    if(ii!=1){
        //NSLog(@"postHTTPError:::::1");
        [self loadErr];
    }else{
        if(myMapView!=nil){
            searchData=[[data objectForKey:@"data"] retain];
            NSMutableArray *arr=[[NSMutableArray alloc] init];
            //for(NSInteger n=0;n<100;n++){
            //NSLog(@"[searchData count]:::::::%d",[searchData count]);
            for(NSInteger i=0;i<[searchData count];i++){
                [self addAnnotation:[searchData objectAtIndex:i]];
                [arr addObject:[searchData objectAtIndex:i]];
            }
            //}
            //NSLog(@"searchData:::%@",searchData);
            //[searchResultBar setData:arr cc:@"SearchResultTVC" _sh:116];
            
            //[controlView showLeft:0];
            //[self setBtn:0];
            [arr release];
        }
        [DataFileConnection saveDataToFile:data fileName:@"searchData.vam" setType:nil];
         [searchLeftView setListData:searchData];
    }
    [self cancel];
    [pool release];
    
    //[self seach:@"上海"];
    
     controlView.userInteractionEnabled=YES;
    
}

- (void)postHTTPError:(HTTPConnection *) _hc{
    [self hideLoading];
    [self loadErr];
}
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
    // NSLog(@"mapView:didSelectAnnotationView");
}
- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view{
    //NSLog(@"mapView:didDeselectAnnotationView");
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    //NSLog(@"mapView:annotationView:calloutAccessoryControlTapped");
}
- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated{
    
    //NSLog(@"regionWillChangeAnimated::regionWillChangeAnimated");
    if(!isSelect)
    if(controlView){
        [controlView showTop:-1];
        [controlView showLeft:-1];
    }
    
}
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation{
    JJMKAnnotationView *pinView = nil; 
   // NSLog(@"mapView");
    if(annotation != mapView.userLocation) 
    { 
        static NSString *defaultPinID = @"jinjing"; 
        pinView = (JJMKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:defaultPinID]; 
        if ( pinView == nil ) pinView = [[[JJMKAnnotationView alloc] 
                                          initWithAnnotation:annotation reuseIdentifier:defaultPinID] autorelease]; 
        //pinView.pinColor = MKPinAnnotationColorRed; 
        //pinView.canShowCallout = YES; 
        //if(cutDic==dic){
           // [myMapView selectAnnotation:mapann animated:YES];
        //}
        pinView.jjAnn=annotation;
        
        pinView.userInteractionEnabled=YES;
        
    } 
    else { 
        [mapView.userLocation setTitle:@"我的位置"];
        
       // [mapView.userLocation setSubtitle:[initData objectForKey:@""]]; 
    }
    [pinView moveIn];
    return pinView; 
}
-(void)initMap{    
    // Custom initialization
    cutDic=nil;
    isSelect=NO;
    isData=NO;
    
    if(myMapView==nil){
   
        myMapView = [[MKMapView alloc] initWithFrame:FULLRECT];
       
        myMapView.delegate=self; 
        myMapView.showsUserLocation=YES;
        
        myLocationManager = [[CLLocationManager alloc] init];
        myLocationManager.delegate = self;     
        myLocationManager.desiredAccuracy = kCLLocationAccuracyBest;  
        [myLocationManager startUpdatingLocation]; 
        [self loadData:@""];
        myCoordinate.latitude=31.230393;
        myCoordinate.longitude=121.473704;
        
        CLLocationCoordinate2D theCoordinate;
    
        theCoordinate.latitude=31.230393;
        theCoordinate.longitude=121.473704;
    
    //loc.latitude = 37.786996;
       
        MKCoordinateRegion region;
        region.span.latitudeDelta = 0.05;
        region.span.longitudeDelta = 0.05;
        region.center = theCoordinate;
    
        [myMapView setCenterCoordinate:theCoordinate animated:YES];
    // 设置显示位置(动画)
        [myMapView setRegion:region animated:YES];
    // 设置地图显示的类型及根据范围进行显示
        [myMapView regionThatFits:region];
    
       // JJMKAnnotation *mapann=[[JJMKAnnotation alloc] initWithInfo:theCoordinate setTitle:@"test1" setSub:@"test2"]; 
        
        //[myMapView addAnnotation:mapann];//在地图上显示大头针
    
        //[mapann release];
    
        [self.view addSubview:myMapView];
    }
    //    
    
}

-(void)btnClicked:(id)sender {
    UIButton *btn = (UIButton *)sender;
    NSInteger ii=btn.tag;
    switch (ii) {
        case 100:
            [self setBtn:0];
            if(isData){
                [controlView showLeft:0];
            }else{
                [controlView showLeft:-1];
            }
            break;
        case 101:
            [self setBtn:1];
            [controlView showLeft:1];
            break;
        case 102:
            [self showMe];
            //[controlView showLeft:0];
            break;
        case 103:
             [jinjiangViewController showShare:2];
           break;
    }
}


- (void)loadView
{
   [super loadView];
    Release2Nil(hTTPConnection);
    index=-1;
    
    //[DataFileConnection readDataFromFile:nil fileName:@"searchData.vam" onDidOk:<#(SEL)#> onErr:<#(SEL)#> delegate:self];
    //[DataFileConnection saveDataToFile:data fileName:@"searchData.vam" setType:@""];
    
}
- (void)viewDidLoad{
      [super viewDidLoad];
    
    NSMutableDictionary *vars = [NSMutableDictionary dictionary];
    [vars setValue:@"地图定位锦江页面" forKey:@"pageName"];
    [vars setValue:@"发现锦江" forKey:@"channel"];
    [OmnitureManager trackWithVariables:vars];
    
    //RemoveRelease(nullTxt);
    
    RemoveRelease(searchLeftView);
    RemoveRelease(lineView);
    RemoveRelease(seachBg);
    RemoveRelease(searchTxt);
    myMapView.delegate=nil;
    RemoveRelease(myMapView);
    
    ControlTopView *temTop;
    
    UIButton *but;
    
    temTop=[[ControlTopView alloc] initWithFrame:TOPRECT];
    
    [GlobalFunction addImage:temTop name:@"top_bg.png" rect:CGRectMake(223+120+61+61, 0, 1024-(223+120+61+61), 56)];
    
    
    but=[ControlView getTopButtom:0 width:222];
    
    [GlobalFunction addImage:but name:@"5_title_btn1.png" rect:CGRectMake(18, 16, 21, 21)];
    //
    //[GlobalFunction addImage:but name:@"5_title_bg.png" rect:CGRectMake(0, 0, 222, 56)];
    but.clipsToBounds=YES;
    but.tag=100;
    [btns addObject:but];
    
    [but addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [temTop addSubview:but];
    
    lineView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"top_w_line.png"]];
    lineView.frame=CGRectMake(222, 0, 1, TOPHEIGHT);
    [temTop addSubview:lineView];
    
    
    
    
    //[GlobalFunction addImage:temTop name:@"top_w_line.png" rect:CGRectMake(222, 0, 1, TOPHEIGHT)];
    
    but=[ControlView getTopButtom:223 width:60];
    
    but.clipsToBounds=YES;
    
    but.tag=101;
    [btns addObject:but];
    
    //5_title_btn2
    //[GlobalFunction addImage:but name:@"5_btn0.png"];
    UIImageView  *uv=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"5_title_btn2.png"]];
    uv.frame=CGRectMake(18, 10, 152, 32);
    [but addSubview:uv];
    //[GlobalFunction addImage:but name:@"5_title_btn2.png"];
    [but addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [temTop addSubview:but];
    
    
    [uv release];
    
    [GlobalFunction addImage:temTop name:@"top_w_line.png" rect:CGRectMake(223+60, 0, 1, TOPHEIGHT)];
    
    myBtn=[ControlView getTopButtom:223+61 width:60];
    
    myBtn.tag=102;
    [btns addObject:but];
    [GlobalFunction addImage:myBtn name:@"5_btn1.png"];
    [myBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [temTop addSubview:myBtn];
    myBtn.userInteractionEnabled=NO;
    [GlobalFunction addImage:temTop name:@"top_w_line.png" rect:CGRectMake(223+61+60, 0, 1, TOPHEIGHT)];
    
    but=[ControlView getTopButtom:223+122 width:120];
    but.tag=103;
    [btns addObject:but];
    [GlobalFunction addImage:but name:@"5_btn2.png"];
    [but addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [temTop addSubview:but]; 
    [GlobalFunction addImage:temTop name:@"top_w_line.png" rect:CGRectMake(223+122+120, 0, 1, TOPHEIGHT)];
    
    
    
    searchTxt = [[UITextField alloc] initWithFrame:CGRectMake(42, 16, 132, 20)];//(30, 8, 132, 20)];//
    searchTxt.borderStyle = UITextBorderStyleNone;
    searchTxt.textColor = [UIColor blackColor];
    searchTxt.font = [UIFont fontWithName:@"STHeitiTC-Medium" size:14];// [UIFont systemFontOfSize:17.0];
    searchTxt.placeholder = @"输入关键字搜索";
    searchTxt.backgroundColor = [UIColor clearColor];
    searchTxt.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    searchTxt.autocorrectionType = UITextAutocorrectionTypeNo;	// no auto correction support
    searchTxt.keyboardType = UIKeyboardTypeDefault;	// use the default type input method (entire keyboard)
    searchTxt.returnKeyType = UIReturnKeySearch;
    searchTxt.autocapitalizationType=UITextAutocapitalizationTypeNone;
    searchTxt.clearButtonMode = UITextFieldViewModeWhileEditing;	// has a clear 'x' button to the right
    
    searchTxt.tag = 200;		// tag this control so we can remove it later for recycled cells
    
    searchTxt.delegate = self;
    
    
    seachBg=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 220, 60)];
    
    seachBg.userInteractionEnabled=NO;
    
    [GlobalFunction addImage:seachBg name:@"5_title_bg.png" point:CGPointMake(12, 8)];
    
    [temTop addSubview:seachBg];
    
    [temTop addSubview:searchTxt];
    
    
    [controlView addTop:temTop];
    [temTop release];
    
    

    searchLeftView=[[SearchLeftView alloc] initSearch:self];
    
    searchResultBar=[[SearchLeftScrollView alloc] initWithFrame:CGRectMake(0, TOPHEIGHT, 381, 768-TOPHEIGHT)];
    
    
    
    searchLeftView.delegate=self;
    
    searchResultBar.delegate=self;
    
    [controlView addLeft:searchResultBar];
    
    [controlView addLeft:searchLeftView];
    
   
    [self initMap];
    
    [self.view addSubview:controlView];
    if(index==-1){
        [self setBtn:0];
        controlView.userInteractionEnabled=NO;
    }else{
       [self setBtn:index]; 
        controlView.userInteractionEnabled=YES;
    }
    [controlView showTop:0];
  
}
- (void)viewDidUnload{
    
    RemoveRelease(searchLeftView);
    RemoveRelease(lineView);
    RemoveRelease(seachBg);
    RemoveRelease(searchTxt);
    myMapView.delegate=nil;
    RemoveRelease(myMapView);
    
    [super viewDidUnload];
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [RootWindowUI closeOpen:YES];
    [controlView showLeft:-1];
    [controlView stopStartHide:YES];
    
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    //NSLog(@"textFieldDidEndEditing");
    [RootWindowUI closeOpen:NO];
    [controlView stopStartHide:NO];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if(textField==searchTxt){
       [self seach:searchTxt.text];
        [textField resignFirstResponder];
        [RootWindowUI closeOpen:NO];
        [controlView stopStartHide:NO];
    }
    
    return YES;
}
-(void)selectView:(NSInteger)index{
    
}

-(void)selectView:(LeftScrollView *)leftScrollView index:(NSInteger)index2 dic:(NSDictionary *)dic{
    if(leftScrollView==searchResultBar){
        //NSLog(@"index2::::%d::%@",index2,dic);
        cutDic=dic;
        [myMapView selectAnnotation:[dic objectForKey:@"annotaion"] animated:YES];
        [self moveMapTo:dic];
    }else{
        
    }
}

-(void)outFun{
    NSLog(@"outFun");
    cacheImage=[[UIImageView alloc] initWithImage:[GlobalFunction imageFromView:self.view]];
    [self.view addSubview:cacheImage];
    
    if(myLocationManager)[myLocationManager stopUpdatingHeading]; 
    [self cancel];
    
    
    
    Release2Nil(searchData);
    Release2Nil(myLocationManager);
    
    //RemoveRelease(nullTxt);
    RemoveRelease(searchResultBar);
    RemoveRelease(searchLeftView);
    RemoveRelease(lineView);
    RemoveRelease(seachBg);
    RemoveRelease(searchTxt);
    
    myMapView.delegate=nil;
    RemoveRelease(myMapView);
    [RootWindowUI closeOpen:NO];
    
}


- (void)dealloc
{
    if(myLocationManager)[myLocationManager stopUpdatingHeading]; 
    //[self cancel];
 
    RemoveRelease(cacheImage);
   
    Release2Nil(searchData);
    Release2Nil(myLocationManager);
    
    //RemoveRelease(nullTxt);
    RemoveRelease(searchResultBar);
    RemoveRelease(searchLeftView);
    RemoveRelease(lineView);
    RemoveRelease(seachBg);
    RemoveRelease(searchTxt);
    myMapView.delegate=nil;
    RemoveRelease(myMapView);
     NSLog(@"dealloc seach");
    [super dealloc];
}

@end
