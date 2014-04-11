//
//  AppDelegate.m
//  eMenuPro
//
//  Created by Gong Lingxiao on 14-2-8.
//  Copyright (c) 2014年 Gong Lingxiao. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSString *docsDir;
    NSArray *dirPaths;
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = [dirPaths objectAtIndex:0];
    // Build the path to the database file
    self.databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"eMenuPro.db"]];
    NSFileManager *filemgr = [NSFileManager defaultManager];
    //当打开系统检查是否存在数据库，如果不存在则创建数据库
    if ([filemgr fileExistsAtPath:self.databasePath] == NO) {
        [SystemUtil createBusinessInfoTable];
        [SystemUtil createDishTypeTable];
        [SystemUtil createDishInfoTable];
        [SystemUtil createImageInfoTable];
        [SystemUtil createOrderDishTable];
        [SystemUtil createWaterMenuTable];
        [SystemUtil createEmployeeTable];
        [SystemUtil createShopCarTable];
    }
    //隐藏状态栏
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    //对程序变量查询，是否已经登录过
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//        [userDefaults setObject:nil forKey:@"loginName"];
//        [userDefaults setObject:nil forKey:@"shopID"];
//        [userDefaults setObject:nil forKey:@"employeeID"];
    NSLog(@"loginName:%@",[userDefaults objectForKey:@"loginName"]);
    NSLog(@"shopID:%@",[userDefaults objectForKey:@"shopID"]);
    NSLog(@"employeeID:%@",[userDefaults objectForKey:@"employeeID"]);
    NSString *shopId=[userDefaults objectForKey:@"shopID"];
    if (shopId!=nil) {
        if ([userDefaults objectForKey:@"employeeID"]!=nil){
            MenuMainViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"MenuMainViewController"];
            self.menuMainViewController = controller;
            self.window.rootViewController = self.menuMainViewController;
        }else{
            if ([Employee select]!=0) {
                EmployeeViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"EmployeeViewController"];
                self.employeeViewController = controller;
                self.window.rootViewController = self.employeeViewController;

            }else{
                SyncViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"SyncViewController"];
                self.syncViewController = controller;
                self.window.rootViewController = self.syncViewController;
            }
        }
    }
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
