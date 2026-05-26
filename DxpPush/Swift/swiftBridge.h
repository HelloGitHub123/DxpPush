//
//  swiftBridge.h
//  DxpPush
//
//  Objective-C 桥接层，供 SwiftAPI 调用底层实现。
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class DxpPushModel;

NS_ASSUME_NONNULL_BEGIN

/// Swift 层与 Objective-C 底层之间的桥接单例
@interface DxpPushSwiftBridge : NSObject

+ (instancetype)sharedBridge;

#pragma mark - DxpPush

@property (nonatomic, copy, nullable) NSString *groupId;
@property (nonatomic, copy, nullable) void (^openURLHandler)(NSString *openURL);
@property (nonatomic, copy) NSArray<NSString *> *categoryActionButtonNames;

- (nullable NSString *)deviceToken;
- (void)initPushWithApplication:(UIApplication *)application
                  launchOptions:(nullable NSDictionary *)launchOptions;
- (void)fetchFCMToken;

#pragma mark - HJNotificationManagement

@property (nonatomic, copy, nullable) void (^notificationOpenURLHandler)(NSString *openURL);

- (void)setNotificationData:(NSDictionary *)data;
- (void)setNotificationData:(NSDictionary *)data actionId:(nullable NSString *)actionId;
- (void)handleNotificationMessage;
- (void)clearNotificationData;
- (BOOL)isNotificationNeedLogin;

@end

NS_ASSUME_NONNULL_END
