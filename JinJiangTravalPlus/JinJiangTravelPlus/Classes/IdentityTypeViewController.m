//
//  IdentityTypeViewController.m
//  JinJiangTravelPlus
//
//  Created by jerry on 13-1-6.
//  Copyright (c) 2013年 JinJiang. All rights reserved.
//

#import "IdentityTypeViewController.h"

@interface IdentityTypeViewController ()

@property (nonatomic, strong) NSMutableArray *identityTypeList;
@property (nonatomic, strong) NSIndexPath *lastIndexPath;

@end

@implementation IdentityTypeViewController

- (id)init
{
    self = [super init];
    if (self)
    {
        IdentityType *identity_ID = [[IdentityType alloc] initWithName:@"ID" cnName:@"身份证"];
        IdentityType *identity_Passport = [[IdentityType alloc] initWithName:@"Passport" cnName:@"护照"];
        IdentityType *identity_Work = [[IdentityType alloc] initWithName:@"Work" cnName:@"工作证"];
        IdentityType *identity_Soldier = [[IdentityType alloc] initWithName:@"Soldier" cnName:@"军人证"];
        IdentityType *identity_Driving = [[IdentityType alloc] initWithName:@"Driving License" cnName:@"驾照"];
        IdentityType *identity_Foreigner = [[IdentityType alloc] initWithName:@"Foreigner" cnName:@"外国人居留证"];
        IdentityType *identity_Taiwan = [[IdentityType alloc] initWithName:@"Taiwan" cnName:@"台胞证"];
        IdentityType *identity_Return = [[IdentityType alloc] initWithName:@"Return" cnName:@"回乡证"];
        IdentityType *identity_Pass = [[IdentityType alloc] initWithName:@"Pass" cnName:@"通行证"];
        IdentityType *identity_Others = [[IdentityType alloc] initWithName:@"Others" cnName:@"其他"];

        _identityTypeList = [[NSMutableArray alloc] initWithObjects:identity_ID, identity_Passport, identity_Work, identity_Soldier, identity_Driving, identity_Foreigner, identity_Taiwan, identity_Return, identity_Pass, identity_Others, nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"请选择证件类型";
    const unsigned int hh = self.view.frame.size.height - 44;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, hh)
                                                  style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorColor = [UIColor clearColor];
    [self.view addSubview:self.tableView];
    [self loadLeftButton];
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigation_bg.png"]];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[[UIImage imageNamed:@"hotel-bg.png"]
                                                                stretchableImageWithLeftCapWidth:20 topCapHeight:20]];
}

- (void)loadLeftButton
{
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 25)];
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"nav-close.png"] forState:UIControlStateNormal];
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"nav-close-press.png"] forState:UIControlStateHighlighted];
    [leftBtn addTarget:self action:@selector(closeCurrentView) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
}

- (void)closeCurrentView
{
    [self.delegate pickIdentityDone:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.identityTypeList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CheckMarkCellIdentifier = @"CheckMarkCellIdentifier";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CheckMarkCellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CheckMarkCellIdentifier];
    }
    const unsigned int row = [indexPath row];
    const unsigned int oldRow = [self.lastIndexPath row];
    IdentityType *identityType = [self.identityTypeList objectAtIndex:row];
    cell.textLabel.text = [NSString stringWithFormat:@"    %@",identityType.identityTypeCnName];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
    cell.accessoryType = (row == oldRow && self.lastIndexPath != nil) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;

    UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(0, 39, 320, 1)];
    line.backgroundColor = [UIColor colorWithPatternImage:[[UIImage imageNamed:@"dashed.png"]
                                                           stretchableImageWithLeftCapWidth:20 topCapHeight:0]];
    [cell addSubview:line];

    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    const unsigned int newRow = [indexPath row];
    IdentityType *identityType = [self.identityTypeList objectAtIndex:newRow];
    const unsigned int oldRow = (self.lastIndexPath != nil) ? [self.lastIndexPath row] : -1;
    if (newRow != oldRow)
    {
        UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
        newCell.accessoryType = UITableViewCellAccessoryCheckmark;

        UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:self.lastIndexPath];
        oldCell.accessoryType = UITableViewCellAccessoryNone;
        self.lastIndexPath = indexPath;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.delegate pickIdentityDone:identityType];
    [[tableView cellForRowAtIndexPath:indexPath] setSelected:NO];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

@end
