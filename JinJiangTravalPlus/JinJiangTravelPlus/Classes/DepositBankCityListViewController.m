
#import "DepositBankCityListViewController.h"

#import "JSON.h"
#import "FileManager.h"
#import "SVProgressHUD.h"

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

@interface DepositBankCityListViewController (PrivateMethods)

- (void)showIndicatorView;
- (void)hideIndicatorView;

@end

@implementation DepositBankCityListViewController

@synthesize selectedCityName;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
    [SVProgressHUD showWithStatus:@"正在加载" maskType:SVProgressHUDMaskTypeClear frameSize:CGRectMake(55, 0, 295, screenRect.size.height + 20)];
    
    self.keys = [[NSMutableArray alloc] initWithCapacity:50];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *path = [FileManager fileCachesPath:@"depositCityList.plist"];
    
    if ([fileManager fileExistsAtPath:path])
    {
        NSData * myData = [NSData dataWithContentsOfFile:path];
        self.citys = [NSKeyedUnarchiver unarchiveObjectWithData:myData];
        NSArray *cityKeys = [self.citys.allKeys sortedArrayUsingSelector:@selector(compare:)];
        [self.keys addObjectsFromArray:cityKeys];
        NSString *hotCityKey = [self.keys lastObject];
        [self.keys removeLastObject];
        [self.keys insertObject:hotCityKey atIndex:0];
    }
    else
    {
        self.citys = [[NSMutableDictionary alloc] initWithCapacity:50];
    }
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dashed.png"]];
    
    CGRect iphone4Frame = CGRectMake(0, 0, 320, 416);
    CGRect iphone5Frame = CGRectMake(0, 0, 320, 568);
    CGRect viewFrame = iPhone5? iphone5Frame : iphone4Frame;
    self.view.backgroundColor = [UIColor clearColor];
    self.view.frame = viewFrame;
    self.tableView.frame = viewFrame;
    
    if ([self.citys count] == 0)
    {
        self.bankCityListParser = [[BankCityListParser alloc] init];
        self.bankCityListParser.delegate = self;
        [self.bankCityListParser getBankCityListRequest];
    }else{
        [SVProgressHUD dismiss];
    }
    [self.tableView reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (_ISIPHONE_)
    {   return interfaceOrientation == UIInterfaceOrientationPortrait;  }
    else
    {   return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([self.citys count]==0)
    {
        return 0;
    }
    return [self.keys count] > 0 ? [self.keys count] : 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.keys count] == 0)
    {
        return 0;
    }
    
    NSString *key = [self.keys objectAtIndex:section];
    NSArray *citysByKey = [self.citys objectForKey:key];
    return [citysByKey count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.keys count] == 0)
    {
        return nil;
    }
    const unsigned int section = [indexPath section];
    const unsigned int row = [indexPath row];
    NSString* key = [self.keys objectAtIndex:section];
    NSArray* array = [self.citys objectForKey:key];
    AllCity* city = [array objectAtIndex:row];
    
    static NSString *CellIdentifier = @"CityCell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.font = [UIFont systemFontOfSize: 14];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.textLabel.text = city.name;
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if ([self.keys count] == 0)
    {   return nil; }
    
    NSString *key = [self.keys objectAtIndex:section];
    
    if (key == UITableViewIndexSearch)
    {   return nil; }
    return key;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.keys;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title
               atIndex:(NSInteger)index
{
    NSString *key = [self.keys objectAtIndex:index];
    if (key == UITableViewIndexSearch) {
        [self.tableView setContentOffset:CGPointZero animated:NO];
        return NSNotFound;
    } else  {   return index;   }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    const unsigned int section = [indexPath section];
    const unsigned int row = [indexPath row];
    NSString *key = [self.keys objectAtIndex:section];
    NSArray *array = [self.citys objectForKey:key];
    AllCity *city = [array objectAtIndex:row];
    self.selectedCityName = city.name;
    
    [[tableView cellForRowAtIndexPath:indexPath] setSelected:YES];
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(buildCity:)])
    {   [self.delegate buildCity:city]; }
}


- (void)parser:(GDataXMLParser *)parser DidParsedData:(NSDictionary *)data
{
    NSMutableArray *citysByKey;
    NSArray *array = [data valueForKey:@"bankCityList"];
    [self.keys addObjectsFromArray:[NSArray arrayWithObjects:@"热门城市", @"A", @"B", @"C" ,@"D" ,@"E" ,@"F" ,@"G" ,@"H" ,@"J" ,@"K" ,@"L" ,@"M" ,@"N" ,@"O" ,@"P" ,@"Q" ,@"R" ,@"S" ,@"T" ,@"W" ,@"X" ,@"Y" ,@"Z", nil]];
    for (NSDictionary *dict in array)
    {
        AllCity *city = [[AllCity alloc] initWithDictionary:dict];
        if ([self.citys objectForKey:city.key] == nil)
        {
            citysByKey = [[NSMutableArray alloc] init];
            [self.citys setObject:citysByKey forKey:city.key];
        }
        else
        {
            citysByKey = [self.citys objectForKey:city.key];
        }
        [citysByKey addObject:city];
    }
    [self writeCitysToFile];
    [self.tableView reloadData];
    [SVProgressHUD dismiss];
}

-(void)parser:(GDataXMLParser *)parser DidFailedParseWithMsg:(NSString *)msg errCode:(NSInteger)code
{
    if(-1 == code)
    {
        [self showAlertMessageWithOkButton:@"因服务器繁忙,获取银行城市列表失败，请稍后再试" title:nil tag:0 delegate:nil];
    }
    else
    {
        [self showAlertMessageWithOkButton:msg title:nil tag:0 delegate:nil];
    }
    
    self.navigationItem.hidesBackButton = NO;
    [SVProgressHUD dismiss];
}

- (void) writeCitysToFile
{
    if (self.citys != nil)
    {
        NSString *path = [FileManager fileCachesPath:@"depositCityList.plist"];
        NSData * myData = [NSKeyedArchiver archivedDataWithRootObject:self.citys];
        BOOL result = [myData writeToFile:path atomically:YES];
        if (!result) {
            //            NSLog("保存银行城市列表错误！");
        }
    }
}

@end
