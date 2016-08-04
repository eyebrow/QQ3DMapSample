//
//  AppDelegate.m
//  QQMapSample
//
//  Created by iprincewang on 16/8/3.
//  Copyright © 2016年 com.tencent.prince. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "QAppKeyCheck.h"
#import "MapSDKDemoViewController.h"

#define MAPKEY @"RGBBZ-CVW3U-GUIVT-BP2GY-IYTN3-4CB74"

@interface AppDelegate () <QAppKeyCheckDelegate>
@property(nonatomic,strong)QAppKeyCheck *keyCheck;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //这里加载第一个页面；
    MapSDKDemoViewController *viewController = [[MapSDKDemoViewController alloc] init];
    UINavigationController *navC = [[UINavigationController alloc]initWithRootViewController:viewController];
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = navC;
    [self.window makeKeyAndVisible];
    
    self.keyCheck = [[QAppKeyCheck alloc] init];
    [self.keyCheck start:@"RGBBZ-CVW3U-GUIVT-BP2GY-IYTN3-4CB74" withDelegate:self];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma  mark -- QAppKeyCheckDelegate
// 这是QAppKeyCheckDelegate提供的key验证回调，用于检查传入的key值是否合法
-(void) notifyAppKeyCheckResult:(QErrorCode)errCode
{
    if (errCode == QErrorNone) {
        NSLog(@"验证成功");
    }
}
@end
