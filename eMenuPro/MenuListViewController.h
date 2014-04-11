//
//  MenuListViewController.h
//  eMenuPro
//
//  Created by Li Feng on 14-3-6.
//  Copyright (c) 2014年 Gong Lingxiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DishInfo.h"
#import "OrderDishes.h"
#import "ShopCar.h"
#import "SetUpViewController.h"

@protocol MenuListViewDelegate <NSObject>
- (void) setBadge;
- (void) showMessage:(int) num withDishTypeId:(NSString *) dishTypeId;
- (void) showLargeImage:(UIImage *) image withDishID:(NSString*)dishID;
@end

@interface MenuListViewController : UIViewController

@property (nonatomic, retain) id<MenuListViewDelegate> delegate;
@property (nonatomic) NSUInteger page;
@property (nonatomic, retain) NSArray *pageList;
@property (nonatomic) int hotDish;
//推荐视图下得按钮
@property (nonatomic, retain) UIView *back;
@property (nonatomic, retain) UIImageView *updownImage;
@property (nonatomic, retain) UITextField *hotdishNum;
@property (nonatomic, retain) UITextView *memo;
@property (nonatomic) int partdishCount;
//大小份标记
@property (nonatomic) int partflag;

@end

