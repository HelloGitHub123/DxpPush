//
//  HJNotificationManagement.m
//  DITOApp
//
//  Created by 李标 on 2022/8/30.
//

#import "HJNotificationManagement.h"
#import "CEECommonConstant.h"
#import <UIKit/UIKit.h>

static HJNotificationManagement *manager = nil;

@interface HJNotificationManagement() {
    NSArray *_pageList; // 需要登录的页面的url scheme 名称。 不需要登陆访问的不加在此数组里面
}

@property (nonatomic, strong) NSDictionary *msgDataDic; // 推送消息报文
@property (nonatomic, copy) NSString *actionID;
//@property (nonatomic, assign) BOOL isLogin; // 是否需要登陆
@end

@implementation HJNotificationManagement

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[HJNotificationManagement alloc] init];
    });
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _pageList = @[];
    }
    return self;
}

// 处理推送消息
- (void)handleNotificationMsg {
    if ([self.msgDataDic allKeys] > 0 && isEmptyString(self.actionID)) {
        // 点击消息本身
        [self notificationApplaunchClickByMsg:self.msgDataDic];
    }
    if ([self.msgDataDic allKeys] > 0 && !isEmptyString(self.actionID)) {
         // 点击action 触发
        [self notificationActionButtonClickByMsg:self.msgDataDic actionId:self.actionID];
    }
}

- (void)dispatchOpenURL:(NSString *)openURLString {
    if (isEmptyString(openURLString)) {
        return;
    }
    if (self.openURLHandlerBlock) {
        self.openURLHandlerBlock(openURLString);
    }
}

// 处理点击推送消息后，app启动消息
- (void)notificationApplaunchClickByMsg:(NSDictionary *)dic {
    if ([dic allKeys] == 0) {
        return;
    }
    NSString *jumpType = [dic objectForKey:@"jumpType"];
    NSString *jumpURL = [dic objectForKey:@"jumpUrl"];
    if (NSNotificationJumpType_DeepLink == [jumpType intValue]) {
        [self dispatchOpenURL:jumpURL];
    } else if (NSNotificationJumpType_GcpURL == [jumpType intValue]) {
        [self dispatchOpenURL:jumpURL];
    }
}

// 处理点击推送消息action事件，app启动消息
- (void)notificationActionButtonClickByMsg:(NSDictionary *)userInfoDic actionId:(NSString *)actionID {
    NSString *index = ((NSArray *)[actionID componentsSeparatedByString:@"_"])[1]; // 取出点击action的index
    NSString *strButton = [userInfoDic objectForKey:@"actionButton"];
    NSArray *buttonList = [self returnArrWithJsonString:strButton];
    NSDictionary *dic = [buttonList objectAtIndex:[index intValue]]; // 取出对应的数据源
    if ([dic allKeys] > 0) {
        [self handlingMessagesAction:dic];
    }
}

// 处理推送消息
- (void)handlingMessagesAction:(NSDictionary *)dic {
    NSString *type = [dic objectForKey:@"callAction"];
    if (NSNotificationActionBtnEvent_DeepLink == [type intValue]) {
        [self dispatchOpenURL:[dic objectForKey:@"openURL"]];
    } else if (NSNotificationActionBtnEvent_Webview == [type intValue]) {
        [self dispatchOpenURL:[dic objectForKey:@"openURL"]];
    } else if (NSNotificationActionBtnEvent_Copy == [type intValue]) {
        NSString *copyText = [dic objectForKey:@"copyText"];
        if (!isEmptyString(copyText)) {
            [UIPasteboard generalPasteboard].string = copyText;
        }
        [self dispatchOpenURL:[dic objectForKey:@"copyJumpUrl"]];
    }
}

// 保存推送消息数据
- (void)setNotificationData:(NSDictionary *)dic {
    if ([dic allKeys] > 0) {
        self.msgDataDic = dic;
    } else {
        self.msgDataDic = @{};
    }
}

// 保存推送消息数据 点击action调用
- (void)setNotificationData:(NSDictionary *)dic actionId:(NSString *)actionID {
    if ([dic allKeys] > 0) {
        self.msgDataDic = dic;
    } else {
        self.msgDataDic = @{};
    }
    self.actionID = isEmptyString(actionID) ? @"" : actionID;
}

// 获取推送消息数据
- (NSDictionary *)getMsgData {
    if ([self.msgDataDic allKeys] > 0) {
        return self.msgDataDic;
    }
    return @{};
}

- (BOOL)checkIsLogin:(NSString *)pageName {
	NSString *authToken = [[NSUserDefaults standardUserDefaults] valueForKey:@"DCLoginToken"];
	if (isEmptyString(authToken)) {
		return YES;
	}
	return NO;
	
//    NSString *authToken = (NSString *)kHJAppDataGetCache(kAuthToken);
//    if ([_pageList containsObject:pageName] && isEmptyString(authToken)) {
//        return YES;
//    }
//    return NO;
}

// 是否需要登陆
//- (BOOL)isNeedLogin {
//    return self.isLogin;
//}

// 清空重置缓存数据
- (void)clearNotificationData {
    self.msgDataDic = @{};
    self.actionID = @"";
}

#pragma mark -- Other
- (NSArray *)returnArrWithJsonString:(NSString *)jsonString {
    return [self returnClass:[NSArray class] dictionaryWithJsonString:jsonString];
}

- (NSDictionary *)returnDicWithJsonString:(NSString *)jsonString {
    return [self returnClass:[NSDictionary class] dictionaryWithJsonString:jsonString];
}

- (id)returnClass:(Class)class dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    id obj = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
           
                                                          error:&err];
    if ([obj isKindOfClass:class]) {
        return obj;
    } else {
        return [class new];
    }
 
    return obj;
}

@end
