//
//  HJNotificationPopUpView.m
//  DITOApp
//
//  Created by 李标 on 2022/8/25.
//

#import "HJNotificationPopUpView.h"
#import <ZFPlayer/ZFAVPlayerManager.h>
#import <ZFPlayer/ZFPlayerControlView.h>
#import <ZFPlayer/UIView+ZFFrame.h>
#import <ZFPlayer/ZFPlayerConst.h>
#import "ZFCustomControlView.h"
#import "CEECommonConstant.h"
#import <Masonry/Masonry.h>

@interface HJNotificationPopUpView ()

// 播放器
@property (nonatomic, strong) ZFPlayerController *player;
@property (nonatomic, strong) UIImageView *containerView;
@property (nonatomic, strong) ZFCustomControlView *controlView;
@property (nonatomic, strong) UIButton *closeBtn;
@end

@implementation HJNotificationPopUpView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.h_image = 0;
        [self createSubViews];
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    }
    return self;
}

- (void)createSubViews
{
    [self addSubview:self.bkView];
    [self.bkView addSubview:self.backImg];
    [self.bkView addSubview:self.containerView];
    [self.bkView addSubview:self.lbContent];
    [self.bkView addSubview:self.confirmBtn];
    [self.bkView addSubview:self.cancelBtn];
    [self addSubview:self.closeBtn];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    //适配等比缩放
    CGFloat scale = (SCREEN_WIDTH - 32) / 343;
    
    CGFloat totalHeight = 0;
    CGFloat h_CancelBtn = 0;
    if (self.isShowCloseBtn) {
        // cancel 按钮的高度
        h_CancelBtn = 20;
    }
    if (self.h_image > 0) {
        totalHeight = self.h_image + self.h_content + 46 + 20 + 16*2 + 22 + 28 + h_CancelBtn;
    } else if (!isEmptyString(self.videoUrl)) {
        totalHeight = 200 + self.h_content + 46 + 20 + 16*2 + 22 + 28 + h_CancelBtn;
    }  else {
        totalHeight = self.h_content + 46 + 20 + 16*2 + 22 + 28 + h_CancelBtn;
    }
    
    [self.bkView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 32, totalHeight));
        make.top.mas_equalTo(self.mas_top).offset((kSafeTop + 157 * scale));
    }];
    
    if (!isEmptyString(self.videoUrl)) {
        ZFAVPlayerManager *playerManager = [[ZFAVPlayerManager alloc] init];
        playerManager.shouldAutoPlay = NO;
        /// 播放器相关
        self.player = [ZFPlayerController playerWithPlayerManager:playerManager containerView:self.containerView];
        self.player.controlView = self.controlView; // 自定义view
        
        [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@200);
            make.top.width.left.mas_equalTo(self.bkView);
        }];
        self.player.pauseWhenAppResignActive = YES;
        self.player.playerDidToEnd = ^(id  _Nonnull asset) {
            //            WS(self);
            //            [self.player play];
            //            [self.player playTheNext];
            //            if (!self.player.isLastAssetURL) {
            //                NSString *title = [NSString stringWithFormat:@"视频标题%zd",self.player.currentPlayIndex];
            //                [self.controlView showTitle:title coverURLString:@"" fullScreenMode:ZFFullScreenModeLandscape];
            //            } else {
            //                [self.player stop];
            //            }
        };
        playerManager.assetURL = [NSURL URLWithString:self.videoUrl];
        [self.controlView showTitle:@"" coverURLString:@"" fullScreenMode:ZFFullScreenModeAutomatic];
        
    } else {
        [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
            make.top.width.left.mas_equalTo(self.bkView);
        }];
    }
    
    [self.backImg mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.mas_equalTo(self.bkView.mas_bottom).offset(-158 * scale);
        make.height.equalTo(@(self.h_image));
        make.top.equalTo(self.containerView.mas_bottom).offset(0);
        make.width.left.mas_equalTo(self.bkView);
    }];
    
    [self.lbContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.backImg.mas_bottom).offset(16);
        make.left.mas_equalTo(self.bkView.mas_left).offset(16);
        make.right.mas_equalTo(self.bkView.mas_right).offset(-16);
        make.height.mas_greaterThanOrEqualTo(22);
    }];
    
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.lbContent.mas_bottom).offset(24 * scale);
        make.left.mas_equalTo(self.bkView.mas_left).offset(16);
        make.right.mas_equalTo(self.bkView.mas_right).offset(-16);
        make.height.mas_equalTo(46 * scale);
    }];
    
//    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.confirmBtn.mas_bottom).offset(22 * scale);
//        make.centerX.mas_equalTo(self.confirmBtn);
//        make.size.mas_equalTo(CGSizeMake(200, 20 * scale));
//    }];
    
    if (self.isShowCloseBtn) {
        [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.confirmBtn.mas_bottom).offset(22 * scale);
            make.centerX.mas_equalTo(self.confirmBtn);
            make.size.mas_equalTo(CGSizeMake(200, 20 * scale));
        }];
    } else {
        [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.bkView.mas_top).offset(2);
            make.right.mas_equalTo(self.bkView.mas_right);
            make.size.mas_equalTo(CGSizeMake(32 * scale, 32 * scale));
        }];
    }

    self.confirmBtn.layer.cornerRadius = 46 * scale / 2;
}

- (void)confirmBtnAction:(UIButton *)sender {
    kPreventRepeatClickTime(1);
    if([self.delegate respondsToSelector:@selector(NotificationPopUpViewClickEvent:)]) {
        [self.delegate NotificationPopUpViewClickEvent:self];
    }
    if (self.player) {
        [self.player stopCurrentPlayingView];
        self.videoUrl = @"";
    }
    [self removeFromSuperview];
}

- (void)cancelBtnAction:(UIButton *)sender {
    if (self.player) {
        [self.player stopCurrentPlayingView];
        self.videoUrl = @"";
    }
    [self removeFromSuperview];
}

#pragma mark -- lazy load

- (UIView *)bkView {
    if (!_bkView) {
        _bkView = [[UIView alloc] init];
        _bkView.backgroundColor = [UIColor whiteColor];
        _bkView.layer.cornerRadius = 16;
    }
    return _bkView;
}

- (UIImageView *)backImg {
    if (!_backImg) {
        _backImg = [[UIImageView alloc] init];
        _backImg.contentMode = UIViewContentModeScaleAspectFill;
//        _backImg.image = [UIImage imageNamed:@"ic_promo_popUp"];
        _backImg.layer.cornerRadius = 16;
        _backImg.clipsToBounds = YES;
    }
    
    return _backImg;
}

- (UILabel *)lbContent {
    if (!_lbContent) {
        _lbContent = [[UILabel alloc] init];
        _lbContent.font = BoldSystemFont(14);
        _lbContent.textAlignment = NSTextAlignmentCenter;
        _lbContent.textColor = UIColorFromRGB(0x3E3E3E);
        _lbContent.numberOfLines = 0;
        _lbContent.lineBreakMode = NSLineBreakByWordWrapping;
    }
    return _lbContent;
}

- (void)setContentText:(NSString *)lbContectText {
    self.lbContent.text = lbContectText;
    // 计算内容高度
    CGSize contnetSize = [self.lbContent sizeThatFits:CGSizeMake((SCREEN_WIDTH - 16*2 - 20*2), CGFLOAT_MAX)];
    self.h_content = contnetSize.height;
}

- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn setTitle:@"Cancel" forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(cancelBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_cancelBtn setTitleColor:UIColorFromRGB(0x0038A8) forState:UIControlStateNormal];
		_cancelBtn.titleLabel.font = systemFont(14);
    }
    return _cancelBtn;
}

- (UIButton *)confirmBtn
{
    if (!_confirmBtn) {
        _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_confirmBtn setTitle:@"OK" forState:UIControlStateNormal];
        [_confirmBtn addTarget:self action:@selector(confirmBtnAction:) forControlEvents:UIControlEventTouchUpInside];
		_confirmBtn.backgroundColor = UIColorFromRGB(0xCE1126);
        [_confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		_confirmBtn.titleLabel.font = systemFont(14);
    }
    return _confirmBtn;
}

- (UIImageView *)containerView {
    if (!_containerView) {
        _containerView = [UIImageView new];
    }
    return _containerView;
}

- (ZFCustomControlView *)controlView {
    if (!_controlView) {
        _controlView = [ZFCustomControlView new];
    }
    return _controlView;
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setImage:[UIImage imageNamed:@"ic_close"] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(cancelBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_closeBtn setTitleColor:UIColorFromRGB(0x0038A8) forState:UIControlStateNormal];
		_closeBtn.titleLabel.font = systemFont(14);
    }
    return _closeBtn;
}

@end
