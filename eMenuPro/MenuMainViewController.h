//
//  MenuMainViewController.h
//  eMenuPro
//
//  Created by Li Feng on 14-3-4.
//  Copyright (c) 2014年 Gong Lingxiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "DishType.h"
#import "DishInfo.h"
#import "MenuListViewController.h"
#import "ShopCarViewController.h"
#import "SetUpViewController.h"
#import "HistoryViewController.h"
#import "AddShopCarViewController.h"
#import "myAlert.h"
#import "CustomDishViewController.h"
#import "ZBarSDK.h"
#import "JSBadgeView.h"
#import "MarqueeLabel.h"
#import "BarcodeViewController.h"
#import "BigImageViewController.h"

@class LoginViewController;
@class EmployeeViewController;
@interface MenuMainViewController : UIViewController<MBProgressHUDDelegate,MenuListViewDelegate,SetUpViewDelegate,ShopCarViewDelegate,HistoryViewDelegate,AddShopCarViewDelegate,CustomDishViewDelegate,UIScrollViewDelegate,UITextFieldDelegate,UIPopoverControllerDelegate,UIAlertViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,ZBarReaderDelegate,BigImageViewControllerDelegate,BarcodeViewDelegate>{
    int num;
    BOOL upOrdown;
    NSTimer * timer;
        
    SetUpViewController *setUpViewController;
    EmployeeViewController *employeeViewController;
    LoginViewController *loginViewController;
    MBProgressHUD *HUD;
}
@property (nonatomic, strong) UIImageView * line;

@property (nonatomic,retain) LoginViewController *loginViewController;
@property (nonatomic,retain) EmployeeViewController *employeeViewController;
@property (nonatomic,retain) NSString* BigImageDishId;
//大小份标记
@property (nonatomic) int partflag;
//是否已经有次订单
@property (nonatomic,retain) NSString* orderIDFlag;
@property (nonatomic,retain) NSArray* lastOrder;
//定义导航栏
@property (nonatomic,retain) UIScrollView *navigationScrollView;
//定义左右2个箭头UI
@property (nonatomic,retain) UIImageView *leftArrow;
@property (nonatomic,retain) UIImageView *rightArrow;
//菜单list
@property (nonatomic,retain) NSArray *dishList;
@property (nonatomic) int hotDish;
//菜品分类list
@property (nonatomic,retain) NSArray *dishTypeList;
//
@property (nonatomic, retain) NSMutableArray *tabItems;
//单个菜品
@property (nonatomic,retain) DishInfo *dishInfo;

//总页数
@property (nonatomic) int pageTotalNum;
@property (nonatomic) int thisPage;

//每页视图
@property (nonatomic, retain) NSMutableArray *viewControllers;

//滚动视图
@property (nonatomic,retain) IBOutlet UIScrollView *menuScrollView;
@property (nonatomic, retain) IBOutlet UIPageControl *menuPageControl;
@property (nonatomic,retain) IBOutlet UILabel *shopAdvert;
@property (nonatomic,retain) MarqueeLabel *myshopAdvert;
//小图放大图滚动
@property (nonatomic, retain) NSMutableArray *largeImageViewControllers;
@property (nonatomic,retain) UIScrollView *menuLargeImageScrollView;
@property (nonatomic) int pageLargeImageTotalNum;

//搜索栏
@property (nonatomic,retain) IBOutlet UITextField *searchBar;
-(IBAction)searchBarAction:(id)sender;

//设置
-(IBAction)setUp:(id)sender;
@property (nonatomic, retain) IBOutlet UIButton *setUpButton;
@property (nonatomic,retain) SetUpViewController *setUpViewController;
@property (nonatomic) int setUpFlag;

//购物车
@property (nonatomic, retain) IBOutlet UIButton *shopCarButton;
//@property (nonatomic,retain) ShopCarViewController *shopCarViewController;
-(IBAction)shopCarButton:(id)sender;
@property (nonatomic, retain) JSBadgeView *badgeView;

//桌号
@property (nonatomic, retain) UITextField *txtTableNo;
@property (nonatomic, retain) NSString *tableNo;


//历史记录
-(IBAction)history:(id)sender;
//@property (nonatomic,retain) HistoryViewController *historyViewController;
@property (nonatomic, retain) IBOutlet UIButton *historyButton;


//自定义菜
-(IBAction)customDish:(id)sender;
@property (nonatomic, retain) IBOutlet UIButton *customDishButton;
@property (nonatomic,retain) CustomDishViewController *customDishViewController;
@property (nonatomic) int customDishFlag;

//跳转到商家页面
-(IBAction)systemWeb:(id)sender;
@property (nonatomic,retain) UITextField *textshopAlert;
@end
