//
//  OrderDishes.h
//  eMenuPro
//
//  Created by Li Feng on 14-2-20.
//  Copyright (c) 2014年 Gong Lingxiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SystemUtil.h"
@interface OrderDishes : NSObject{
    NSString *orderID;
    NSString *orderStatus;
    NSString *orderTime;
    NSString *desk;
    NSString *employee;
    
    NSString *dishID;
    NSString *dishName;
    NSString *dishPrice;
    NSString *dishStatus;
    NSString *typeName;
    NSString *sellCount;
    NSString *dishUnit;
    NSString *memo;
}

@property (nonatomic,retain) NSString *orderID;
@property (nonatomic,retain) NSString *orderStatus;
@property (nonatomic,retain) NSString *orderTime;
@property (nonatomic,retain) NSString *desk;
@property (nonatomic,retain) NSString *employee;

@property (nonatomic,retain) NSString *dishID;
@property (nonatomic,retain) NSString *dishName;
@property (nonatomic,retain) NSString *dishPrice;
@property (nonatomic,retain) NSString *dishStatus;
@property (nonatomic,retain) NSString *typeName;
@property (nonatomic,retain) NSString *sellCount;
@property (nonatomic,retain) NSString *dishUnit;
@property (nonatomic,retain) NSString *memo;

+ (int) insert:(OrderDishes *)orderDishes;


+ (NSMutableArray *) select:(NSString *) orderID;
+ (NSMutableArray *) selectAll;
+ (int) delete;
+ (int) delete:(NSString *) orderID;
@end
