//
//  ShopCar.h
//  eMenuPro
//
//  Created by Li Feng on 14-3-10.
//  Copyright (c) 2014年 Gong Lingxiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SystemUtil.h"

@interface ShopCar : NSObject{
    NSString *systemID;
    NSString *dishID;
    NSString *dishName;
    NSString *typeName;
    NSString *sellCount;
    NSString *dishPrice;
    NSString *dishUnit;
    NSString *memo;
    NSString *dishStatus;
}
@property (nonatomic,retain) NSString *systemID;
@property (nonatomic,retain) NSString *dishID;
@property (nonatomic,retain) NSString *dishName;
@property (nonatomic,retain) NSString *dishPrice;
@property (nonatomic,retain) NSString *typeName;
@property (nonatomic,retain) NSString *sellCount;
@property (nonatomic,retain) NSString *dishUnit;
@property (nonatomic,retain) NSString *memo;
@property (nonatomic,retain) NSString *dishStatus;

+ (int) insert:(ShopCar *)shopCar;
+ (int) insertOrderDishItem:(ShopCar *)shopCar WithOrderID:(NSString*) orderId;
+ (int) selectAllCount;
+ (NSMutableArray *) selectAll;
+ (ShopCar *) select:(NSString *) dishid;
+ (ShopCar *)selectWithPrice: (NSString *)dishid withPrice:(NSString*) dishPrice;
+ (int) deleteAll;
+ (int) delete:(NSString *)dishid;
@end
