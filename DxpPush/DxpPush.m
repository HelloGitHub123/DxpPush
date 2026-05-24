//
//  DxpPush.m
//  TestPush
//
//  Created by 李标 on 2026/5/21.
//

#import "DxpPush.h"
#import "DxpPushModel.h"
#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>
#import <Firebase/Firebase.h>
#import "HJNotificationPopUpView.h"
#import "CEECommonConstant.h"
#import <SDWebImage/SDWebImage.h>
#import "UIImage+ndImgSize.h"
#import "HJNotificationManagement.h"

static DxpPush *manager = nil;
static NSString * const kDXPNotificationCategoryIdentifier = @"DXPcategory";

@interface DxpPush () <UNUserNotificationCenterDelegate, FIRMessagingDelegate,NotificationPopUpViewDelegate>
@property (nonatomic, strong) NSDictionary *notification_userInfo;
@property (nonatomic, copy, nullable) NSString *cachedDeviceToken;
@property (nonatomic, strong) HJNotificationPopUpView *notificationPopUpView;
@end

@implementation DxpPush

+ (instancetype)getInstance {
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		manager = [[DxpPush alloc] init];
	});
	return manager;
}

- (instancetype)init {
	self = [super init];
	if (self) {
		self.notification_userInfo = @{};
		self.categoryActionButtonNameList = @[@"action1",@"action2"];
	}
	return self;
}

- (nullable NSString *)deviceToken {
	return self.cachedDeviceToken;
}

- (void)setDxpPushOpenURLBlock:(void (^)(NSString *))dxpPushOpenURLBlock {
	_dxpPushOpenURLBlock = [dxpPushOpenURLBlock copy];
	[HJNotificationManagement sharedInstance].openURLHandlerBlock = _dxpPushOpenURLBlock;
}

- (void)initPushConfig:(UIApplication *)application
         launchOptions:(NSDictionary *)launchOptions {
	if ([FIRApp defaultApp] == nil) {
		[FIRApp configure];
	}

	[UNUserNotificationCenter currentNotificationCenter].delegate = self;
	UNAuthorizationOptions authOptions = UNAuthorizationOptionAlert |
	UNAuthorizationOptionSound | UNAuthorizationOptionBadge;

	[[UNUserNotificationCenter currentNotificationCenter]
	 setNotificationCategories:[self createNotificationCategoryActions]];

	[[UNUserNotificationCenter currentNotificationCenter]
	 getNotificationCategoriesWithCompletionHandler:^(NSSet<UNNotificationCategory *> *categories) {
		NSLog(@"Get categories:%@", categories);
	}];

	[[UNUserNotificationCenter currentNotificationCenter]
	 requestAuthorizationWithOptions:authOptions
	 completionHandler:^(BOOL granted, NSError *error) {
		if (error) {
			NSLog(@"Push authorization error: %@", error);
			return;
		}
		NSLog(@"Push authorization granted: %d", granted);
		if (granted) {
			dispatch_async(dispatch_get_main_queue(), ^{
				[self fetchFCMToken];
			});
		}
	}];

	[application registerForRemoteNotifications];
	[FIRMessaging messaging].delegate = self;
}

- (NSSet<UNNotificationCategory *> *)createNotificationCategoryActions {
	NSMutableArray<UNNotificationAction *> *actions = [NSMutableArray array];
	// 每个 category 最多 4 个 action（系统限制）
	NSUInteger count = MIN(self.categoryActionButtonNameList.count, 4);

	for (NSUInteger i = 0; i < count; i++) {
		NSString *title = self.categoryActionButtonNameList[i];
		if (title.length == 0) {
			continue;
		}
		NSString *identifier = [NSString stringWithFormat:@"action_%lu", (unsigned long)i];
		UNNotificationAction *action = [UNNotificationAction actionWithIdentifier:identifier
																			  title:title
																			options:UNNotificationActionOptionAuthenticationRequired];
		[actions addObject:action];
	}

	if (actions.count == 0) {
		return [NSSet set];
	}

	UNNotificationCategory *category = [UNNotificationCategory categoryWithIdentifier:kDXPNotificationCategoryIdentifier
																			  actions:actions
																	intentIdentifiers:@[]
																			  options:UNNotificationCategoryOptionCustomDismissAction];
	return [NSSet setWithObject:category];
}

- (void)fetchFCMToken {
	[[FIRMessaging messaging] tokenWithCompletion:^(NSString *token, NSError *error) {
		if (error) {
			NSLog(@"Error getting FCM registration token: %@", error);
			return;
		}
		NSLog(@"FCM registration token: %@", token);
		self.cachedDeviceToken = token;
	}];
}

#pragma mark - FIRMessagingDelegate

- (void)messaging:(FIRMessaging *)messaging didReceiveRegistrationToken:(NSString *)fcmToken {
	NSLog(@"FCM registration token refreshed: %@", fcmToken);
	self.cachedDeviceToken = fcmToken;
}

#pragma mark -- deviceToken上报接口
- (void)reportPushToken {
	// self.cachedDeviceToken
}


#pragma mark - UNUserNotificationCenterDelegate
// App 处于前台时接收通知
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
	   willPresentNotification:(UNNotification *)notification
		 withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {

	NSDictionary *userInfo = notification.request.content.userInfo;
	NSLog(@"推送数据:userInfo:%@", userInfo);
	self.notification_userInfo = userInfo;
	// 存储数据
	NSUserDefaults *sharedDefault = [[NSUserDefaults alloc] initWithSuiteName:self.groupId];
	[sharedDefault setValue:userInfo forKey:@"Notification_UserInfo"];
	
	if ([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
		// 判断弹出类型
		NSString *showType = [userInfo objectForKey:@"showType"];
		int jumpType = [[userInfo objectForKey:@"jumpType"] intValue];
		bool isNarie = [ @"Y" isEqualToString:[userInfo objectForKey:@"isNarie"]];
		
		if(isNarie) { //
			//			[[HJQuestInvestManager sharedMgr] investUserNotificationCenter:notification];
			completionHandler(UNNotificationPresentationOptionNone);
		}else {
			if (NSNotificationShowType_Alert == [showType intValue]) {
				// 收到远程推送消息  弹出提醒，声音提醒
				completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert);
			}else if (NSNotificationShowType_PopUp == [showType intValue]) {
				
				// 收到远程推送消息 不弹页眉，弹出popup框
				NSString *title = [userInfo objectForKey:@"title"];
				NSString *content = [userInfo objectForKey:@"content"];
				NSString *category = [userInfo objectForKey:@"category"];
				
				self.notificationPopUpView = nil;
				
				// 1.是否显示关闭按钮 Y:显示 N:不显示;
				// 2.N的话右上角添加X关闭功能
				NSString *isShowCloseBtn = [userInfo objectForKey:@"showCloseBtn"];
				self.notificationPopUpView.isShowCloseBtn = [isShowCloseBtn isEqualToString:@"Y"] ? YES: NO;
				NSString *closeTextBtn = [userInfo objectForKey:@"closeBtnText"];
				NSString *moreTextBtn = [userInfo objectForKey:@"moreBtnText"];
				if (!isEmptyString(closeTextBtn)) {
					[self.notificationPopUpView.cancelBtn setTitle:closeTextBtn forState:UIControlStateNormal];
				}
				if (!isEmptyString(moreTextBtn)) {
					[self.notificationPopUpView.confirmBtn setTitle:moreTextBtn forState:UIControlStateNormal];
				}
				
				if ([category isEqualToString:@"img_Category"]) {
					// 图片的高度
					NSString *imgUrl = [userInfo objectForKey:@"richMediaFilePath"];
					CGSize size = [UIImage getImageSizeWithURL:[NSURL URLWithString:imgUrl]];
					
					if (size.width > 0 && size.height > 0) {
						CGFloat h_imageView = ((SCREEN_WIDTH - 16*2) * size.height) / size.width;
						self.notificationPopUpView.h_image = h_imageView;
					}
					self.notificationPopUpView.msgType = KNotificationMsgType_Image;
					[self.notificationPopUpView setContentText:isEmptyString(content)?@"":content];
					
					[[self keyWindow] addSubview:self.notificationPopUpView];
					[self.notificationPopUpView.backImg sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@""] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
						
					}];
				} else if ([category isEqualToString:@"video_Category"]) {
					NSString *videoUrl = [userInfo objectForKey:@"richMediaFilePath"];
					self.notificationPopUpView.msgType = KNotificationMsgType_Video;
					self.notificationPopUpView.videoUrl = videoUrl;
					[self.notificationPopUpView setContentText:isEmptyString(content)?@"":content];
					[[self keyWindow] addSubview:self.notificationPopUpView];
				} else {
					self.notificationPopUpView.msgType = KNotificationMsgType_default;
					[self.notificationPopUpView setContentText:isEmptyString(content)?@"":content];
					[[self keyWindow] addSubview:self.notificationPopUpView];
				}
				
				completionHandler(UNNotificationPresentationOptionNone);
			} else {
				// 默认
				completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert);
			}
		}
	} else {
		// 收到本地推送消息
		NSLog(@"收到本地推送消息: %@", userInfo);
		completionHandler(UNNotificationPresentationOptionNone);
	}
}

#pragma mark - 用户点击通知（前台/后台）
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
didReceiveNotificationResponse:(UNNotificationResponse *)response
		 withCompletionHandler:(void (^)(void))completionHandler {

	NSDictionary *userInfo = response.notification.request.content.userInfo;
	self.notification_userInfo = userInfo;
	NSString *actionID = response.actionIdentifier;
	
	// 存储数据
	NSUserDefaults *sharedDefault = [[NSUserDefaults alloc] initWithSuiteName:self.groupId];
	[sharedDefault setValue:userInfo forKey:@"Notification_UserInfo"];
	
	NSLog(@"推送数据:userInfo:%@", userInfo);
	// 判断点击事件
	if ([actionID isEqualToString:@"com.apple.UNNotificationDefaultActionIdentifier"]) {
		
		bool isNarie = [ @"Y" isEqualToString:[userInfo objectForKey:@"isNarie"]];
		
		if(isNarie) {
			//			[HJQuestInvestManager sharedMgr].backNotification = response.notification;
		}else {
			if ([self currentVC]  && [self currentVC].navigationController) {
				// 默认打开app 不论是前台还是后台
				[[HJNotificationManagement sharedInstance] setNotificationData:userInfo];
				[[HJNotificationManagement sharedInstance] handleNotificationMsg];
			}
		}
	} else {
		if ([self currentVC] && [self currentVC].navigationController) {
			// 点击的是action 不论是前台还是后台
			//            [self notificationItemClickByUserInfo:userInfo actionId:actionID];
			[[HJNotificationManagement sharedInstance] setNotificationData:userInfo actionId:actionID];
			[[HJNotificationManagement sharedInstance] handleNotificationMsg];
			
		} else {
			// 保存数据到单例
			[[HJNotificationManagement sharedInstance] setNotificationData:userInfo actionId:actionID];
		}
	}
	completionHandler();
}


#pragma mark -- tools
// 获取当前window
- (UIWindow *)keyWindow {
	return [UIApplication sharedApplication].keyWindow;
}

#pragma mark -- layz load
- (HJNotificationPopUpView *)notificationPopUpView {
	if (!_notificationPopUpView) {
		_notificationPopUpView = [[HJNotificationPopUpView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
		_notificationPopUpView.delegate = self;
	}
	return _notificationPopUpView;
}

- (UIViewController *)currentVC {
	if ([[UIApplication sharedApplication].delegate.window.rootViewController isKindOfClass:[UINavigationController class]]) {
		return ((UINavigationController *)[UIApplication sharedApplication].delegate.window.rootViewController).topViewController;
	} else if ([[UIApplication sharedApplication].delegate.window.rootViewController isKindOfClass:[UITabBarController class]]) {
		UITabBarController *tab = (UITabBarController *)[UIApplication sharedApplication].delegate.window.rootViewController;
		return ((UINavigationController *)tab.selectedViewController).topViewController;
	}
	return nil;
}

@end
