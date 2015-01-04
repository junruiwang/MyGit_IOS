//
//  SceneListViewController.m
//  HomeFurnishing
//
//  Created by jerry on 14/12/25.
//  Copyright (c) 2014年 handpay. All rights reserved.
//

#import "SceneListViewController.h"
#import "SceneListParser.h"
#import "Constants.h"
#import "CodeUtil.h"
#import "NSDataAES.h"
#import "SceneTableCell.h"
#import "AppDelegate.h"

#define TABLE_ROW_INDEX_START 200

@interface SceneListViewController ()<JsonParserDelegate>

@property(nonatomic, strong) SceneListParser *sceneListParser;
@property(nonatomic, strong) NSMutableArray *sceneList;

@end

@implementation SceneListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    self.listTableView.backgroundColor = [UIColor clearColor];
    [self loadRemoteSceneList];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadRemoteSceneList
{
    NSString *serverId = TheAppDelegate.currentServerId;
    
    if (serverId != nil) {
        if (self.sceneListParser != nil) {
            [self.sceneListParser cancel];
            self.sceneListParser = nil;
        }
        self.sceneListParser = [[SceneListParser alloc] init];
        self.sceneListParser.serverAddress = kSceneListURL;
        self.sceneListParser.requestString = [self md5HexForRequest:serverId];
        self.sceneListParser.isArrayReturnValue = YES;
        self.sceneListParser.delegate = self;
        [self.sceneListParser start];
        [self showLoadingView];
    }
}

- (NSString *)md5HexForRequest:(NSString *)serverId
{
    NSString *token = [[NSUUID UUID] UUIDString];
    NSString *appendStr = [NSString stringWithFormat:@"%@%@", token, kSecretKey];
    NSString *sign = [CodeUtil hexStringFromString:[appendStr MD5String]];
    NSLog(@"sign : %@",sign);
    
    return [NSString stringWithFormat:@"api=true&sign=E50AEBBE04A43A035629B463C138C3C6&token=123&serverId=%@",serverId];
}

- (void)checkButtonClicked:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    NSInteger tagNum = btn.tag - TABLE_ROW_INDEX_START;
    NSDictionary *dict = [self.sceneList objectAtIndex:tagNum];
    BOOL isExit = NO;
    if (self.selectedSceneList) {
        for (NSDictionary *selDict in self.selectedSceneList) {
            NSString *curId = [dict objectForKey:@"id"];
            NSString *selId = [selDict objectForKey:@"id"];
            if ([curId isEqualToString:selId]) {
                isExit = YES;
            }
        }
    } else {
        self.selectedSceneList = [[NSMutableArray alloc] initWithCapacity:5];
    }
    if (!isExit) {
        [self.selectedSceneList addObject:dict];
    }
    
    btn.selected = !btn.selected;
    if (btn.selected) {
        [btn setBackgroundImage:[UIImage imageNamed:@"checkbox_pressed"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"checkbox_pressed"] forState:UIControlStateHighlighted];
        [btn setBackgroundImage:[UIImage imageNamed:@"checkbox_pressed"] forState:UIControlStateSelected];
    } else {
        [btn setBackgroundImage:[UIImage imageNamed:@"checkbox_normal"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"checkbox_normal"] forState:UIControlStateHighlighted];
        [btn setBackgroundImage:[UIImage imageNamed:@"checkbox_normal"] forState:UIControlStateSelected];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.sceneList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [self.sceneList objectAtIndex:[indexPath row]];
    SceneTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SceneTableCell"];
    cell.selBtn.tag = TABLE_ROW_INDEX_START + [indexPath row];
    [cell.selBtn addTarget:self action:@selector(checkButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    BOOL isExit = NO;
    if (self.selectedSceneList) {
        for (NSDictionary *selDict in self.selectedSceneList) {
            NSString *curId = [dict objectForKey:@"id"];
            NSString *selId = [selDict objectForKey:@"id"];
            //忽略大小写比较
            if ([curId isEqualToString:selId]) {
                isExit = YES;
            }
        }
    }
    if (isExit) {
        [cell.selBtn setBackgroundImage:[UIImage imageNamed:@"checkbox_pressed"] forState:UIControlStateNormal];
        [cell.selBtn setBackgroundImage:[UIImage imageNamed:@"checkbox_pressed"] forState:UIControlStateHighlighted];
        [cell.selBtn setBackgroundImage:[UIImage imageNamed:@"checkbox_pressed"] forState:UIControlStateSelected];
        cell.selBtn.selected = YES;
    } else {
        [cell.selBtn setBackgroundImage:[UIImage imageNamed:@"checkbox_normal"] forState:UIControlStateNormal];
        [cell.selBtn setBackgroundImage:[UIImage imageNamed:@"checkbox_normal"] forState:UIControlStateHighlighted];
        [cell.selBtn setBackgroundImage:[UIImage imageNamed:@"checkbox_normal"] forState:UIControlStateSelected];
        cell.selBtn.selected = NO;
    }
    cell.separatorImage.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dashed_detail.png"]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = [dict objectForKey:@"name"];
    cell.textLabel.font = [UIFont systemFontOfSize:18];
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[tableView cellForRowAtIndexPath:indexPath] setSelected:NO];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}


#pragma mark JsonParserDelegate

- (void)parser:(JsonParser*)parser DidFailedParseWithMsg:(NSString*)msg errCode:(NSInteger)code
{
    NSLog(@"%@",msg);
    [self hideLoadingView];
}

- (void)parser:(JsonParser*)parser DidParsedData:(NSDictionary *)data
{
    NSArray *list = [data objectForKey:@"data"];
    if (list) {
        self.sceneList = [list mutableCopy];
        [self.listTableView reloadData];
    }
    [self hideLoadingView];
}

@end
