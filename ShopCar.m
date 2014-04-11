//
//  ShopCar.m
//  eMenuPro
//
//  Created by Li Feng on 14-3-10.
//  Copyright (c) 2014年 Gong Lingxiao. All rights reserved.
//

#import "ShopCar.h"

@implementation ShopCar
@synthesize systemID;
@synthesize dishID;
@synthesize dishName;
@synthesize typeName;
@synthesize sellCount;
@synthesize dishPrice;
@synthesize dishUnit;
@synthesize memo;
@synthesize dishStatus;

+(NSMutableArray*) selectAll{
    NSMutableArray *arr=[[NSMutableArray alloc]init];
    NSString *databasePath = [SystemUtil getDBPath];
    sqlite3 *eMenuDB;
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &eMenuDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM SHOPCAR ORDER BY DISHID,DISHNAME,SELLPRICE,MEMO"];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(eMenuDB, query_stmt, -1, &statement, NULL) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                ShopCar *shopCar= [[ShopCar alloc]init];
                shopCar.systemID= [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
                shopCar.dishID= [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
                shopCar.dishName= [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)];
                shopCar.typeName= [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 3)];
                shopCar.sellCount= [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 4)];
                shopCar.dishPrice= [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 5)];
                shopCar.dishUnit= [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 6)];
                shopCar.memo= [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 7)];
                shopCar.dishStatus=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 8)];
                [arr addObject:shopCar];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(eMenuDB);
    }
    return arr;
}

+(int)selectAllCount{
    int arr=0;
    NSString *databasePath = [SystemUtil getDBPath];
    sqlite3 *eMenuDB;
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &eMenuDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT count(*) FROM SHOPCAR"];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(eMenuDB, query_stmt, -1, &statement, NULL) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                arr=[[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)] intValue];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(eMenuDB);
    }
    return arr;
}

+ (ShopCar *)select : (NSString *)dishid{
    ShopCar *shopCar=[[ShopCar alloc]init];
    NSString *databasePath = [SystemUtil getDBPath];
    sqlite3 *eMenuDB;
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &eMenuDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM SHOPCAR WHERE DISHID=\"%@\";",dishid];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(eMenuDB, query_stmt, -1, &statement, NULL) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                shopCar.systemID= [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
                shopCar.dishID= [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
                shopCar.dishName= [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)];
                shopCar.typeName= [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 3)];
                shopCar.sellCount= [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 4)];
                shopCar.dishPrice= [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 5)];
                shopCar.dishUnit= [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 6)];
                shopCar.memo= [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 7)];
                shopCar.dishStatus=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 8)];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(eMenuDB);
    }
    return shopCar;
}

+ (ShopCar *)selectWithPrice: (NSString *)dishid withPrice:(NSString*)dishPrice{
    ShopCar *shopCar=[[ShopCar alloc]init];
    NSString *databasePath = [SystemUtil getDBPath];
    sqlite3 *eMenuDB;
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &eMenuDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM SHOPCAR WHERE DISHID=\"%@\" AND SELLPRICE=\"%@\" ;",dishid,dishPrice];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(eMenuDB, query_stmt, -1, &statement, NULL) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                shopCar.systemID= [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
                shopCar.dishID= [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
                shopCar.dishName= [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)];
                shopCar.typeName= [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 3)];
                shopCar.sellCount= [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 4)];
                shopCar.dishPrice= [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 5)];
                shopCar.dishUnit= [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 6)];
                shopCar.memo= [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 7)];
                shopCar.dishStatus=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 8)];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(eMenuDB);
    }
    return shopCar;
}



+(int)delete:systemId{
    NSString *dataBasePath=[SystemUtil getDBPath];
    sqlite3 *eMenuDB;
    const char *dbpath=[dataBasePath UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &eMenuDB)==SQLITE_OK){
        
        NSString *deleteSQL=[NSString stringWithFormat:@"DELETE FROM SHOPCAR WHERE SYSTEMID=\"%@\";",systemId];
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
+(int)deleteAll{
    NSString *dataBasePath=[SystemUtil getDBPath];
    sqlite3 *eMenuDB;
    const char *dbpath=[dataBasePath UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &eMenuDB)==SQLITE_OK){
        
        NSString *deleteSQL=[NSString stringWithFormat:@"DELETE FROM SHOPCAR;"];
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


+(int)insert:(ShopCar *)shopCar{
    NSString *dataBasePath=[SystemUtil getDBPath];
    sqlite3 *eMenuDB;
    const char *dbPath=[dataBasePath UTF8String];
    sqlite3_stmt *statement;
    if(sqlite3_open(dbPath, &eMenuDB)==SQLITE_OK){
        NSString *insertSQL =[NSString stringWithFormat:@"INSERT INTO SHOPCAR VALUES(null,\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\");", shopCar.dishID,
                              shopCar.dishName,
                              shopCar.typeName,
                              shopCar.sellCount,
                              shopCar.dishPrice,
                              shopCar.dishUnit,
                              shopCar.memo,
                              shopCar.dishStatus];
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

+ (int) insertOrderDishItem:(ShopCar *)shopCar WithOrderID:(NSString *)orderId{
    NSString *dataBasePath=[SystemUtil getDBPath];
    sqlite3 *eMenuDB;
    const char *dbPath=[dataBasePath UTF8String];
    sqlite3_stmt *statement;
    if(sqlite3_open(dbPath, &eMenuDB)==SQLITE_OK){
        NSString *insertSQL =[NSString stringWithFormat:@"INSERT INTO ORDERDISHESITEM VALUES(NULL,\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\");",orderId,shopCar.dishID,shopCar.dishName,shopCar.dishStatus,shopCar.typeName,shopCar.sellCount,shopCar.dishPrice,shopCar.dishUnit,shopCar.memo];
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

@end
