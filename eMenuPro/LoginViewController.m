//
//  LoginViewController.m
//  eMenuPro
//
//  Created by Li Feng on 14-2-19.
//  Copyright (c) 2014年 Gong Lingxiao. All rights reserved.
//

#import "LoginViewController.h"



@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize userName;
@synthesize passWord;
@synthesize background;
@synthesize syncViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.view setFrame:CGRectMake(0, 0, 1024, 768)];
    self.background.image=[UIImage imageNamed:@"line"];
    self.passWord.secureTextEntry=YES;
    //self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:nil]];
	// Do any additional setup after loading the view.
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
    [self.view.superview addSubview:HUD];
    [self.view bringSubviewToFront:HUD];
    HUD.dimBackground = YES;
    HUD.delegate = self;
    [HUD setLabelText:@"验证中..."];
    [HUD show:YES];
    //调用myLoginTask方法
    [self login];
}

-(void) login{
    //定义返回错误信息
    NSError *error;
    //获取服务器路径
    NSString *Url = [NSString stringWithFormat:@"%@ws/shopLogin", WEBSERVICE_ADDRESS];
    //定义http请求管理
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    //设定传输值
    NSDictionary *params = @{@"shopLoginName": userName.text, @"password": passWord.text};
    //链接http
    [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:Url parameters:params error:&error];
    //获取链接信息
    operationManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //提取返回数据
    [operationManager POST:Url parameters:params
                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                       NSError *error;
                       NSDictionary *json = [NSJSONSerialization
                                             JSONObjectWithData:responseObject
                                             options:kNilOptions
                                             error:&error];
                       //NSDictionary *latestLoans = (NSDictionary *) responseObject;
                       NSLog(@"JSON: %@", json);
                       int erron=[[json objectForKey:@"errno"] intValue];
                       [HUD hide:YES];
                       if (erron==1){
                           NSDictionary *arr = [json objectForKey:@"rst"];
                           //NSLog(@"%@",[arr objectAtIndex:0]);
                           NSLog(@"address: %@", [arr objectForKey:@"address"]);
                           Shop *shop=[Shop alloc];
                           //把服务器上取得的数据放入实体
                           shop.shopID =[arr objectForKey:@"id"];
                           shop.shopName=[arr objectForKey:@"shopName"];
                           shop.shopAddress=[arr objectForKey:@"address"];
                           shop.loginName=[arr objectForKey:@"loginName"];
                           shop.shopSummary=[arr objectForKey:@"summary"];
                           shop.shopPhone=@"";//[arr objectForKey:@"shopPhone"];
                           shop.shopIco=[arr objectForKey:@"shopIco"];
                           shop.shopAdvert=[arr objectForKey:@"advert"];
                           //调用插入Sqlite
                           [Shop insert:shop];
                            //登录状态写入程序变量
                           NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                           [userDefaults setObject:shop.loginName forKey:@"loginName"];
                           [userDefaults setObject:shop.shopID forKey:@"shopID"];
                           [userDefaults synchronize];
                           UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                           SyncViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"SyncViewController"];
                           self.syncViewController=controller;
                           [self.view addSubview:syncViewController.view];
                       }else if (erron==0){
                           NSLog(@"用户名密码错误");
                           UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示!" message:@"用户名或密码错误，请重新登陆！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                           [alert show];
                       }else{
                           NSLog(@"数据异常");
                           UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示!" message:@"数据异常！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                           [alert show];
                       }
                   } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                       NSLog(@"Error: %@", error);
                       [HUD hide:YES];
                       UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"网络状况不佳，或未知错误，请重新尝试！"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                       [alert show];
                   }];

}


-(IBAction)textFieldDoneEdit:(id)sender{
    [sender resignFirstResponder];
}
-(IBAction)editReturn:(id)sender{
    [userName resignFirstResponder];
    [passWord resignFirstResponder];
}

@end
