//
//  DxpPushModel.h
//  TestPush
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum {
	NSNotificationShowType_Alert = 1, // 默认屏幕页面弹框
	NSNotificationShowType_PopUp = 2, // popup 弹框
} NSNotificationShowType;

@interface DxpPushModel : NSObject

@property (nonatomic, assign) NSNotificationShowType showType;
@property (nonatomic, assign) NSInteger jumpType;
@property (nonatomic, copy, nullable) NSString *title;
@property (nonatomic, copy, nullable) NSString *content;
@property (nonatomic, copy, nullable) NSString *category;
@property (nonatomic, assign) BOOL isShowCloseBtn;
@property (nonatomic, copy, nullable) NSString *closeBtnText;
@property (nonatomic, copy, nullable) NSString *moreBtnText;
@property (nonatomic, copy, nullable) NSString *richMediaFilePath;

@end

NS_ASSUME_NONNULL_END
