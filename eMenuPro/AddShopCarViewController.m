//
//  AddShopCarViewController.m
//  eMenuPro
//
//  Created by Li Feng on 14-3-14.
//  Copyright (c) 2014年 Gong Lingxiao. All rights reserved.
//

#import "AddShopCarViewController.h"

@interface AddShopCarViewController ()

@end

@implementation AddShopCarViewController
@synthesize shopCarItems;
@synthesize shopCarItemKey;
@synthesize shopCarDict;
@synthesize delegate;
@synthesize orderId;
@synthesize OldshopCar;


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
	// Do any additional setup after loading the view.
    [self.view setFrame:CGRectMake(0, 0, 1024, 595)];
    self.view.backgroundColor=[UIColor clearColor];
    self.backImage.backgroundColor=[UIColor colorWithRed:60/255.0 green:61/255.0 blue:60/255.0 alpha:0.25];
    if (![orderId isEqualToString:@""]){
        OrderDishes *ord=[[OrderDishes alloc]init];
        NSArray *OldOrder=[OrderDishes select:orderId];
        ord=[OldOrder objectAtIndex:0];
        self.myTitle.text=[ord.desk stringByAppendingString: @"号桌 已选菜单"];
    }else{
        self.myTitle.text=@"已 选 菜 单";
    }
    
    self.tableView.backgroundColor=[UIColor clearColor];
    self.tableView.scrollEnabled=YES;
    [self getPage];
}

- (void) getPage{

    NSArray *orders=[OrderDishes select:orderId];
    OldshopCar=[[NSMutableArray alloc] init];
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
        [OldshopCar addObject:shop];
    }

    self.totalUnit = 0;
    self.totalPrice = 0;
    self.shopCarItems = [[NSMutableArray alloc] init];
    self.shopCarItemKey = [[NSMutableArray alloc] init];
    self.shopCarDict = [[NSMutableDictionary alloc] init];
    
    for (ShopCar *shopCarList in OldshopCar){
        BOOL flag=NO;
        for (NSString *key in shopCarDict){
            if ([shopCarList.typeName isEqualToString:key]){
                flag=YES;
                break;
            }
        }
        if (flag) {
            NSMutableArray *array = [self.shopCarDict objectForKey:shopCarList.typeName];
            [array addObject:shopCarList];
            self.totalUnit=[shopCarList.sellCount intValue]+self.totalUnit;
            self.totalPrice=self.totalPrice+[shopCarList.sellCount intValue]*[shopCarList.dishPrice floatValue];
        } else {
            NSMutableArray *array = [[NSMutableArray alloc] init];
            [array addObject:shopCarList];
            [self.shopCarDict setObject:array forKey:shopCarList.typeName];
            self.totalUnit=[shopCarList.sellCount intValue]+self.totalUnit;
            self.totalPrice=self.totalPrice+[shopCarList.sellCount intValue]*[shopCarList.dishPrice floatValue];
        }
    }
    for (NSString *key in self.shopCarDict) {
        [self.shopCarItemKey addObject:key];
    }
    self.totalCountlab.text=[@"总数: " stringByAppendingString: [NSString stringWithFormat:@"%d",self.totalUnit]];
    self.Pricelab.text=[NSString stringWithFormat:@"%.2f",self.totalPrice];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addDishButton:(id)sender{
    [self.delegate addHistroyDish:orderId];
    
}
- (IBAction)backToHistory:(id)sender{
    [self.delegate showHistroy];
}

#pragma mark - Table view data source

//模块数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [shopCarItemKey count];
}
//每个模块的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[shopCarDict objectForKey:[shopCarItemKey objectAtIndex:section]] count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 35)];
    headerView.backgroundColor=[UIColor colorWithRed:60/255.0 green:61/255.0 blue:60/255.0 alpha:0.25];
    
    UILabel *dishType=[[UILabel alloc] initWithFrame:CGRectMake(50, 3, 100, 30)];//菜品种类
    dishType.font=[UIFont  systemFontOfSize:20];
    dishType.text = [NSString stringWithFormat:@"%@",[shopCarItemKey objectAtIndex:section]];
    dishType.backgroundColor=[UIColor clearColor];
    UILabel *price=[[UILabel alloc] initWithFrame:CGRectMake(420, 3, 50, 30)];//单价
    price.font=[UIFont  systemFontOfSize:20];
    price.text = @"单价";
    price.backgroundColor=[UIColor clearColor];
    UILabel *count=[[UILabel alloc] initWithFrame:CGRectMake(512, 3, 50, 30)];//数量
    count.font=[UIFont  systemFontOfSize:20];
    count.text = @"数量";
    count.backgroundColor=[UIColor clearColor];
    UILabel *quantity=[[UILabel alloc] initWithFrame:CGRectMake(620, 3, 50, 30)];//份量
    quantity.font=[UIFont  systemFontOfSize:20];
    quantity.text = @"份量";
    quantity.backgroundColor=[UIColor clearColor];
    UILabel *subtotal=[[UILabel alloc] initWithFrame:CGRectMake(695, 3, 50, 30)];//小计
    subtotal.font=[UIFont  systemFontOfSize:20];
    subtotal.text = @"小计";
    subtotal.backgroundColor=[UIColor clearColor];
    UILabel *menu=[[UILabel alloc] initWithFrame:CGRectMake(840, 3, 50, 30)];//备注
    menu.font=[UIFont  systemFontOfSize:20];
    menu.text = @"备注";
    menu.backgroundColor=[UIColor clearColor];
    [headerView addSubview:dishType];
    [headerView addSubview:price];
    [headerView addSubview:count];
    [headerView addSubview:quantity];
    [headerView addSubview:subtotal];
    [headerView addSubview:menu];
    return headerView;
}
//创建Cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ShopCarCell";
    ShopCarCell *cell = (ShopCarCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    //从shopCarDict中取得对应的shopCar实体
    NSArray *shopCarForSection=[self.shopCarDict objectForKey:[self.shopCarItemKey objectAtIndex:indexPath.section]];
    ShopCar *shopCar=[shopCarForSection objectAtIndex:indexPath.row];
      
    //绘制cell
    cell.backgroundColor=[UIColor clearColor];
    DishInfo *dish=[DishInfo selectByDishID:shopCar.dishID];
    NSString *idText=dish.dishCode;
    idText=[idText stringByAppendingString: @"   "];
    if ([shopCar.dishID isEqualToString:@""]){
        idText=@"";
    }
    cell.dishID.text=[idText stringByAppendingString:shopCar.dishName];
    cell.dishUnit.text=@"￥";
    cell.dishPrice.text=[NSString stringWithFormat:@"%.2f",[shopCar.dishPrice floatValue]];
    //    UIButton *minB = [[UIButton alloc] init];
    //    [minB setBackgroundImage:[UIImage imageNamed:@"shopCarMinus"] forState:UIControlStateNormal];
    //    cell.minusButton = minB;
    [cell.minusButton setBackgroundImage:[UIImage imageNamed:@"shopCarMinus"] forState:UIControlStateNormal];
    [cell.plusButton setBackgroundImage:[UIImage imageNamed:@"shopCarPlus"] forState:UIControlStateNormal];
    cell.dishCountLab.backgroundColor=[UIColor clearColor];
    cell.dishCountLab.text=shopCar.sellCount;
    cell.dishCountLab.textAlignment=NSTextAlignmentCenter;
    cell.dishSumUint.text=@"￥";
    cell.dishSumPrice.text=[NSString stringWithFormat:@"%.2f",[shopCar.dishPrice floatValue]*[shopCar.sellCount intValue]];
    if ([shopCar.memo isEqualToString:@""]){
        cell.dishMenuLab.text=@"—";
    }else{
        cell.dishMenuLab.text=shopCar.memo;
    }
    
    if (dish.dishID!=nil){
        if ([shopCar.dishPrice isEqualToString: dish.dishPrice]){
            cell.dropDownList.text=@"中";
        }else if([shopCar.dishPrice isEqualToString: dish.smallDishPrice]){
            cell.dropDownList.text=@"小";
        }else{
            cell.dropDownList.text=@"大";
        }
    }else{
        cell.dropDownList.text=@"—";
    }

    cell.dishMenuLab.textAlignment=NSTextAlignmentCenter;
    cell.dishMenuLab.backgroundColor=[UIColor clearColor];
    //cell.CancelButton=[[UIButton alloc]init];
    [cell.CancelButton setBackgroundImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    return cell;
}




#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}



@end
