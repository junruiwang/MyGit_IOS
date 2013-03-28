//
//  CourseViewController.m
//  ChoiceCourse
//
//  Created by 汪君瑞 on 12-10-25.
//  Copyright (c) 2012年 jerry. All rights reserved.
//

#import "CourseViewController.h"
#import "RegexKitLite.h"
#import "Course.h"
#import "ServerAddressManager.h"
#import "CourseCell.h"

@interface CourseViewController ()

@property(nonatomic, copy) NSString *email;

- (void)registICal:(Course *) course;
- (void)downloadCourseList;

@end

@implementation CourseViewController

@synthesize loginInfo = _loginInfo;
@synthesize courseParser;
@synthesize email = _email;


- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *userEmail = [userDefaults stringForKey:@"user_email_info"];
        self.email = userEmail;
        [self downloadCourseList];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.trackedViewName = @"小老师选课页面";
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"choice_bg.png"]];
    NSString *regexString = @"\\b([a-zA-Z0-9%_.+\\-]+)@([a-zA-Z0-9.\\-]+?\\.[a-zA-Z]{2,6})\\b";
    NSString *userEmail = self.email;
    [self showUserName:regexString userEmail:userEmail];
    self.tableview.delegate = self;
    self.tableview.separatorColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dashed.png"]];
    self.navigationController.navigationBarHidden = NO;
    
    //the if code blank will delete
    if(self.courseList && [self.courseList count] >0){
        [self fillDetailViewValue:0];
    }
    self.detailTextLabel.numberOfLines = 0;
    self.teacherTitle.numberOfLines = 0;
    // Do any additional setup after loading the view from its nib.
}

- (void)showUserName:(NSString *)regexString userEmail:(NSString *)userEmail {
    BOOL matched = [userEmail isMatchedByRegex:regexString];
    if (matched) {
        NSRange range = [userEmail rangeOfString:@"@"];
        userEmail = [userEmail substringWithRange:NSMakeRange(0, range.location)];
    }
//    self.loginInfo.text = [NSString stringWithFormat:@"%@ 您好，欢迎进入选课系统！",userEmail];
}

- (void)registICal:(Course *) course
{
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    EKEvent *event = [EKEvent eventWithEventStore:eventStore];
    event.title = course.courseName;
    event.startDate = [[NSDate alloc] init];
    event.endDate = [[NSDate alloc] initWithTimeInterval:600 sinceDate:event.startDate];
    [event setCalendar:[eventStore defaultCalendarForNewEvents]];
    NSError *err;
    [eventStore saveEvent:event span:EKSpanThisEvent error:&err];
}

- (void)downloadCourseList
{
//    if (self.courseParser != nil) {
//        [self.courseParser cancel];
//        self.courseParser = nil;
//    }
//    self.courseParser = [[[CourseParser alloc] init] autorelease];
//    self.courseParser.serverAddress = [ServerAddressManager serverAddress:@"deposit_bank_city_list"];
////    self.courseParser.requestString = [NSString stringWithFormat:@"email=%@&keyWord=%@",self.email,@"新西兰"];
//    self.courseParser.delegate = self;
//    [self.courseParser start];

    [self mockCourseList];
}


-(void)mockCourseList{
    NSMutableArray *courseList = [[NSMutableArray alloc] init];
    for(int i=0;i<5;i++){
        Course *course = [[Course alloc] init];
        course.courseSpeaker =@"jack.joson";
        course.courseDescription = @"抓住男人的心，就要抓住男人的领带抓住男人的心，就要抓住男人的领带,抓住男人的心，就要抓住男人的领带，抓住男人的心，就要抓住男人的领带";
        course.courseStartTime = @"";
        course.courseName =[NSString stringWithFormat:@"抓住男人的心，就要抓住男人的领带,抓住男人的心，就要抓住男人的领带%d",i];
        [courseList addObject:course];
    }
self.courseList = courseList;
//[self.tableview reloadData];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    self.loginInfo = nil;
    self.tableview = nil;
    self.teacherTitle = nil;
    self.detailTextLabel = nil;
    self.detailImageView = nil;
    self.courseList = nil;
    self.courseParser = nil;
    [super viewDidUnload];
}

- (void) dealloc
{
    self.loginInfo = nil;
    self.courseParser = nil;
    self.tableview = nil;
    self.teacherTitle = nil;
    self.detailTextLabel = nil;
    self.detailImageView = nil;
    self.courseList = nil;
    self.courseParser = nil;
    [super dealloc];
}


- (void)showAlertMessage:(NSString *)msg {
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"错误提示"
                              message:msg
                              delegate:nil
                              cancelButtonTitle:@"确定"
                              otherButtonTitles:nil];
    [alertView show];
    [alertView release];
}

#pragma mark -
#pragma mark BaseJSONParserDelegate 
- (void)parser:(BaseParser*)parser DidFailedParseWithMsg:(NSString*)msg errCode:(NSInteger)code
{
    [self showAlertMessage:msg];
}

- (void)parser:(BaseParser*)parser DidParsedData:(NSDictionary *)data
{
    NSArray *courseArry = [data valueForKey:@"data"];
    NSMutableArray *courses = [[NSMutableArray alloc] initWithCapacity:30];
    for (NSDictionary *dict in courseArry) {
        NSString * courseName = [dict valueForKey:@"courseName"];
        NSString * bookable = [dict valueForKey:@"bookable"];

        NSDictionary * event_type = [dict valueForKey:@"event_type"];

        NSString * type_name = [event_type valueForKey:@"type_name"];
        NSString * courseDescription = [dict valueForKey:@"courseDescription"];
        NSLog(@"返回课程名称为：%@，预定标识：%@", courseName, bookable);
        Course *course= [[Course alloc] init];
        course.courseName = [NSString stringWithFormat:@"抓住男人的心，就要抓住男人的领带%@",courseName]
        ;
        course.bookable = bookable;
        course.type_image = type_name;
        course.courseDescription = courseDescription;
        [courses addObject:course];
    }
    self.courseList = courses;
    if(self.courseList && [self.courseList count] >0){
        [self fillDetailViewValue:0];
    }
    [self.tableview reloadData];
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.courseList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell";
    CourseCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [tableView
                dequeueReusableCellWithIdentifier:@"courseCell_Id"];
    }
    NSInteger row = [indexPath row];
    Course *course = (Course *) [self.courseList objectAtIndex:row];
    [self showTitleLabel:cell currentCourse:course];
    // Configure the cell...
    return cell;
}

- (void)showTitleLabel:(CourseCell *)cell currentCourse:(Course *)course {
    cell.courseLabel.text = course.courseName;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"cell";
  NSInteger row = [indexPath row];
    CourseCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell){
        cell.ramarkImgView.hidden = NO;
    }
    
  [self fillDetailViewValue:row];
}

-(void)fillDetailViewValue:(NSInteger) row{
    Course *course = [self.courseList objectAtIndex:row];
    self.teacherTitle.text = course.courseName;
    [self.detailTextLabel setNumberOfLines:0];
    self.detailTextLabel.text = course.courseDescription;
}

@end
