//
//  OrderDishes.m
//  eMenuPro
//
//  Created by Li Feng on 14-2-20.
//  Copyright (c) 2014年 Gong Lingxiao. All rights reserved.
//

#import "OrderDishes.h"

@interface OrderDishes ()

@end

@implementation OrderDishes
@synthesize orderID;
@synthesize orderStatus;
@synthesize orderTime;
@synthesize desk;
@synthesize dishID;
@synthesize dishName;
@synthesize dishPrice;
@synthesize dishStatus;
@synthesize typeName;
@synthesize sellCount;
@synthesize dishUnit;
@synthesize memo;
@synthesize employee;

+(NSMutableArray *) selectAll{
    NSMutableArray *arr=[[NSMutableArray alloc]init];
    NSString *databasePath = [SystemUtil getDBPath];
    sqlite3 *eMenuDB;
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &eMenuDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT T.*,H.DISHID,H.DISHNAME,H.DISHSTATUS,H.TYPENAME,H.SELLCOUNT,H.SELLPRICE,H.DISHUNIT,H.MEMO FROM ORDERDISHES T LEFT JOIN ORDERDISHESITEM H ON T.ORDERID=H.ORDERID ORDER BY ORDERTIME;"];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(eMenuDB, query_stmt, -1, &statement, NULL) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                OrderDishes *orderDishes=[[OrderDishes alloc]init];
                orderDishes.orderID= [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
                orderDishes.orderStatus=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
                orderDishes.orderTime=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)];
                orderDishes.desk=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 3)];
                orderDishes.employee=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 4)];
                orderDishes.dishID=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 5)];
                orderDishes.dishName=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 6)];
                orderDishes.dishStatus=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 7)];
                orderDishes.typeName=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 8)];
                orderDishes.sellCount=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 9)];
                orderDishes.dishPrice=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 10)];
                orderDishes.dishUnit=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 11)];
                orderDishes.memo=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 12)];
                [arr addObject:orderDishes];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(eMenuDB);
    }
    return arr;
}



+(NSMutableArray *) select:(NSString *) orderID{
    NSMutableArray *arr=[[NSMutableArray alloc]init];
    NSString *databasePath = [SystemUtil getDBPath];
    sqlite3 *eMenuDB;
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &eMenuDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT T.*,H.DISHID,H.DISHNAME,H.DISHSTATUS,H.TYPENAME,H.SELLCOUNT,H.SELLPRICE,H.DISHUNIT,H.MEMO FROM ORDERDISHES T LEFT JOIN ORDERDISHESITEM H ON T.ORDERID=H.ORDERID WHERE T.ORDERID=\"%@\" ;",orderID];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(eMenuDB, query_stmt, -1, &statement, NULL) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                OrderDishes *orderDishes=[[OrderDishes alloc]init];
                orderDishes.orderID= [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
                orderDishes.orderStatus=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
                orderDishes.orderTime=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)];
                orderDishes.desk=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 3)];
                orderDishes.employee=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 4)];
                orderDishes.dishID=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 5)];
                orderDishes.dishName=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 6)];
                orderDishes.dishStatus=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 7)];
                orderDishes.typeName=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 8)];
                orderDishes.sellCount=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 9)];
                orderDishes.dishPrice=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 10)];
                orderDishes.dishUnit=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 11)];
                orderDishes.memo=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 12)];
                [arr addObject:orderDishes];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(eMenuDB);
    }
    return arr;
}

+ (int) insert:(OrderDishes *)orderDishes{
    NSString *dataBasePath=[SystemUtil getDBPath];
    sqlite3 *eMenuDB;
    const char *dbPath=[dataBasePath UTF8String];
    sqlite3_stmt *statement;
    if(sqlite3_open(dbPath, &eMenuDB)==SQLITE_OK){
        NSString *insertSQL =[NSString stringWithFormat:@"INSERT INTO ORDERDISHES VALUES(\"%@\",\"%@\",\"%@\",\"%@\",\"%@\");",orderDishes.orderID,orderDishes.orderStatus,orderDishes.orderTime,orderDishes.desk,orderDishes.employee];
        const char *insert_stmt=[insertSQL UTF8String];
        sqlite3_prepare_v2(eMenuDB, insert_stmt, -1, &statement, NULL);
        if (sqlite3_step(statement)==SQLITE_DONE){
            return 1;
        }else{
            return 0;
        }
        sqlite3_finalize(statement);
        sqlite3_close(eMenuDB);
    }else{
        return -1;
    }
}


+(int)delete{
    NSString *dataBasePath=[SystemUtil getDBPath];
    sqlite3 *eMenuDB;
    const char *dbPath=[dataBasePath UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_open(dbPath, &eMenuDB)==SQLITE_OK){
        NSString *deleteSQL=[NSString stringWithFormat:@"DELETE * FROM ORDERDISHES;"];
        const char *insert_stmt =[deleteSQL UTF8String];
        sqlite3_prepare_v2(eMenuDB, insert_stmt, -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE) {
            //表示删除成功
            return 1;
        }else{
            //表示删除失败
            return 0;
        }
        sqlite3_finalize(statement);
        sqlite3_close(eMenuDB);
    }else{
        //表示数据库连接失败
        return -1;
    }
}

+ (int) delete:(NSString *) orderID{
    NSString *dataBasePath=[SystemUtil getDBPath];
    sqlite3 *eMenuDB;
    const char *dbPath=[dataBasePath UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_open(dbPath, &eMenuDB)==SQLITE_OK){
        NSString *deleteSQL=[NSString stringWithFormat:@"DELETE FROM ORDERDISHES WHERE ORDERID=\"%@\";",orderID];
        const char *insert_stmt =[deleteSQL UTF8String];
        sqlite3_prepare_v2(eMenuDB, insert_stmt, -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE) {
            //表示删除成功
            return [self deleteOrderDishesItem:orderID];
        }else{
            //表示删除失败
            return 0;
        }
        sqlite3_finalize(statement);
        sqlite3_close(eMenuDB);
    }else{
        //表示数据库连接失败
        return -1;
    }
}

+ (int) deleteOrderDishesItem:(NSString *) orderID{
    NSString *dataBasePath=[SystemUtil getDBPath];
    sqlite3 *eMenuDB;
    const char *dbPath=[dataBasePath UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_open(dbPath, &eMenuDB)==SQLITE_OK){
        NSString *deleteSQL=[NSString stringWithFormat:@"DELETE FROM ORDERDISHESITEM WHERE ORDERID=\"%@\";",orderID];
        const char *insert_stmt =[deleteSQL UTF8String];
        sqlite3_prepare_v2(eMenuDB, insert_stmt, -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE) {
            //表示删除成功
            return 1;
        }else{
            //表示删除失败
            return 0;
        }
        sqlite3_finalize(statement);
        sqlite3_close(eMenuDB);
    }else{
        //表示数据库连接失败
        return -1;
    }
}
@end
