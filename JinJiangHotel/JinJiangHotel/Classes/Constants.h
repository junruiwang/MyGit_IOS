//
//  Constants.h
//  JinJiangHotel
//
//  Created by Rong Hao on 13-8-13.
//  Copyright (c) 2013年 jinjiang. All rights reserved.
//


#ifndef JinJiangHotel_Constants_h
#define JinJiangHotel_Constants_h


// URL
#define kQAURL                            @"http://gatewayqa.jje.com:5555/gateway"
#define kLocal                            @"http://192.168.4.45:8008/"
#define kUATURL                           @"http://gatewayuat.jje.com:5555/gateway"
#define kPREURL                           @"http://pre.jinjiang.com/gateway"
#define kProductionURL                    @"http://210.14.68.228/gateway"

#ifdef DEBUG
#define kBaseURL                          kProductionURL
#else
#define kBaseURL                          kProductionURL
#endif

#define kClientVersionURL                 [kBaseURL stringByAppendingPathComponent:@"getClientVersion"]
#define kHotelSearchURL                   [kBaseURL stringByAppendingPathComponent:@"hotels/hotel/list"]
#define kHotelPricePlanURL                [kBaseURL stringByAppendingPathComponent:@"hotels/room/newlist"]
#define kHotelOverviewURL                 [kBaseURL stringByAppendingPathComponent:@"hotels/hotel"]
#define kHotelRatingURL                   [kBaseURL stringByAppendingPathComponent:@"/lvping/rating"]
#define kHotelPriceConfirmURL             [kBaseURL stringByAppendingPathComponent:@"hotels/room/getPriceTimeDpa"]
#define kHotelOrderPlaceURL               [kBaseURL stringByAppendingPathComponent:@"hotels/order"]
#define kHotelOrderDetailURL              [kBaseURL stringByAppendingPathComponent:@"hotels/order/view"]
#define kUserOrderListURL                 [kBaseURL stringByAppendingPathComponent:@"hotels/order/list"]
#define kUserActiveOrderListURL           [kBaseURL stringByAppendingPathComponent:@"hotels/order/activeList"]
#define kHotelOrderCancelURL              [kBaseURL stringByAppendingPathComponent:@"hotels/order/cancel"]
#define kUserRegisterURL                  [kBaseURL stringByAppendingPathComponent:@"member"]
#define kUserCompleteRegisterURL          [kBaseURL stringByAppendingPathComponent:@"member/completeRegister"]
#define kUserFeedbackURL                  [kBaseURL stringByAppendingPathComponent:@"feedback"]
#define kUpdatePasswordURL                [kBaseURL stringByAppendingPathComponent:@"member/updatePassword"]
#define kApnsDeviceTokenURL               [kBaseURL stringByAppendingPathComponent:@"apns"]
#define kUserLoginURL                     [kBaseURL stringByAppendingPathComponent:@"member/login"]
#define kUserInfoURL                      [kBaseURL stringByAppendingPathComponent:@"member/getUserInfo"]
#define kCityVersionURL                   [kBaseURL stringByAppendingPathComponent:@"city/version"]
#define kCityListURL                      [kBaseURL stringByAppendingPathComponent:@"city/list"]
#define kAreaListURL                      [kBaseURL stringByAppendingPathComponent:@"/city/areaList"]
#define kPromotionRequestURL              [kBaseURL stringByAppendingPathComponent:@"promotion/list"]
#define kPaymentVerifyURL                 [kBaseURL stringByAppendingPathComponent:@"payment/verify"]
#define kPaymentPayingURL                 [kBaseURL stringByAppendingPathComponent:@"payment/paying"]
#define kDepositBankCityListURL           [kBaseURL stringByAppendingPathComponent:@"city/cityList"]
#define kMemberCardRightsURL              [kBaseURL stringByAppendingPathComponent:@"member/memberCardRights"]
#define kMemberCardPriceURL               [kBaseURL stringByAppendingPathComponent:@"member/jBenifitCardPrice"]
#define kMemberPreBuyCardURL              [kBaseURL stringByAppendingPathComponent:@"member/prepareBuyMemberCard"]
#define kCouponListURL                    [kBaseURL stringByAppendingPathComponent:@"coupon"]
#define kCouponRuleListURL                [kBaseURL stringByAppendingPathComponent:@"coupon/list"]
#define kMemberModifyURL                  [kBaseURL stringByAppendingPathComponent:@"member/modifyBasicInfo"]
#define kJJInnRegisterURL                 [kBaseURL stringByAppendingPathComponent:@"member/bindMobileAndActiveJJStarMember"]
#define kMemberUpgradeURL                 [kBaseURL stringByAppendingPathComponent:@"member/upRegistMember"]
#define kActivationURL                    [kBaseURL stringByAppendingPathComponent:@"member/activeJJStarMember"]
#define kRetrieveURL                      [kBaseURL stringByAppendingPathComponent:@"member/retrievePwdByPhone"]
#define KGetOrderPassbookURL              [kBaseURL stringByAppendingPathComponent:@"passbook/getPassbook"]
#define KRemovePassbookURL                [kBaseURL stringByAppendingPathComponent:@"passbook/removePassbook"]
#define KGetCardPassbookURL               [kBaseURL stringByAppendingPathComponent:@"/member/getPassbook"]
#define KAliPayWapURL                     [kBaseURL stringByAppendingPathComponent:@"/payment/aliPay"]
#define KAliPayClientURL                  [kBaseURL stringByAppendingPathComponent:@"/payment/aliClientPay"]
#define kCpaSaveURL                       [kBaseURL stringByAppendingPathComponent:@"/cpa/save"]
#define kIsMemberURL                      [kBaseURL stringByAppendingPathComponent:@"/member/isMember/"]
#define kHotelGuestBookingURL             [kBaseURL stringByAppendingPathComponent:@"hotels/order/guestBooking"]
#define kReadShakeAwardConfigURL          [kBaseURL stringByAppendingPathComponent:@"carnival/getCarnivalConfiguration"]
#define kShakeAwardURL                    [kBaseURL stringByAppendingPathComponent:@"carnival"]
#define kUserTraceURL                     [kBaseURL stringByAppendingPathComponent:@"trace/collect"];
#define kIntegralRuleListURL              [kBaseURL stringByAppendingPathComponent:@"coupon/newCouponRules"]
#define kScoreExchangeURL                 [kBaseURL stringByAppendingPathComponent:@"points/scoreExchange"]
#define kBookingDescription               [kBaseURL stringByAppendingPathComponent:@"carnival/bookingDescription"]
#define kCarnivalConsignee                [kBaseURL stringByAppendingPathComponent:@"carnival/consignee"]

#define kHistoryPointsURL                 [kBaseURL stringByAppendingPathComponent:@"points/pointsHistory"]
#define kRenewCardOrderURL                [kBaseURL stringByAppendingPathComponent:@"member/createCardRenewOrder"]
#define kRenewGetPayInfoURL                [kBaseURL stringByAppendingPathComponent:@"member/getOrderForPay"]
#define kActivityConfigURL                [kBaseURL stringByAppendingPathComponent:@"carnival/readActivityConfiguration"]

// notification
#define kHotelDateChangedNotification @"kHotelDateChangedNotification"

// Message
#define kNetworkProblemAlertMessage NSLocalizedString(@"Network or service busy. Retry now?", nil)
#define kXMLParseFailAlertMessage NSLocalizedString(@"Service unavailable", nil)

//baidu map key
#define kBaiduKey  @"7ED6576827E61B34742E834C5CEBFA1BC46E2495"

//UMAppkey&GA measure
#ifdef DEBUG
#define kUMAppkey  @"518a0ba656240b42ba03ab28"
#define kTrackingId  @"UA-39572739-5"
#define kLogEnable YES
#else
#define kUMAppkey  @"518a09fe56240b42b703acbb"
#define kTrackingId  @"UA-39572739-1"
#define kLogEnable NO
#endif

#define kUMEnable  true

// Key
#define kRestoreCityListVersion @"RestoreCityListVersion"
#define kRestorePromotionsVersion @"RestorePromotionsVersion"
#define kRestoreLatestCity @"kRestoreLatestCity"

#define kDefaultUserEmail @"services@jinjiang.com"
#define kMarket @"test"

#define kClientVersion  @"2.2.2"
#define kAppStoreUrl @"https://itunes.apple.com/us/app/jin-jiang-lu-xing+pro-jin/id595304265?ls=1&mt=8"
#define kCommentUrl @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=595304265"

#define kUMengShareKey @"518a09fe56240b42b703acbb"
#define kWXShareKey @"wx29af9cb8693bcd02"

// for signature
//#define kSecurityKey  @"7e6bfbe8101e8925ad985407ebdb5afb"
#define kSecurityKey @"7c0afff5dccd94e67089b7ae97c610f7"

// account
#define kRestoreSaveUserName  @"RestoreSaveUserName"
#define kRestoreSaveAccount  @"RestoreSaveAccount"
#define kRestoreAutoLogin  @"RestoreAutoLogin"
#define kRestoreUserId  @"RestoreUserId"
#define kRestoreUserName  @"RestoreUserName"
#define kRestorePassword  @"RestorePassword"
#define kRestoreDeviceIdSent  @"RestoreDeviceIdSent"

// recent contact for order page
#define kRestoreLastLoginName  @"RestoreLastLoginName"
#define kRestoreContactName  @"RestoreContactName"
#define kRestoreGuestName  @"RestoreGuestName"
#define kRestoreGuestMobile  @"RestoreGuestMobile"
#define kRestoreGuestEmail  @"RestoreGuestEmail"

//alipayClient about
#define kAppScheme @"jinjiangtravelplus"

#define nilStringFlag  @"nil"

#define TEXT_FIELD_TAG  9999

#define TIME 60

#define kSecondsPerDay  (24 * 60 * 60)
#define kSecondsThreeMonth  (24 * 60 * 60 * 30 * 3)
#define kMaxStayDays  15
#define kDismissAlertDelay  1.2

//HotelFilterViewController
#define BRAND_CODE @"BRAND_CODE"
#define PRICE_CODE @"PRICE_CODE"
#define STAR_CODE @"STAR_CODE"
#define AREA_CODE @"AREA_CODE"

//product channel
#define PRODUCT_CHANNEL @"APPSTORE_MARKET"

//MemberCardType
#define JJCARD @"JJCARD"
#define JBENEFITCARD @"JBENEFITCARD"
#define J2BENEFITCARD @"J2BENEFITCARD"
#define J8BENEFITCARD @"J8BENEFITCARD"

#define USER_CITY_SAME_LOC @"USER_CITY_SAME_LOCATION_SEARCH_JINJIANG_TRAVEL_PLUS"
#define USER_DEVICE_5 @"USER_DEVICE_5_JINJIANG_TRAVEL_PLUS"
#define USER_ORDER_ALL @"USER_ORDER_ALL_JINJIANG_TRAVEL_PLUS"
#define USER_DEVICE_VERSION @"USER_DEVICE_VERSION"

#define FIRST @"kClientVersion_FirstView_JINJIANG_HOTEL_++"

#define kPrintfInfo printf("%s Line: %d\n", __FUNCTION__, __LINE__)
#define kUPdateUrl @"kUPdateUrl_JINJIANG_HOTEL"
#define kVersionDescription @"kVersionDescription_JINJIANG_HOTEL"
#define kForceUPBool @"forceUPBool_JINJIANG_HOTEL"



//SEGUE ID
//fromXxxxxToYyyy
#define FROM_INDEX_TO_ABOUT                 @"fromIndexToAbout"
#define FROM_INDEX_TO_SEARCH                @"fromIndexToSearch"
#define FROM_INDEX_TO_PERSONAL_CENTER       @"fromIndexToPersonalCenter"
#define FROM_INDEX_TO_FEEDBACK              @"fromIndexToFeedback"
#define FROM_INDEX_TO_CONFIG                @"fromIndexToConfig"
#define FROM_INDEX_TO_FAVERATE_HOTEL        @"fromIndexToFaverateHotel"
#define FROM_INDEX_TO_PROMOTION             @"fromIndexToPromotion"

#define FROM_SEARCH_TO_HOTLE_LIST           @"fromSearchToHotelList"
#define FROM_SEARCH_TO_LOGIN                @"fromSearchToLogin"
#define FROM_HOTEL_LIST_TO_DETAIL           @"fromHotelListToDetail"
#define FROM_MAP_HOTEL_LIST_TO_DETAIL       @"fromMapHotelListToDetail"
#define FROM_BILL_LIST_TO_PAYMENT           @"fromBillListToPayment"
#define FROM_BILL_LIST_TO_DETAIL            @"fromBillListToDetail"
#define FROM_DETAIL_TO_HOTEL_DETAIL         @"fromDetailToHotelDetail"
#define FROM_HOTEL_LIST_TO_BOOKING          @"fromHotelListToBooking"
#define FROM_HOTEL_LIST_TO_LOGIN            @"fromHotelListToLogin"
#define FROM_LOGIN_TO_BOOKING               @"fromLoginToBooking"

//Cell ID
#define OrderEffectiveCellID                @"orderCellEffective"
#define OrderHistoryCellID                  @"orderCellHistory"
#define PromotionCellID                     @"promotionCell"

//TRACE CATEGORY
//from 100
#define TRACE_CREATE_ORDER_LOCATION     @"100"

#import "AppDelegate.h"
#define TheAppDelegate  ((AppDelegate *)[UIApplication sharedApplication].delegate)

#endif


