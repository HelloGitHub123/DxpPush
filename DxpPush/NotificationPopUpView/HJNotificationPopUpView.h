//
//  HJNotificationPopUpView.h
//  DITOApp
//
//  Created by 李标 on 2022/8/25.
//  远程推送 弹框

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, KNotificationMsgType) {
    KNotificationMsgType_default     = 0,  // 默认
    KNotificationMsgType_Image       = 1, // 图片
    KNotificationMsgType_Video       = 2, // 视频
};

NS_ASSUME_NONNULL_BEGIN

@protocol NotificationPopUpViewDelegate <NSObject>

- (void)NotificationPopUpViewClickEvent:(id)target;
@end

@interface HJNotificationPopUpView : UIView

@property (nonatomic, assign) id<NotificationPopUpViewDelegate> delegate;
@property (nonatomic, assign) KNotificationMsgType msgType;
@property (nonatomic, strong) UIView *bkView;
@property (nonatomic, strong) UIImageView *backImg;
@property (nonatomic, copy) NSString *videoUrl;
@property (nonatomic, strong) UILabel *lbContent;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *confirmBtn;
@property (nonatomic, assign) CGFloat h_image; // 图片高度
@property (nonatomic, assign) CGFloat h_content; // 内容高度
@property (nonatomic, assign) BOOL isShowCloseBtn; // 是否显示关闭按钮

- (void)setContentText:(NSString *)lbContectText;
@end

NS_ASSUME_NONNULL_END
