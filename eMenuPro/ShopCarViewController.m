//
//  ShopCarViewController.m
//  eMenuPro
//
//  Created by Li Feng on 14-3-11.
//  Copyright (c) 2014年 Gong Lingxiao. All rights reserved.
//

#import "ShopCarViewController.h"
#import "MenuMainViewController.h"

@interface ShopCarViewController ()

@end

@implementation ShopCarViewController
@synthesize shopCarItems;
@synthesize shopCarItemKey;
@synthesize shopCarDict;
@synthesize finishOrderButton;
@synthesize delegate;
@synthesize orderID;


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
    if (![orderID isEqualToString:@""]){
        OrderDishes *ord=[[OrderDishes alloc]init];
        self.OldOrder=[[NSArray alloc]init];
        self.OldOrder=[OrderDishes select:orderID];
        ord=[self.OldOrder objectAtIndex:0];
        self.myTitle.text=[ord.desk stringByAppendingString: @"号桌 已选菜单"];
    }else{
        self.myTitle.text=@"已 选 菜 单";
    }
    self.tableView.backgroundColor=[UIColor clearColor];
    self.tableView.scrollEnabled=YES;
    [self.addDishButton setBackgroundColor:[UIColor whiteColor]];
    [self getPage];
}

- (void) getPage{
    self.totalUnit = 0;
    self.totalPrice = 0;
    self.shopCarItems = [[NSMutableArray alloc] init];
    self.shopCarItemKey = [[NSMutableArray alloc] init];
    self.shopCarDict = [[NSMutableDictionary alloc] init];
    NSArray *shopCar=[ShopCar selectAll];
    for (ShopCar *shopCarList in shopCar){
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
    self.totalCountlab.text=[NSString stringWithFormat:@"%d",self.totalUnit];
    self.Pricelab.text=[NSString stringWithFormat:@"%.2f",self.totalPrice];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)cancelButton:(id)sender{
    //获取当前按钮的cell，组，行
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    NSInteger SectionCount = [indexPath section];
    //取得对应的shopCar中得商品
    NSString *key=[shopCarItemKey objectAtIndex:SectionCount];
    NSArray *shopCarForSection=[self.shopCarDict objectForKey:key];
    self.deleteShopCar=[shopCarForSection objectAtIndex:indexPath.row];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要删除该道菜吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
    
    }else{
        [ShopCar delete:self.deleteShopCar.systemID];
        NSArray *count =[ShopCar selectAll];
        [self.delegate setBadge];
        if (count.count == 0){
            [SystemUtil deleteShopCarTable];
            [SystemUtil createShopCarTable];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"购物车里还没有菜，请先点取你需要的菜!" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
            [alert show];
            [self.delegate cleanDishShowMenu];
            return;
        }
        [self getPage];
        [self.tableView reloadData];
    }
}

- (IBAction)plusDish:(id)sender {
    //获取当前按钮的cell，组，行
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    ShopCarCell *cell = (ShopCarCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    NSInteger SectionCount = [indexPath section];
    //取得对应的shopCar中得商品
    NSString *key=[shopCarItemKey objectAtIndex:SectionCount];
    NSArray *shopCarForSection=[self.shopCarDict objectForKey:key];
    ShopCar *shopCar=[shopCarForSection objectAtIndex:indexPath.row];
    shopCar.sellCount=[NSString stringWithFormat:@"%d",[shopCar.sellCount intValue]+1];
    cell.dishCount.text=shopCar.sellCount;
    cell.dishSumPrice.text=[NSString stringWithFormat:@"%.2f", [cell.dishSumPrice.text floatValue] + [shopCar.dishPrice floatValue]];
    self.totalCountlab.text=[NSString stringWithFormat:@"%d",[self.totalCountlab.text intValue]+1];
    self.Pricelab.text=[NSString stringWithFormat:@"%.2f", [self.Pricelab.text floatValue] + [shopCar.dishPrice floatValue]];
    [ShopCar delete:shopCar.systemID];
    [ShopCar insert:shopCar];
    [self getPage];
    [self.tableView reloadData];
}

- (IBAction)minusDish:(id)sender {
    //获取当前按钮的cell，组，行
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    ShopCarCell *cell = (ShopCarCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    NSInteger SectionCount = [indexPath section];
    //取得对应的shopCar中得商品
    NSString *key=[shopCarItemKey objectAtIndex:SectionCount];
    NSArray *shopCarForSection=[self.shopCarDict objectForKey:key];
    ShopCar *shopCar=[shopCarForSection objectAtIndex:indexPath.row];
    if (![shopCar.sellCount isEqualToString:@"1"]){
        shopCar.sellCount=[NSString stringWithFormat:@"%d",[shopCar.sellCount intValue]-1];
        cell.dishCount.text=shopCar.sellCount;
        cell.dishSumPrice.text=[NSString stringWithFormat:@"%.2f", [cell.dishSumPrice.text floatValue] - [shopCar.dishPrice floatValue]];
        self.totalCountlab.text=[NSString stringWithFormat:@"%d",[self.totalCountlab.text intValue]-1];
        self.Pricelab.text=[NSString stringWithFormat:@"%.2f", [self.Pricelab.text floatValue] - [shopCar.dishPrice floatValue]];
        [ShopCar delete:shopCar.systemID];
        [ShopCar insert:shopCar];
        [self getPage];
        [self.tableView reloadData];
    }
}

- (IBAction)addMenu:(id)sender{
    //获取当前按钮的cell，组，行
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    NSInteger SectionCount = [indexPath section];
    //取得对应的shopCar中得商品
    NSString *key=[shopCarItemKey objectAtIndex:SectionCount];
    NSArray *shopCarForSection=[self.shopCarDict objectForKey:key];
    ShopCar *shopCar=[shopCarForSection objectAtIndex:indexPath.row];
    
    UITextField *text=sender;
    shopCar.memo=text.text;
    [ShopCar delete:shopCar.systemID];
    [ShopCar insert:shopCar];
    [self getPage];
    [self.tableView reloadData];
}

- (IBAction)countText:(id)sender{
    //获取当前按钮的cell，组，行
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    ShopCarCell *cell = (ShopCarCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    NSInteger SectionCount = [indexPath section];
    //取得对应的shopCar中得商品
    NSString *key=[shopCarItemKey objectAtIndex:SectionCount];
    NSArray *shopCarForSection=[self.shopCarDict objectForKey:key];
    ShopCar *shopCar=[shopCarForSection objectAtIndex:indexPath.row];
    
    UITextField *text=sender;
    text.text=[NSString stringWithFormat:@"%d", [text.text intValue]];
    cell.dishSumPrice.text=[NSString stringWithFormat:@"%.2f",[text.text intValue]*[shopCar.dishPrice floatValue]];
    shopCar.sellCount=[NSString stringWithFormat:@"%d", [text.text intValue]];
    sender=text.text;
    [ShopCar delete:shopCar.systemID];
    [ShopCar insert:shopCar];
    [self getPage];
    [self.tableView reloadData];
}


- (IBAction)addDishButton:(id)sender{
    [self.delegate showMenu];
    
}
- (IBAction)finishOrderButton:(id)sender{
    NSArray *shopCar=[ShopCar selectAll];
    NSMutableArray *changeOrder=[[NSMutableArray alloc]init];
    for (ShopCar *new in shopCar){
        ShopCar *last=new;
        BOOL flag=YES;
        last.dishStatus=[NSString stringWithFormat:@"1"];
        for (ShopCar *old in self.OldOrder){
            if ([new.dishID isEqualToString:@""] || new.dishID==nil){
                if ([new.dishName isEqualToString:old.dishName] && [new.dishPrice isEqualToString:old.dishPrice] && [new.memo isEqualToString:old.memo]){
                        int addCount=[new.sellCount intValue]-[old.sellCount intValue];
                        if (addCount>0){
                            last.sellCount=[NSString stringWithFormat:@"%d", addCount];
                        }else if (addCount<0){
                            last.sellCount=[NSString stringWithFormat:@"%d", 0-addCount];
                            last.dishStatus=[NSString stringWithFormat:@"2"];
                        }else{
                            flag=NO;
                            break;
                        }
                }
            }else{
                if ([new.dishID isEqualToString:old.dishID]){
                    if([new.dishPrice isEqualToString:old.dishPrice]){
                        int addCount=[new.sellCount intValue]-[old.sellCount intValue];
                        if (addCount>0){
                            last.sellCount=[NSString stringWithFormat:@"%d", addCount];
                        }else if (addCount<0){
                            last.sellCount=[NSString stringWithFormat:@"%d", 0-addCount];
                            last.dishStatus=[NSString stringWithFormat:@"2"];
                        }else{
                            flag=NO;
                            break;
                        }
                    }
                }
            }
            
        }
        if (flag){
            [changeOrder addObject:last];
        }
    }
    for (ShopCar *old in self.OldOrder){
        ShopCar *last=old;
        BOOL flag=NO;
        last.dishStatus=[NSString stringWithFormat:@"2"];
        for (ShopCar *new in shopCar){
            if ([old.dishID isEqualToString:@""] || old.dishID==nil){
                if ([new.dishName isEqualToString:old.dishName] && [new.dishPrice isEqualToString:old.dishPrice] && [new.memo isEqualToString:old.memo]){
                    flag=YES;
                    break;
                }
            }else{
                if ([new.dishID isEqualToString:old.dishID]){
                    flag=YES;
                    break;
                }
            }

            
        }
        if (flag==NO){
            [changeOrder addObject:last];
        }
    }
    [self.delegate finishOrder:changeOrder withOrderId:orderID];
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
    //初始化各个空间的颜色，样式；
    UIColor *textColor=[UIColor blackColor];
    NSString *shopCarMinus=@"shopCarMinus";
    NSString *shopCarPlus=@"shopCarPlus";
    NSString *cancel=@"cancel";
    UIColor *dishCountBG=[UIColor colorWithRed:60/255.0 green:61/255.0 blue:60/255.0 alpha:0.55];
    UIColor *dishMenuBG=[UIColor colorWithRed:60/255.0 green:61/255.0 blue:60/255.0 alpha:0.4];
    
    
    if (![self.orderID isEqualToString:@""]){
        textColor=[UIColor colorWithRed:233/255.0 green:90/255.0 blue:20/255.0 alpha:1];
        shopCarMinus=[shopCarMinus stringByAppendingString:@"G"];
        shopCarPlus=[shopCarPlus stringByAppendingString:@"G"];
        cancel=[cancel stringByAppendingString:@"G"];
        dishCountBG=[UIColor colorWithRed:233/255.0 green:90/255.0 blue:20/255.0 alpha:0.55];
        dishMenuBG=[UIColor colorWithRed:233/255.0 green:90/255.0 blue:20/255.0 alpha:0.4];
    for (ShopCar *f in self.OldOrder){
        if ([f.dishID isEqualToString:shopCar.dishID] &&
            [f.sellCount isEqualToString: shopCar.sellCount] &&
            [f.dishPrice isEqualToString: shopCar.dishPrice]){
            textColor=[UIColor blackColor];
            shopCarMinus=@"shopCarMinus";
            shopCarPlus=@"shopCarPlus";
            cancel=@"cancel";
            dishCountBG=[UIColor colorWithRed:60/255.0 green:61/255.0 blue:60/255.0 alpha:0.55];
            dishMenuBG=[UIColor colorWithRed:60/255.0 green:61/255.0 blue:60/255.0 alpha:0.4];
            
            break;
        }
    }
    }else{
        textColor=[UIColor blackColor];
    }
    //绘制cell
    cell.backgroundColor=[UIColor clearColor];
    DishInfo *dish=[DishInfo selectByDishID:shopCar.dishID];
    NSString *idText=dish.dishCode;
    idText=[idText stringByAppendingString: @"   "];
    if ([shopCar.dishID isEqualToString:@""]){
        idText=@"";
    }
    cell.dishID.text=[idText stringByAppendingString:shopCar.dishName];
    cell.dishID.textColor=textColor;
    cell.dishUnit.text=@"￥";
    cell.dishUnit.textColor=textColor;
    cell.dishPrice.text=shopCar.dishPrice;
    cell.dishPrice.textColor=textColor;
    [cell.minusButton setBackgroundImage:[UIImage imageNamed:shopCarMinus] forState:UIControlStateNormal];
    [cell.plusButton setBackgroundImage:[UIImage imageNamed:shopCarPlus] forState:UIControlStateNormal];
    cell.dishCount.backgroundColor=dishCountBG;
    cell.dishCount.text=shopCar.sellCount;
    cell.dishCount.textAlignment=NSTextAlignmentCenter;
    cell.dishCount.textColor=textColor;
    cell.dishSumUint.text=@"￥";
    cell.dishSumUint.textColor=textColor;
    cell.dishSumPrice.text=[NSString stringWithFormat:@"%.2f",[shopCar.dishPrice floatValue]*[shopCar.sellCount floatValue]];
    cell.dishSumPrice.textColor=textColor;
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
    cell.dishMenu.text=shopCar.memo;
    cell.dishMenu.textColor=textColor;
    cell.dishMenu.textAlignment=NSTextAlignmentCenter;
    cell.dishMenu.backgroundColor=dishMenuBG;
    [cell.CancelButton setBackgroundImage:[UIImage imageNamed:cancel] forState:UIControlStateNormal];
    //取消了分割线
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    return cell;
}




#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"sg4564dsgds");
}



@end
