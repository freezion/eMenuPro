//
//  AppDelegate.h
//  eMenuPro
//
//  Created by Gong Lingxiao on 14-2-8.
//  Copyright (c) 2014年 Gong Lingxiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SystemUtil.h"
#import "Shop.h"
#import "EmployeeViewController.h"
#import "MenuMainViewController.h"
#import "SyncViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSString *databasePath;

@property (retain, nonatomic) EmployeeViewController *employeeViewController;
@property (retain, nonatomic) MenuMainViewController *menuMainViewController;
@property (retain, nonatomic) SyncViewController *syncViewController;

@end
