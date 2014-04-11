//
//  SystemUtil.h
//  eMenuPro
//
//  Created by Gong Lingxiao on 14-2-11.
//  Copyright (c) 2014年 Gong Lingxiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>


@interface SystemUtil : NSObject

+ (NSString *)getDBPath;
//区域表
//+ (void) createAreaTable;
//城市信息表
//+ (void) createCityTable;
//菜系表
//+ (void) createCuisineTable;
//商家菜系关系表
//+ (void) createBCRelationshipTable;
//用户表
//+ (void) createUserTable;


//商家信息表
+ (void) createBusinessInfoTable;
//创建菜品分类表
+ (void) createDishTypeTable;
//创建菜品信息表
+ (void) createDishInfoTable;
//图片信息表
+ (void) createImageInfoTable;
//员工表
+ (void) createEmployeeTable;
//点菜表
+ (void) createOrderDishTable;
//点菜流水表
+ (void) createWaterMenuTable;
//临时购物车表
+ (void) createShopCarTable;

//商家信息表
+ (void) deleteBusinessInfoTable;
//创建菜品分类表
+ (void) deleteDishTypeTable;
//创建菜品信息表
+ (void) deleteDishInfoTable;
//图片信息表
+ (void) deleteImageInfoTable;
//员工表
+ (void) deleteEmployeeTable;
//点菜表
+ (void) deleteOrderDishTable;
//点菜流水表
+ (void) deleteWaterMenuTable;
//临时购物车表
+ (void) deleteShopCarTable;

@end
