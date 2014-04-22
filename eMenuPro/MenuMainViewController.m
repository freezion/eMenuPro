//
//  MenuMainViewController.m
//  eMenuPro
//
//  Created by Li Feng on 14-3-4.
//  Copyright (c) 2014年 Gong Lingxiao. All rights reserved.
//

#import "MenuMainViewController.h"
#import "EmployeeViewController.h"
#import "SyncViewController.h"
#import "LoginViewController.h"

@interface MenuMainViewController ()

@end

@implementation MenuMainViewController
@synthesize leftArrow;
@synthesize rightArrow;
@synthesize dishTypeList;
@synthesize tabItems;
@synthesize dishList;
@synthesize dishInfo;
@synthesize viewControllers;
@synthesize pageTotalNum;
@synthesize menuScrollView;
@synthesize navigationScrollView;
@synthesize loginViewController;
@synthesize employeeViewController;
@synthesize setUpViewController;
@synthesize partflag;

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
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    Shop *shop=[Shop select:[userDefaults objectForKey:@"shopID"]];
//    self.shopAdvert.text=shop.shopAdvert;
    
    self.myshopAdvert = [[MarqueeLabel alloc] initWithFrame:CGRectMake(158, 719, 720, 48) rate:50.0f andFadeLength:718.0f];
    self.myshopAdvert.numberOfLines = 1;
    self.myshopAdvert.opaque = NO;
    self.myshopAdvert.enabled = YES;
    self.myshopAdvert.shadowOffset = CGSizeMake(0.0, -1.0);
    self.myshopAdvert.textAlignment = NSTextAlignmentLeft;
    self.myshopAdvert.textColor = [UIColor colorWithRed:0.234 green:0.234 blue:0.234 alpha:1.000];
    self.myshopAdvert.backgroundColor = [UIColor clearColor];
    self.myshopAdvert.font = [UIFont systemFontOfSize:25];
    self.myshopAdvert.text = shop.shopAdvert;
    [self.view addSubview:self.myshopAdvert];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self setBadge];
    self.thisPage=0;
    self.customDishFlag=0;
    self.setUpFlag=0;
    self.hotDish=1;
    self.orderIDFlag=@"";
    [self.view setFrame:CGRectMake(0, 0, 1024, 768)];
    dishTypeList=[DishType selectAll];
    UIImage *right;
    if (dishTypeList.count<=8){
        right=[UIImage imageNamed:@"right"];
    }else{
        right=[UIImage imageNamed:@"rightBlack"];
    }
    UIImage *left=[UIImage imageNamed:@"left"];
    leftArrow=[[UIImageView alloc]initWithFrame:CGRectMake(988, 72, left.size.width, left.size.height)];
    leftArrow.image=left;

    rightArrow=[[UIImageView alloc]initWithFrame:CGRectMake(1005, 72, right.size.width, right.size.height)];
    rightArrow.image=right;
    [self.view addSubview:leftArrow];
    [self.view addSubview:rightArrow];
	[self initPage];
}

-(void)initPage{
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view addSubview:HUD];
	
	HUD.delegate = self;
	HUD.labelText = @"初始化";
	
	[HUD show:YES];
    
    navigationScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 56, 980, 47)];
    navigationScrollView.delegate = self;
    navigationScrollView.tag=2;
    // 设置内容大小
    navigationScrollView.contentSize = CGSizeMake(123*dishTypeList.count, 47);
    // 横向滚动条
    navigationScrollView.showsVerticalScrollIndicator = NO;
    navigationScrollView.showsHorizontalScrollIndicator = NO;
    navigationScrollView.scrollsToTop = NO;
    [self.view addSubview:navigationScrollView];
    // 导航栏按钮初始化
    for (NSUInteger i = 0; i < dishTypeList.count; i++){
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(123*i, 0, 120, 47)];
        if (i==0){
            [button setBackgroundImage:[UIImage imageNamed:@"menuBarG" ] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }else{
            [button setBackgroundImage:[UIImage imageNamed:@"menuBar" ] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
        button.titleLabel.textAlignment = UIControlContentHorizontalAlignmentCenter;
        DishType *dishType=[dishTypeList objectAtIndex:i];
        [button setTitle:dishType.typeName forState: UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize: 20.0];
        [button setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
        button.tag=i;
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [navigationScrollView addSubview:button];
    }
    [self shouDishView:0];
    [HUD hide:YES];
}

-(void) shouDishView:(int)i {
    NSUInteger numberPages;
    // 检索菜品数据
    if (i==0){
        self.hotDish=0;
        dishList =[NSArray arrayWithArray:[DishInfo selectAllByIsHot:@"1"]];
        numberPages=dishList.count;
        self.pageTotalNum = numberPages;
    }else{
        self.hotDish=i;
        NSString *typeId = ((DishType *)[dishTypeList objectAtIndex:i]).typeID;
        dishList = [NSArray arrayWithArray:[DishInfo selectAllByType:typeId]];
        numberPages = [self getTotalPage:dishList];
    }
    
    //self.orderDishList = [[NSMutableArray alloc] init];
    NSMutableArray *controllers = [[NSMutableArray alloc] init];
    for (NSUInteger i = 0; i < numberPages; i++)
    {
        [controllers addObject:[NSNull null]];
    }
    self.viewControllers = controllers;
    self.menuPageControl.numberOfPages=numberPages;
    self.menuPageControl.userInteractionEnabled=NO;
    NSArray *viewsToRemove = [self.menuScrollView subviews];
    for (UIView *v in viewsToRemove) [v removeFromSuperview];
    //是否分页
    self.menuScrollView.pagingEnabled = YES;
    //设置scroll大小
    self.menuScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.menuScrollView.frame) * numberPages, CGRectGetHeight(self.menuScrollView.frame));
    self.menuScrollView.scrollEnabled = YES;
    self.menuScrollView.showsHorizontalScrollIndicator = NO;
    self.menuScrollView.showsVerticalScrollIndicator = NO;
    self.menuScrollView.scrollsToTop = NO;
    self.menuScrollView.scrollEnabled=YES;
    self.menuScrollView.delegate = self;
    [self.menuScrollView setContentOffset:CGPointMake(0.0, 0.0)];
    menuScrollView.delaysContentTouches = YES;
    menuScrollView.canCancelContentTouches = YES;
    self.menuPageControl.currentPage=0;
    if (i==0){
        self.menuPageControl.hidden=YES;
    }else{
        self.menuPageControl.hidden=NO;
    }
    [self loadScrollViewWithPage:0];
    [self loadScrollViewWithPage:1];
}

//获取一种菜品的总页数
- (NSUInteger) getTotalPage:(NSArray *) listData {
    NSUInteger numberPages = listData.count;
    NSUInteger retNum = 0;
    
    float fltNum = numberPages / 6.0;
    int intNum = numberPages / 6.0;
    if (fltNum > intNum) {
        retNum = intNum + 1;
    } else {
        retNum = intNum;
    }
    self.pageTotalNum = retNum;
    return retNum;
}

- (void)loadScrollViewWithPage:(NSUInteger)page
{
    if (page >= self.pageTotalNum)
        return;

    // replace the placeholder if necessary
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MenuListViewController *controller = [self.viewControllers objectAtIndex:page];
    if ((NSNull *)controller == [NSNull null])
    {
        MenuListViewController *dishListViewController = [storyboard instantiateViewControllerWithIdentifier:@"MenuListViewController"];
        dishListViewController.page = page;
        controller = dishListViewController;
        controller.delegate = self;
        controller.pageList = [self listForPage:page];
        controller.hotDish= self.hotDish;
        [self.viewControllers replaceObjectAtIndex:page withObject:controller];
    }
    
    // add the controller's view to the scroll view
    if (controller.view.superview == nil)
    {
        CGRect frame = self.menuScrollView.frame;
        frame.origin.x = CGRectGetWidth(frame) * page;
        frame.origin.y = 0;
        controller.view.frame = frame;
        
        [self addChildViewController:controller];
        [self.menuScrollView addSubview:controller.view];
        [controller didMoveToParentViewController:self];
    }
}

- (NSArray *) listForPage:(int) pageNum {
    if (self.hotDish==0){
        NSMutableArray *pageList = [[NSMutableArray alloc] init];
        int start = pageNum * 1;
        int end = (pageNum + 1) * 1;
        for (int i = start; i < end; i ++) {
            if (i <= (dishList.count - 1))
                [pageList addObject:[dishList objectAtIndex:i]];
        }
        return pageList;
    }else{
        NSMutableArray *pageList = [[NSMutableArray alloc] init];
        int start = pageNum * 6;
        int end = (pageNum + 1) * 6;
        for (int i = start; i < end; i ++) {
            if (i <= (dishList.count - 1))
                [pageList addObject:[dishList objectAtIndex:i]];
        }
        return pageList;
    }
}

#pragma mark -
// scrollView 已经滑动
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView.tag==2){
        //x偏移位置
        CGPoint contentOffsetPoint = scrollView.contentOffset;
        CGRect frame = scrollView.frame;
        if (contentOffsetPoint.x == scrollView.contentSize.width - frame.size.width || scrollView.contentSize.width < frame.size.width)
        {
            leftArrow.image=[UIImage imageNamed:@"leftBlack"];
            rightArrow.image=[UIImage imageNamed:@"right"];
        }else if(contentOffsetPoint.x == 0){
            leftArrow.image=[UIImage imageNamed:@"left"];
            rightArrow.image=[UIImage imageNamed:@"rightBlack"];
        }else{
            leftArrow.image=[UIImage imageNamed:@"leftBlack"];
            rightArrow.image=[UIImage imageNamed:@"rightBlack"];
        }
    }else if(scrollView.tag==3){
        // switch the indicator when more than 50% of the previous/next page is visible
        CGFloat pageWidth = CGRectGetWidth(scrollView.frame);
        NSUInteger page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
        int intNum = page / 6.0;
        self.thisPage=intNum;
        [self loadLargeImageScrollViewWithPage:page - 1];
        [self loadLargeImageScrollViewWithPage:page];
        [self loadLargeImageScrollViewWithPage:page + 1];
    }else{
        // switch the indicator when more than 50% of the previous/next page is visible
        CGFloat pageWidth = CGRectGetWidth(scrollView.frame);
        NSUInteger page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
        self.thisPage=page;
        self.menuPageControl.currentPage=page;
        [self loadScrollViewWithPage:page - 1];
        [self loadScrollViewWithPage:page];
        [self loadScrollViewWithPage:page + 1];
    }
}


- (void) showMessage:(int) num withDishTypeId:(NSString *) dishTypeId {
    /*
     messageDishNum = messageDishNum + num;
     if (messageDishNum > 0) {
     self.orderDishCountImage.image = [UIImage imageNamed:@"DetailTag_1_3.png"];
     self.orderDishCount.text = [NSString stringWithFormat:@"%d", messageDishNum];
     } else {
     self.orderDishCountImage.image = [UIImage imageNamed:@""];
     self.orderDishCount.text = @"";
     }
     
     int index = 0;
     for (LSTabItem *item in self.tabItems) {
     if ([item.object isEqual:dishTypeId]) {
     item.badgeNumber = item.badgeNumber + num;
     break;
     }
     index ++;
     }
     [tabView removeFromSuperview];
     tabView = [[VerticalScrollTabBarView alloc] initWithItems:self.tabItems delegate:self];
     tabView.autoresizingMask |= UIViewAutoresizingFlexibleHeight;
     tabView.itemPadding = -50.0f;
     tabView.margin = 0.0f;
     tabView.frame = CGRectMake(self.view.viewWidth - 76.0f, 8.0f, 76.0f, self.view.bounds.size.height);
     [tabView setSelectedTabIndex:index];
     [self.view addSubview:tabView];
     */
}


//完成订单
- (void) finishOrder:(NSArray*)changeOrder withOrderId:(NSString *)orderID{
    if ([orderID isEqualToString:@""] || orderID==nil){
        self.txtTableNo = [[UITextField alloc] init];
        NSArray *array = [ShopCar selectAll];
        if (array.count == 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"未有点菜" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
            [alert show];
        } else {
            UIView *myAlert=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024, 768)];
            myAlert.backgroundColor=[UIColor colorWithRed:229/255.0 green:229/255.0 blue:226/255.0 alpha:0.7];
            myAlert.tag=88;
            
            UIImageView *backImg=[[UIImageView alloc] initWithFrame:CGRectMake(300, 200, 472, 235)];
            backImg.backgroundColor=[UIColor colorWithRed:19/255.0 green:19/255.0 blue:19/255.0 alpha:0.7];
            UILabel *titleLab=[[UILabel alloc] initWithFrame:CGRectMake(500, 220, 170, 55)];
            titleLab.text=@"桌号";
            titleLab.textColor=[UIColor whiteColor];
            titleLab.backgroundColor=[UIColor clearColor];
            titleLab.font=[UIFont systemFontOfSize:38];
            self.txtTableNo=[[UITextField alloc] initWithFrame:CGRectMake(380, 300, 280, 60)];
            self.txtTableNo.placeholder = @"输入桌号";
            self.txtTableNo.keyboardType = UIKeyboardTypeNumberPad;
            self.txtTableNo.font=[UIFont systemFontOfSize:30];
            self.txtTableNo.backgroundColor=[UIColor colorWithRed:229/255.0 green:229/255.0 blue:226/255.0 alpha:0.7];
            self.txtTableNo.textColor=[UIColor whiteColor];
            self.txtTableNo.textAlignment=NSTextAlignmentCenter;
            self.txtTableNo.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            UIButton *dimensional=[[UIButton alloc]initWithFrame:CGRectMake(670, 300, 60, 60)];
            [dimensional setBackgroundColor:[UIColor clearColor]];
            [dimensional setImage:[UIImage imageNamed:@"two-dimensional"] forState:UIControlStateNormal];
            [dimensional addTarget:self action:@selector(setupCamera) forControlEvents:UIControlEventTouchUpInside];
            
            UIButton *noButton=[[UIButton alloc]initWithFrame:CGRectMake(300, 437, 235, 55)];
            [noButton setBackgroundColor:[UIColor colorWithRed:19/255.0 green:19/255.0 blue:19/255.0 alpha:0.7]];
            
            [noButton setTitle:@"返 回" forState:UIControlStateNormal];
            noButton.titleLabel.font=[UIFont systemFontOfSize:30];
            [noButton addTarget:self action:@selector(noButtonAction) forControlEvents:UIControlEventTouchUpInside];
            noButton.titleLabel.textColor=[UIColor whiteColor];
            
            
            UIButton *okButton=[[UIButton alloc]initWithFrame:CGRectMake(537, 437, 235, 55)];
            [okButton setBackgroundColor:[UIColor colorWithRed:19/255.0 green:19/255.0 blue:19/255.0 alpha:0.7]];
            [okButton setTitle:@"确 定" forState:UIControlStateNormal];
            okButton.titleLabel.font=[UIFont systemFontOfSize:30];
            [okButton addTarget:self action:@selector(okButtonAction) forControlEvents:UIControlEventTouchUpInside];
            okButton.titleLabel.textColor=[UIColor whiteColor];
            [myAlert addSubview:backImg];
            [myAlert addSubview:titleLab];
            [myAlert addSubview:self.txtTableNo];
            [myAlert addSubview:noButton];
            [myAlert addSubview:okButton];
            [myAlert addSubview:dimensional];
            [self.view addSubview:myAlert];
        }
    }else{
        self.txtTableNo = [[UITextField alloc] init];
        self.lastOrder=[[NSArray alloc]init];
        if (changeOrder.count==0){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"订单未有改动，请加菜后再做提交！" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
        self.lastOrder=changeOrder;
        OrderDishes *order=[[OrderDishes select:orderID] objectAtIndex:0];
        self.txtTableNo.text=order.desk;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确定要修改订单吗？" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag=3;
        [alert show];
    }
}
- (void)dismissAlert:(UITapGestureRecognizer *) gestureRecognizer {
    [UIView beginAnimations:@"MoveOut" context:nil];
    [self.view viewWithTag:88].alpha = 0;
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(removeAlertViews:)];
    [UIView commitAnimations];
}
- (void)removeAlertViews:(id)object {
    [[self.view viewWithTag:88] removeFromSuperview];
}

-(void) okButtonAction{
    [self dismissAlert:nil];
    self.tableNo = self.txtTableNo.text;
    if ([self.tableNo isEqualToString:@""] || self.tableNo==nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"未输入桌号" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
        [alert show];
    } else {
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        HUD.dimBackground = YES;
        [HUD setDelegate:self];
        [HUD setLabelText:@"提交中..."];
        [HUD show:YES];
        [self toJson];
    }
    [self goshopCar];
}
-(void) noButtonAction{
    [self dismissAlert:nil];
    [self goshopCar];
}



-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        if (alertView.tag == 4) {
            [HUD hide:YES];
            self.orderIDFlag=@"";
            self.tableNo=@"";
            [self.shopCarButton setImage:[UIImage imageNamed:@"shopCar"] forState:UIControlStateNormal];
            for (id obj in self.navigationScrollView.subviews)
            {
                if ([obj isKindOfClass:[UIButton class]])
                {
                    UIButton* theButton = (UIButton*)obj;
                    if (theButton.tag==0){
                        [theButton setBackgroundImage:[UIImage imageNamed:@"menuBarG" ] forState:UIControlStateNormal];
                        [theButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    }
                }
            }
            
            [self shouDishView:0];
        }
    } else {
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view.superview addSubview:HUD];
        [self.view bringSubviewToFront:HUD];
        HUD.dimBackground = YES;
        HUD.delegate = self;
        [HUD setLabelText:@"处理中..."];
        if (alertView.tag == 3){
            self.tableNo = self.txtTableNo.text;
            HUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:HUD];
            HUD.dimBackground = YES;
            [HUD setDelegate:self];
            [HUD setLabelText:@"提交中..."];
            [HUD show:YES];
            [self changeToJson];
        }else if(alertView.tag==12){
            [self.historyButton setImage:[UIImage imageNamed:@"history"] forState:UIControlStateNormal];
            [SystemUtil deleteShopCarTable];
            [SystemUtil createShopCarTable];
            NSArray *orders=[OrderDishes select:self.orderIDFlag];
            NSMutableArray *shopCar=[[NSMutableArray alloc] init];
            for (OrderDishes *dis in orders){
                ShopCar *shop=[[ShopCar alloc]init];
                shop.dishID=dis.dishID;
                shop.dishName=dis.dishName;
                shop.typeName=dis.typeName;
                shop.sellCount=dis.sellCount;
                shop.dishPrice=dis.dishPrice;
                shop.dishUnit=dis.dishUnit;
                shop.memo=dis.memo;
                shop.dishStatus=dis.dishStatus;
                [shopCar addObject:shop];
                [ShopCar insert:shop];
            }
            [self setBadge];
            [self shopCarButton:nil];
        }else if (alertView.tag==22){
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [self VerificationShop:[userDefaults objectForKey:@"loginName"]];
        }else if (alertView.tag==23){
            [HUD hide:YES];
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults removeObjectForKey:@"employeeID"];
            NSLog(@"employeeID:%@",[userDefaults objectForKey:@"employeeID"]);
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            EmployeeViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"EmployeeViewController"];
            self.employeeViewController=controller;
            //直接跳转方式
            [self.view addSubview:self.employeeViewController.view];
        }else if (alertView.tag==24){
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [self changeShop:[userDefaults objectForKey:@"loginName"]];
        }
    }
}

//先转换为json格式
- (void) toJson {
    NSError *error;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *shopId=[userDefaults objectForKey:@"shopID"];
    NSMutableArray *arrayOfDicts = [[NSMutableArray alloc] init];
    NSArray *array = [ShopCar selectAll];
    for (ShopCar *orderDish in array) {
        //打包成JSON格式
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                              orderDish.dishID, @"dishId",
                              orderDish.dishStatus, @"status",
                              orderDish.dishName, @"dishName",
                              orderDish.dishPrice, @"dishPrice",
                              orderDish.dishPrice, @"dishSellPrice",
                              orderDish.sellCount, @"count",
                              nil];
        [arrayOfDicts addObject:dict];
    }
    NSArray *info = [NSArray arrayWithArray:arrayOfDicts];
    NSDictionary *jsonDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                    @"0",@"orderStatus",
                                    shopId,@"shopId",
                                    self.tableNo, @"tableNum",
                                    info, @"dishAccountList",
                                    nil];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDictionary
                                                       options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    [self goCheckWebService:jsonString];
}

//订单信息校验是否库存充足
-(void) goCheckWebService:(NSString*)jsonString{
    //定义返回错误信息
    NSError *error;
    //获取服务器路径
    NSString *Url = [NSString stringWithFormat:@"%@ws/checkOrderDishCount", WEBSERVICE_ADDRESS];
    //定义http请求管理
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    //设定传输值
    NSDictionary *params = @{@"orderDish": jsonString};
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
                       NSLog(@"JSON: %@", json);
                       int erron=[[json objectForKey:@"errno"] intValue];
                       if (erron==1){
                           [HUD hide:YES];
                           NSDictionary *arr = [json objectForKey:@"rst"];
                           NSString *alertStr=@"尊敬的顾客，很抱歉，菜品:";
                           int flag=0;
                           for(NSDictionary *inner in arr){
                               DishInfo *dishes=[DishInfo alloc];
                               //把服务器上取得的数据放入实体
                               dishes.dishID=[inner objectForKey:@"id"];
                               dishes.stock=[inner objectForKey:@"dishCount"];
                               //调用插入Sqlite
                               if ([dishes.stock intValue]==0)
                               {
                                   [DishInfo update:dishes];
                                   alertStr=[alertStr stringByAppendingString:@"\n"];
                                   alertStr=[alertStr stringByAppendingString:[DishInfo selectByDishID:dishes.dishID].dishName];
                                   alertStr=[alertStr stringByAppendingString:@","];
                                   flag=1;
                               }
                           }
                           if (flag==1){
                               alertStr=[alertStr stringByAppendingString:@"已售完。"];
                           }
                           for(NSDictionary *inner in arr){
                               DishInfo *dishes=[DishInfo alloc];
                               //把服务器上取得的数据放入实体
                               dishes.dishID=[inner objectForKey:@"id"];
                               dishes.stock=[inner objectForKey:@"dishCount"];
                               if ([dishes.stock intValue]!=0)
                               {
                                   int stock=[[inner objectForKey:@"dishCount"] intValue];
                                   alertStr=[alertStr stringByAppendingString:@"\n"];
                                   alertStr=[alertStr stringByAppendingString:[DishInfo selectByDishID:dishes.dishID].dishName];
                                   alertStr=[alertStr stringByAppendingString:@"当前还有"];
                                   alertStr=[alertStr stringByAppendingString:[NSString stringWithFormat:@"%d",stock]];
                                   alertStr=[alertStr stringByAppendingString:@"份"];
                               }
                           }
                           alertStr=[alertStr stringByAppendingString:@"\n请重新选购。"];
                           UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:alertStr delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
                           [alert show];
                       }else if(erron==0){
                           [HUD hide:YES];
                           [self goWebService:jsonString];
                       }else{
                           [HUD hide:YES];
                           UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"未知错误，或网络状况不佳" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
                           [alert show];

                       }
                   } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                       [HUD hide:YES];
                       UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"未知错误，或网络状况不佳" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
                       [alert show];
                       
                   }];
}



//订单信息上传
-(void) goWebService:(NSString*)jsonString{
    //定义返回错误信息
    NSError *error;
    //获取服务器路径
    NSString *Url = [NSString stringWithFormat:@"%@ws/addOrderDish", WEBSERVICE_ADDRESS];
    //定义http请求管理
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    //设定传输值
    NSDictionary *params = @{@"orderDish": jsonString};
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
                       NSLog(@"JSON: %@", json);
                       int erron=[[json objectForKey:@"errno"] intValue];
                       if (erron==1){
                           NSDictionary *arr = [json objectForKey:@"rst"];
                           //NSLog(@"%@",[arr objectAtIndex:0]);
                           NSLog(@"address: %@", [arr objectForKey:@"orderCode"]);
                           OrderDishes *order=[[OrderDishes alloc]init];
                           //把服务器上取得的数据放入实体
                           order.orderID =[arr objectForKey:@"orderCode"];
                           //订单状态0:表示完成；1:表示添加；2:表示删除
                           order.orderStatus=@"0";
                           NSDate *  senddate=[NSDate date];
                           NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
                           [dateformatter setDateFormat:@"YYYY-MM-dd HH:mm"];
                           NSString *  morelocationString=[dateformatter stringFromDate:senddate];
                           order.orderTime=morelocationString;
                           order.desk=self.tableNo;
                           NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                           NSString *employeeId=[userDefaults objectForKey:@"thisEmployeeID"];
                           order.employee=employeeId;
                           //调用插入Sqlite
                           int flag=[OrderDishes insert:order];
                           NSArray *shopCarItem=[ShopCar selectAll];
                           for (ShopCar *s in shopCarItem){
                               if (flag==1){
                                   [ShopCar insertOrderDishItem:s WithOrderID:order.orderID];
                               }else{
                                   flag=0;
                                   break;
                               }
                           }
                           [HUD hide:YES];
                           if (flag==1){
                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"下单成功" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
                               alert.tag = 4;
                               [SystemUtil deleteShopCarTable];
                               [SystemUtil createShopCarTable];
                               [self setBadge];
                               [alert show];
                           }else{
                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"未知错误，或网络状况不佳" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
                               [alert show];
                           }
                       }else{
                           [HUD hide:YES];
                           UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"未知错误，或网络状况不佳" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
                           [alert show];
                           
                       }
                   } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                       [HUD hide:YES];
                       UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"未知错误，或网络状况不佳" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
                       [alert show];
                       
                   }];
}

//更改后的菜单记录
- (void) changeToJson{
    NSError *error;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *shopId=[userDefaults objectForKey:@"shopID"];
    NSMutableArray *arrayOfDicts = [[NSMutableArray alloc] init];
    NSArray *array = self.lastOrder;
    for (ShopCar *orderDish in array) {
        //打包成JSON格式
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                              orderDish.dishID, @"dishId",
                              orderDish.dishStatus, @"status",
                              orderDish.dishName, @"dishName",
                              orderDish.dishPrice, @"dishPrice",
                              orderDish.dishPrice, @"dishSellPrice",
                              orderDish.sellCount, @"count",
                              nil];
        [arrayOfDicts addObject:dict];
    }
    NSArray *info = [NSArray arrayWithArray:arrayOfDicts];
    NSString *orderId=self.orderIDFlag;
    
    NSDictionary *jsonDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                    orderId,@"orderDishId",
                                    shopId,@"shopId",
                                    info, @"dishAccountList",
                                    nil];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDictionary
                                                       options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    [self changeGoCheckWebService:jsonString];
}

//更改后订单信息校验是否库存充足
-(void) changeGoCheckWebService:(NSString*)jsonString{
    //定义返回错误信息
    NSError *error;
    //获取服务器路径
    NSString *Url = [NSString stringWithFormat:@"%@ws/checkDishAccountCount", WEBSERVICE_ADDRESS];
    //定义http请求管理
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    //设定传输值
    NSDictionary *params = @{@"orderDishAccount": jsonString};
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
                       NSLog(@"JSON: %@", json);
                       int erron=[[json objectForKey:@"errno"] intValue];
                       if (erron==1){
                           [HUD hide:YES];
                           NSDictionary *arr = [json objectForKey:@"rst"];
                           NSString *alertStr=@"尊敬的顾客，很抱歉，菜品:";
                           for(NSDictionary *inner in arr){
                               DishInfo *dishes=[DishInfo alloc];
                               //把服务器上取得的数据放入实体
                               dishes.dishID=[inner objectForKey:@"id"];
                               dishes.stock=[inner objectForKey:@"dishCount"];
                               //调用插入Sqlite
                               if ([dishes.stock intValue]==0)
                               {
                                   [DishInfo update:dishes];
                                   alertStr=[alertStr stringByAppendingString:@"\n"];
                                   alertStr=[alertStr stringByAppendingString:[DishInfo selectByDishID:dishes.dishID].dishName];
                                   alertStr=[alertStr stringByAppendingString:@","];
                               }
                           }
                           alertStr=[alertStr stringByAppendingString:@"已售完。"];
                           for(NSDictionary *inner in arr){
                               DishInfo *dishes=[DishInfo alloc];
                               //把服务器上取得的数据放入实体
                               dishes.dishID=[inner objectForKey:@"id"];
                               dishes.stock=[inner objectForKey:@"dishCount"];
                               if ([dishes.stock intValue]!=0)
                               {
                                   int stock=[[inner objectForKey:@"dishCount"] intValue];
                                   alertStr=[alertStr stringByAppendingString:@"\n"];
                                   alertStr=[alertStr stringByAppendingString:[DishInfo selectByDishID:dishes.dishID].dishName];
                                   alertStr=[alertStr stringByAppendingString:@"当前还有"];
                                   alertStr=[alertStr stringByAppendingString:[NSString stringWithFormat:@"%d",stock]];
                                   alertStr=[alertStr stringByAppendingString:@"份"];
                               }
                           }
                           
                           UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:alertStr delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
                           [alert show];
                       }else if(erron==0){
                           [HUD hide:YES];
                           [self changeGoWebService:jsonString];
                       }else{
                           [HUD hide:YES];
                           UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"未知错误，或网络状况不佳" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
                           [alert show];
                           
                       }
                   } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                       [HUD hide:YES];
                       UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"未知错误，或网络状况不佳" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
                       [alert show];
                       
                   }];
}

//更改后订单信息上传
-(void) changeGoWebService:(NSString*)jsonString{
    NSLog(@"%@",jsonString);
    //定义返回错误信息
    NSError *error;
    //获取服务器路径
    NSString *Url = [NSString stringWithFormat:@"%@ws/addOrderDishAccount", WEBSERVICE_ADDRESS];
    //定义http请求管理
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    //设定传输值
    NSDictionary *params = @{@"orderDishAccount": jsonString};
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
                       NSLog(@"JSON: %@", json);
                       int erron=[[json objectForKey:@"errno"] intValue];
                       if (erron==1){
                           OrderDishes *order=[[OrderDishes alloc]init];
                           NSArray *array = self.lastOrder;
                           for (ShopCar *changeDishInfo in array){
                               if ([changeDishInfo.dishStatus isEqualToString:@"2"]){
                                   DishInfo *changeStock=[[DishInfo alloc]init];
                                   changeStock.dishID=changeDishInfo.dishID;
                                   changeStock.stock=@"1";
                                   [DishInfo update:changeStock];
                               }
                           }
                           //把服务器上取得的数据放入实体
                           order.orderID =self.orderIDFlag;
                           //订单状态0:表示下单完成；1:表示更改完成
                           order.orderStatus=@"1";
                           NSDate *  senddate=[NSDate date];
                           NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
                           [dateformatter setDateFormat:@"YYYY-MM-dd HH:mm"];
                           NSString *  morelocationString=[dateformatter stringFromDate:senddate];
                           order.orderTime=morelocationString;
                           order.desk=self.tableNo;
                           NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                           NSString *employeeId=[userDefaults objectForKey:@"thisEmployeeID"];
                           order.employee=employeeId;
                           [OrderDishes delete:order.orderID];
                           //调用插入Sqlite
                           int flag=[OrderDishes insert:order];
                           NSArray *shopCarItem=[ShopCar selectAll];
                           for (ShopCar *s in shopCarItem){
                               if (flag==1){
                                   [ShopCar insertOrderDishItem:s WithOrderID:order.orderID];
                               }else{
                                   flag=0;
                                   break;
                               }
                           }
                           [HUD hide:YES];
                           if (flag==1){
                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"下单成功" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
                               alert.tag = 4;
                               [SystemUtil deleteShopCarTable];
                               [SystemUtil createShopCarTable];
                               [self setBadge];
                               [alert show];
                           }else{
                               [HUD hide:YES];
                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"未知错误，或网络状况不佳" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
                               [alert show];
                           }
                       }else{
                           [HUD hide:YES];
                           UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"未知错误，或网络状况不佳" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
                           [alert show];
                           
                       }
                   } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                       [HUD hide:YES];
                       UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"未知错误，或网络状况不佳" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
                       [alert show];
                       
                   }];
}
//初始化大图的滚动视图
-(void) shouLargeDishView{
    NSUInteger numberPages;
    NSString *typeId = ((DishType *)[dishTypeList objectAtIndex:self.hotDish]).typeID;
    dishList = [NSArray arrayWithArray:[DishInfo selectAllByType:typeId]];
    numberPages = dishList.count;
    self.pageLargeImageTotalNum=numberPages;
    int page=0;
    for (DishInfo *v in dishList){
        if (![v.dishID isEqualToString:self.BigImageDishId]){
            page++;
        }else{
            break;
        }
    }
    //self.orderDishList = [[NSMutableArray alloc] init];
    NSMutableArray *controllers = [[NSMutableArray alloc] init];
    for (NSUInteger i = 0; i < numberPages; i++)
    {
        [controllers addObject:[NSNull null]];
    }
    self.largeImageViewControllers = controllers;
    self.menuLargeImageScrollView =[[UIScrollView alloc]init];
    self.menuLargeImageScrollView.tag=3;
    NSArray *viewsToRemove = [self.menuLargeImageScrollView subviews];
    for (UIView *v in viewsToRemove) [v removeFromSuperview];
    //是否分页
    self.menuLargeImageScrollView.pagingEnabled = YES;
    //设置scroll大小
    self.menuLargeImageScrollView.frame=CGRectMake(0, 0, 1024, 768);
    self.menuLargeImageScrollView.contentSize = CGSizeMake(1024 * numberPages, 768);
    self.menuLargeImageScrollView.scrollEnabled = YES;
    self.menuLargeImageScrollView.showsHorizontalScrollIndicator = NO;
    self.menuLargeImageScrollView.showsVerticalScrollIndicator = NO;
    self.menuLargeImageScrollView.scrollsToTop = NO;
    self.menuLargeImageScrollView.scrollEnabled=YES;
    self.menuLargeImageScrollView.delegate = self;
    [self.menuLargeImageScrollView setContentOffset:CGPointMake(0.0+1024*page, 0.0)];
    self.menuLargeImageScrollView.delaysContentTouches = YES;
    self.menuLargeImageScrollView.canCancelContentTouches = YES;
    [self loadLargeImageScrollViewWithPage:page-1];
    [self loadLargeImageScrollViewWithPage:page];
    [self loadLargeImageScrollViewWithPage:page+1];
}
//载入大图的滚动视图
- (void)loadLargeImageScrollViewWithPage:(NSUInteger)page
{
    if (page >= self.pageLargeImageTotalNum)
        return;
    
    // replace the placeholder if necessary
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    BigImageViewController *controller = [self.largeImageViewControllers objectAtIndex:page];
    if ((NSNull *)controller == [NSNull null])
    {
        BigImageViewController *dishListViewController = [storyboard instantiateViewControllerWithIdentifier:@"BigImageViewController"];
        controller = dishListViewController;
        controller.delegate=self;

        DishInfo *mydishInfo=[dishList objectAtIndex:page];
        controller.dishID=mydishInfo.dishID;
        controller.dishInfo = mydishInfo;
        [self.largeImageViewControllers replaceObjectAtIndex:page withObject:controller];
    }
    
    // add the controller's view to the scroll view
    if (controller.view.superview == nil)
    {
        CGRect frame = self.menuLargeImageScrollView.frame;
        frame.origin.x = CGRectGetWidth(frame) * page;
        frame.origin.y = 0;
        controller.view.frame = frame;
        
        [self addChildViewController:controller];
        [self.menuLargeImageScrollView addSubview:controller.view];
        [controller didMoveToParentViewController:self];
 
    }
}
//显示大图
- (void) showLargeImage:(UIImage *) image withDishID:(NSString *)dishID {
    self.BigImageDishId=dishID;
    [self shouLargeDishView];
    UIView *view = [[UIView alloc] init];
    view.backgroundColor=[UIColor colorWithRed:233/255.0 green:233/255.0 blue:233/255.0 alpha:1];
    view.tag=98;
    [view setFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    [view addSubview:self.menuLargeImageScrollView];
    [self.view addSubview:view];
}

//设置购物车的badge
- (void) setBadge{
    int count=[ShopCar selectAllCount];
    [self.badgeView removeFromSuperview];
    self.badgeView = [[JSBadgeView alloc] initWithParentView:self.shopCarButton alignment:JSBadgeViewAlignmentTopRight];
    self.badgeView.badgeText=[NSString stringWithFormat:@"%d",count];
    if (count<=0){
        self.badgeView.badgeText=@"";
    }
}

- (void)dismissDarkView{
    //大图转小图，重新绘制当前的滚动视图，并且让视图画面初始化当当前页面
    NSMutableArray *controllers = [[NSMutableArray alloc] init];
    for (NSUInteger i = 0; i < dishList.count; i++)
    {
        [controllers addObject:[NSNull null]];
    }
    self.viewControllers = controllers;
    NSArray *viewsToRemove = [self.menuScrollView subviews];
    for (UIView *v in viewsToRemove) [v removeFromSuperview];
    //是否分页
    self.menuScrollView.pagingEnabled = YES;
    //设置scroll大小
    self.menuScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.menuScrollView.frame) * self.pageTotalNum, CGRectGetHeight(self.menuScrollView.frame));
    self.menuScrollView.scrollEnabled = YES;
    self.menuScrollView.showsHorizontalScrollIndicator = NO;
    self.menuScrollView.showsVerticalScrollIndicator = NO;
    self.menuScrollView.scrollsToTop = NO;
    self.menuScrollView.scrollEnabled=YES;
    self.menuScrollView.delegate = self;
    //让视图画面初始化当当前页面
    [self.menuScrollView setContentOffset:CGPointMake(1024.0*self.thisPage, 0.0)];
    menuScrollView.delaysContentTouches = YES;
    menuScrollView.canCancelContentTouches = YES;
    [self loadScrollViewWithPage:self.thisPage-1];
    [self loadScrollViewWithPage:self.thisPage];
    [self loadScrollViewWithPage:self.thisPage+1];
    
    [UIView beginAnimations:@"MoveOut" context:nil];
    [self.view viewWithTag:98].alpha = 0;
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(removeViews:)];
    [UIView commitAnimations];
}

- (void)removeViews:(id)object {
    [[self.view viewWithTag:98] removeFromSuperview];
}

//点击导航条上得按钮
-(void) buttonClicked:(id)sender{
    UIButton *btn=sender;
    self.thisPage=0;
    [self resetAllButton];
    
    [btn setBackgroundImage:[UIImage imageNamed:@"menuBarG" ] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self shouDishView:btn.tag];
}

-(void) resetAllButton{
    for (id obj in self.navigationScrollView.subviews)
    {
        if ([obj isKindOfClass:[UIButton class]])
        {
            UIButton* theButton = (UIButton*)obj;
            [theButton setBackgroundImage:[UIImage imageNamed:@"menuBar" ] forState:UIControlStateNormal];
            [theButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
    }
    [self.shopCarButton setImage:[UIImage imageNamed:@"shopCar"] forState:UIControlStateNormal];
    [self.historyButton setImage:[UIImage imageNamed:@"history"] forState:UIControlStateNormal];
    [self.setUpButton setImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];
    [self.customDishButton setImage:[UIImage imageNamed:@"custom"] forState:UIControlStateNormal];
}

//自定义菜单
-(IBAction)customDish:(id)sender{
    if (self.customDishFlag==0){
        self.customDishFlag=1;
        [self.customDishButton setImage:[UIImage imageNamed:@"customG"] forState:UIControlStateNormal];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        CATransition *animation = [CATransition animation];
        animation.delegate = self;
        animation.duration = 0.2;
        animation.timingFunction = UIViewAnimationCurveEaseInOut;
        animation.type = kCATransitionMoveIn;
        animation.subtype = kCATransitionFromTop;
        
        CustomDishViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"CustomDishViewController"];
        controller.delegate = self;
        self.customDishViewController = controller;
        [self.view addSubview:self.customDishViewController.view];
        
        [[self.customDishViewController.view layer] addAnimation:animation forKey:@"animation"];
    }
    else{
        [self.customDishButton setImage:[UIImage imageNamed:@"custom"] forState:UIControlStateNormal];
        [self closeCustomDish];
    }
}

-(void)closeCustomDishView{
    [self customDish:nil];
}

-(void) closeCustomDish{
    CGRect napkinTopFrame = self.customDishViewController.view.frame;
    napkinTopFrame.origin.y = napkinTopFrame.origin.y + 588;
    self.customDishFlag=0;
    [UIView animateWithDuration:0.2
                          delay:0
                        options:UIViewAnimationOptionTransitionFlipFromBottom
                     animations:^{
                         self.customDishViewController.view.frame = napkinTopFrame;
                         self.customDishViewController.view.alpha = 0.0;
                     }
                     completion:^(BOOL finished){
                         [self.customDishViewController.view removeFromSuperview];
                     }];
}

-(void) customToAddDish:(ShopCar*)dish{
    [ShopCar insert:dish];
    [self.customDishButton setImage:[UIImage imageNamed:@"custom"] forState:UIControlStateNormal];
    [self closeCustomDish];
    [self shopCarButton:nil];
    [self setBadge];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"添加成功!" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
    [alert show];
}

//历史记录
-(IBAction)history:(id)sender{
    NSArray *orderArr= [OrderDishes selectAll];
    for (OrderDishes *h in orderArr){
        NSDate *  senddate=[NSDate date];
        NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
        [dateformatter setDateFormat:@"YYYY-MM-dd"];
        NSString *  morelocationString=[dateformatter stringFromDate:senddate];
        NSString * data=[h.orderTime substringToIndex:10];
        if (![data isEqualToString: morelocationString]){
            [OrderDishes delete:h.orderID];
        }
    }
    for (id obj in self.navigationScrollView.subviews)
    {
        if ([obj isKindOfClass:[UIButton class]])
        {
            UIButton* theButton = (UIButton*)obj;
            [theButton setBackgroundImage:[UIImage imageNamed:@"menuBar" ] forState:UIControlStateNormal];
            [theButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
    }
    [self.shopCarButton setImage:[UIImage imageNamed:@"shopCar"] forState:UIControlStateNormal];
    [self.historyButton setImage:[UIImage imageNamed:@"historyG"] forState:UIControlStateNormal];
    self.menuPageControl.hidden=YES;
    //清空视图
    NSArray *viewsToRemove = [self.menuScrollView subviews];
    for (UIView *v in viewsToRemove) [v removeFromSuperview];
    //是否分页
    self.menuScrollView.pagingEnabled = NO;
    //设置scroll大小
    self.menuScrollView.showsHorizontalScrollIndicator = NO;
    self.menuScrollView.showsVerticalScrollIndicator = NO;
    self.menuScrollView.scrollsToTop = NO;
    self.menuScrollView.scrollEnabled=NO;
    self.menuScrollView.delegate = self;
    [self.menuScrollView setContentOffset:CGPointMake(0.0, 0.0)];
    menuScrollView.delaysContentTouches = NO;
    menuScrollView.canCancelContentTouches = NO;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    HistoryViewController *historyViewController = [storyboard instantiateViewControllerWithIdentifier:@"HistoryViewController"];
    historyViewController.delegate=self;
    //由于之前清空了视图的视图的组织形式和响应者链；
    if (historyViewController.view.superview == nil)
    {
        CGRect frame = self.menuScrollView.frame;
        frame.origin.x = 0;
        frame.origin.y = 0;
        historyViewController.view.frame = frame;
        [self addChildViewController:historyViewController];
        [self.menuScrollView addSubview:historyViewController.view];
        [historyViewController didMoveToParentViewController:self];
    }
}

//显示主页面
-(void) showMenu{
    [self.shopCarButton setImage:[UIImage imageNamed:@"shopCar"] forState:UIControlStateNormal];
    [self.historyButton setImage:[UIImage imageNamed:@"history"] forState:UIControlStateNormal];
    for (id obj in self.navigationScrollView.subviews)
    {
        if ([obj isKindOfClass:[UIButton class]])
        {
            UIButton* theButton = (UIButton*)obj;
            if (theButton.tag==0){
                [theButton setBackgroundImage:[UIImage imageNamed:@"menuBarG" ] forState:UIControlStateNormal];
                [theButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }
        }
    }
    [self shouDishView:0];
}
- (void) cleanDishShowMenu{
    self.orderIDFlag=@"";
    [self.shopCarButton setImage:[UIImage imageNamed:@"shopCar"] forState:UIControlStateNormal];
    [self.historyButton setImage:[UIImage imageNamed:@"history"] forState:UIControlStateNormal];
    for (id obj in self.navigationScrollView.subviews)
    {
        if ([obj isKindOfClass:[UIButton class]])
        {
            UIButton* theButton = (UIButton*)obj;
            if (theButton.tag==0){
                [theButton setBackgroundImage:[UIImage imageNamed:@"menuBarG" ] forState:UIControlStateNormal];
                [theButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }
        }
    }
    [self shouDishView:0];
}

- (void)closeSetUpView{
    [self setUp:nil];
}
//打开设置
-(IBAction)setUp:(id)sender{
    if (self.setUpFlag==0){
        self.setUpFlag=1;
        [self.setUpButton setImage:[UIImage imageNamed:@"menuG"] forState:UIControlStateNormal];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        CATransition *animation = [CATransition animation];
        animation.delegate = self;
        animation.duration = 0.2;
        animation.timingFunction = UIViewAnimationCurveEaseInOut;
        animation.type = kCATransitionMoveIn;
        animation.subtype = kCATransitionFromTop;
        
        SetUpViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"SetUpViewController"];
        controller.delegate = self;
        self.setUpViewController = controller;
        [self.view addSubview:setUpViewController.view];
        
        [[self.setUpViewController.view layer] addAnimation:animation forKey:@"animation"];
    }
    else{
        [self.setUpButton setImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];
        [self closeSetUp];
    }
}

-(void)closeSetUp{
    CGRect napkinTopFrame = self.setUpViewController.view.frame;
    napkinTopFrame.origin.y = napkinTopFrame.origin.y + 588;
    self.setUpFlag=0;
    [UIView animateWithDuration:0.2
                          delay:0
                        options:UIViewAnimationOptionTransitionFlipFromBottom
                     animations:^{
                         self.setUpViewController.view.frame = napkinTopFrame;
                         self.setUpViewController.view.alpha = 0.0;
                     }
                     completion:^(BOOL finished){
                         [self.setUpViewController.view removeFromSuperview];
                     }];
}

//打开购物车视图
-(IBAction)shopCarButton:(id)sender{
    [self goshopCar];
}

-(void) goshopCar{
    for (id obj in self.navigationScrollView.subviews)
    {
        if ([obj isKindOfClass:[UIButton class]])
        {
            UIButton* theButton = (UIButton*)obj;
            [theButton setBackgroundImage:[UIImage imageNamed:@"menuBar" ] forState:UIControlStateNormal];
            [theButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
    }
    
    NSArray *count =[ShopCar selectAll];
    if (count.count == 0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"还没有点菜，请先点取你需要的菜!" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    [self resetAllButton];
    [self.shopCarButton setImage:[UIImage imageNamed:@"shopCarG"] forState:UIControlStateNormal];
    self.menuPageControl.hidden=YES;
    //清空视图
    NSArray *viewsToRemove = [self.menuScrollView subviews];
    for (UIView *v in viewsToRemove) [v removeFromSuperview];
    //是否分页
    self.menuScrollView.pagingEnabled = NO;
    //设置scroll大小
    self.menuScrollView.showsHorizontalScrollIndicator = NO;
    self.menuScrollView.showsVerticalScrollIndicator = NO;
    self.menuScrollView.scrollsToTop = NO;
    self.menuScrollView.scrollEnabled=NO;
    self.menuScrollView.delegate = self;
    [self.menuScrollView setContentOffset:CGPointMake(0.0, 0.0)];
    menuScrollView.delaysContentTouches = NO;
    menuScrollView.canCancelContentTouches = NO;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ShopCarViewController *shopCarViewController = [storyboard instantiateViewControllerWithIdentifier:@"ShopCarViewController"];
    shopCarViewController.delegate=self;
    shopCarViewController.orderID=self.orderIDFlag;
    //由于之前清空了视图的视图的组织形式和响应者链；
    if (shopCarViewController.view.superview == nil)
    {
        CGRect frame = self.menuScrollView.frame;
        frame.origin.x = 0;
        frame.origin.y = 0;
        shopCarViewController.view.frame = frame;
        [self addChildViewController:shopCarViewController];
        [self.menuScrollView addSubview:shopCarViewController.view];
        [shopCarViewController didMoveToParentViewController:self];
    }
}


//查询历史订单中的菜单
-(void)showAddDishList:(NSString *)orderID{
    for (id obj in self.navigationScrollView.subviews)
    {
        if ([obj isKindOfClass:[UIButton class]])
        {
            UIButton* theButton = (UIButton*)obj;
            [theButton setBackgroundImage:[UIImage imageNamed:@"menuBar" ] forState:UIControlStateNormal];
            [theButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
    }
    
    //清空视图
    NSArray *viewsToRemove = [self.menuScrollView subviews];
    for (UIView *v in viewsToRemove) [v removeFromSuperview];
    //是否分页
    self.menuScrollView.pagingEnabled = NO;
    //设置scroll大小
    self.menuScrollView.showsHorizontalScrollIndicator = NO;
    self.menuScrollView.showsVerticalScrollIndicator = NO;
    self.menuScrollView.scrollsToTop = NO;
    self.menuScrollView.delegate = self;
    [self.menuScrollView setContentOffset:CGPointMake(0.0, 0.0)];
    //menuScrollView.userInteractionEnabled=NO;
    //menuScrollView.scrollEnabled = NO;
    //menuScrollView.directionalLockEnabled=NO;
    menuScrollView.delaysContentTouches = NO;
    menuScrollView.canCancelContentTouches = NO;
    self.menuScrollView.scrollEnabled=NO;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AddShopCarViewController *addShopCarViewController = [storyboard instantiateViewControllerWithIdentifier:@"AddShopCarViewController"];
    addShopCarViewController.delegate=self;
    addShopCarViewController.orderId=orderID;
    //由于之前清空了视图的视图的组织形式和响应者链；
    if (addShopCarViewController.view.superview == nil)
    {
        CGRect frame = self.menuScrollView.frame;
        frame.origin.x = 0;
        frame.origin.y = 0;
        addShopCarViewController.view.frame = frame;
        [self addChildViewController:addShopCarViewController];
        [self.menuScrollView addSubview:addShopCarViewController.view];
        [addShopCarViewController didMoveToParentViewController:self];
    }
    
}


//跳转进去历史加菜菜单(即购物车)
- (void) addHistroyDish:(NSString*) orderID{
    NSArray *count =[ShopCar selectAll];
    if (count.count != 0){
        self.orderIDFlag=orderID;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"你还有商品在购物车，未买单，确定要加菜吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag=12;
        [alert show];
    }else{
        self.orderIDFlag=orderID;
        [self.historyButton setImage:[UIImage imageNamed:@"history"] forState:UIControlStateNormal];
        [SystemUtil deleteShopCarTable];
        [SystemUtil createShopCarTable];
        NSArray *orders=[OrderDishes select:orderID];
        NSMutableArray *shopCar=[[NSMutableArray alloc] init];
        for (OrderDishes *dis in orders){
            ShopCar *shop=[[ShopCar alloc]init];
            shop.dishID=dis.dishID;
            shop.dishName=dis.dishName;
            shop.typeName=dis.typeName;
            shop.sellCount=dis.sellCount;
            shop.dishPrice=dis.dishPrice;
            shop.dishUnit=dis.dishUnit;
            shop.memo=dis.memo;
            shop.dishStatus=dis.dishStatus;
            [shopCar addObject:shop];
            [ShopCar insert:shop];
        }
        [self setBadge];
        [self shopCarButton:nil];
    }
}
- (void) showHistroy{
    [self history:nil];
}

//重新同步
- (void)reSynchronous{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"同步信息会需要一定时间，如果确定同步，请保持网络通畅！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    self.textshopAlert=[[UITextField alloc]init];
    [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    self.textshopAlert = [alert textFieldAtIndex:0];
    self.textshopAlert.placeholder = @"请输入商家密码";
    [self.textshopAlert setSecureTextEntry:YES];
    self.textshopAlert.keyboardType = UIKeyboardTypeNumberPad;
    
    alert.tag=22;
    [alert show];
}
//换肤
-(void)changeskin{
    
}
//切换用户
-(void)changeEmployee{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要更改用户吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag=23;
    [alert show];
}
//切换商家
-(void)changeShop{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要更改商家吗？更改商家会需要重新同步信息。" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    self.textshopAlert=[[UITextField alloc]init];
    [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    self.textshopAlert = [alert textFieldAtIndex:0];
    self.textshopAlert.placeholder = @"请输入商家密码";
    [self.textshopAlert setSecureTextEntry:YES];
    self.textshopAlert.keyboardType = UIKeyboardTypeNumberPad;
    alert.tag=24;
    [alert show];
}
//关于我们
-(void)aboutUs{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//************以下为同步信息模块************
//同步验证商家密码
-(void) VerificationShop:(NSString*)shopName{
    //定义返回错误信息
    NSError *error;
    //获取服务器路径
    NSString *Url = [NSString stringWithFormat:@"%@ws/shopLogin", WEBSERVICE_ADDRESS];
    //定义http请求管理
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    //设定传输值
    NSDictionary *params = @{@"shopLoginName": shopName, @"password": self.textshopAlert.text};
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
                           NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                           [userDefaults removeObjectForKey:@"employeeID"];
                           NSLog(@"employeeID:%@",[userDefaults objectForKey:@"employeeID"]);
                           [[NSUserDefaults standardUserDefaults] synchronize];
                           [SystemUtil deleteDishTypeTable];
                           [SystemUtil deleteDishInfoTable];
                           [SystemUtil deleteImageInfoTable];
                           [SystemUtil deleteEmployeeTable];
                           [SystemUtil deleteShopCarTable];
                           
                           [SystemUtil createDishTypeTable];
                           [SystemUtil createDishInfoTable];
                           [SystemUtil createImageInfoTable];
                           [SystemUtil createEmployeeTable];
                           [SystemUtil createShopCarTable];
                           [self Synchronization:[arr objectForKey:@"id"]];
                       }else{
                           NSLog(@"用户名密码错误");
                           UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示!" message:@"密码错误，请重新尝试！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                           [alert show];
                       }
                   } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                       NSLog(@"Error: %@", error);
                       [HUD hide:YES];
                       UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络状况不佳，或未知错误，请重新尝试！" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
                       [alert show];
                       
                   }];
}

//更改商家验证商家密码
-(void) changeShop:(NSString*)shopName{
    //定义返回错误信息
    NSError *error;
    //获取服务器路径
    NSString *Url = [NSString stringWithFormat:@"%@ws/shopLogin", WEBSERVICE_ADDRESS];
    //定义http请求管理
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    //设定传输值
    NSDictionary *params = @{@"shopLoginName": shopName, @"password": self.textshopAlert.text};
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
                           NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                           [userDefaults removeObjectForKey:@"loginName"];
                           [userDefaults removeObjectForKey:@"shopID"];
                           [userDefaults removeObjectForKey:@"employeeID"];
                           [[NSUserDefaults standardUserDefaults] synchronize];
                           NSLog(@"loginName:%@",[userDefaults objectForKey:@"loginName"]);
                           NSLog(@"shopID:%@",[userDefaults objectForKey:@"shopID"]);
                           NSLog(@"employeeID:%@",[userDefaults objectForKey:@"employeeID"]);
                           [SystemUtil deleteBusinessInfoTable];
                           [SystemUtil deleteDishTypeTable];
                           [SystemUtil deleteDishInfoTable];
                           [SystemUtil deleteImageInfoTable];
                           [SystemUtil deleteOrderDishTable];
                           [SystemUtil deleteWaterMenuTable];
                           [SystemUtil deleteEmployeeTable];
                           [SystemUtil deleteShopCarTable];


                           [SystemUtil createBusinessInfoTable];
                           [SystemUtil createDishTypeTable];
                           [SystemUtil createDishInfoTable];
                           [SystemUtil createImageInfoTable];
                           [SystemUtil createOrderDishTable];
                           [SystemUtil createWaterMenuTable];
                           [SystemUtil createEmployeeTable];
                           [SystemUtil createShopCarTable];
                           UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                           LoginViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
                           self.loginViewController=controller;
                           [self.view addSubview:self.loginViewController.view];
                       }else{
                           NSLog(@"用户名密码错误");
                           UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示!" message:@"密码错误，请重新尝试！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                           [alert show];
                       }
                   } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                       NSLog(@"Error: %@", error);
                       [HUD hide:YES];
                       UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络状况不佳，或未知错误，请重新尝试！" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
                       [alert show];
                       
                   }];
    
}



-(void)Synchronization:(NSString*)shopID{
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.dimBackground = YES;
    [HUD setDelegate:self];
    [HUD setLabelText:@"正在同步，请稍等..."];
    [HUD show:YES];
    //调用EmployeeSynch方法
    [self EmployeeSynch:shopID];
}

//同步员工
- (void)EmployeeSynch:(NSString*)shopID{
    
    //定义返回错误信息
    NSError *error;
    //获取服务器路径
    NSString *Url = [NSString stringWithFormat:@"%@ws/employee", WEBSERVICE_ADDRESS];
    //定义http请求管理
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    //设定传输值
    NSDictionary *params = @{@"shopId": shopID};
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
                           NSMutableArray  *arr = [json objectForKey:@"rst"];
                           //NSLog(@"%@",[arr objectAtIndex:0]);
                           for(NSDictionary *inner in arr){
                               Employee *employee=[Employee alloc];
                               //把服务器上取得的数据放入实体
                               employee.EmployeeID=[inner objectForKey:@"code"];                               employee.EmployeeName=[inner objectForKey:@"name"];                               employee.PassWord=[inner objectForKey:@"password"];
                               //调用插入Sqlite
                               int flag=[Employee insert:employee];
                               if (flag==1){
                                   NSLog(@"员工插入成功！");
                               }
                           }
                           [self DishSynch:shopID];
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
                       NSLog(@"Error: %@", error);
                       UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络状况不佳，或未知错误，请重新尝试！" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
                       [alert show];
                   }];
}
//同步菜品
- (void)DishSynch:(NSString*)shopID{
    //定义返回错误信息
    NSError *error;
    //获取服务器路径
    NSString *Url = [NSString stringWithFormat:@"%@ws/dish", WEBSERVICE_ADDRESS];
    //定义http请求管理
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    //设定传输值
    NSDictionary *params = @{@"shopId": shopID};
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
                           NSMutableArray  *arr = [json objectForKey:@"rst"];
                           //NSLog(@"%@",[arr objectAtIndex:0]);
                           for(NSDictionary *inner in arr){
                               DishInfo *thedishInfo=[DishInfo alloc];
                               //把服务器上取得的数据放入实体
                               thedishInfo.dishCode=[inner objectForKey:@"dishCode"];
                               thedishInfo.dishID=[inner objectForKey:@"id"];
                               thedishInfo.dishName=[inner objectForKey:@"dishName"];
                               thedishInfo.dishMemo=[inner objectForKey:@"dishDesc"];
                               thedishInfo.dishIntro=[inner objectForKey:@"dishIntro"];
                               thedishInfo.dishPrice=[inner objectForKey:@"dishSellPrice"];
                               thedishInfo.dishSellPrice=[inner objectForKey:@"dishSellPrice"];
                               thedishInfo.smallDishPrice=[inner objectForKey:@"dishSmallSellPrice"];
                               thedishInfo.bigDishPrice=[inner objectForKey:@"dishBigSellPrice"];
                               thedishInfo.dishStatus=[inner objectForKey:@"dishStatus"];
                               thedishInfo.dishTypeID=[inner objectForKey:@"dishTypeId"];
                               thedishInfo.dishUnit=[inner objectForKey:@"dishUnit"];
                               thedishInfo.isHot=[inner objectForKey:@"isHot"];
                               thedishInfo.imageID=@"";
                               thedishInfo.imageName=[inner objectForKey:@"imageUrl"];
                               thedishInfo.dishSpicy=[inner objectForKey:@"spicy"];
                               thedishInfo.stock=[inner objectForKey:@"dishCount"];
                               NSArray *imgname=[thedishInfo.imageName componentsSeparatedByString:@"/"];
                               thedishInfo.imageName=[imgname lastObject];
                               //调用插入Sqlite
                               int flag=[DishInfo insert:thedishInfo];
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
                                   [uniquePath appendString:thedishInfo.imageName];
                                   //将图片写到文件中
                                   [UIImagePNGRepresentation(imga)writeToFile: uniquePath    atomically:YES];
                                   //调用方法将图片缩小0.6，再次写入做小图显示
                                   imga=[self scaleImage:imga toScale:0.5];
                                   uniquePath=[[NSMutableString alloc] init];
                                   [uniquePath appendString:[paths objectAtIndex:0]];
                                   [uniquePath appendString:@"/Sml"];
                                   [uniquePath appendString:thedishInfo.imageName];
                                   [UIImagePNGRepresentation(imga)writeToFile: uniquePath    atomically:YES];
                               }
                           }
                           [self DishTypeSynch:shopID];
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
                       NSLog(@"Error: %@", error);
                       UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络状况不佳，或未知错误，请重新尝试！" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
                       [alert show];
                   }];
}

-(void)DishTypeSynch:(NSString*)shopID{
    //定义返回错误信息
    NSError *error;
    //获取服务器路径
    NSString *Url = [NSString stringWithFormat:@"%@ws/type", WEBSERVICE_ADDRESS];
    //定义http请求管理
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    //设定传输值
    NSDictionary *params = @{@"shopId": shopID};
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
                           [self.view addSubview:controller.view];
                           UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"同步成功，请重新登录！" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
                           [alert show];
                           [HUD hide:YES];
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
                       NSLog(@"Error: %@", error);
                       UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络状况不佳，或未知错误，请重新尝试！" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
                       [alert show];
                   }];
}

//搜索功能
-(IBAction)searchBarAction:(id)sender{
    for (id obj in self.navigationScrollView.subviews)
    {
        if ([obj isKindOfClass:[UIButton class]])
        {
            UIButton* theButton = (UIButton*)obj;
            [theButton setBackgroundImage:[UIImage imageNamed:@"menuBar" ] forState:UIControlStateNormal];
            [theButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
    }
    
    
    NSString *searchData = @"";
    if (self.searchBar.text==nil || [self.searchBar.text isEqualToString:@""]){
        searchData=@"";
    }else{
        searchData=self.searchBar.text;
    }
    //隐藏键盘
    [self.searchBar resignFirstResponder];
    self.hotDish=1;
    // 检索菜品数据
    dishList = [NSArray arrayWithArray:[DishInfo selectBySearchKey:searchData]];
    self.menuPageControl.hidden=NO;
    NSUInteger numberPages = [self getTotalPage:dishList];
    self.menuPageControl.numberOfPages=numberPages;
    NSMutableArray *controllers = [[NSMutableArray alloc] init];
    for (NSUInteger i = 0; i < numberPages; i++)
    {
        [controllers addObject:[NSNull null]];
    }
    self.viewControllers = controllers;
    
    NSArray *viewsToRemove = [self.menuScrollView subviews];
    for (UIView *v in viewsToRemove) [v removeFromSuperview];
    //是否分页
    self.menuScrollView.pagingEnabled = YES;
    //设置scroll大小
    self.menuScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.menuScrollView.frame) * numberPages, CGRectGetHeight(self.menuScrollView.frame));
    self.menuScrollView.scrollEnabled = YES;
    self.menuScrollView.showsHorizontalScrollIndicator = NO;
    self.menuScrollView.showsVerticalScrollIndicator = NO;
    self.menuScrollView.scrollsToTop = NO;
    self.menuScrollView.delegate = self;
    [self.menuScrollView setContentOffset:CGPointMake(0.0, 0.0)];
    menuScrollView.delaysContentTouches = YES;
    menuScrollView.canCancelContentTouches = YES;
    
    [self loadScrollViewWithPage:0];
    [self loadScrollViewWithPage:1];
}

//跳转到商家页面
-(IBAction)systemWeb:(id)sender{
    //    NSString *iTunesLink;
    //    iTunesLink = @"http://www.baidu.com/";
    //    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
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


-(void) setDeskTextField:(NSString *)desk{
    self.txtTableNo.text=desk;
}
//扫描
-(void)setupCamera
{
        [self scanBtnAction];
}

-(void)scanBtnAction
{
    num = 0;
    upOrdown = NO;
    //初始话ZBar
    ZBarReaderViewController * reader = [ZBarReaderViewController new];
    //设置代理
    reader.readerDelegate = self;
    //支持界面旋转
    reader.supportedOrientationsMask = ZBarOrientationMaskAll;
    reader.showsHelpOnFail = NO;
    reader.showsZBarControls = NO;
    reader.scanCrop = CGRectMake(0.1, 0.2, 0.8, 0.8);//扫描的感应框
    [reader setHidesBottomBarWhenPushed:YES];
    ZBarImageScanner * scanner = reader.scanner;
    [scanner setSymbology:ZBAR_I25
                   config:ZBAR_CFG_ENABLE
                       to:0];
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024, 768)];
    view.backgroundColor = [UIColor clearColor];
    reader.cameraOverlayView = view;
    
    UIButton * scanButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [scanButton setTitle:@"取消" forState:UIControlStateNormal];
    [scanButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    scanButton.frame = CGRectMake(450, 520, 120, 40);
    [scanButton addTarget:self action:@selector(backAction)forControlEvents:UIControlEventTouchUpInside];
    [reader.view addSubview:scanButton];

    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(380, 150, 280, 40)];
    label.text = @"请将扫描的二维码至于下面的框内\n谢谢！";
    label.textColor = [UIColor whiteColor];
    label.textAlignment = 1;
    label.lineBreakMode = 0;
    label.numberOfLines = 2;
    label.backgroundColor = [UIColor clearColor];
    [view addSubview:label];
    
    UIImageView * image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pick_bg.png"]];
    image.frame = CGRectMake(380, 230, 280, 280);
    [view addSubview:image];
    
    
    _line = [[UIImageView alloc] initWithFrame:CGRectMake(30, 10, 220, 2)];
    _line.image = [UIImage imageNamed:@"line.png"];
    [image addSubview:_line];
    //定时器，设定时间过1.5秒，
    timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(animation1) userInfo:nil repeats:YES];
    
    [self presentViewController:reader animated:YES completion:^{
        
    }];
}



-(void)backAction
{
    [self dismissViewControllerAnimated:YES completion:^{
        [timer invalidate];
    }];
}
-(void)animation1
{
    if (upOrdown == NO) {
        num ++;
        _line.frame = CGRectMake(30, 10+2*num, 220, 2);
        if (2*num == 260) {
            upOrdown = YES;
        }
    }
    else {
        num --;
        _line.frame = CGRectMake(30, 10+2*num, 220, 2);
        if (num == 0) {
            upOrdown = NO;
        }
    }
    
    
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [timer invalidate];
    _line.frame = CGRectMake(380, 10, 220, 2);
    num = 0;
    upOrdown = NO;
    [picker dismissViewControllerAnimated:YES completion:^{
        [picker removeFromParentViewController];
    }];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [timer invalidate];
    _line.frame = CGRectMake(380, 10, 220, 2);
    num = 0;
    upOrdown = NO;
    [picker dismissViewControllerAnimated:YES completion:^{
        [picker removeFromParentViewController];
        UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];
        //初始化
        ZBarReaderController * read = [ZBarReaderController new];
        //设置代理
        read.readerDelegate = self;
        CGImageRef cgImageRef = image.CGImage;
        ZBarSymbol * symbol = nil;
        id <NSFastEnumeration> results = [read scanImage:cgImageRef];
        for (symbol in results)
        {
            break;
        }
        NSString * result;
        if ([symbol.data canBeConvertedToEncoding:NSShiftJISStringEncoding])
            
        {
            result = [NSString stringWithCString:[symbol.data cStringUsingEncoding: NSShiftJISStringEncoding] encoding:NSUTF8StringEncoding];
        }
        else
        {
            result = symbol.data;
        }
        
        self.txtTableNo.text=result;
    }];
    
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];    //主要是[receiver resignFirstResponder]在哪调用就能把receiver对应的键盘往下收
    return YES;
}

@end
