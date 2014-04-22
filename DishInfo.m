
//
//  DishInfo.m
//  eMenuPro
//
//  Created by Li Feng on 14-2-20.
//  Copyright (c) 2014年 Gong Lingxiao. All rights reserved.
//

#import "DishInfo.h"

@interface DishInfo ()

@end

@implementation DishInfo
@synthesize dishCode;
@synthesize dishID;
@synthesize dishName;
@synthesize dishMemo;
@synthesize dishIntro;
@synthesize dishPrice;
@synthesize dishSellPrice;
@synthesize dishStatus;
@synthesize dishUnit;
@synthesize smallDishPrice;
@synthesize bigDishPrice;
@synthesize dishTypeID;
@synthesize typeName;
@synthesize typeSort;
@synthesize typeDescribe;
@synthesize imageID;
@synthesize imageName;
@synthesize isHot;
@synthesize dishSpicy;
@synthesize stock;

+ (int) insert:(DishInfo *)dish{
    NSString *dataBasePath=[SystemUtil getDBPath];
    sqlite3 *eMenuDB;
    const char *dbPath=[dataBasePath UTF8String];
    sqlite3_stmt *statement;
    if(sqlite3_open(dbPath, &eMenuDB)==SQLITE_OK){
        NSString *insertSQL =[NSString stringWithFormat:@"INSERT INTO DISHINFO VALUES(\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\");",
                              dish.dishCode,
                              dish.dishID,
                              dish.dishName,
                              dish.dishMemo,
                              dish.dishIntro,
                              dish.dishPrice,
                              dish.dishSellPrice,
                              dish.dishStatus,
                              dish.dishTypeID,
                              dish.dishUnit,
                              dish.smallDishPrice,
                              dish.bigDishPrice,
                              dish.isHot,
                              dish.dishSpicy,
                              dish.stock];
        const char *insert_stmt=[insertSQL UTF8String];
        sqlite3_prepare_v2(eMenuDB, insert_stmt, -1, &statement, NULL);
        if (sqlite3_step(statement)==SQLITE_DONE){
            return [self insertImg:dish];
        }else{
            return 0;
        }
        sqlite3_finalize(statement);
        sqlite3_close(eMenuDB);
    }else{
        return -1;
    }
}


+ (int) insertImg:(DishInfo *)dish{
    NSString *dataBasePath=[SystemUtil getDBPath];
    sqlite3 *eMenuDB;
    const char *dbPath=[dataBasePath UTF8String];
    sqlite3_stmt *statement;
    if(sqlite3_open(dbPath, &eMenuDB)==SQLITE_OK){
        NSString *insertSQL =[NSString stringWithFormat:@"INSERT INTO DISHIMAGE VALUES(NULL,\"%@\",\"%@\");",
                              dish.dishID,
                              dish.imageName];
        NSLog(@"%@", insertSQL);
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


+ (NSMutableArray *) selectAll{
    NSMutableArray *arr=[[NSMutableArray alloc]init];
    NSString *databasePath = [SystemUtil getDBPath];
    sqlite3 *eMenuDB;
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &eMenuDB) == SQLITE_OK)
    {
        // ORDER BY SYSTEMID DESC
        NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM DISHINFO ORDER BY DISHID;"];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(eMenuDB, query_stmt, -1, &statement, NULL) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                DishInfo *dishinfo=[[DishInfo alloc]init];
                dishinfo.dishCode=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
                dishinfo.dishID = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
                dishinfo.dishName=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)];
                dishinfo.dishMemo=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 3)];
                dishinfo.dishIntro=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 4)];
                dishinfo.dishPrice=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 5)];
                dishinfo.dishSellPrice=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 6)];
                dishinfo.dishStatus=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 7)];
                dishinfo.dishTypeID=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 8)];
                dishinfo.dishUnit=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 9)];
                dishinfo.smallDishPrice=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 10)];
                dishinfo.bigDishPrice=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 11)];
                dishinfo.isHot=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 12)];
                dishinfo.dishSpicy=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 13)];
                dishinfo.stock=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 14)];
                [arr addObject:dishinfo];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(eMenuDB);
    }
    return arr;
}

+ (NSMutableArray *) selectAllByType:typeId{
    NSMutableArray *arr=[[NSMutableArray alloc]init];
    NSString *databasePath = [SystemUtil getDBPath];
    sqlite3 *eMenuDB;
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &eMenuDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT X.*,Y.TYPENAME FROM  (SELECT T.*,M.IMAGENAME FROM DISHINFO T LEFT JOIN DISHIMAGE M ON T.DISHID=M.DISHID WHERE T.DISHTYPEID=\"%@\" ORDER BY DISHID) X LEFT JOIN DISHTYPE Y ON X.DISHTYPEID=Y.TYPEID;",typeId];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(eMenuDB, query_stmt, -1, &statement, NULL) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                DishInfo *dishinfo=[[DishInfo alloc]init];
                dishinfo.dishCode=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
                dishinfo.dishID = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
                dishinfo.dishName=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)];
                dishinfo.dishMemo=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 3)];
                dishinfo.dishIntro=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 4)];
                dishinfo.dishPrice=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 5)];
                dishinfo.dishSellPrice=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 6)];
                dishinfo.dishStatus=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 7)];
                dishinfo.dishTypeID=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 8)];
                dishinfo.dishUnit=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 9)];
                dishinfo.smallDishPrice=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 10)];
                dishinfo.bigDishPrice=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 11)];
                dishinfo.isHot=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 12)];
                dishinfo.dishSpicy=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 13)];
                dishinfo.stock=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 14)];
                dishinfo.imageName=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 15)];
                dishinfo.typeName=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 16)];
                [arr addObject:dishinfo];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(eMenuDB);
    }
    return arr;
}

+ (NSMutableArray *) selectAllByIsHot :(NSString*)isHot{
    NSMutableArray *arr=[[NSMutableArray alloc]init];
    NSString *databasePath = [SystemUtil getDBPath];
    sqlite3 *eMenuDB;
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &eMenuDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT X.*,Y.TYPENAME FROM  (SELECT T.*,M.IMAGENAME FROM DISHINFO T LEFT JOIN DISHIMAGE M ON T.DISHID=M.DISHID WHERE T.ISHOT=\"%@\" ORDER BY DISHID) X LEFT JOIN DISHTYPE Y ON X.DISHTYPEID=Y.TYPEID;",isHot];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(eMenuDB, query_stmt, -1, &statement, NULL) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                DishInfo *dishinfo=[[DishInfo alloc]init];
                dishinfo.dishCode=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
                dishinfo.dishID = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
                dishinfo.dishName=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)];
                dishinfo.dishMemo=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 3)];
                dishinfo.dishIntro=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 4)];
                dishinfo.dishPrice=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 5)];
                dishinfo.dishSellPrice=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 6)];
                dishinfo.dishStatus=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 7)];
                dishinfo.dishTypeID=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 8)];
                dishinfo.dishUnit=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 9)];
                dishinfo.smallDishPrice=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 10)];
                dishinfo.bigDishPrice=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 11)];
                dishinfo.isHot=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 12)];
                dishinfo.dishSpicy=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 13)];
                dishinfo.stock=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 14)];
                dishinfo.imageName=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 15)];
                dishinfo.typeName=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 16)];
                [arr addObject:dishinfo];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(eMenuDB);
    }
    return arr;
}

+ (DishInfo *) selectByDishID:(NSString*)dishID{
    DishInfo *dishinfo=[[DishInfo alloc]init];
    NSString *databasePath = [SystemUtil getDBPath];
    sqlite3 *eMenuDB;
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &eMenuDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT X.*,Y.IMAGENAME FROM (SELECT T.*,M.TYPENAME FROM DISHINFO T LEFT JOIN DISHTYPE M ON T.DISHTYPEID=M.TYPEID WHERE T.DISHID=\"%@\" ORDER BY DISHID) X LEFT JOIN DISHIMAGE Y ON X.DISHID=Y.DISHID;",dishID];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(eMenuDB, query_stmt, -1, &statement, NULL) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                dishinfo.dishCode=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
                dishinfo.dishID = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
                dishinfo.dishName=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)];
                dishinfo.dishMemo=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 3)];
                dishinfo.dishIntro=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 4)];
                dishinfo.dishPrice=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 5)];
                dishinfo.dishSellPrice=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 6)];
                dishinfo.dishStatus=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 7)];
                dishinfo.dishTypeID=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 8)];
                dishinfo.dishUnit=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 9)];
                dishinfo.smallDishPrice=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 10)];
                dishinfo.bigDishPrice=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 11)];
                dishinfo.isHot=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 12)];
                dishinfo.dishSpicy=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 13)];
                dishinfo.stock=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 14)];
                dishinfo.typeName=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 15)];
                dishinfo.imageName=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 16)];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(eMenuDB);
    }
    return dishinfo;
}

+ (NSMutableArray *) selectBySearchKey:(NSString*)searchText{
    NSMutableArray *arr=[[NSMutableArray alloc]init];
    NSString *databasePath = [SystemUtil getDBPath];
    sqlite3 *eMenuDB;
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &eMenuDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT X.*,Y.TYPENAME FROM   (SELECT T.*,M.IMAGENAME FROM DISHINFO T LEFT JOIN DISHIMAGE M ON T.DISHID=M.DISHID  WHERE T.DISHID LIKE '%%%@%%' OR T.DISHNAME LIKE '%%%@%%' ORDER BY DISHID) X  LEFT JOIN DISHTYPE Y ON X.DISHTYPEID=Y.TYPEID;",searchText,searchText];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(eMenuDB, query_stmt, -1, &statement, NULL) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                DishInfo *dishinfo=[[DishInfo alloc]init];
                dishinfo.dishCode=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
                dishinfo.dishID = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
                dishinfo.dishName=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)];
                dishinfo.dishMemo=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 3)];
                dishinfo.dishIntro=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 4)];
                dishinfo.dishPrice=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 5)];
                dishinfo.dishSellPrice=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 6)];
                dishinfo.dishStatus=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 7)];
                dishinfo.dishTypeID=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 8)];
                dishinfo.dishUnit=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 9)];
                dishinfo.smallDishPrice=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 10)];
                dishinfo.bigDishPrice=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 11)];
                dishinfo.isHot=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 12)];
                dishinfo.dishSpicy=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 13)];
                dishinfo.stock=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 14)];
                dishinfo.imageName=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 15)];
                dishinfo.typeName=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 16)];
                [arr addObject:dishinfo];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(eMenuDB);
    }
    return arr;
}



+(int)delete{
    NSString *dataBasePath=[SystemUtil getDBPath];
    sqlite3 *eMenuDB;
    const char *dbpath=[dataBasePath UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &eMenuDB)==SQLITE_OK){
        
        NSString *deleteSQL=[NSString stringWithFormat:@"DELETE * FROM DISHINFO;"];
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

+ (int) deleteImage{
    NSString *dataBasePath=[SystemUtil getDBPath];
    sqlite3 *eMenuDB;
    const char *dbpath=[dataBasePath UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &eMenuDB)==SQLITE_OK){
        
        NSString *deleteSQL=[NSString stringWithFormat:@"DELETE * FROM DISHIMAGE;"];
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

+ (int) update:(DishInfo *)dish{
    NSString *dataBasePath=[SystemUtil getDBPath];
    sqlite3 *eMenuDB;
    const char *dbPath=[dataBasePath UTF8String];
    sqlite3_stmt *statement;
    if(sqlite3_open(dbPath, &eMenuDB)==SQLITE_OK){
        NSString *insertSQL =[NSString stringWithFormat:@"UPDATE DISHINFO SET STOCK=\"%@\" WHERE DISHID = \"%@\";",dish.stock,
                              dish.dishID];
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
