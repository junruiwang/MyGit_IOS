//
//  SHSOAuthSharer.h
//  ShareDemo
//
//  Created by tmy on 11-11-29.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define PLATFORM_KAIXIN @"kaixin"
#define PLATFORM_RENREN @"renren"
#define PLATFORM_SOHUWB @"sohuminiblog"
#define PLATFORM_NETEASEWB @"neteasewb"
#define PLATFORM_QQWB @"qqwb"
#define PLATFORM_SINAWB @"sinawb"
#define PLATFORM_SINAWB2 @"sinawb2"

typedef enum
{
    kaixin,renren,sohuminiblog,neteasewb,qqwb,sinawb,sinawb2
} bsPlatform;


@interface NSString (bsOauthInfo)
+(NSString *) stringWithPlatform:(bsPlatform)platform;
@end


//@interface OAuthInfo : NSObject
//+(void) save:(NSString *) accessToken tokenSecret:(NSString *)tokenSecret for:(bsPlatform)platformName;
//+(NSString *)readAccessToken:(bsPlatform)platformName;
//+(NSString *)readAccessSecretToken:(bsPlatform)platformName;
//+(void) logout:(bsPlatform)platformName;
//+(void) logout;
//@end


//服务认证类型
typedef enum
{
    OAuthTypeOAuth1WithHeader=0,
    OAuthTypeOAuth1WithQueryString=1,
    OAuthTypeOAuth2=2,
    OAuthTypeNone=5
}OAuthType;

//分享类型
typedef enum
{
    ShareTypeText=0,        //仅分享文字
    ShareTypeTextAndImage=1, //分享文字和图片
    ShareTypeNormal=2//
    
}ShareType;


@protocol AuthorizationDelegate <NSObject>

@optional
- (void)authorizationDidFinishWithToken:(NSString *)token andVerifier:(NSString *)verifier; //OAuth1.0
- (void)authorizationDidFinishWithAccessToken:(NSString *)token withExpireTime:(NSTimeInterval)expire; //OAuth2.0
- (void)authorizationDidCancel;
- (void)authorizationDidFail;

@end


@protocol SHSOAuthSharerProtocol;

@protocol SHSOAuthDelegate <NSObject>

@optional
- (void)OAuthSharerDidBeginVerification:(id<SHSOAuthSharerProtocol>)oauthSharer;
- (void)OAuthSharerDidFinishVerification:(id<SHSOAuthSharerProtocol>)oauthSharer;
- (void)OAuthSharerDidCancelVerification:(id<SHSOAuthSharerProtocol>)oauthSharer;
- (void)OAuthSharerDidFailInVerification:(id<SHSOAuthSharerProtocol>)oauthSharer;
- (void)OAuthSharerDidBeginShare:(id<SHSOAuthSharerProtocol>)oauthSharer;
- (void)OAuthSharerDidFinishShare:(id<SHSOAuthSharerProtocol>)oauthSharer;
- (void)OAuthSharerDidFailShare:(id<SHSOAuthSharerProtocol>)oauthSharer;
@end

@protocol SHSOAuthSharerProtocol <NSObject>
@property (nonatomic, retain) NSString *key;
@property (nonatomic,retain) NSString *name;
@property (nonatomic) OAuthType oauthType;
@property (nonatomic) ShareType pendingShare;
@property (nonatomic,retain) NSString *sharedUrl;
@property (nonatomic,retain) NSString *sharedText;
@property (nonatomic,retain) UIImage *sharedImage;
@property (nonatomic,assign) id<SHSOAuthDelegate> delegate;
@property (nonatomic,assign) UIViewController *rootViewController;

- (void)beginOAuthVerification;
- (void)SaveToken;
- (BOOL)isVerified;
- (void)shareText:(NSString *)text;
- (void)shareText:(NSString *)text andImage:(UIImage *)image;
- (NSString *)getURL:(NSString *)url andSite:(NSString *)site;

@optional
- (bsPlatform)getPlatformName;
@end
