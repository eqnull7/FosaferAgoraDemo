//
//  AppDelegate.m
//  FOSAgoraDemo
//
//  Created by liujiemin on 2022/5/12.
//  Copyright © 2022 Fosafer. All rights reserved.
//

#import "AppDelegate.h"
#import "FOSHomeViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    FOSHomeViewController *homeVC = [[FOSHomeViewController alloc] init];
    UINavigationController *navc = [[UINavigationController alloc] initWithRootViewController:homeVC];
    self.window.rootViewController = navc;
    [self.window makeKeyAndVisible];
    
    return YES;
}


@end
