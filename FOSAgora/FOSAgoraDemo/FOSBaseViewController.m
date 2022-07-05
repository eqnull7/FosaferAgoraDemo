//
//  FOSBaseViewController.m
//  SilentActiveDemo
//
//  Created by liujiemin on 2022/3/23.
//  Copyright © 2022 Fosafer. All rights reserved.
//

#import "FOSBaseViewController.h"
#import "Reachability.h"
#import <AVFoundation/AVFoundation.h>

@interface FOSBaseViewController ()

/**************************页面控件 *********************************/
// 取景图
@property (nonatomic, strong) UIImageView *viewFinderImageView;
// 左边白
@property (nonatomic, strong) UIView *leftMaskView;
// 右边白
@property (nonatomic, strong) UIView *rightMaskView;
// 上边白
@property (nonatomic, strong) UIView *topMaskView;
// 下边白
@property (nonatomic, strong) UIView *bottomMaskView;
// 上方提示Label
@property (nonatomic, strong) UILabel *tipsLabel;
// 环境信息Label
@property (nonatomic, strong) UILabel *enviLabel;

@end

@implementation FOSBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initSubviews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 网络权限检测
    [self conntectedToNetwork];
    
    // 摄像头权限检测
    [self checkCameraPermission];
}

- (void)initSubviews {
    self.fd_prefersNavigationBarHidden = YES;
    self.view.backgroundColor = [UIColor blackColor];
    
    [self.view addSubview:self.viewFinderImageView];
    [self.view addSubview:self.leftMaskView];
    [self.view addSubview:self.rightMaskView];
    [self.view addSubview:self.topMaskView];
    [self.view addSubview:self.bottomMaskView];
    [self.view addSubview:self.tipsLabel];
    [self.view addSubview:self.enviLabel];
    
    [self.topMaskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(FOS_RATIO_HEIGHT(FOS_STATUS_BAR_HEIGHT+118.0));
    }];
    
    [self.leftMaskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topMaskView.mas_bottom);
        make.left.equalTo(self.view);
        make.right.equalTo(self.viewFinderImageView.mas_left);
        make.bottom.equalTo(self.bottomMaskView.mas_top);
    }];
    
    [self.rightMaskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topMaskView.mas_bottom);
        make.left.equalTo(self.viewFinderImageView.mas_right);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.bottomMaskView.mas_top);
    }];
    
    [self.bottomMaskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.viewFinderImageView.mas_bottom);
        make.bottom.left.right.equalTo(self.view);
    }];
    
    [self.viewFinderImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topMaskView.mas_bottom);
        make.width.height.mas_equalTo(FOS_RATIO_WIDTH(200));
        make.centerX.equalTo(self.view);
    }];
    
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(FOS_RATIO_HEIGHT(75.1));
        make.width.mas_equalTo(FOS_RATIO_WIDTH(FOS_SCREEN_WIDTH - 60));
        make.centerX.equalTo(self.view);
    }];
    
    [self.enviLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.viewFinderImageView.mas_bottom).offset(FOS_RATIO_HEIGHT(20.0));
        make.centerX.equalTo(self.view);
    }];
}

- (void)pop {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setTips:(NSString *)tips {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.tipsLabel.text = tips;
    });
}

- (void)setEnviInfo:(NSString *)enviInfoStr {
    self.enviLabel.text = enviInfoStr;
}

// 检测网络权限
- (void)conntectedToNetwork {
    Reachability *con = [Reachability reachabilityForInternetConnection];
    NetworkStatus status = [con currentReachabilityStatus];
    if (status == NotReachable) {
        WS(ws);
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"无法使用网络"
                                                                       message:@"没有网络访问权限"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [ws pop];
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

// 检测摄像头权限
- (void)checkCameraPermission {
    __block BOOL hasCameraPermission = YES;
    NSString *mediaType = AVMediaTypeVideo;
    dispatch_semaphore_t waitCameraPermission = dispatch_semaphore_create(0);
    [AVCaptureDevice requestAccessForMediaType:mediaType completionHandler:^(BOOL granted) {
        hasCameraPermission = granted;
        dispatch_semaphore_signal(waitCameraPermission);
    }];
    dispatch_semaphore_wait(waitCameraPermission, DISPATCH_TIME_FOREVER);
    
    if (!hasCameraPermission) {
        WS(ws);
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"无法使用相机"
                                                                       message:@"没有相机访问权限"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [ws pop];
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

#pragma mark - 懒加载
- (UIImageView *)viewFinderImageView {
    if (!_viewFinderImageView) {
        _viewFinderImageView = [[UIImageView alloc] init];
        _viewFinderImageView.image = [UIImage imageNamed:@"bgImage"];
    }
    return _viewFinderImageView;
}

- (UIView *)leftMaskView {
    if (!_leftMaskView) {
        _leftMaskView = [[UIView alloc] init];
        _leftMaskView.backgroundColor = [UIColor whiteColor];
    }
    return _leftMaskView;
}

- (UIView *)rightMaskView {
    if (!_rightMaskView) {
        _rightMaskView = [[UIView alloc] init];
        _rightMaskView.backgroundColor = [UIColor whiteColor];
    }
    return _rightMaskView;
}

- (UIView *)topMaskView {
    if (!_topMaskView) {
        _topMaskView = [[UIView alloc] init];
        _topMaskView.backgroundColor = [UIColor whiteColor];
    }
    return _topMaskView;
}

- (UIView *)bottomMaskView {
    if (!_bottomMaskView) {
        _bottomMaskView = [[UIView alloc] init];
        _bottomMaskView.backgroundColor = [UIColor whiteColor];
    }
    return _bottomMaskView;
}

- (UILabel *)tipsLabel {
    if (!_tipsLabel) {
        _tipsLabel = [[UILabel alloc] init];
        _tipsLabel.font = [UIFont fontWithName:@"PingFang SC" size:24];
        _tipsLabel.textColor = FOS_COLOR_RGB16(0x1A2F7B, 1.0);
        _tipsLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _tipsLabel;
}

- (UILabel *)enviLabel {
    if (!_enviLabel) {
        _enviLabel = [[UILabel alloc] init];
        _enviLabel.font = [UIFont fontWithName:@"PingFang SC" size:20];
        _enviLabel.textColor = FOS_COLOR_RGB16(0x086C7C, 1.0);
        _enviLabel.text = @"";
        _enviLabel.numberOfLines = 0;
    }
    return _enviLabel;
}

@end
