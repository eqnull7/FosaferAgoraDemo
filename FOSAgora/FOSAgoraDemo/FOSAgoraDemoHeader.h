//
//  FOSAgoraDemoHeader.h
//  FOSAgoraDemo
//
//  Created by liujiemin on 2022/6/8.
//  Copyright © 2022 Fosafer. All rights reserved.
//

#ifndef FOSAgoraDemoHeader_h
#define FOSAgoraDemoHeader_h


#endif /* FOSAgoraDemoHeader_h */

/**************************屏幕颜色适配 *********************************/
#define FOS_STATUS_BAR_HEIGHT ([UIApplication sharedApplication].statusBarFrame.size.height)
#define FOS_SCREEN_WIDTH   [UIScreen mainScreen].bounds.size.width
#define FOS_SCREEN_HEIGHT  [UIScreen mainScreen].bounds.size.height
#define FOS_RATIO_WIDTH(width) width * FOS_SCREEN_WIDTH / 375.0
#define FOS_RATIO_HEIGHT(height) height * FOS_SCREEN_HEIGHT / 667.0
//#define FOS_RATIO_HEIGHT(height) ((FOS_SCREEN_HEIGHT >= 812)? (height * (FOS_SCREEN_HEIGHT - 78) / 667.0):(height * FOS_SCREEN_HEIGHT / 667.0))
// 16进制颜色
#define FOS_COLOR_RGB16(hexValue,ad) [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16)) / 255.0 green:((float)((hexValue & 0xFF00) >> 8)) / 255.0 blue:((float)(hexValue & 0xFF)) / 255.0 alpha:ad]
// 随机颜色
#define FOS_COLOR_RANDOM  [UIColor colorWithRed:(arc4random()%255)/255.0green:(arc4random()%255)/255.0blue:(arc4random()%255)/255.0alpha:1.0]
#define RGB(R,G,B) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1]

#define WS(weakSelf) __weak __typeof(&*self)weakSelf = self;

#define FOSLog(fmt, ...) NSLog((@"[文件名:%s]\n" "[函数名:%s]\n" "[行号:%d] \n" fmt), __FILE__, __FUNCTION__, __LINE__, ##__VA_ARGS__);
#define FOSBugLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);

/**************************头文件引入 *********************************/
#import "Masonry.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
