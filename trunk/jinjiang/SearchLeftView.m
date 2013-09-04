//
//  SearchTVC.m
//  jinjiang
//
//  Created by Jeff.Yan on 11-11-15.
//  Copyright 2011年 W+K. All rights reserved.
//

#import "SearchLeftView.h"

#import "GlobalFunction.h"
#import "SearchVC.h"


@implementation SearchLeftView
@synthesize delegate;

#define SEARCHRECT CGRectMake(0, TOPHEIGHT, 347, 768-TOPHEIGHT)

-(void)searchClick:(id)btn{
    if(searchVC!=nil){
        [searchVC seach:keywordTxt.text cityName:cityTxt.text typeName:typeTxt.text];
    }
}
-(void)setTextField:(UITextField *)ut placeholder:(NSString *)placeholder tag:(NSInteger)tag{
   
    ut.borderStyle = UITextBorderStyleNone;
    ut.textColor = [UIColor blackColor];
    ut.font = [UIFont fontWithName:@"STHeitiTC-Medium" size:14];
    ut.placeholder = placeholder;
    ut.backgroundColor = [UIColor clearColor];
    ut.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    ut.autocorrectionType = UITextAutocorrectionTypeNo;	
    ut.keyboardType = UIKeyboardTypeDefault;	
    ut.returnKeyType = UIReturnKeyNext;
    ut.autocapitalizationType=UITextAutocapitalizationTypeNone;
    ut.clearButtonMode = UITextFieldViewModeNever;
    ut.userInteractionEnabled=NO;
    ut.tag = tag;
    
    

}
- (id)initSearch:(SearchVC *)svc
{
    self = [super initWithFrame:SEARCHRECT];
    if (self) {
        searchVC=svc;
        [GlobalFunction addImage:self name:@"5_seach_bg.png" rect:CGRectMake(0, 0, 350, 768-TOPHEIGHT)];
        [GlobalFunction addImage:self name:@"5_seach_txt.png" rect:CGRectMake(8, 20, 225, 211)];

        
        UIControl *uc1=[[UIControl alloc] initWithFrame:CGRectMake(74, 102, 233, 32)];
        UIView *uc2=[[UIControl alloc] initWithFrame:CGRectMake(74, 147, 233, 32)];
        UIControl *uc3=[[UIControl alloc] initWithFrame:CGRectMake(74, 192, 233, 32)];
        uc1.tag=200;
        uc2.tag=201;
        uc3.tag=202;
        //5_search_txt_bg
        
               
        
        [GlobalFunction addImage:uc1 name:@"5_search_txt_bg.png" rect:CGRectMake(0, 0, 233, 32)];
        [GlobalFunction addImage:uc2 name:@"5_search_txt_bg.png" rect:CGRectMake(0, 0, 233, 32)];
        [GlobalFunction addImage:uc3 name:@"5_search_txt_bg.png" rect:CGRectMake(0, 0, 233, 32)];
        
        [GlobalFunction addImage:uc1 name:@"5_search_txt_bg2.png" rect:CGRectMake(202, 15, 13, 8)];
        [GlobalFunction addImage:uc3 name:@"5_search_txt_bg2.png" rect:CGRectMake(202, 15, 13, 8)];
        
        [uc1 addTarget:self action:@selector(selectBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [uc3 addTarget:self action:@selector(selectBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        cityTxt=[[UITextField alloc] initWithFrame:CGRectMake(12, 7, 200, 20)];
        keywordTxt=[[UITextField alloc] initWithFrame:CGRectMake(12, 7, 213, 20)];
        typeTxt=[[UITextField alloc] initWithFrame:CGRectMake(12, 7, 200, 20)];
        
        [self setTextField:cityTxt placeholder:@"选择城市" tag:300];
        [self setTextField:keywordTxt placeholder:@"输入酒店名" tag:301];
        [self setTextField:typeTxt placeholder:@"选择酒店类型" tag:302];
        
        keywordTxt.clearButtonMode = UITextFieldViewModeWhileEditing;
        keywordTxt.userInteractionEnabled=YES;
        keywordTxt.delegate = self;
        
        [uc1 addSubview:cityTxt];
        [uc2 addSubview:keywordTxt];
        [uc3 addSubview:typeTxt];
        //UITextFieldViewModeWhileEditing
        
        UIViewController *contentViewController = [[UIViewController alloc] init];
        
        popover = [[UIPopoverController alloc] initWithContentViewController:contentViewController];
        popover.popoverContentSize = CGSizeMake(233, 300); 
        popover.passthroughViews=[NSArray arrayWithObjects:uc1,uc3,nil];
        popover.delegate=self;
        
        
        popTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0,233, 300)];
        popTableView.delegate=self;
        popTableView.dataSource=self;
        [contentViewController.view addSubview:popTableView];
        //popover 
        [contentViewController release];
        
        UIButton *seach=[UIButton buttonWithType:UIButtonTypeCustom];
        [seach setImage:[UIImage imageNamed:@"5_seach_btn.png"] forState:UIControlStateNormal];
        seach.frame=CGRectMake(88, 290, 154, 48);
        
        [seach addTarget:self action:@selector(searchClick:) forControlEvents:UIControlEventTouchUpInside];
    
        [self addSubview:uc1];
        [self addSubview:uc2];
        [self addSubview:uc3];
        [self addSubview:seach];
        editTxt=nil;
        cutData=nil;
        selectCity=-1;
        selectType=-1;
        //citys=[[NSMutableArray alloc] init];
        //types=[[NSMutableArray alloc] init];
        //APARTMENT
        
        citys=nil;
        types=nil;
        
        [uc1 release];
        [uc2 release];
        [uc3 release];
        //5_seach_btn
    }
    return self;
}
-(void)setListData:(NSArray *)data{
    //[httpData setObject:var1 forKey:@"HotelType"]; 
    //[httpData setObject:var2 forKey:@"CityName"];
    Release2Nil(citys);
    Release2Nil(types);
    
    NSMutableDictionary *cityKey=[[NSMutableDictionary alloc] init];
    NSMutableDictionary *typeKey=[[NSMutableDictionary alloc] init];
     NSMutableDictionary *temCityKey=[[NSMutableDictionary alloc] init];
    
    NSString *str=@"";
    
    //上海，北京，广州，深圳，南京，杭州，天津。
   // /*
    [temCityKey setValue:str forKey:@"上海"];
    [temCityKey setValue:str forKey:@"北京"];
    [temCityKey setValue:str forKey:@"广州"];
    [temCityKey setValue:str forKey:@"深圳"];
    [temCityKey setValue:str forKey:@"南京"];
    [temCityKey setValue:str forKey:@"杭州"];
    [temCityKey setValue:str forKey:@"天津"];
    //*/
    
    for(NSInteger i=0;i<[data count]; i++){
        NSLog(@"city:::::%d",i);
        NSLog(@"city:::::%@",[[data objectAtIndex:i] objectForKey:@"CityName"]);
        NSLog(@"------------------");
        if([[data objectAtIndex:i] objectForKey:@"CityName"] && ![[[data objectAtIndex:i] objectForKey:@"CityName"] isEqualToString:@"null"]  && ![[[data objectAtIndex:i] objectForKey:@"CityName"] isEqualToString:@""]  && ![[[data objectAtIndex:i] objectForKey:@"CityName"] isEqualToString:@"NULL"]  && ![[[data objectAtIndex:i] objectForKey:@"CityName"] isEqualToString:@"Null"]){
        if([cityKey objectForKey:[[data objectAtIndex:i] objectForKey:@"CityName"]] || [temCityKey objectForKey:[[data objectAtIndex:i] objectForKey:@"CityName"]]){
            
        }else
        [cityKey setValue:str forKey:[[data objectAtIndex:i] objectForKey:@"CityName"]];
        }
        
        if([[data objectAtIndex:i] objectForKey:@"HotelType"]  && ![[[data objectAtIndex:i] objectForKey:@"HotelType"] isEqualToString:@"null"]  && ![[[data objectAtIndex:i] objectForKey:@"HotelType"] isEqualToString:@""]  && ![[[data objectAtIndex:i] objectForKey:@"HotelType"] isEqualToString:@"NULL"]  && ![[[data objectAtIndex:i] objectForKey:@"HotelType"] isEqualToString:@"Null"]){

        if([typeKey objectForKey:[[data objectAtIndex:i] objectForKey:@"HotelType"]]){
            
        }else
        [typeKey setValue:str forKey:[[data objectAtIndex:i] objectForKey:@"HotelType"]];
        }
    }
    
    citys=[[NSMutableArray alloc] initWithObjects:@"全部",@"上海",@"北京",@"广州",@"深圳",@"南京",@"杭州",@"天津",nil];
    
    types=[[NSMutableArray alloc] initWithObjects:@"全部", nil];
    
    [citys addObjectsFromArray:[cityKey allKeys]];
    
    [types addObjectsFromArray:[typeKey allKeys]];
    
    Release2Nil(temCityKey);
    Release2Nil(cityKey);
    Release2Nil(typeKey);
    
    //citys=[[NSMutableArray alloc] initWithObjects:@"全部",@"北京",@"上海",@"广州",@"南京",@"深圳",nil];
    //  types=[[NSMutableArray alloc] initWithObjects:@"公寓",@"酒店",@"酒店式公寓",@"花园酒店",@"经济型酒店",@"豪华酒店",@"酒店及会议中心",@"度假村",@"汽车旅馆",@"全套房酒店",@"精品酒店",@"托管公寓",@"会议中心" nil];
    
    //types=[[NSMutableArray alloc] initWithObjects:@"全部",@"公寓",@"酒店",@"酒店式公寓",@"花园酒店",@"经济型酒店",@"豪华酒店",@"酒店及会议中心",@"度假村",@"汽车旅馆",@"全套房酒店",@"精品酒店",@"托管公寓",@"会议中心",nil];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30.0;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSUInteger row = [indexPath row];  
    if(cutData==citys){
        selectCity=row;
        cityTxt.text = [cutData objectAtIndex:row]; 
    }else if(cutData==types){
        selectType=row;
        typeTxt.text = [cutData objectAtIndex:row];
    }
    [popover dismissPopoverAnimated:YES];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(cutData)
    return [cutData count];
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";  
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];  
    if(cell == nil){  
        //cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:SimpleTableIdentifier] autorelease];
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SimpleTableIdentifier] autorelease];
    }  
    
    NSUInteger row = [indexPath row]; 
    if(cutData==citys){
        if(row==selectCity){
            cell.selected=YES;
        }else{
            cell.selected=NO;
        }
        cell.textLabel.text = [cutData objectAtIndex:row]; 
    }else if(cutData==types){
        cell.textLabel.text = [cutData objectAtIndex:row];
        if(row==selectType){
            cell.selected=YES;
        }else{
            cell.selected=NO;
        }
    }
    return cell;  
}
-(void)selectBtnClicked:(id)sender{
    //NSLog(@"selectBtnClicked:::%@",sender);
    UIControl *ui=(UIControl*)sender;
    CGRect popoverRect;
    [popover dismissPopoverAnimated:NO];
    if(ui.tag==200){
        cutData=citys;
        popover.popoverContentSize = CGSizeMake(233, 300);
       // NSLog(@"ui:::%@:%@",ui,NSStringFromCGRect(ui.frame));
        //popoverRect = CGRectMake(ui.frame.origin.x, ui.frame.origin.y, 0, 0);
        popoverRect = CGRectMake(ui.frame.origin.x+ui.frame.size.width/2, ui.frame.origin.y+46, 0, 0);
        [popover presentPopoverFromRect:popoverRect inView:self permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
        [popTableView reloadData];

    }else  if(ui.tag==202){
        cutData=types;
        popover.popoverContentSize = CGSizeMake(233, 300); 
        //popoverRect = CGRectMake(ui.frame.origin.x, ui.frame.origin.y, 0, 0);
        popoverRect = CGRectMake(ui.frame.origin.x+ui.frame.size.width/2, ui.frame.origin.y+46, 0, 0);
        [popover presentPopoverFromRect:popoverRect inView:self permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
        [popTableView reloadData];
    }
   
    ControlView *controlView=(ControlView *)self.superview;
    if(controlView)
        [controlView stopStartHide:YES];
    
    //NSLog(@"selectBtnClicked:::%@",controlView);
    [RootWindowUI closeOpen:YES];
}
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController{
    
    ControlView *controlView=(ControlView *)self.superview;
    if(controlView)
        [controlView stopStartHide:NO];
    
     //NSLog(@"popoverControllerDidDismissPopover:::%@",controlView);
    [RootWindowUI closeOpen:NO];
}
-(void)hide{
    if(editTxt!=nil){
        [editTxt resignFirstResponder];
    }
    editTxt=nil;
    [popover dismissPopoverAnimated:YES];

    
}
- (BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController{
    ControlView *controlView=(ControlView *)self.superview;
    if(controlView)
        [controlView stopStartHide:NO];
    [RootWindowUI closeOpen:NO];
    return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    ControlView *controlView=(ControlView *)self.superview;
    if(controlView)
    [controlView stopStartHide:YES];
    
    [RootWindowUI closeOpen:YES];
    editTxt=textField;
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    ControlView *controlView=(ControlView *)self.superview;
    if(controlView)
    [controlView stopStartHide:NO];
    
    [RootWindowUI closeOpen:NO];
    editTxt=nil;
    return YES;
}



- (void)dealloc
{
    Release2Nil(citys);
    Release2Nil(types);
    RemoveRelease(popTableView);
    RemoveRelease(cityTxt);
    RemoveRelease(keywordTxt);
    RemoveRelease(typeTxt);
    Release2Nil(popover);
    [super dealloc];
}

@end
