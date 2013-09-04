//
//  UsableCouponListViewController.m
//  JinJiangTravelPlus
//
//  Created by 胡 桂祁 on 1/9/13.
//  Copyright (c) 2013 JinJiang. All rights reserved.
//

#import "UsableCouponListViewController.h"
#import "OrderCoupon.h"
#import "TableSelectButton.h"
#import "MinusOrAddButton.h"
#import "MinusOrAddObj.h"
#import "UseCouponObj.h"


#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

@interface UsableCouponListViewController (Private)


@end

@implementation UsableCouponListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.trackedViewName = @"订单使用优惠券页面";
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.couponListTableView.backgroundColor = [UIColor blackColor];
    self.couponListTableView.separatorColor = [UIColor clearColor];
    self.view.backgroundColor = [UIColor clearColor];
    NSMutableArray *tempCouponUseObjArray = [[NSMutableArray alloc] init];
    
    if (_couponList && [_couponList count]>0)
    {
        for (unsigned int i = 0; i<[_couponList count]; i++)
        {
            UseCouponObj *useCouponObj = [[UseCouponObj alloc] init];
            
            TableSelectButton *selectButton = [[TableSelectButton alloc] initWithFrame:CGRectMake(20, 10, 25, 25) unSelectImgName:@"unCheck_coupon_frame.png" selectImgName:@"check_coupon_pressed.png"];
            
            [selectButton addTarget:self action:@selector(clickSelectCoupon:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside ];
           
            useCouponObj.selectButton = selectButton;

            MinusOrAddObj *minusOrAddObj = [[MinusOrAddObj alloc] init];

            [minusOrAddObj.minusButton addTarget:self action:@selector(minusCouponSize:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside ];
            [minusOrAddObj.addButton addTarget:self action:@selector(addCouponSize:) forControlEvents:UIControlEventTouchUpInside |
                                     UIControlEventTouchUpOutside ];
            OrderCoupon *orderCoupon =[_couponList objectAtIndex:i];
            minusOrAddObj.minusButton.tag = orderCoupon.maxUseSize;
            minusOrAddObj.minusButton.currentIndex = i;
            minusOrAddObj.addButton.tag = orderCoupon.maxUseSize;
            minusOrAddObj.addButton.currentIndex = i;
            minusOrAddObj.couponSizeLabel.text = [NSString stringWithFormat:@"%d",orderCoupon.maxUseSize];
            
            useCouponObj.minusOrAddObj = minusOrAddObj;
            
            [tempCouponUseObjArray addObject:useCouponObj];
        }
        _couponUseObjList = tempCouponUseObjArray;
        _useCoupon = [[UseCoupon alloc] init];
    }
 
        UIButton *okButton = nil;
        if ([[NSUserDefaults standardUserDefaults] boolForKey:USER_DEVICE_5] == YES)
        {
            okButton = [[UIButton alloc] initWithFrame:CGRectMake(55, 438, 162, 39)];
        } else {
            okButton = [[UIButton alloc] initWithFrame:CGRectMake(55, 350, 162, 39)];
        }
        okButton.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"OK_coupon.png"]];
        [okButton addTarget:self action:@selector(okClickEvent:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
        
        [self.view addSubview:okButton];

    
	// Do any additional setup after loading the view.
}

//#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
        return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!self.couponList || [self.couponList count] == 0)
    {
        return 1;
    }
    return [self.couponList count] + 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    const unsigned int couponListCount = [self.couponList count];
    if ([self.couponList count] <= 0)
    {
        return nil;
    }
    NSUInteger section = [indexPath section];
    const unsigned int row = [indexPath row];
    
    static NSString *CellIdentifier = @"CouponCell";
    UITableViewCell *cell = [self.couponListTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.font = [UIFont systemFontOfSize: 14];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    if(section == 0 && row == 0)
    {
        UILabel *amountTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 15, 40, 15)];
        amountTextLabel.text = @"金额";
        amountTextLabel.font=[UIFont systemFontOfSize:15];
        [cell.contentView addSubview:amountTextLabel];
        
        UILabel *useSizeTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(170, 15, 80, 15)];
        useSizeTextLabel.text = @"使用张数";
        useSizeTextLabel.font=[UIFont systemFontOfSize:15];
        [cell.contentView addSubview:useSizeTextLabel];
        UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(0, 39, 285, 1)];
        line.backgroundColor = [UIColor colorWithPatternImage:[[UIImage imageNamed:@"dashed.png"]
                                                               stretchableImageWithLeftCapWidth:20 topCapHeight:0]];
        [cell addSubview:line];
        
    }
    else if(section == 0 && row <= couponListCount)
    {
        OrderCoupon *orderCoupon = [self.couponList objectAtIndex:row - 1];
        UseCouponObj *tempCouponUseObj = [self.couponUseObjList objectAtIndex:row-1];
        
        TableSelectButton *selectButton = tempCouponUseObj.selectButton;
        selectButton.currentIndex = row-1;
        [cell.contentView addSubview:selectButton];

        UILabel *amountTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 15, 40, 15)];
        amountTextLabel.text = [NSString stringWithFormat:@"￥%d",orderCoupon.couponAmount];
        amountTextLabel.font = [UIFont systemFontOfSize:14];
        [cell.contentView addSubview:amountTextLabel];

        MinusOrAddObj *minusOrAddObj = tempCouponUseObj.minusOrAddObj;
        UILabel *useSizeTextLabel = minusOrAddObj.couponSizeLabel;
        [cell.contentView addSubview:useSizeTextLabel];

        UIButton *minusBtn = minusOrAddObj.minusButton;
        [cell.contentView addSubview:minusBtn];

        UIButton *addBtn = minusOrAddObj.addButton;
        [cell.contentView addSubview:addBtn];
        UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(0, 39, 285, 1)];
        line.backgroundColor = [UIColor colorWithPatternImage:[[UIImage imageNamed:@"dashed.png"]
                                                               stretchableImageWithLeftCapWidth:20 topCapHeight:0]];
        [cell addSubview:line];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

-(void)okClickEvent:sender
{
   [self.delegate buildUseCoupon:_useCoupon];
}


#pragma mark --minusCouponSize:sender

-(void)minusCouponSize:(id)sender
{
    MinusOrAddButton *minusBtn = (MinusOrAddButton *) sender;
    unsigned int currentCouponSize= [minusBtn.couponSizeLabel.text intValue];
    currentCouponSize--;
    
    UseCouponObj *tempUseCouponObj = [_couponUseObjList objectAtIndex:minusBtn.currentIndex];
    MinusOrAddObj *minusOrAddObj = tempUseCouponObj.minusOrAddObj;
    if(currentCouponSize<=1)
    {
        if(currentCouponSize == 1)
        {
            minusOrAddObj.minusButton.couponSizeLabel.text = [NSString stringWithFormat:@"%d",currentCouponSize];
        }
        [minusOrAddObj disabledMinusBtn];
        //保证取的优惠券数量是最新的
        _useCoupon.useCouponNum = [minusOrAddObj.couponSizeLabel.text integerValue];
        return;
    }
    minusOrAddObj.minusButton.couponSizeLabel.text = [NSString stringWithFormat:@"%d",currentCouponSize];
    //保证取的优惠券数量是最新的
    _useCoupon.useCouponNum = [minusOrAddObj.couponSizeLabel.text integerValue];
    if (currentCouponSize == minusBtn.tag -1)
    {
        [minusOrAddObj enableAddButton];
    }
}

#pragma mark --addCouponSize:(id)sender
-(void)addCouponSize:(id)sender
{
    MinusOrAddButton *addBtn = (MinusOrAddButton *) sender;
    NSUInteger currentCouponSize=[addBtn.couponSizeLabel.text intValue];
    
    currentCouponSize++;
    UseCouponObj *tempUseCouponObj = [_couponUseObjList objectAtIndex:addBtn.currentIndex];
    MinusOrAddObj *minusOrAddObj = tempUseCouponObj.minusOrAddObj;
    if(currentCouponSize >= addBtn.tag)
    {
        if (currentCouponSize == addBtn.tag)
        {
            addBtn.couponSizeLabel.text = [NSString stringWithFormat:@"%d", currentCouponSize];
        }
        [minusOrAddObj disabledAddBtn];
        //保证取的优惠券数量是最新的
        _useCoupon.useCouponNum = [minusOrAddObj.couponSizeLabel.text integerValue];
        return;
    }
    
    addBtn.couponSizeLabel.text = [NSString stringWithFormat:@"%d", currentCouponSize];
    //保证取的优惠券数量是最新的
    _useCoupon.useCouponNum = [minusOrAddObj.couponSizeLabel.text integerValue];
    if (currentCouponSize>1&& currentCouponSize<= addBtn.tag)
    {
        minusOrAddObj.minusButton.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"minus-press.png"]];
    }
    
}

- (void)setValueForUseCoupon:(TableSelectButton *)button minusOrAddObj:(MinusOrAddObj *)minusOrAddObj
{
    OrderCoupon *orderCoupon = [self.couponList objectAtIndex:button.currentIndex];
    _useCoupon.couponIndex = button.currentIndex;
    _useCoupon.useCouponNum = [minusOrAddObj.couponSizeLabel.text integerValue];
    _useCoupon.couponAmount = orderCoupon.couponAmount;
}

-(void)resetValueForUseCoupon
{
    _useCoupon.couponIndex = 0;
    _useCoupon.totalAmount = 0;
    _useCoupon.useCouponNum = 0;
}

#pragma mark --clickSelectCoupon:(id)sender
-(void)clickSelectCoupon:(id)sender
{
    TableSelectButton *button =(TableSelectButton *) sender;
    button.tag++;
    
    UseCouponObj *useCouponObj = [_couponUseObjList objectAtIndex:button.currentIndex];
    MinusOrAddObj *minusOrAddObj = useCouponObj.minusOrAddObj;
    
    if(button.isChecked)
    {
        [button selectBtn];
        [minusOrAddObj showMinusOrAddObj];
        [minusOrAddObj makeMinusOrAddBtnDark];
        [self setValueForUseCoupon:button minusOrAddObj:minusOrAddObj];
    }
    else
    {
        [button unSelectBtn];
        [minusOrAddObj hiddenMinusOrAddObj];
        [self resetValueForUseCoupon];
    }
    for (unsigned int i = 0; i < [_couponUseObjList count]; i++ )
    {
        if(button.currentIndex == i)
            continue;
            UseCouponObj *tempUseCouponObj = [_couponUseObjList objectAtIndex:i];
            TableSelectButton *tempButton = tempUseCouponObj.selectButton;
            MinusOrAddObj *tempMinusOrAddObj = tempUseCouponObj.minusOrAddObj;
            [tempButton resetSelectStatus];
            [tempMinusOrAddObj hiddenMinusOrAddObj];
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    const unsigned int row = [indexPath row];
    
    if(row!=0 && row<=[self.couponList count])
    {
        UseCouponObj *tempUseCouponObj = [_couponUseObjList objectAtIndex:row -1];
        
        TableSelectButton *selectButton = tempUseCouponObj.selectButton;
        [self clickSelectCoupon:selectButton];
    }
    [[tableView cellForRowAtIndexPath:indexPath] setSelected:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
