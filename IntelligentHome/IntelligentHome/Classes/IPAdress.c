//
//  IPAdress.c
//  WhatsMyIP
//
//  Created by jerry on 13-10-9.
//  Copyright (c) 2013年 jerry. All rights reserved.
//

#include <stdio.h>
/*
As far as I know there is only one hacky way to do that. You basically open a socket and get its address using POSIX functions. 
Here is the code I used for this:  
 */

/*  
 *  IPAdress.h  
 *  
 *  
 */  

#define MAXADDRS    32  

extern char *if_names[MAXADDRS];  
extern char *ip_names[MAXADDRS];  
extern char *hw_addrs[MAXADDRS];  
extern unsigned long ip_addrs[MAXADDRS];  

// Function prototypes  

void InitAddresses();  
void FreeAddresses();  
void GetIPAddresses();  
void GetHWAddresses();  


/*  
 *  IPAddress.c  
 *  
 */  

//#include "IPAddress.h"  

#include <stdio.h> 
#include <stdlib.h> 
#include <string.h> 
#include <unistd.h> 
#include <sys/ioctl.h> 
#include <sys/types.h> 
#include <sys/socket.h> 
#include <netinet/in.h> 
#include <netdb.h> 
#include <arpa/inet.h> 
#include <sys/sockio.h> 
#include <net/if.h> 
#include <errno.h> 
#include <net/if_dl.h> 

#define    min(a,b)    ((a) < (b) ? (a) : (b))  
#define    max(a,b)    ((a) > (b) ? (a) : (b))  

#define BUFFERSIZE    4000  

char *if_names[MAXADDRS];  
char *ip_names[MAXADDRS];  
char *hw_addrs[MAXADDRS];  
unsigned long ip_addrs[MAXADDRS];  

static int   nextAddr = 0;  

void InitAddresses()  
{  
    int i;  
    for (i=0; i<MAXADDRS; ++i)  
    {  
        if_names[i] = ip_names[i] = hw_addrs[i] = NULL;  
        ip_addrs[i] = 0;  
    }  
}  

void FreeAddresses()  
{  
    int i;  
    for (i=0; i<MAXADDRS; ++i)  
    {  
        if (if_names[i] != 0) free(if_names[i]);  
        if (ip_names[i] != 0) free(ip_names[i]);  
        if (hw_addrs[i] != 0) free(hw_addrs[i]);  
        ip_addrs[i] = 0;  
    }  
    InitAddresses();  
}  

void GetIPAddresses()  
{  
    int                 i, len, flags;  
    char                buffer[BUFFERSIZE], *ptr, lastname[IFNAMSIZ], *cptr;  
    struct ifconf       ifc;  
    struct ifreq        *ifr, ifrcopy;  
    struct sockaddr_in    *sin;  
    
    char temp[80];  
    
    int sockfd;  
    
    for (i=0; i<MAXADDRS; ++i)  
    {  
        if_names[i] = ip_names[i] = NULL;  
        ip_addrs[i] = 0;  
    }  
    
    sockfd = socket(AF_INET, SOCK_DGRAM, 0);  
    if (sockfd < 0)  
    {  
        perror("socket failed");  
        return;  
    }  
    
    ifc.ifc_len = BUFFERSIZE;  
    ifc.ifc_buf = buffer;  
    
    if (ioctl(sockfd, SIOCGIFCONF, &ifc) < 0)  
    {  
        perror("ioctl error");  
        return;  
    }  
    
    lastname[0] = 0;  
    
    for (ptr = buffer; ptr < buffer + ifc.ifc_len; )  
    {  
        ifr = (struct ifreq *)ptr;  
        len = max(sizeof(struct sockaddr), ifr->ifr_addr.sa_len);  
        ptr += sizeof(ifr->ifr_name) + len;    // for next one in buffer  
        
        if (ifr->ifr_addr.sa_family != AF_INET)  
        {  
            continue;    // ignore if not desired address family  
        }  
        
        if ((cptr = (char *)strchr(ifr->ifr_name, ':')) != NULL)  
        {  
            *cptr = 0;        // replace colon will null  
        }  
        
        if (strncmp(lastname, ifr->ifr_name, IFNAMSIZ) == 0)  
        {  
            continue;    /* already processed this interface */  
        }  
        
        memcpy(lastname, ifr->ifr_name, IFNAMSIZ);  
        
        ifrcopy = *ifr;  
        ioctl(sockfd, SIOCGIFFLAGS, &ifrcopy);  
        flags = ifrcopy.ifr_flags;  
        if ((flags & IFF_UP) == 0)  
        {  
            continue;    // ignore if interface not up  
        }  
        
        if_names[nextAddr] = (char *)malloc(strlen(ifr->ifr_name)+1);  
        if (if_names[nextAddr] == NULL)  
        {  
            return;  
        }  
        strcpy(if_names[nextAddr], ifr->ifr_name);  
        
        sin = (struct sockaddr_in *)&ifr->ifr_addr;  
        strcpy(temp, inet_ntoa(sin->sin_addr));  
        
        ip_names[nextAddr] = (char *)malloc(strlen(temp)+1);  
        if (ip_names[nextAddr] == NULL)  
        {  
            return;  
        }  
        strcpy(ip_names[nextAddr], temp);  
        
        ip_addrs[nextAddr] = sin->sin_addr.s_addr;  
        
        ++nextAddr;  
    }  
    
    close(sockfd);  
}

