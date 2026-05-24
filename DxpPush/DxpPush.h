//
//  DxpPush.h
//  TestPush
//
//  Created by 李标 on 2026/5/21.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "DxpPushModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DxpPush : NSObject

+ (instancetype)getInstance;

/// App Group ID，用于 Extension 共享通知数据
@property (nonatomic, copy, nullable) NSString *groupId;

/// PopUp 类型推送弹框回调
//@property (nonatomic, copy, nullable) void (^dxpPushPopUpViewBlock)(DxpPushModel *model);

/// 推送点击跳转 URL 回调（DeepLink / WebView / Action 按钮），由宿主 App 处理 openURL
@property (nonatomic, copy, nullable) void (^dxpPushOpenURLBlock)(NSString *openURL);

@property (nonatomic, strong) NSArray *categoryActionButtonNameList; // 分类按钮名称

/// 当前 FCM registration token
- (nullable NSString *)deviceToken;

/// 初始化推送权限、远程通知与 FCM
- (void)initPushConfig:(UIApplication *)application
         launchOptions:(nullable NSDictionary *)launchOptions;

/// 主动拉取 FCM token（授权完成后可调用）
- (void)fetchFCMToken;

@end

NS_ASSUME_NONNULL_END
