//
//  LoginViewController.h
//  eMenuPro
//
//  Created by Li Feng on 14-2-19.
//  Copyright (c) 2014年 Gong Lingxiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SyncViewController.h"
#import "MBProgressHUD.h"
#import "Shop.h"

@interface LoginViewController : UIViewController<MBProgressHUDDelegate>{
    UITextField *userName;
    UITextField *passWord;
    SyncViewController *syncViewController;
    
    MBProgressHUD *HUD;
}

@property (nonatomic,retain) IBOutlet UITextField *userName;
@property (nonatomic,retain) IBOutlet UITextField *passWord;
@property (nonatomic, retain) IBOutlet UIImageView *background;
@property (nonatomic, retain) SyncViewController *syncViewController;

-(IBAction)loginButton:(id)sender;
-(IBAction)textFieldDoneEdit:(id)sender;
-(IBAction)editReturn:(id)sender;


@end
