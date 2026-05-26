Pod::Spec.new do |spec|
  spec.name         = "DxpPush"
  spec.module_name  = "DxpPush"
  spec.version      = "1.0.2"
  spec.summary      = "Dxp Push"
  spec.description  = "Dxp Push SDK: notification Push"
  spec.homepage     = "https://github.com/HelloGitHub123/DxpPush"
  spec.license      = "MIT"
  spec.author             = { "李标" => "li.biao3@iwhalecloud.com" }

  spec.platform     = :ios, "13.0"
  spec.swift_versions = ['5.0']
  spec.source       = { :git => "https://github.com/HelloGitHub123/DxpPush.git", :tag => "1.0.2" }

   # 关键配置
  spec.source_files = "DxpPush/**/*.{h,m,swift}"
  spec.public_header_files = [
    "DxpPush/DxpPush.h",
    "DxpPush/DxpPushModel.h",
    "DxpPush/comm/CEECommonConstant.h",
    "DxpPush/NotificationPopUpView/HJNotificationManagement.h",
    "DxpPush/NotificationPopUpView/HJNotificationPopUpView.h",
    "DxpPush/Tools/UIImage+ndImgSize.h",
    "DxpPush/ZFCustomControlView/ZFCustomControlView.h",
    "DxpPush/Swift/swiftBridge.h"
  ]
  spec.header_mappings_dir = "DxpPush"

  spec.requires_arc = true
  spec.static_framework = true
   
  # 启用模块定义（Swift 通过同模块 Clang Module 访问 OC，无需 Bridging Header）
  spec.pod_target_xcconfig = {
    'DEFINES_MODULE' => 'YES',
    'CLANG_ENABLE_MODULES' => 'YES',
    'BUILD_LIBRARY_FOR_DISTRIBUTION' => 'YES'
  }
  spec.dependency 'Firebase/Messaging','~> 11.10.0'
	spec.dependency 'Masonry'
	spec.dependency 'SDWebImage'
	spec.dependency 'ZFPlayer', '~> 4.0'
	spec.dependency 'ZFPlayer/ControlView', '~> 4.0'
	spec.dependency 'ZFPlayer/AVPlayer', '~> 4.0'
  spec.dependency 'DXPToolsLib'
end
