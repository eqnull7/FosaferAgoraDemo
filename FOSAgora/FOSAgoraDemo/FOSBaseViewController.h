//
//  FOSBaseViewController.h
//  SilentActiveDemo
//
//  Created by liujiemin on 2022/3/23.
//  Copyright © 2022 Fosafer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FOSBaseViewController : UIViewController

// 返回上一个页面
- (void)pop;
// 设置提示信息
- (void)setTips:(NSString *)tips;
// 设置环境检测结果信息
- (void)setEnviInfo:(NSString *)enviInfoStr;

@end

NS_ASSUME_NONNULL_END
