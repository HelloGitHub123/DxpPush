//
//  CEECommonConstant.h
//  MPTCLPMall
//
//  Created by OO on 2020/9/1.
//  Copyright © 2020 OO. All rights reserved.
//

#ifndef CEECommonConstant_h
#define CEECommonConstant_h

//判断是否为空
#define objectOrNull(obj)        ((obj) ? (obj) : [NSNull null])
#define objectOrEmptyStr(obj)    ((obj) ? (obj) : @"")
#define isNull(x)                (!x || [x isKindOfClass:[NSNull class]])
#define toInt(x)                 (isNull(x) ? 0 : [x intValue])
#define isEmptyString(x)         (isNull(x) || [x isEqual:@""] || [x isEqual:@"(null)"] || [x isEqual:@"null"])
#define IsNilOrNull(_ref)        (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]))
#define IsArrEmpty(_ref)    (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]) ||([(_ref) count] == 0))

//颜色
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define RGBA(r,g,b,a)            [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define RGB(r,g,b)               [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]

//字体
#define BoldSystemFont(FontValue)     [UIFont fontWithName:@"Roboto-Bold" size:FontValue]
#define systemFont(FontValue)         [UIFont fontWithName:@"Roboto-Medium" size:FontValue]

#define BoldNameFont(FontValue)         [UIFont fontWithName:@"Roboto-Bold" size:FontValue]
#define SystemNameFont(FontValue)         [UIFont fontWithName:@"Roboto-Medium" size:FontValue]
//#define BoldSystemFont(font) [UIFont fontWithName:@"MyanmarSangamMN-Bold" size:font]
//#define systemFont(font)         [UIFont fontWithName:@"MyanmarSangamMN" size:font]

#define kNormalFont              [UIFont systemFontOfSize:14]
#define getFont(n,s)             [UIFont fontWithName:n size:s]

#define stringReplacing(a)     [a stringByReplacingOccurrencesOfString:@"%s" withString:@"%@"]
//版本号
#define kVersion_Coding          [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]
#define kVersionBuild_Coding     [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]
#define OS_VERSION               [UIDevice currentDevice].systemVersion
#define Is_up_Ios_9              ([[UIDevice currentDevice].systemVersion floatValue]) >= 9.0
#define IOS8_OR_LATER            ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0f)
#define bundleID                 [[NSBundle mainBundle] bundleIdentifier]
#define widgetBundleID           @"com.mptvasmm.app.dev.ios.MMDataMallWidget"

#define MD5SerectStr @"32BytesString"
//#define MD5SerectStr @"16BytesString"
//屏幕的宽高
#define SCREEN_WIDTH             [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT            [UIScreen mainScreen].bounds.size.height
#define kScreenWidthScale SCREEN_WIDTH / 375.0
#define kLittleScreenWidthScale (SCREEN_WIDTH-16*2) / 375.0

#define kScreenHeightScale SCREEN_HEIGHT / 812.0
#define kSafeTop ([[UIApplication sharedApplication] statusBarFrame].size.height>20?44:20)

#define CLPCache @"CLPCache"
#define selectedService @"selectedService"

#define customMenuService @"customMenuService"

#define WordFontColor             RGBA(0, 0, 0, 0.85)

#define HOME_ADV_HEIGHT          (SCREEN_HEIGHT>480 ? 0.3 * SCREEN_WIDTH : 0.23 * SCREEN_WIDTH)
#define HOME_TITLE_HEIGHT        (SCREEN_HEIGHT>480 ? SCREEN_WIDTH * 0.6 : SCREEN_WIDTH * 0.56)
//#define HOME_TITLE_HEIGHT        (SCREEN_HEIGHT>480 ? SCREEN_WIDTH * 0.3 : SCREEN_WIDTH * 0.35)
// iPhoneX
#define Is_iPhoneX_Or_More ([UIScreen mainScreen].bounds.size.height >= 812)
#define Is_iPhoneX_Or_MoreForLandscape ([UIScreen mainScreen].bounds.size.width >= 812 || [UIScreen mainScreen].bounds.size.height >= 812 )
//导航栏高度
#define LTNavigationBar_Height ([[UIDevice currentDevice] isiPhoneXMore] ? navigationBarAndStatusBarHeight : 64)
//安全区域高度
#define Safe_Area_Hegiht (SCREEN_HEIGHT>736 ? 34 : 0)

#define get375height(y) (Is_iPhoneX_Or_More ? y : (y * SCREEN_HEIGHT / 812))
#define get375width(x) (Is_iPhoneX_Or_More ? x : (x * SCREEN_WIDTH / 375.0))

#define KIsiPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
#define KIsiPhoneXSMAx ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) : NO)
#define LEIphonePlusOver            (SCREEN_HEIGHT>736?YES:NO)
#define isIphonePlusLess            (SCREEN_HEIGHT<736?YES:NO)
//#define iPhoneXOrLater [UIScreen mainScreen].bounds.size.height>=812? YES : NO
//#define KIsiPhoneX [UIScreen mainScreen].bounds.size.height>=812? YES : NO

//其他
#define stringFormat(s, ...)     [NSString stringWithFormat:(s),##__VA_ARGS__]
#define sleep(s);                [NSThread sleepForTimeInterval:s];
#define Syn(x)                   @synthesize x = _##x
#define _image(x)                [UIImage imageNamed:x]
#define DebugLog(s, ...)         NSLog(@"%s(%d): %@", __FUNCTION__, __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__])
#define PhotosMessageDir         ([[NSString documentPath] stringByAppendingPathComponent:@"/PhotosMessageDir/"])

#define kBlackColor [UIColor blackColor]
#define kMainTitleColor [kBlackColor colorWithAlphaComponent:0.85]
#define kBodyTitleColor [kBlackColor colorWithAlphaComponent:0.65]
#define kDetailTitleColor [kBlackColor colorWithAlphaComponent:0.45]

#define kAppDelegate ((AppDelegate *)[UIApplication sharedApplication].delegate)

// 防止多次调用
#define kPreventRepeatClickTime(_seconds_) \
static BOOL shouldPrevent; \
if (shouldPrevent) return; \
shouldPrevent = YES; \
dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((_seconds_) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ \
shouldPrevent = NO; \
}); \

// 状态栏高度
#define STATUS_BAR_HEIGHT       (Is_iPhoneX_Or_More ? 44.f : 20.f)

#define HOME_INDICATOR_HEIGHT       (Is_iPhoneX_Or_More ? 34.f : 0.f)

#define navigationBarAndStatusBarHeight self.navigationController.navigationBar.frame.size.height + [[UIApplication sharedApplication] statusBarFrame].size.height

#define statusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height

#define navigationBarHeight self.navigationController.navigationBar.frame.size.height

//新状态栏高度
#define KNewStatusHeight ({CGFloat statusBarHeight = 0.0;if (@available(iOS 13.0, *)) {statusBarHeight = [UIApplication sharedApplication].windows.firstObject.windowScene.statusBarManager.statusBarFrame.size.height;} else {statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;}(statusBarHeight);})
//新导航栏高度
#define KNewNavHeight  44.f
#define knewnavigationBarAndStatusBarHeight KNewNavHeight+KNewStatusHeight

#define WS(weakSelf)    __weak __typeof(&*self)weakSelf = self
//宏定义常用字体，常用字体颜色
#define btnBlueColor  UIColorFromRGB(0x1A59E6)
#define normalTextColor RGBA(0,0,0,0.85)
#define normalLabelColor RGBA(0,0,0,0.65)
#define normalHeadTitleColor UIColorFromRGB(0x262626)
#define bgWhiteColor UIColorFromRGB(0xffffff)
#define bgBlackColor UIColorFromRGB(0x000000)
#define normalBtnColor UIColorFromRGB(0xffbd00)

#define normalRedColor UIColorFromRGB(0xE20020)

#define normalBlueColor UIColorFromRGB(0x1A1886)

#define set_Height_Present(a)   [[NSUserDefaults standardUserDefaults] setObject:a forKey:@"height_Present"]
#define get_Height_Present    [[NSUserDefaults standardUserDefaults] objectForKey:@"height_Present"]
//主蓝色
#define mainBlueColor RGBA(26,24,134,1)
//大号粗颜色
#define boldTextColor RGBA(36,36,36,1)
//小号细颜色
#define sysTextColor  RGBA(84,84,84,1)
//线条颜色
#define grayLineColor  RGBA(235,235,235,1)

// 缓存名
#define kHJDataCache @"HJDataCache"
// 底部tabbar缓存key
#define kHJTabbarCache @"HJTabbarCache"
// 首页侧边栏缓存key
#define kHJHomeSliderCache @"HJHomeSliderCache"
// 是否展示语言弹窗
#define kShowLanguageAlert @"showLanguageAlert"

#define kIsReceivePushNotification @"isReceivePushNotification"
// 版本
#define app_Version [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"]

#define kIndividualLoginAccount @"IndividualLoginAccount"
#define kCorporateLoginAccount @"CorporateLoginAccount"


typedef NS_ENUM(NSInteger, kSignUpProgressTag) {
    kSignUpProgressSuccess     = 1,
    kSignUpProgressOne     = 2,
    kSignUpProgressTwo    = 3,
    kSignUpProgressThree   = 4,
    
};

typedef NS_ENUM(NSInteger, kFullFillProgressTag) {
    kFullFillProgressSuccess     = 1,
    kFullFillProgressOne     = 2,
    kFullFillProgressTwo    = 3,
    kFullFillProgressThree   = 4,
    
};

typedef NS_ENUM(NSInteger, kEngageLevelsTag) {
    kRegisterEngageLevelsTag     = 0,
    kPrepaidEngageLevelsTag     = 1,
    kPostpaidEngageLevelsTag    = 2,
    
};


typedef NS_ENUM(NSInteger, kSIMSwapProgressTag) {
    kSIMSwapProgressSuccess     = 1,
    kSIMSwapProgressOne     = 2,
    kSIMSwapProgressTwo    = 3,
    kSIMSwapProgressThree   = 4,
    kSIMSwapProgressFour   = 5,
};

typedef NS_ENUM(NSInteger, kModifyAddrTag) {
    kModifyStreetAddr     = 0,
    kModifyVillageAddr     = 1,
    kModifyProvinveCityAddr    = 2,
};

typedef NS_ENUM(NSInteger, kOrderConfirmTypeTag) {
    kDiyOrderConfirm     = 1,
    kGiftOrderConfirm     = 2,
    kPurchaseOrderConfirm    = 3,
    
};

typedef NS_ENUM(NSInteger, kBalanceItemType) {
    kBalanceVoiceType     = 1,
    kBalanceDataType     = 2,
    kBalanceSMSType    = 3,
    
};

typedef NS_ENUM(NSInteger, kCommentFuelStationType) {
    kBothCanCommentType     = 1,
    kPetrolCanCommentType   = 2,
    kDieselCanCommentType    = 3,
    kNoCanCommentType    = 4,
};

typedef NS_ENUM(NSInteger, kFuelStationStateType) {
    kFuelStationNoInfoStateType     = 0,
    kFuelStationNoOilStateType   = 1,
    kFuelStationAvailabelOilStateType    = 2,
    kFuelStationHaveOilStateType    = 3,
};

typedef enum {
	NSNotificationJumpType_Default   = 0,
	NSNotificationJumpType_APP       = 1, // 打开app
	NSNotificationJumpType_DeepLink  = 2, // 打开app后跳转url scheme
	NSNotificationJumpType_GcpURL    = 3, // 打开app后跳转webview加载url
	NSNotificationJumpType_Invest    = 4, // 打开app后跳问卷调查页面
} NSNotificationJumpType;

typedef enum {
	NSNotificationActionBtnEvent_Default   = 1, // 默认打开app
	NSNotificationActionBtnEvent_DeepLink  = 2, // 打开app后跳转url scheme
	NSNotificationActionBtnEvent_Webview   = 3, // 打开app后跳转webview加载url
	NSNotificationActionBtnEvent_Copy      = 4, // 拷贝文本
} NSNotificationActionBtnEvent;


#endif /* CEECommonConstant_h */
