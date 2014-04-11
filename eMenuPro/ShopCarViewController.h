//
//  ShopCarViewController.h
//  eMenuPro
//
//  Created by Li Feng on 14-3-11.
//  Copyright (c) 2014年 Gong Lingxiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopCar.h"
#import "ShopCarCell.h"
#import "ShopCar.h"

@protocol ShopCarViewDelegate <NSObject>
- (void) setBadge;
- (void) finishOrder:(NSArray*)changeOrder withOrderId:(NSString*)orderID;
- (void) showMenu;
- (void) cleanDishShowMenu;
@end

@interface ShopCarViewController : UIViewController<UITableViewDataSource, UITableViewDelegate,UIAlertViewDelegate>{
    NSMutableArray *shopCarItems;
    NSMutableArray *shopCarItemKey;
    NSMutableDictionary *shopCarDict;


}
@property (nonatomic) NSString *orderID;


@property (nonatomic, retain) id<ShopCarViewDelegate> delegate;
@property (nonatomic,retain) IBOutlet UITableView *tableView;

@property (nonatomic,retain) IBOutlet UIImageView *backImage;
@property (nonatomic,retain) IBOutlet UILabel *myTitle;
@property (nonatomic,retain) IBOutlet UILabel *totalCountlab;
@property (nonatomic,retain) IBOutlet UILabel *totalPricelab;
@property (nonatomic,retain) IBOutlet UILabel *Unitlab;
@property (nonatomic,retain) IBOutlet UILabel *Pricelab;
@property (nonatomic,retain) IBOutlet UIButton *addDishButton;
@property (nonatomic,retain) IBOutlet UIButton *finishOrderButton;


@property (nonatomic,retain) NSMutableArray *shopCarItems;
@property (nonatomic, retain) NSMutableArray *shopCarItemKey;
@property (nonatomic, retain) NSMutableDictionary *shopCarDict;
@property (nonatomic) float totalPrice;
@property (nonatomic) int totalUnit;
@property (nonatomic,retain) NSArray *OldOrder;
@property (nonatomic,retain) ShopCar *deleteShopCar;

- (IBAction)cancelButton:(id)sender;
- (IBAction)plusDish:(id)sender;
- (IBAction)minusDish:(id)sender;

- (IBAction)addMenu:(id)sender;
- (IBAction)countText:(id)sender;

- (IBAction)addDishButton:(id)sender;
- (IBAction)finishOrderButton:(id)sender;


@end
