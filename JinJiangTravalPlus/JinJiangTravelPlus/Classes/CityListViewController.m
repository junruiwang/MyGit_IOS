//
//  CityListViewController.m
//  JinJiangTravalPlus
//
//  Created by 胡 桂祁 on 11/5/12.
//  Copyright (c) 2012 Leon. All rights reserved.
//

#import "CityListViewController.h"
#import "CityListParser.h"
#import "Constants.h"
#import "HotelSearchViewController.h"
#import "FileManager.h"
#import "SVProgressHUD.h"


#define kRecentThreeCityDesc @"最近选择城市"
#define kHotCityDesc @"热门城市"

@interface CityListViewController ()

@property(nonatomic,strong) NSMutableArray *recentCities;

@end

@implementation CityListViewController

@synthesize cityListParser;
@synthesize recentCities;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.cityListTable.separatorColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dashed.png"]];
    self.view.backgroundColor = [UIColor clearColor];
    if (!recentCities) {
        recentCities = [[NSMutableArray alloc] initWithCapacity:3];
    }
}

- (void)getCityList
{
    if (!self.cityListParser)
    {
        self.cityListParser = [[CityListParser alloc] init];
        self.cityListParser.isHTTPGet = NO;
        self.cityListParser.serverAddress = kCityListURL;
    }
    self.cityListParser.delegate = self;
    [self.cityListParser start];
}

- (void)downloadData
{
    NSLog(@"%s getCityList...", __FUNCTION__);
    BOOL isExistCache=[self canReadCityListFromLocalFile];
    if(isExistCache == YES) {
        return;
    }
    [self performSelector:@selector(showSVProgressHUD) withObject:nil afterDelay:0.2];
}

- (void)showSVProgressHUD
{
    CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
    [SVProgressHUD showWithStatus:@"正在加载" maskType:SVProgressHUDMaskTypeClear
                        frameSize:CGRectMake(25, 0, 295, screenRect.size.height + 20)];
    [self getCityList];
}

- (void)writeCityListToFile
{
    NSLog(@"%s writeCityListToFile...", __FUNCTION__);
    if ([self.cityList count] == 0)
    {
        NSLog(@"%s No city to be saved.", __FUNCTION__);
        return;
    }
    
    NSString *path = [FileManager fileCachesPath:@"citylist.plist"];
    
    // convert all value to NSString/NSNumber (NSInterget and BOOL can't be saved in property list)
    NSMutableArray *cityArray = [[NSMutableArray alloc] initWithCapacity:300];
    for (City *city in self.cityList)
    {
        if (city.name == nil || city.namePinyin == nil) {   continue;   }
        
        NSDictionary *tempDict = [NSDictionary dictionaryWithObjects:
                                  [NSArray arrayWithObjects: city.name, city.namePinyin, @(city.latitude), @(city.longitude), nil]
                                                             forKeys:[NSArray arrayWithObjects:@"Name", @"Pinyin", @"Lat", @"Lng", nil]];
        [cityArray addObject:tempDict];
    }
    
    BOOL res = [cityArray writeToFile: path atomically:YES];
    NSLog(@"%s save city list to path %@ result: %d", __FUNCTION__, path, res);
}

- (void)unBoxingDictToCityList:(NSArray *)dictArray
{
    NSMutableArray *cityArray = [[NSMutableArray alloc] initWithCapacity:700];
    for (NSDictionary *tempDict in dictArray)
    {
        City *city = [[City alloc] init];
        city.name = [tempDict valueForKey:@"Name"];
        city.namePinyin = [tempDict valueForKey:@"Pinyin"];
        //CLLocationCoordinate2D pos = {[[tempDict valueForKey:@"Lat"] floatValue], [[tempDict valueForKey:@"Lng"] floatValue]};
        city.latitude = [[tempDict valueForKey:@"Lat"] floatValue];
        city.longitude = [[tempDict valueForKey:@"Lng"] floatValue];
        [cityArray addObject:city];
    }
    [self fillAndGroupData :cityArray];
}

- (BOOL)canReadCityListFromLocalFile
{
    NSString *path = [FileManager fileCachesPath:@"citylist.plist"];
    NSLog(@"%s restore city list from file [%@]", __FUNCTION__, path);
    NSArray *dictArray = [[NSArray alloc] initWithContentsOfFile:path];
    
    if(dictArray.count == 0)    {
        return NO;
    }
    
    [self unBoxingDictToCityList:dictArray];
    NSLog(@"%s canReadCityListFromLocalFile %d cities from local file.", __FUNCTION__, [self.cityList count]);
    
    return ([self.cityList count] != 0);
}


- (void)navigationSetStyle
{
    [self.navigationController.navigationBar setCancelButtonTitle:NSLocalizedString(@"关闭", nil) target:self action:@selector(dismissModalViewControllerAnimated:)];
    
    self.title = NSLocalizedString(@"Domestic cities", nil);
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    self.cityListTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
}

- (void)groupData
{
    const unsigned int collationTitleCount = [[self.collation sectionTitles] count];
    if (collationTitleCount == 47)
    {
        // Simple Chinese
        self.sectionTitles = [NSArray arrayWithObjects:@"",kRecentThreeCityDesc,@"热门",@"A", @"B", @"C" ,@"D" ,@"E" ,@"F" ,@"G" ,@"H" ,@"J" ,@"K" ,@"L"
                              ,@"M" ,@"N" ,@"O" ,@"P" ,@"Q" ,@"R" ,@"S" ,@"T" ,@"W" ,@"X" ,@"Y" ,@"Z", nil];
    }
    else
    {
        // Traditional Chinese(52) or English(27)
        self.sectionTitles = [NSArray arrayWithObjects:@"",kRecentThreeCityDesc,@"热门", @"A", @"B", @"C" ,@"D" ,@"E" ,@"F" ,@"G" ,@"H" , @"I", @"J" ,@"K" ,@"L"
                              ,@"M" ,@"N" ,@"O" ,@"P" ,@"Q" ,@"R" ,@"S" ,@"T" , @"U", @"V" ,@"W" ,@"X" ,@"Y" ,@"Z", nil];
    }
    [self navigationSetStyle];
    // (1)
    const unsigned int sectionCount = [self.sectionTitles count];
    [self filterCalculateSection:sectionCount];
    // (2)
    NSMutableArray *sectionArrays = [NSMutableArray arrayWithCapacity:200];
    [self filterCalculateSectionArray:sectionCount sectionArrays:sectionArrays];
    // (3)
    [self filterAddCityAtSectionArray:sectionArrays];
    
    //因为加了一个空的section，则需要加一个空的城市来补齐
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    [tempArray addObject:[[City alloc] init]];
    [self.citiesSections addObject:tempArray];
    
    [self addRecentThreeCitiesToCitiesSections];
    
    [self addHotCitiesToCitiesSections];
    // (4)
    [self filterCitiesSectionsForDidIndexPinyin:sectionArrays];
}

- (void)addHotCitiesToCitiesSections
{
    NSMutableArray *hotCityArray = [[NSMutableArray alloc] init];
    NSArray* hotCities = [NSArray arrayWithObjects:@"北京", @"上海", @"广州", @"深圳", @"成都", @"杭州", @"武汉", @"西安", @"重庆",
                          @"青岛", @"南京", @"厦门", @"大连", @"天津", @"三亚", @"济南", @"宁波", nil];
    for(NSString* name in hotCities)
    {
        for(City *theCity in self.cityList)
        {
            //NSLog(@"city name is %@", theCity.name);
            if([theCity.name isEqualToString:name])
            {
                [hotCityArray addObject:theCity];
                break;
            }
        }
    }
    [self.citiesSections addObject:hotCityArray];
}

- (void)filterAddCityAtSectionArray:(NSMutableArray *)sectionArrays
{
    for (City *theCity in self.cityList)
    {
        // NSLog(@"%s new city [%@] section  %d", __FUNCTION__, theCity.name, theCity.section);
        [(NSMutableArray *)[sectionArrays objectAtIndex:theCity.section ] addObject: theCity];
    }
}

- (void)filterCalculateSectionArray:(NSInteger)sectionCount sectionArrays:(NSMutableArray *)sectionArrays
{
    for (unsigned int i = 0; i < sectionCount; i++)
    {
        NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:200];
        [sectionArrays addObject:sectionArray];
    }
}

- (void)filterCalculateSection:(NSInteger)sectionCount
{
    for (City *theCity in self.cityList)
    {
        const int sect = [self.collation sectionForObject:theCity collationStringSelector:@selector(namePinyin)];
        theCity.section = MIN(sect, sectionCount);
    }
}

- (void)filterCitiesSectionsForDidIndexPinyin:(NSMutableArray *)sectionArrays
{
    for (NSMutableArray *sectionArray in sectionArrays)
    {
        [self.citiesSections addObject:[sectionArray sortedArrayUsingSelector:@selector(comparePinyin:)]];
    }
}

- (NSString *)simplePinyin:(NSString *)pinyin
{
    NSArray *wordArray = [pinyin componentsSeparatedByString:@" "];
    NSMutableString *simplePinyin = [NSMutableString stringWithCapacity:10];
    for (NSString *word in wordArray)
    {
        if ([word length] != 0)
        {
            // in case the 'pinyin' have several space, e.g "d   e"
            [simplePinyin appendString: [word substringToIndex:1]];
        }
    }
    return simplePinyin;
}

#pragma recent three citis
- (void)addRecentThreeCitiesToCitiesSections

{
    NSMutableArray *recentThreeCities = [[NSMutableArray alloc] init];
   NSArray *threeCities = [[NSUserDefaults standardUserDefaults] arrayForKey:@"recentThreeCitis"];

    //过滤必须在列表中的城市
    for(NSString* name in threeCities)
    {
        for(City *theCity in self.cityList)
        {
            if([theCity.name isEqualToString:name])
            {
                [recentThreeCities addObject:theCity];
                break;
            }
        }
    }
    self.recentCities = [NSMutableArray arrayWithArray:threeCities];
    [self.citiesSections addObject:recentThreeCities];
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.citiesSections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.citiesSections count] == 0 || [self.citiesSections count] <= section)
    {
        return 0;
    }
    unsigned int rowCount = [[self.citiesSections objectAtIndex:section] count];
    if (section == 0) {
        return 1;
    }
    return rowCount;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if ([self.citiesSections count] == 0 || [self.citiesSections count] <= section)
    {
        return nil;
    }
    if (section == 0) {
        return nil;
    }
    
    if([self.recentCities count] >0)
    {
        if (section == 1) {
            return kRecentThreeCityDesc;
        }
        if (section == 2) {
            return kHotCityDesc;
        }
    }else{
        if (section == 1) {
            return kHotCityDesc;
        }
    }
   
    
    if (section > 1)
    {
        NSArray *citiesInSection = [self.citiesSections objectAtIndex:section];
        if ([citiesInSection count] == 0)
        {
            return nil;
        }
    }
    
    NSString *title;
    
    if (section < [self.sectionTitles count])
    {   title = [NSString stringWithString: (NSString *)[self.sectionTitles objectAtIndex:section]];    }
    else
    {
        return nil;
    }
    
    return title;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if ([self.citiesSections count] == 0 || [self.citiesSections count] <= section)
    {
        return 0;
    }
    
    NSArray *citiesInSection = [self.citiesSections objectAtIndex:section];
    if ([citiesInSection count] == 0)
    {   return 0;   }
    
    if(section == 0)
    {   return 26;  }
    else if (section < [self.sectionTitles count])
    {   return 22;  }
    else
    {   return 0;   }
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    
    return self.sectionTitles;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return index;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:18];
    // Set up the cell...
    unsigned int row = [indexPath row];
    const unsigned int section = [indexPath section];
	City *city = nil;
    
    NSArray *citiesInSection = [self.citiesSections objectAtIndex:section];
    if (section == 0 && row == 0) {
        cell.textLabel.text = NSLocalizedString(@"Current Position", nil);
        return cell;
    } 
    
    city = [citiesInSection objectAtIndex:row];
    cell.textLabel.text = city.name;
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    const unsigned int section = indexPath.section;
    unsigned int row = indexPath.row;
    City *currentCity = nil;
    if (section == 0)
    {
        if (row == 0)
        {
            currentCity = [[City alloc] init];
            currentCity.name = TheAppDelegate.locationInfo.cityName;
            currentCity.longitude = TheAppDelegate.locationInfo.currentPoint.longitude;
            currentCity.latitude = TheAppDelegate.locationInfo.currentPoint.latitude;
        }
        else
        {
            row = row -1;
            NSArray *citiesInSection = [self.citiesSections objectAtIndex:section];
            currentCity = [citiesInSection objectAtIndex:row];
        }
    }
    else
    {
        NSArray *citiesInSection = [self.citiesSections objectAtIndex:section];
        currentCity = [citiesInSection objectAtIndex:row];
    }
    [self.cityListDelegate selectedCity:currentCity];
    
    //记录最近选择的城市
    [self filterSameCities:currentCity];
    
    [self saveRecentCitiesToUserDefault];
    
    [self dismissModalViewControllerAnimated:YES];
    [[tableView cellForRowAtIndexPath:indexPath] setSelected:NO];
}


-(void)saveRecentCitiesToUserDefault
{
    if ([recentCities count] > 3) {
        [recentCities removeLastObject];
    }
    [[NSUserDefaults standardUserDefaults] setObject:recentCities forKey:@"recentThreeCitis"];
}

//把相同城市过滤掉
-(void)filterSameCities:(City *) currentCity
{
    if (currentCity && currentCity.name && ![@"" isEqualToString:currentCity.name]) {
        if ([recentCities count]>0) {
            BOOL flag = YES;
            NSUInteger sameIndex;
            for (int i = 0;i<[recentCities count];i++) {
                NSString *cityName = [recentCities objectAtIndex:i];
                if ([cityName isEqualToString:currentCity.name]) {
                    flag = NO;
                    sameIndex = i;
                    break;
                }
            }
            if (flag) {
                [recentCities insertObject:currentCity.name atIndex:0];
            }else{
                 [recentCities removeObjectAtIndex:sameIndex];
                 [recentCities insertObject:currentCity.name atIndex:0];                
            }
        }else{
            [recentCities insertObject:currentCity.name atIndex:0];
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *sectionTitle = [self tableView:tableView titleForHeaderInSection:section];
    if (sectionTitle == nil)
    {
        return nil;
    }
    
    // Create label with section title
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(11, 0, 300, 24);
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor colorWithRed:0.0 green:0.67 blue:0.62 alpha:1.0];
    label.shadowOffset = CGSizeMake(0.0, 1.0);
    label.font = [UIFont boldSystemFontOfSize:16];
    label.text = sectionTitle; const unsigned int ww = tableView.bounds.size.width;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ww, 20)];
    view.backgroundColor = [UIColor colorWithRed:0.96 green:0.93 blue:0.93 alpha:1.0];
    
    [view addSubview:label];
    return view;
}

#pragma mark - fillAndGroupData
- (void)fillAndGroupData :(NSMutableArray *) cityArray
{
    [self.cityList removeAllObjects];
    self.cityList = cityArray;
    self.collation = [UILocalizedIndexedCollation currentCollation];
    self.citiesSections = [NSMutableArray arrayWithCapacity:100];
    self.filteredListContent = [NSMutableArray arrayWithCapacity:[self.cityList count]];
    [self groupData];
    [self.cityListTable reloadData];
}

#pragma mark - GDataXMLParserDelegate
- (void)parser:(GDataXMLParser*)parser DidParsedData:(NSDictionary *)data
{
    NSMutableArray *cityList = [data objectForKey:@"cityList"];
    [self fillAndGroupData :cityList];
    [self writeCityListToFile];
    [self.cityListTable reloadData];
    [SVProgressHUD dismiss];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
