//
//  ViewController.m
//  eMenuPro
//
//  Created by Gong Lingxiao on 14-2-8.
//  Copyright (c) 2014年 Gong Lingxiao. All rights reserved.
//

#import "SyncViewController.h"


@interface SyncViewController ()

@end

@implementation SyncViewController
@synthesize employeeViewController;

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
    userDefaults = [NSUserDefaults standardUserDefaults];
    [self.view setFrame:CGRectMake(0, 0, 1024, 768)];
    //NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //[userDefaults setInteger:myInteger forKey:@"myInteger"];
    //[userDefaults setInteger:myInteger forKey:@"myInteger"];
    //[userDefaults setInteger:myInteger forKey:@"myInteger"];
    //[userDefaults setInteger:myInteger forKey:@"myInteger"];
    //[userDefaults setInteger:myInteger forKey:@"myInteger"];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//商家登陆后同步商家
- (IBAction)Synchronization:(id)sender {
    [self Synchronization];

}

-(void)Synchronization{
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.dimBackground = YES;
    [HUD setDelegate:self];
    [HUD setLabelText:@"同步中，请耐心等待..."];
    [HUD show:YES];
    //调用EmployeeSynch方法
    [self EmployeeSynch];
}

//同步员工
- (void)EmployeeSynch{
    
    //定义返回错误信息
    NSError *error;
    //获取服务器路径
    NSString *Url = [NSString stringWithFormat:@"%@ws/employee", WEBSERVICE_ADDRESS];
    //定义http请求管理
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    //设定传输值
    NSDictionary *params = @{@"shopId": [userDefaults objectForKey:@"shopID"]};
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
                       if (erron==1){
                           [Employee delete];
                           NSMutableArray  *arr = [json objectForKey:@"rst"];
                           //NSLog(@"%@",[arr objectAtIndex:0]);
                           for(NSDictionary *inner in arr){
                               Employee *employee=[Employee alloc];
                               //把服务器上取得的数据放入实体
                               employee.EmployeeID=[inner objectForKey:@"code"];
                               employee.EmployeeName=[inner objectForKey:@"name"];
                               employee.PassWord=[inner objectForKey:@"password"];
                               //调用插入Sqlite
                               int flag=[Employee insert:employee];
                               if (flag==1){
                                   NSLog(@"员工插入成功！");
                               }
                           }
                            [self DishSynch];
                       }else if (erron==0){
                           [HUD hide:YES];
                           NSLog(@"无服务员");
                           UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示!" message:@"服务员不存在，请先添加服务员！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                           [alert show];
                       }else{
                           [HUD hide:YES];
                           NSLog(@"数据异常");
                           UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示!" message:@"数据异常，同步失败！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                           [alert show];
                       }
                   } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                       [SystemUtil deleteEmployeeTable];
                       [SystemUtil createEmployeeTable];
                       [HUD hide:YES];
                       NSLog(@"Error: %@", error);
                       UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"网络状况不佳，或未知错误，请重新尝试！"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                       [alert show];
                   }];
}

//同步菜品
- (void)DishSynch{
    //定义返回错误信息
    NSError *error;
    //获取服务器路径
    NSString *Url = [NSString stringWithFormat:@"%@ws/dish", WEBSERVICE_ADDRESS];
    //定义http请求管理
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    //设定传输值
    NSDictionary *params = @{@"shopId": [userDefaults objectForKey:@"shopID"]};
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
                       if (erron==1){
                           [DishInfo delete];
                           [DishInfo deleteImage];
                           NSMutableArray  *arr = [json objectForKey:@"rst"];
                           //NSLog(@"%@",[arr objectAtIndex:0]);
                           for(NSDictionary *inner in arr){
                               DishInfo *dishInfo=[DishInfo alloc];
                               //把服务器上取得的数据放入实体
                               dishInfo.dishCode=[inner objectForKey:@"dishCode"];
                               dishInfo.dishID=[inner objectForKey:@"id"];
                               dishInfo.dishName=[inner objectForKey:@"dishName"];
                               dishInfo.dishMemo=[inner objectForKey:@"dishDesc"];
                               dishInfo.dishIntro=[inner objectForKey:@"dishIntro"];
                               dishInfo.dishPrice=[inner objectForKey:@"dishSellPrice"];
                               dishInfo.dishSellPrice=[inner objectForKey:@"dishSellPrice"];
                               dishInfo.smallDishPrice=[inner objectForKey:@"dishSmallSellPrice"];
                               dishInfo.bigDishPrice=[inner objectForKey:@"dishBigSellPrice"];
                               dishInfo.dishStatus=[inner objectForKey:@"dishStatus"];
                               dishInfo.isHot=[inner objectForKey:@"isHot"];
                               dishInfo.dishTypeID=[inner objectForKey:@"dishTypeId"];
                               dishInfo.dishUnit=[inner objectForKey:@"dishUnit"];
                               dishInfo.dishSpicy=[inner objectForKey:@"spicy"];
                               dishInfo.stock=[inner objectForKey:@"dishCount"];
                               //dishInfo.imageID=[inner objectForKey:@"imageId"];
                               dishInfo.imageID=@"";
                               
                               
                               dishInfo.imageName=[inner objectForKey:@"imageUrl"];
                               NSArray *imgname=[dishInfo.imageName componentsSeparatedByString:@"/"];
                               dishInfo.imageName=[imgname lastObject];
                               
                               NSLog(@"%@", dishInfo.dishName);
                               NSLog(@"%@", dishInfo.imageName);
                               
                               //调用插入Sqlite
                               int flag=[DishInfo insert:dishInfo];
                               
                               if (flag==1){
                                   NSLog(@"菜品插入成功！");
                                   //取得网上图片
                                   NSURL *url = [NSURL URLWithString:[WEBSERVICE_ADDRESS stringByAppendingString:[inner objectForKey:@"imageUrl"]]];
                                   UIImage *imga = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:url]];
                                   //存放路径此处为Document
                                   NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
                                   /*写入图片*/
                                   //帮文件起个全路径名字
                                   NSMutableString *uniquePath = [[NSMutableString alloc] init];
                                   [uniquePath appendString:[paths objectAtIndex:0]];
                                   [uniquePath appendString:@"/"];
                                   [uniquePath appendString:dishInfo.imageName];
                                   //将图片写到文件中
                                   [UIImagePNGRepresentation(imga)writeToFile: uniquePath    atomically:YES];
                                   //调用方法将图片缩小0.6，再次写入做小图显示
                                   imga=[self scaleImage:imga toScale:0.5];
                                   uniquePath=[[NSMutableString alloc] init];
                                   [uniquePath appendString:[paths objectAtIndex:0]];
                                   [uniquePath appendString:@"/Sml"];
                                   [uniquePath appendString:dishInfo.imageName];
                                   [UIImagePNGRepresentation(imga)writeToFile: uniquePath    atomically:YES];
                               }
                           }
                           [self DishTypeSynch];
                       }else if (erron==0){
                           [HUD hide:YES];
                           NSLog(@"无数据");
                           UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示!" message:@"菜品不存在，请先添加菜品！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                           [alert show];
                       }else{
                           [HUD hide:YES];
                           NSLog(@"菜品同步失败");
                           UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示!" message:@"菜品同步失败，请重新尝试！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                           [alert show];
                       }
                   } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                       [SystemUtil deleteDishInfoTable];
                       [SystemUtil deleteImageInfoTable];
                       [SystemUtil deleteEmployeeTable];
                       
                       [SystemUtil createDishInfoTable];
                       [SystemUtil createImageInfoTable];
                       [SystemUtil createEmployeeTable];
                       [HUD hide:YES];
                       NSLog(@"Error: %@", error);
                       UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"网络状况不佳，或未知错误，请重新尝试！"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                       [alert show];
                   }];
}

-(void)DishTypeSynch{
    //定义返回错误信息
    NSError *error;
    //获取服务器路径
    NSString *Url = [NSString stringWithFormat:@"%@ws/type", WEBSERVICE_ADDRESS];
    //定义http请求管理
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    //设定传输值
    NSDictionary *params = @{@"shopId": [userDefaults objectForKey:@"shopID"]};
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
                           [DishType delete];
                           NSMutableArray  *arr = [json objectForKey:@"rst"];
                           //NSLog(@"%@",[arr objectAtIndex:0]);
                           for(NSDictionary *inner in arr){
                               DishType *dishType=[DishType alloc];
                               //把服务器上取得的数据放入实体
                               dishType.typeID=[inner objectForKey:@"id"];
                               dishType.typeName=[inner objectForKey:@"typeName"];
                               dishType.typeSort=[inner objectForKey:@"sort"];
                               dishType.typeDescribe=[inner objectForKey:@"meno"];
                               //调用插入Sqlite
                               int flag=[DishType insert:dishType];
                               if (flag==1){
                                   NSLog(@"菜品种类插入成功！");
                               }
                           }
                           
                           UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                           EmployeeViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"EmployeeViewController"];
                           self.employeeViewController=controller;
                           [self.view addSubview:employeeViewController.view];
                       }else if(erron==0){
                           NSLog(@"无数据");
                           UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示!" message:@"菜品分类未分，请先添加菜品分类！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                           [alert show];
                       }else{
                           NSLog(@"数据异常");
                           UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示!" message:@"同步菜品分类失败，请重新尝试！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                           [alert show];
                       }
                   } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                       [SystemUtil deleteDishTypeTable];
                       [SystemUtil deleteDishInfoTable];
                       [SystemUtil deleteImageInfoTable];
                       [SystemUtil deleteEmployeeTable];
                       
                       [SystemUtil createDishTypeTable];
                       [SystemUtil createDishInfoTable];
                       [SystemUtil createImageInfoTable];
                       [SystemUtil createEmployeeTable];
                       NSLog(@"Error: %@", error);
                       [HUD hide:YES];
                       UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"网络状况不佳，或未知错误，请重新尝试！"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                       [alert show];
                   }];
}

//图片等比例缩放
- (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize
{
    
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scaleSize, image.size.height * scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

@end
