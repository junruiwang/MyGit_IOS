//
//  IPAddress.h
//  JinJiang
//
//  Created by shaka on 12-4-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#define MAXADDRS    32  

extern char *if_names[MAXADDRS];  
extern char *ip_names[MAXADDRS];  
extern char *hw_addrs[MAXADDRS];  
extern unsigned long ip_addrs[MAXADDRS];    

@interface IPAddress : NSObject 

void InitAddresses();  
void FreeAddresses();  
void GetIPAddresses();  
void GetHWAddresses();

+ (NSString*)currentIPAddress;

@end
