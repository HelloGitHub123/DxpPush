//
//  swiftBridge.m
//  DxpPush
//

#import "swiftBridge.h"
#import "DxpPush.h"
#import "HJNotificationManagement.h"

@implementation DxpPushSwiftBridge

+ (instancetype)sharedBridge {
    static DxpPushSwiftBridge *bridge = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        bridge = [[DxpPushSwiftBridge alloc] init];
    });
    return bridge;
}

#pragma mark - DxpPush

- (NSString *)groupId {
    return [DxpPush getInstance].groupId;
}

- (void)setGroupId:(NSString *)groupId {
    [DxpPush getInstance].groupId = groupId;
}

- (void (^)(NSString *))openURLHandler {
    return [DxpPush getInstance].dxpPushOpenURLBlock;
}

- (void)setOpenURLHandler:(void (^)(NSString *))openURLHandler {
    [DxpPush getInstance].dxpPushOpenURLBlock = openURLHandler;
}

- (NSArray<NSString *> *)categoryActionButtonNames {
    NSArray *list = [DxpPush getInstance].categoryActionButtonNameList;
    if (![list isKindOfClass:[NSArray class]]) {
        return @[];
    }
    return list;
}

- (void)setCategoryActionButtonNames:(NSArray<NSString *> *)categoryActionButtonNames {
    [DxpPush getInstance].categoryActionButtonNameList = categoryActionButtonNames ?: @[];
}

- (NSString *)deviceToken {
    return [[DxpPush getInstance] deviceToken];
}

- (void)initPushWithApplication:(UIApplication *)application
                  launchOptions:(NSDictionary *)launchOptions {
    [[DxpPush getInstance] initPushConfig:application launchOptions:launchOptions];
}

- (void)fetchFCMToken {
    [[DxpPush getInstance] fetchFCMToken];
}

#pragma mark - HJNotificationManagement

- (void (^)(NSString *))notificationOpenURLHandler {
    return [HJNotificationManagement sharedInstance].openURLHandlerBlock;
}

- (void)setNotificationOpenURLHandler:(void (^)(NSString *))notificationOpenURLHandler {
    [HJNotificationManagement sharedInstance].openURLHandlerBlock = notificationOpenURLHandler;
}

- (void)setNotificationData:(NSDictionary *)data {
    [[HJNotificationManagement sharedInstance] setNotificationData:data];
}

- (void)setNotificationData:(NSDictionary *)data actionId:(NSString *)actionId {
    [[HJNotificationManagement sharedInstance] setNotificationData:data actionId:actionId ?: @""];
}

- (void)handleNotificationMessage {
    [[HJNotificationManagement sharedInstance] handleNotificationMsg];
}

- (void)clearNotificationData {
    [[HJNotificationManagement sharedInstance] clearNotificationData];
}

- (BOOL)isNotificationNeedLogin {
    return [[HJNotificationManagement sharedInstance] isNeedLogin];
}

@end
