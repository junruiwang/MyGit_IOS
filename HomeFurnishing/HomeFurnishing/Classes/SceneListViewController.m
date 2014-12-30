//
//  SceneListViewController.m
//  HomeFurnishing
//
//  Created by jerry on 14/12/25.
//  Copyright (c) 2014年 handpay. All rights reserved.
//

#import "SceneListViewController.h"
#import "SceneListParser.h"
#import "MyServerIdManager.h"
#import "Constants.h"
#import "CodeUtil.h"
#import "NSDataAES.h"

@interface SceneListViewController ()<JsonParserDelegate>

@property(nonatomic, strong) SceneListParser *sceneListParser;
@property(nonatomic, strong) NSMutableArray *sceneList;
@property(nonatomic, strong) MyServerIdManager *myServerIdManager;
@property(nonatomic, strong) NSMutableArray *selectedSceneList;

@end

@implementation SceneListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.myServerIdManager = [[MyServerIdManager alloc] init];
    self.selectedSceneList = [[NSMutableArray alloc] initWithCapacity:5];
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
    NSString *serverId = [self.myServerIdManager getCurrentServerId];
    
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
    }
}

- (NSString *)md5HexForRequest:(NSString *)serverId
{
//    NSString *udidString = [[UIDevice currentDevice].identifierForVendor UUIDString];
//    NSString *token = [udidString stringByReplacingOccurrencesOfString:@"-" withString:@""];
//    NSString *appendStr = [NSString stringWithFormat:@"%@%@",token,kSecretKey];
//    NSString *sign = [CodeUtil hexStringFromString:[appendStr MD5String]];
    
    return [NSString stringWithFormat:@"api=true&sign=E50AEBBE04A43A035629B463C138C3C6&token=123&serverId=%@",serverId];
}

- (void)checkButtonClicked:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    btn.selected = !btn.selected;
    if (btn.selected) {
        [btn setBackgroundImage:[UIImage imageNamed:@"checkbox_pressed"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"checkbox_pressed"] forState:UIControlStateHighlighted];
    } else {
        [btn setBackgroundImage:[UIImage imageNamed:@"checkbox_normal"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"checkbox_normal"] forState:UIControlStateHighlighted];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.sceneList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        UIButton *selBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        selBtn.frame = CGRectMake(350, 10, 30, 30);
        [selBtn setBackgroundImage:[UIImage imageNamed:@"checkbox_normal"] forState:UIControlStateNormal];
        [selBtn setBackgroundImage:[UIImage imageNamed:@"checkbox_normal"] forState:UIControlStateHighlighted];
        [selBtn addTarget:self action:@selector(checkButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:selBtn];
        
        UIImageView *separatorImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 43, 400, 1)];
        separatorImage.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dashed_detail.png"]];
        [cell addSubview:separatorImage];
    }
    cell.backgroundColor = [UIColor clearColor];
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    NSDictionary *dict = [self.sceneList objectAtIndex:[indexPath row]];
    cell.textLabel.text = [dict objectForKey:@"name"];
    cell.textLabel.font = [UIFont systemFontOfSize:18];
    
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
}

- (void)parser:(JsonParser*)parser DidParsedData:(NSDictionary *)data
{
    NSArray *list = [data objectForKey:@"data"];
    if (list) {
        self.sceneList = [list mutableCopy];
        [self.listTableView reloadData];
    }
}

@end
