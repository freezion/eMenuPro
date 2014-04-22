//
//  SystemUtil.m
//  eMenuPro
//
//  Created by Gong Lingxiao on 14-2-11.
//  Copyright (c) 2014年 Gong Lingxiao. All rights reserved.
//

#import "SystemUtil.h"
#import "DishImage.h"
@implementation SystemUtil


+ (NSString *)getDBPath {
    NSString *docsDir;
    NSArray *dirPaths;
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = [dirPaths objectAtIndex:0];
    // Build the path to the database file
    NSString *databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"eMenuPro.db"]];
    return databasePath;
}


//商家信息表
+ (void) createBusinessInfoTable{
    NSString *databasePath=[self getDBPath];
    sqlite3 *eMenuProDB;
    const char *dbpath=[databasePath UTF8String];
    if (sqlite3_open(dbpath, &eMenuProDB)==SQLITE_OK){
        char *errMsg;
        const char *sql_stmt="CREATE TABLE IF NOT EXISTS SHOP(SHOPID VARCHAR(20) PRIMARY KEY, LOGINNAME VARCHAR(20), SHOPNAME VARCHAR(30), SHOPADDRESS VARCHAR(500), SHOPICO VARCHAR(50), SHOPSUMMARY TEXT, SHOPPHONE VARCHAR(13),SHOPADVERT VARCHAR(256));";
        if (sqlite3_exec(eMenuProDB, sql_stmt, NULL, NULL, &errMsg)!=SQLITE_OK){
            NSLog(@"create failed!\n");
        }else{
            NSLog(@"create success!\n");}
    }
    else{
        NSLog(@"创建/打开数据库失败");
    }
}


+ (void) deleteBusinessInfoTable{
    NSString *databasePath=[self getDBPath];
    sqlite3 *eMenuProDB;
    const char *dbpath=[databasePath UTF8String];
    if (sqlite3_open(dbpath, &eMenuProDB)==SQLITE_OK){
        char *errMsg;
        const char *sql_stmt="DROP TABLE SHOP;";
        if (sqlite3_exec(eMenuProDB, sql_stmt, NULL, NULL, &errMsg)!=SQLITE_OK){
            NSLog(@"delete failed!\n");
        }else{
            NSLog(@"delete success!\n");}
    }
    else{
        NSLog(@"删除数据库失败");
    }
}


//创建菜品分类表
+ (void) createDishTypeTable{
    NSString *databasePath = [self getDBPath];
    sqlite3 *eMenuProDB;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &eMenuProDB)==SQLITE_OK)
    {
        char *errMsg;
        const char *sql_stmt = "CREATE TABLE IF NOT EXISTS DISHTYPE(TYPEID VARCHAR(20) PRIMARY KEY, TYPENAME VARCHAR(20), TYPESORT INT, TYPEDESCRIBE VARCHAR(200));";
        if (sqlite3_exec(eMenuProDB, sql_stmt, NULL, NULL, &errMsg)!=SQLITE_OK) {
            NSLog(@"create failed!\n");
        }else{
            NSLog(@"create success!\n");}
    }
    else
    {
        NSLog(@"创建/打开数据库失败");
    }
}

+ (void) deleteDishTypeTable{
    NSString *databasePath = [self getDBPath];
    sqlite3 *eMenuProDB;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &eMenuProDB)==SQLITE_OK)
    {
        char *errMsg;
        const char *sql_stmt = "DROP TABLE DISHTYPE;";
        if (sqlite3_exec(eMenuProDB, sql_stmt, NULL, NULL, &errMsg)!=SQLITE_OK) {
            NSLog(@"delete failed!\n");
        }else{
            NSLog(@"delete success!\n");}
    }
    else
    {
        NSLog(@"删除数据库失败");
    }
}

//创建菜品信息表
+ (void) createDishInfoTable{
    NSString *databasePath=[self getDBPath];
    sqlite3 *eMenuProDB;
    const char *dbpath=[databasePath UTF8String];
    if (sqlite3_open(dbpath, &eMenuProDB)==SQLITE_OK){
        char *errMsg;
        const char *sql_stmt ="CREATE TABLE IF NOT EXISTS DISHINFO(DISHCODE VARCHAR(10) PRIMARY KEY, DISHID integer, DISHNAME VARCHAR(30), DISHMEMO TEXT, DISHINTRO TEXT, DISHPRICE NUMERIC(10,2), DISHSELLPRICE NUMERIC(10,2), DISHSTATUS INT, DISHTYPEID INT, DISHUNIT VARCHAR(5), SMALLDISHPRICE NUMERIC(10,2), BIGDISHPRICE NUMERIC(10,2) ,ISHOT VARCHAR(5) ,DISHSPICY VARCHAR(5) ,STOCK INTEGER);";
        if (sqlite3_exec(eMenuProDB, sql_stmt, NULL, NULL, &errMsg)!=SQLITE_OK)
        {
            NSLog(@"create failed!\n");
        }else{
            NSLog(@"create success!\n");}
    }
    else{
        NSLog(@"创建/打开数据库失败");
    }
}

+ (void) deleteDishInfoTable{
    NSString *databasePath = [self getDBPath];
    sqlite3 *eMenuProDB;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &eMenuProDB)==SQLITE_OK)
    {
        char *errMsg;
        const char *sql_stmt = "DROP TABLE DISHINFO";
        if (sqlite3_exec(eMenuProDB, sql_stmt, NULL, NULL, &errMsg)!=SQLITE_OK) {
            NSLog(@"delete failed!\n");
        }else{
            NSLog(@"delete success!\n");}
    }
    else
    {
        NSLog(@"删除数据库失败");
    }

}
//图片信息表
+ (void) createImageInfoTable{
    NSString *databasePath=[self getDBPath];
    sqlite3 *eMenuProDB;
    const char *dbpath=[databasePath UTF8String];
    if (sqlite3_open(dbpath, &eMenuProDB)==SQLITE_OK){
        char *errMsg;
        const char *sql_stmt ="CREATE TABLE IF NOT EXISTS DISHIMAGE(IMAGEID INTEGER PRIMARY KEY AUTOINCREMENT, DISHID VARCHAR(20), IMAGENAME VARCHAR(50));";
        if (sqlite3_exec(eMenuProDB, sql_stmt, NULL, NULL, &errMsg)!=SQLITE_OK)
        {
            NSLog(@"create failed!\n");
        }else{
            NSLog(@"create success!\n");}
    }
    else{
        NSLog(@"创建/打开数据库失败");
    }
}

+ (void) deleteImageInfoTable{
    NSArray *imageArr=[DishImage selectAllImageName];
    NSFileManager *fm=[NSFileManager defaultManager];
    for (NSString *imageName in imageArr){
        if (![imageName isEqualToString:@""]){
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        /*写入图片*/
        //帮文件起个全路径名字
        NSMutableString *uniquePath = [[NSMutableString alloc] init];
        [uniquePath appendString:[paths objectAtIndex:0]];
        [uniquePath appendString:@"/"];
        [uniquePath appendString:imageName];
        [fm removeItemAtPath:uniquePath error:nil];
        NSMutableString *uniquePath1 = [[NSMutableString alloc] init];
        [uniquePath1 appendString:[paths objectAtIndex:0]];
        [uniquePath1 appendString:@"/Sml"];
        [uniquePath1 appendString:imageName];
        [fm removeItemAtPath:uniquePath1 error:nil];
        }
    }

    NSString *databasePath = [self getDBPath];
    sqlite3 *eMenuProDB;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &eMenuProDB)==SQLITE_OK)
    {
        char *errMsg;
        const char *sql_stmt = "DROP TABLE DISHIMAGE;";
        if (sqlite3_exec(eMenuProDB, sql_stmt, NULL, NULL, &errMsg)!=SQLITE_OK) {
            NSLog(@"delete failed!\n");
        }else{
            NSLog(@"delete success!\n");
        }
    }
    else
    {
        NSLog(@"删除数据库失败");
    }

}
//员工表
+ (void) createEmployeeTable{
    NSString *databasePath=[self getDBPath];
    sqlite3 *eMenuProDB;
    const char *dbpath=[databasePath UTF8String];
    if (sqlite3_open(dbpath, &eMenuProDB)==SQLITE_OK){
        char *errMsg;
        const char *sql_stmt ="CREATE TABLE IF NOT EXISTS EMPLOYEE(EMPLOYEEID VARCHAR(20) PRIMARY KEY, EMPLOYEENAME VARCHAR(20),PASSWORD VARCHAR(32));";
        if (sqlite3_exec(eMenuProDB, sql_stmt, NULL, NULL, &errMsg)!=SQLITE_OK)
        {
            NSLog(@"create failed!\n");
        }else{
            NSLog(@"create success!\n");}
    }
    else{
        NSLog(@"创建/打开数据库失败");
    }
}

+ (void) deleteEmployeeTable{
    NSString *databasePath = [self getDBPath];
    sqlite3 *eMenuProDB;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &eMenuProDB)==SQLITE_OK)
    {
        char *errMsg;
        const char *sql_stmt = "DROP TABLE EMPLOYEE;";
        if (sqlite3_exec(eMenuProDB, sql_stmt, NULL, NULL, &errMsg)!=SQLITE_OK) {
            NSLog(@"delete failed!\n");
        }else{
            NSLog(@"delete success!\n");}
    }
    else
    {
        NSLog(@"删除数据库失败");
    }
}


//点菜表
+ (void) createOrderDishTable{
    NSString *databasePath=[self getDBPath];
    sqlite3 *eMenuProDB;
    const char *dbpath=[databasePath UTF8String];
    if (sqlite3_open(dbpath, &eMenuProDB)==SQLITE_OK){
        char *errMsg;
        const char *sql_stmt ="CREATE TABLE IF NOT EXISTS ORDERDISHES(ORDERID VARCHAR(20) PRIMARY KEY, ORDERSTATUS INT, ORDERTIME TEXT, DESK VARCHAR(10),EMPLOYEEID VARCHAR(20));";
        if (sqlite3_exec(eMenuProDB, sql_stmt, NULL, NULL, &errMsg)!=SQLITE_OK)
        {
            NSLog(@"create failed!\n");
        }else{
            NSLog(@"create success!\n");}
    }
    else{
        NSLog(@"创建/打开数据库失败");
    }
}

+ (void) deleteOrderDishTable{
    NSString *databasePath = [self getDBPath];
    sqlite3 *eMenuProDB;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &eMenuProDB)==SQLITE_OK)
    {
        char *errMsg;
        const char *sql_stmt = "DROP TABLE ORDERDISHES;";
        if (sqlite3_exec(eMenuProDB, sql_stmt, NULL, NULL, &errMsg)!=SQLITE_OK) {
            NSLog(@"delete failed!\n");
        }else{
            NSLog(@"delete success!\n");}
    }
    else
    {
        NSLog(@"删除数据库失败");
    }
}


//点菜流水表
+ (void) createWaterMenuTable{
    NSString *databasePath=[self getDBPath];
    sqlite3 *eMenuProDB;
    const char *dbpath=[databasePath UTF8String];
    if (sqlite3_open(dbpath, &eMenuProDB)==SQLITE_OK){
        char *errMsg;
        const char *sql_stmt ="CREATE TABLE IF NOT EXISTS ORDERDISHESITEM(SYSTEMID integer PRIMARY KEY, ORDERID VARCHAR(20) , DISHID VARCHAR(20), DISHNAME VARCHAR(30),DISHSTATUS INT, TYPENAME VARCHAR(10), SELLCOUNT INT, SELLPRICE NUMERIC(10,2), DISHUNIT VARCHAR(5), MEMO VARCHAR(100));";
        if (sqlite3_exec(eMenuProDB, sql_stmt, NULL, NULL, &errMsg)!=SQLITE_OK)
        {
            NSLog(@"create failed!\n");
        }else{
            NSLog(@"create success!\n");}
    }
    else{
        NSLog(@"创建/打开数据库失败");
    }
}

+ (void) deleteWaterMenuTable{
    NSString *databasePath = [self getDBPath];
    sqlite3 *eMenuProDB;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &eMenuProDB)==SQLITE_OK)
    {
        char *errMsg;
        const char *sql_stmt = "DROP TABLE ORDERDISHESITEM;";
        if (sqlite3_exec(eMenuProDB, sql_stmt, NULL, NULL, &errMsg)!=SQLITE_OK) {
            NSLog(@"delete failed!\n");
        }else{
            NSLog(@"delete success!\n");}
    }
    else
    {
        NSLog(@"删除数据库失败");
    }

}


//临时购物车表
+ (void) createShopCarTable{
    NSString *databasePath=[self getDBPath];
    sqlite3 *eMenuProDB;
    const char *dbpath=[databasePath UTF8String];
    if (sqlite3_open(dbpath, &eMenuProDB)==SQLITE_OK){
        char *errMsg;
        const char *sql_stmt ="CREATE TABLE IF NOT EXISTS SHOPCAR(SYSTEMID integer PRIMARY KEY autoincrement,DISHID VARCHAR(20),DISHNAME VARCHAR(30), TYPENAME VARCHAR(10), SELLCOUNT INT, SELLPRICE NUMERIC(10,2), DISHUNIT VARCHAR(5), MEMO VARCHAR(100) ,DISHSTATUS VARCHAR(3));";
        if (sqlite3_exec(eMenuProDB, sql_stmt, NULL, NULL, &errMsg)!=SQLITE_OK)
        {
            NSLog(@"create failed!\n");
        }else{
            NSLog(@"create success!\n");}
    }
    else{
        NSLog(@"创建/打开数据库失败");
    }
}

+ (void) deleteShopCarTable{
    NSString *databasePath = [self getDBPath];
    sqlite3 *eMenuProDB;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &eMenuProDB)==SQLITE_OK)
    {
        char *errMsg;
        const char *sql_stmt = "DROP TABLE SHOPCAR;";
        if (sqlite3_exec(eMenuProDB, sql_stmt, NULL, NULL, &errMsg)!=SQLITE_OK) {
            NSLog(@"delete failed!\n");
        }else{
            NSLog(@"delete success!\n");}
    }
    else
    {
        NSLog(@"删除数据库失败");
    }

}

@end
