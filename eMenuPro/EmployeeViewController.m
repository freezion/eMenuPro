//
//  EmployeeViewController.m
//  eMenuPro
//
//  Created by Li Feng on 14-3-3.
//  Copyright (c) 2014年 Gong Lingxiao. All rights reserved.
//

#import "EmployeeViewController.h"

@interface EmployeeViewController ()

@end

@implementation EmployeeViewController
@synthesize userName;
@synthesize passWord;
@synthesize menuMainViewController;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(IBAction)rememberPassWord:(id)sender{
    if (self.rememberPassWord.tag==1){
        self.rememberPassWord.tag=2;
        [self.rememberPassWord setImage:[UIImage imageNamed:@"select"] forState:UIControlStateNormal];
    }else{
        self.rememberPassWord.tag=1;
        [self.rememberPassWord setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateNormal];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.view setFrame:CGRectMake(0, 0, 1024, 768)];
    [[NSUserDefaults standardUserDefaults] synchronize];
    self.passWord.secureTextEntry=YES;
    self.rememberPassWord.tag=2;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)loginButton:(id)sender{
    if ([userName.text isEqualToString:@""] || userName.text==nil || [passWord.text isEqualToString:@""] || passWord.text==nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"用户名或密码没有输入" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.dimBackground = YES;
    [HUD setDelegate:self];
    [HUD setLabelText:@"验证中..."];
    //调用myLoginTask方法
    [self login];
}

-(void) login{
    Employee *employee=[[Employee alloc]init];
    employee=[Employee select:userName.text withPassword: [self md5:passWord.text]];
    if (employee.EmployeeID!=nil){
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        if (self.rememberPassWord.tag==1){
            [userDefaults setObject:employee.EmployeeID forKey:@"employeeID"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        [userDefaults setObject:employee.EmployeeID forKey:@"thisEmployeeID"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        //[self performSegueWithIdentifier:@"MemuMainView" sender:self];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        MenuMainViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"MenuMainViewController"];
        self.menuMainViewController=controller;
        [HUD hide:YES];
        [self.view addSubview:menuMainViewController.view];

    }else{
        [HUD hide:YES];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示!" message:@"用户名或密码错误，请重新登陆！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil,nil];
        [alert show];
    }
}
//MD5加密
-(NSString *) md5:(NSString *)input
{
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), digest );
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}

-(IBAction)textFieldDoneEdit:(id)sender{
    [sender resignFirstResponder];
}
-(IBAction)editReturn:(id)sender{
    [userName resignFirstResponder];
    [passWord resignFirstResponder];
}

@end
