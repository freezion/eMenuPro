//
//  AddShopCarViewController.h
//  eMenuPro
//
//  Created by Li Feng on 14-3-14.
//  Copyright (c) 2014年 Gong Lingxiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopCar.h"
#import "ShopCarCell.h"
#import "ShopCar.h"
#import "DishInfo.h"
#import "OrderDishes.h"

@protocol AddShopCarViewDelegate <NSObject>
- (void) addHistroyDish:(NSString*)orderID;
- (void) showHistroy;
@end

@interface AddShopCarViewController : UIViewController

@property (nonatomic, retain) NSString *orderId;



@property (nonatomic, retain) id<AddShopCarViewDelegate> delegate;
@property (nonatomic,retain) IBOutlet UITableView *tableView;
@property (nonatomic,retain) IBOutlet UILabel *myTitle;
@property (nonatomic,retain) IBOutlet UIImageView *backImage;
@property (nonatomic,retain) IBOutlet UILabel *totalCountlab;
@property (nonatomic,retain) IBOutlet UILabel *totalPricelab;
@property (nonatomic,retain) IBOutlet UILabel *Unitlab;
@property (nonatomic,retain) IBOutlet UILabel *Pricelab;

@property (nonatomic,retain) NSMutableArray *OldshopCar;
@property (nonatomic,retain) NSMutableArray *shopCarItems;
@property (nonatomic, retain) NSMutableArray *shopCarItemKey;
@property (nonatomic, retain) NSMutableDictionary *shopCarDict;
@property (nonatomic) float totalPrice;
@property (nonatomic) int totalUnit;


@property (nonatomic,retain) IBOutlet UIButton *addDishButton;
@property (nonatomic,retain) IBOutlet UIButton *backToHistory;
- (IBAction)addDishButton:(id)sender;
- (IBAction)backToHistory:(id)sender;


@end
