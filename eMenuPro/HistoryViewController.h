//
//  HistoryViewController.h
//  eMenuPro
//
//  Created by Li Feng on 14-3-12.
//  Copyright (c) 2014年 Gong Lingxiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderDishes.h"
#import "HistoryCell.h"

@protocol HistoryViewDelegate <NSObject>
- (void) showMenu;
- (void) showAddDishList:(NSString*) orderID;
@end


@interface HistoryViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>


@property (nonatomic,retain) NSMutableDictionary *orderDict;
@property (nonatomic,retain) NSMutableArray *orderDictKey;



@property (nonatomic, retain) id<HistoryViewDelegate> delegate;
@property (nonatomic,retain) IBOutlet UITableView *tableView;
@property (nonatomic,retain) IBOutlet UIImageView *topImage;
@property (nonatomic,retain) IBOutlet UIImageView *backImage;
@property (nonatomic,retain) IBOutlet UILabel *totalOrders;

//返回
@property (nonatomic,retain) IBOutlet UIButton *goBack;
-(IBAction)goBack:(id)sender;

//订单数
@property (nonatomic) int orderCount;
//所有订单
@property (nonatomic,retain) NSArray *orders;

@end


