//
//  FOSDetectViewController.m
//  FOSDemo
//
//  Created by liujiemin on 2022/4/19.
//  Copyright © 2022 Fosafer. All rights reserved.
//

#import "FOSDetectViewController.h"
#import <AgoraRtcKit/AgoraRtcEngineKit.h>

#define App_id @""
#define App_Key @""
#define App_Secret @""

@interface FOSDetectViewController ()<AgoraRtcEngineDelegate,AgoraMediaFilterEventDelegate>

@property(strong, nonatomic) AgoraRtcEngineKit *agoraKit;

// 预览图
@property (nonatomic, strong) UIView *preview;

@end

@implementation FOSDetectViewController

- (void)viewDidDisappear:(BOOL)animated {
    [self destroy];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addSubviews];
    [self initRtcEngine];
}

- (void)addSubviews {
    [self.view addSubview:self.preview];
    [self.view sendSubviewToBack:self.preview];
}

- (void)initRtcEngine {
    
    AgoraRtcEngineConfig *config = [AgoraRtcEngineConfig new];
    config.eventDelegate = self;
    config.appId = App_id;
    self.agoraKit = [AgoraRtcEngineKit sharedEngineWithConfig:config
                                                   delegate:self];
    
    [self.agoraKit enableExtensionWithVendor:@"fosafer"
                                  extension:@"alive"
                                   enabled:YES];
    [self.agoraKit enableVideo];
    [self.agoraKit setChannelProfile:AgoraChannelProfileLiveBroadcasting];
    [self.agoraKit setClientRole:AgoraClientRoleBroadcaster];
    AgoraRtcVideoCanvas *canvas = [AgoraRtcVideoCanvas new];
    canvas.view = self.preview;
    [self.agoraKit setupLocalVideo:canvas];
    [self.agoraKit startPreview];
    
    // 设置appKey和appSecret
    NSDictionary *propertyDic = @{@"appKey" : App_Key,
                                  @"appSecret" : App_Secret
                                };
    NSData *propertyData = [NSJSONSerialization dataWithJSONObject:propertyDic options:0 error:0];
    NSString *propertyStr = [[NSString alloc] initWithData:propertyData encoding:NSUTF8StringEncoding];
    [self.agoraKit setExtensionPropertyWithVendor:@"fosafer"
                                        extension:@"alive"
                                              key:@"set_appKey_appSecret"
                                            value:propertyStr];
}

// 暂停
- (void)pause {
    [self.agoraKit enableExtensionWithVendor:@"fosafer"
                                  extension:@"alive"
                                   enabled:NO];
}

// 继续
- (void)retry {
    [self setTips:@"请在检测框中露出人脸"];
    // 重置超时时间
    NSDictionary *propertyDic = @{@"retry" : @1
                                };
    NSData *propertyData = [NSJSONSerialization dataWithJSONObject:propertyDic options:0 error:0];
    NSString *propertyStr = [[NSString alloc] initWithData:propertyData encoding:NSUTF8StringEncoding];
    [self.agoraKit setExtensionPropertyWithVendor:@"fosafer"
                                        extension:@"alive"
                                              key:@"retry"
                                            value:propertyStr];
    
    [self.agoraKit enableLocalVideo:YES];
    [self.agoraKit startPreview];
    // 开启检测
    [self.agoraKit enableExtensionWithVendor:@"fosafer"
                                  extension:@"alive"
                                   enabled:YES];
}

// 销毁
- (void)destroy {
    [self.agoraKit stopPreview];
    [self.agoraKit enableLocalVideo:NO];
    [AgoraRtcEngineKit destroy];
}

// 超时的操作
- (void)timeoutAction {
    [self pause];
    [self alertTitle:@"提示" message:@"检测超时" type:1];
}

// 检测成功
- (void)detectSuccessAction {
    [self setTips:@"检测成功"];
    [self alertTitle:@"提示" message:@"检测成功" type:1];
}

- (void)onEvent:(NSString *__nullable)provider
      extension:(NSString *__nullable)extension
            key:(NSString *__nullable)key
          value:(NSString *__nullable)value {
    NSData *jsonData = [value dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if (!err) {
        NSString *errorCode = [dic objectForKey:@"errorCode"];
        NSString *message   = [dic objectForKey:@"message"];
        switch (errorCode.integerValue) {
            case 0:
                NSLog(@"成功");
                [self detectSuccessAction];
                break;
            case 1001:
                [self timeoutAction];
                break;
            case 1002:
                [self alertTitle:@"提示" message:@"打开引擎库失败,请重试" type:1];
                break;
            case 1003:
                [self alertTitle:@"提示" message:@"引擎库返回人脸图片为空,请重试" type:1];
                break;
            case 1004:
                [self alertTitle:@"提示" message:@"setProperty方法参数格式错误" type:1];
                break;
            case 1005:
                [self alertTitle:@"提示" message:@"appKey不能为空" type:1];
                break;
            case 1006:
                [self alertTitle:@"提示" message:@"appSecret不能为空" type:1];
                break;
            case 2000:
                [self setTips:@"正在处理"];
                [self.agoraKit enableLocalVideo:NO];
                break;
            case 2001:
                [self setTips:@"请在检测框中露出人脸"];
                break;
            case 2002:
                [self setTips:@"请在检测框中露出人脸"];
                break;
            case 2003:
                [self setTips:@"靠近点"];
                break;
            case 2004:
                [self setTips:@"离远点"];
                break;
            case 2005:
                [self setTips:@"环境过暗"];
                break;
            case 2006:
                [self setTips:@"环境过亮"];
                break;
            case 2007:
                [self setTips:@"请保持稳定"];
                break;
            case 2008:
                [self setTips:@"请保持手机竖直"];
                break;
            case 3001:
                [self alertTitle:@"提示" message:message type:1];
                break;
            case 3002:
                [self alertTitle:@"提示" message:message type:1];
                break;
                
            default:
                break;
        }
    }
}

- (void)alertTitle:(NSString *)title message:(NSString *)message type:(NSInteger)type{
    WS(ws);
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:title
                                                                       message:message
                                                                preferredStyle:UIAlertControllerStyleAlert];\
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [ws destroy];
            [ws.navigationController popViewControllerAnimated:YES];
        }]];
        
        if (type == 1) {
            [alert addAction:[UIAlertAction actionWithTitle:@"再试一次" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [ws retry];
            }]];
        }
        [ws presentViewController:alert animated:YES completion:nil];
    });
}

#pragma mark - lazy load
- (UIView *)preview {
    if (!_preview) {
        _preview = [[UIView alloc] init];
        CGFloat width = FOS_RATIO_WIDTH(200);
        CGFloat height = 667 * width / 375;
        _preview.frame = CGRectMake(self.view.frame.size.width/4.0, self.view.frame.size.height/6.0, width, height);
    }
    return _preview;
}

- (void)dealloc {
    NSLog(@"检测页面销毁");
}

@end
