//
//  ActivationTypeController.m
//  JinJiangTravelPlus
//
//  Created by 吕 硕 on 12-12-20.
//  Copyright (c) 2012年 JinJiang. All rights reserved.
//

#import "ActivationTypeController.h"
#import "ActivationType.h"

@interface ActivationTypeController ()

@end

@implementation ActivationTypeController

@synthesize typeArray;
@synthesize typeTableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    CGRect framex = CGRectMake(0, 0, 320, self.view.frame.size.height - 44);
    self.typeTableView = [[UITableView alloc] initWithFrame:framex style:UITableViewStylePlain];
    [self.typeTableView setSeparatorColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"dashed.png"]]];
    [self.typeTableView setDelegate:self]; [self.typeTableView setDataSource:self];
    [self.view addSubview:self.typeTableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.typeArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {   cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];  }
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    const unsigned int row = [indexPath row];
    ActivationType* activationType = [self.typeArray objectAtIndex:row];
    cell.textLabel.text = activationType.cnName;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString* cnName = cell.textLabel.text; unsigned int i = 0;
    [cell setSelected:NO];

    for (i = 0; i < [self.typeArray count]; i++)
    {
        ActivationType* activationType = [self.typeArray objectAtIndex:i];
        if ([cnName isEqualToString:activationType.cnName]) {   break;  }
    }

    if (self.delegate != nil) { [self.delegate selectActivationType:i]; }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 41;
}

@end
