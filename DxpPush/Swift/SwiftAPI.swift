//
//  SwiftAPI.swift
//  DxpPush
//
//  对外 Swift 友好 API，集成方只需 `import DxpPush` 即可使用，无需额外桥接配置。
//

import Foundation
import UIKit

// MARK: - Enums

/// 推送展示类型
@objc public enum DxpPushShowType: Int {
    case alert = 1
    case popup = 2
}

/// 推送跳转类型
@objc public enum DxpPushJumpType: Int {
    case `default` = 0
    case app = 1
    case deepLink = 2
    case webView = 3
    case survey = 4
}

/// 推送 Action 按钮事件类型
@objc public enum DxpPushActionType: Int {
    case `default` = 1
    case deepLink = 2
    case webView = 3
    case copy = 4
}

// MARK: - Model

/// Swift 推送数据模型
@objcMembers
public final class DxpPushNotificationModel: NSObject {
    public var showType: DxpPushShowType = .alert
    public var jumpType: DxpPushJumpType = .default
    public var title: String?
    public var content: String?
    public var category: String?
    public var isShowCloseBtn: Bool = false
    public var closeBtnText: String?
    public var moreBtnText: String?
    public var richMediaFilePath: String?

    public override init() {
        super.init()
    }

    /// 从 Objective-C `DxpPushModel` 转换
    public convenience init(ocModel: DxpPushModel) {
        self.init()
        showType = DxpPushShowType(rawValue: Int(ocModel.showType.rawValue)) ?? .alert
        jumpType = DxpPushJumpType(rawValue: ocModel.jumpType) ?? .default
        title = ocModel.title
        content = ocModel.content
        category = ocModel.category
        isShowCloseBtn = ocModel.isShowCloseBtn
        closeBtnText = ocModel.closeBtnText
        moreBtnText = ocModel.moreBtnText
        richMediaFilePath = ocModel.richMediaFilePath
    }

    /// 转换为 Objective-C `DxpPushModel`
    public func toOCModel() -> DxpPushModel {
        let model = DxpPushModel()
        model.showType = NSNotificationShowType(rawValue: UInt32(showType.rawValue))
        model.jumpType = jumpType.rawValue
        model.title = title
        model.content = content
        model.category = category
        model.isShowCloseBtn = isShowCloseBtn
        model.closeBtnText = closeBtnText
        model.moreBtnText = moreBtnText
        model.richMediaFilePath = richMediaFilePath
        return model
    }
}

// MARK: - Main API

/// DxpPush Swift 主入口，封装推送初始化、Token 获取与 URL 回调
@objcMembers
public final class DxpPushAPI: NSObject {

    /// 单例
    @objc public static let shared = DxpPushAPI()

    private let bridge = DxpPushSwiftBridge.shared()

    private override init() {
        super.init()
    }

    /// App Group ID，用于 Extension 共享通知数据
    @objc public var groupId: String? {
        get { bridge.groupId }
        set { bridge.groupId = newValue }
    }

    /// 推送点击跳转 URL 回调（DeepLink / WebView / Action 按钮）
    @objc public var onOpenURL: ((String) -> Void)? {
        get {
            guard let handler = bridge.openURLHandler else { return nil }
            return { url in handler(url) }
        }
        set {
            if let handler = newValue {
                bridge.openURLHandler = { url in handler(url) }
            } else {
                bridge.openURLHandler = nil
            }
        }
    }

    /// 通知 Category Action 按钮标题（最多 4 个）
    @objc public var categoryActionButtonNames: [String] {
        get { bridge.categoryActionButtonNames }
        set { bridge.categoryActionButtonNames = newValue }
    }

    /// 当前 FCM registration token
    @objc public var deviceToken: String? {
        bridge.deviceToken()
    }

    /// 初始化推送权限、远程通知与 FCM
    @objc public func configure(
        application: UIApplication,
        launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) {
        bridge.initPush(with: application, launchOptions: launchOptions)
    }

    /// 主动拉取 FCM token（授权完成后可调用）
    @objc public func fetchFCMToken() {
        bridge.fetchFCMToken()
    }
}

// MARK: - Notification Handler

/// 推送消息跳转管理（高级场景，一般通过 DxpPushAPI.onOpenURL 即可）
@objcMembers
public final class DxpPushNotificationHandler: NSObject {

    @objc public static let shared = DxpPushNotificationHandler()

    private let bridge = DxpPushSwiftBridge.shared()

    private override init() {
        super.init()
    }

    /// 点击推送或 Action 按钮后需要打开的 URL 回调
    @objc public var onOpenURL: ((String) -> Void)? {
        get {
            guard let handler = bridge.notificationOpenURLHandler else { return nil }
            return { url in handler(url) }
        }
        set {
            if let handler = newValue {
                bridge.notificationOpenURLHandler = { url in handler(url) }
            } else {
                bridge.notificationOpenURLHandler = nil
            }
        }
    }

    /// 保存推送 payload
    @objc public func setNotificationData(_ data: [AnyHashable: Any]) {
        bridge.setNotificationData(data)
    }

    /// 保存推送 payload 与 Action ID
    @objc public func setNotificationData(_ data: [AnyHashable: Any], actionId: String?) {
        bridge.setNotificationData(data, actionId: actionId)
    }

    /// 处理推送消息跳转
    @objc public func handleNotification() {
        bridge.handleNotificationMessage()
    }

    /// 清空缓存数据
    @objc public func clear() {
        bridge.clearNotificationData()
    }

    /// 是否需要登录
    @objc public var isNeedLogin: Bool {
        bridge.isNotificationNeedLogin()
    }
}
