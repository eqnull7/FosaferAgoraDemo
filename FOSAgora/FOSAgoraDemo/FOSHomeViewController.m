//
//  FOSHomeViewController.m
//  SilentActiveDemo
//
//  Created by liujiemin on 2022/3/23.
//  Copyright © 2022 Fosafer. All rights reserved.
//

#import "FOSHomeViewController.h"
#import "FOSDetectViewController.h"

@interface FOSHomeViewController ()

// 提示Label
@property (nonatomic, strong) UILabel *tipsLabel;

// 示范imageView
@property (nonatomic, strong) UIImageView *modelImageView;

// 分割线
@property (nonatomic, strong) UIView *gapLine;

// 提示ImageView
@property (nonatomic, strong) UIImageView *tipsImageView;

// 开始按钮
@property (nonatomic, strong) UIButton *startBtn;

@end

@implementation FOSHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initSubviews];
}

- (void)initSubviews {
    self.view.backgroundColor = [UIColor whiteColor];
    self.fd_prefersNavigationBarHidden = YES;
    
    [self.view addSubview:self.tipsLabel];
    [self.view addSubview:self.modelImageView];
    [self.view addSubview:self.gapLine];
    [self.view addSubview:self.tipsImageView];
    [self.view addSubview:self.startBtn];
    
    
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(FOS_RATIO_HEIGHT(FOS_STATUS_BAR_HEIGHT+55.1));
        make.centerX.equalTo(self.view);
    }];
    
    [self.modelImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tipsLabel.mas_bottom).offset(FOS_RATIO_HEIGHT(9.5));
        make.width.height.mas_equalTo(FOS_RATIO_WIDTH(230.0));
        make.centerX.equalTo(self.view);
    }];
    
    [self.gapLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(FOS_RATIO_WIDTH(300.0));
        make.height.mas_equalTo(1);
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.modelImageView.mas_bottom).offset(FOS_RATIO_HEIGHT(30.5));
    }];
    
    [self.tipsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(FOS_RATIO_WIDTH(272.0));
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.gapLine.mas_bottom).offset(FOS_RATIO_HEIGHT(30.0));
    }];
    
    [self.startBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(FOS_RATIO_WIDTH(20.0));
        make.right.equalTo(self.view).offset(FOS_RATIO_WIDTH(-20.0));
        make.height.mas_equalTo(FOS_RATIO_HEIGHT(45.0));
        make.top.equalTo(self.tipsImageView.mas_bottom).offset(FOS_RATIO_HEIGHT(80.0));
    }];
}

- (void)startBtnAction {
    FOSDetectViewController *vc = [[FOSDetectViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 懒加载
- (UILabel *)tipsLabel {
    if (!_tipsLabel) {
        _tipsLabel = [[UILabel alloc] init];
        _tipsLabel.font = [UIFont fontWithName:@"PingFang SC" size:24];
        _tipsLabel.textColor = FOS_COLOR_RGB16(0x1A2F7B, 1.0);
        _tipsLabel.text = @"请按照提示完成操作";
    }
    return _tipsLabel;
}

- (UIImageView *)modelImageView {
    if (!_modelImageView) {
        _modelImageView = [[UIImageView alloc] init];
        _modelImageView.image = [UIImage imageNamed:@"modelIcon"];
    }
    return _modelImageView;
}

- (UIView *)gapLine {
    if (!_gapLine) {
        _gapLine = [[UIView alloc] init];
        _gapLine.backgroundColor = FOS_COLOR_RGB16(0xEFEFEF, 1.0);
    }
    return _gapLine;
}

- (UIButton *)startBtn {
    if (!_startBtn) {
        _startBtn = [[UIButton alloc] init];
        _startBtn.backgroundColor = FOS_COLOR_RGB16(0x5170D9, 1.0);
        [_startBtn setTitle:@"开始识别" forState:UIControlStateNormal];
        [_startBtn addTarget:self action:@selector(startBtnAction) forControlEvents:UIControlEventTouchUpInside];
        _startBtn.layer.cornerRadius = 4.0;
    }
    return _startBtn;
}

- (UIImageView *)tipsImageView {
    if (!_tipsImageView) {
        _tipsImageView = [[UIImageView alloc] init];
        _tipsImageView.image = [UIImage imageNamed:@"tipsIcon"];
    }
    return _tipsImageView;
}


@end
