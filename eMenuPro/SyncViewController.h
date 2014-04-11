//
//  ViewController.h
//  eMenuPro
//
//  Created by Gong Lingxiao on 14-2-8.
//  Copyright (c) 2014年 Gong Lingxiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "EmployeeViewController.h"
#import "Shop.h"
#import "Employee.h"
#import "DishInfo.h"
#import "DishType.h"

@interface SyncViewController : UIViewController<MBProgressHUDDelegate>
{
    NSUserDefaults *userDefaults;
    MBProgressHUD *HUD;
    EmployeeViewController *employeeViewController;
}
@property (nonatomic, strong) UIImageView * line;
@property (nonatomic, strong) UIView *darkView;
@property (nonatomic,strong) EmployeeViewController *employeeViewController;

- (IBAction)Synchronization:(id)sender;
- (void)Synchronization;
- (void)EmployeeSynch;
- (void)DishSynch;
@end

