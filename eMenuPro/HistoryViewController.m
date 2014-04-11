//
//  HistoryViewController.m
//  eMenuPro
//
//  Created by Li Feng on 14-3-12.
//  Copyright (c) 2014年 Gong Lingxiao. All rights reserved.
//

#import "HistoryViewController.h"

@interface HistoryViewController ()

@end

@implementation HistoryViewController
@synthesize delegate;
@synthesize orderDict;


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
	[self.view setFrame:CGRectMake(0, 0, 1024, 595)];
    self.view.backgroundColor=[UIColor clearColor];
    self.backImage.backgroundColor=[UIColor colorWithRed:60/255.0 green:61/255.0 blue:60/255.0 alpha:0.25];
    self.topImage.backgroundColor=[UIColor colorWithRed:60/255.0 green:61/255.0 blue:60/255.0 alpha:0.25];
    
    self.tableView.backgroundColor=[UIColor clearColor];
    self.tableView.scrollEnabled=YES;
    [self getPage];
    // Do any additional setup after loading the view.
}

- (void) getPage{
    self.orderCount = 0;
    orderDict=[[NSMutableDictionary alloc]init];
    self.orderDictKey =[[NSMutableArray alloc]init];
    self.orders=[OrderDishes selectAll];
    for (OrderDishes *dis in self.orders){
        BOOL flag=NO;
        for (NSString *key in orderDict){
            if ([dis.orderID isEqualToString:key]){
                flag=YES;
                break;
            }
        }
        if (flag) {
            NSMutableArray *array = [orderDict objectForKey:dis.orderID];
            [array addObject:dis];
        } else {
            NSMutableArray *array = [[NSMutableArray alloc] init];
            [array addObject:dis];
            [orderDict setObject:array forKey:dis.orderID];
            self.orderCount=self.orderCount+1;
        }
        
    }
    for (NSString *key in orderDict) {
        [self.orderDictKey addObject:key];
    }
    
    self.totalOrders.text=[NSString stringWithFormat:@"%d", self.orderCount];
}


-(IBAction)goBack:(id)sender{
    [self.delegate showMenu];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

//模块数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
//每个模块的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [orderDict count];
}

//创建Cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"HistoryCell";
    HistoryCell *cell = (HistoryCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    NSArray *OrderForSection=[orderDict objectForKey:[self.orderDictKey objectAtIndex:indexPath.row]];
    int dishCount=0;
    float dishPrice=0.0;
    for (OrderDishes *orderDishItem in OrderForSection){
        dishCount=[orderDishItem.sellCount intValue]+dishCount;
        dishPrice=dishPrice+[orderDishItem.sellCount intValue]*[orderDishItem.dishPrice intValue];
    }
    OrderDishes *orderList=[[OrderDishes alloc]init];
    orderList=[OrderForSection objectAtIndex:0];
    cell.backG.backgroundColor=[UIColor colorWithRed:60/255.0 green:61/255.0 blue:60/255.0 alpha:0.25];
    cell.backgroundColor=[UIColor clearColor];
    cell.deskNum.text=orderList.desk;
    cell.dishCount.text=[NSString stringWithFormat:@"%d", dishCount];
    cell.totalPrice.text=[NSString stringWithFormat:@"%.2f", dishPrice];
    cell.orderTime.text=orderList.orderTime;
    cell.employee.text=orderList.employee;
    //cell.dishCount
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    return cell;
}

//点击cell跳转查看订单详情
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *OrderForSection=[orderDict objectForKey:[self.orderDictKey objectAtIndex:indexPath.row]];
    OrderDishes *orderList=[[OrderDishes alloc]init];
    NSLog(@"%d",indexPath.row);
    orderList=[OrderForSection objectAtIndex:0];
    [self.delegate showAddDishList:orderList.orderID];
}



@end
