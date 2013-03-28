//
//  User.m
//  ChoiceCourse
//
//  Created by 杨 栋栋 on 12-10-16.
//  Copyright (c) 2012年 jerry. All rights reserved.
//

#import "User.h"

@implementation User

@synthesize email;

-(void) write {
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:self forKey:@"user"];
    [archiver finishEncoding];
    BOOL result = [data writeToFile:[self dataFilePath] atomically:YES];

    if (!result) {
        NSLog(@"登陆失败");
    }
    [data release];
    
}


-(NSString *) dataFilePath{
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/login.plist"];
    
}



- (User *) load
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:@"user.plist"]) {
        self = [NSKeyedUnarchiver unarchiveObjectWithData : [NSData dataWithContentsOfFile:@"user.plist"]];
    } else {
        self = [[User alloc] init];
    }
    return self;
}


- (void) dealloc {
    [email release];
    [super dealloc];
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    self.email = [aDecoder decodeObjectForKey:@"email"];
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.email forKey:@"email"];
}

- (id) copyWithZone:(NSZone *)zone
{
    User *copyUser = [[[self class] allocWithZone:zone] init];
    copyUser.email = [[self.email copyWithZone:zone] autorelease];
    return copyUser;
}

@end
