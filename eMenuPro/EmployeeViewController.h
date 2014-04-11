//
//  EmployeeViewController.h
//  eMenuPro
//
//  Created by Li Feng on 14-3-3.
//  Copyright (c) 2014年 Gong Lingxiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "Employee.h"
#import "MenuMainViewController.h"
#import <CommonCrypto/CommonDigest.h>

@interface EmployeeViewController : UIViewController<MBProgressHUDDelegate>{
    UITextField *userName;
    UITextField *passWord;
    
    MenuMainViewController *menuMainViewController;
    MBProgressHUD *HUD;
}

@property (nonatomic,retain) IBOutlet UITextField *userName;
@property (nonatomic,retain) IBOutlet UITextField *passWord;
@property (nonatomic,retain) IBOutlet UIButton *rememberPassWord;
@property (nonatomic,retain) MenuMainViewController *menuMainViewController;

-(IBAction)rememberPassWord:(id)sender;
-(IBAction)loginButton:(id)sender;
-(IBAction)textFieldDoneEdit:(id)sender;
-(IBAction)editReturn:(id)sender;

@end
