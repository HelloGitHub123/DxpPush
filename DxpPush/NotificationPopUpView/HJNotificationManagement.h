//
//  HJNotificationManagement.h
//  DITOApp
//
//  Created by 李标 on 2022/8/30.
//  推送通知消息管理单例

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 推送跳转 URL 回调，由宿主 App 处理 DeepLink / WebView 等（参数为 jumpUrl / openURL / copyJumpUrl）
typedef void (^HJNotificationOpenURLHandler)(NSString *openURL);

@interface HJNotificationManagement : NSObject

+ (instancetype)sharedInstance;

/// 点击推送或 Action 按钮后需要打开的 URL，交由第三方处理
@property (nonatomic, copy, nullable) HJNotificationOpenURLHandler openURLHandlerBlock;

// 设置推送消息数据
- (void)setNotificationData:(NSDictionary *)dic;
- (void)setNotificationData:(NSDictionary *)dic actionId:(NSString *)actionID;
// 存储是否登陆
//- (void)setLoginFlag:(BOOL)isLogin;
// 是否需要登陆
- (BOOL)isNeedLogin;
// 处理推送消息
- (void)handleNotificationMsg;
// 清空重置缓存数据
- (void)clearNotificationData;
@end

NS_ASSUME_NONNULL_END
