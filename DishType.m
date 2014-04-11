//
//  DishType.m
//  eMenuPro
//
//  Created by Li Feng on 14-2-24.
//  Copyright (c) 2014年 Gong Lingxiao. All rights reserved.
//

#import "DishType.h"

@interface DishType ()

@end

@implementation DishType
@synthesize typeID;
@synthesize typeName;
@synthesize typeSort;
@synthesize typeDescribe;

+ (int) insert:(DishType *)dishType{
    NSString *dataBasePath=[SystemUtil getDBPath];
    sqlite3 *eMenuDB;
    const char *dbPath=[dataBasePath UTF8String];
    sqlite3_stmt *statement;
    if(sqlite3_open(dbPath, &eMenuDB)==SQLITE_OK){
        NSString *insertSQL =[NSString stringWithFormat:@"INSERT INTO DISHTYPE VALUES(\"%@\",\"%@\",\"%@\",\"%@\");",dishType.typeID,dishType.typeName,dishType.typeSort,dishType.typeDescribe];
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
        NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM DISHTYPE ORDER BY TYPESORT ;"];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(eMenuDB, query_stmt, -1, &statement, NULL) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                DishType *dishType=[[DishType alloc]init];
                dishType.typeID = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
                //dishType.typeDescribe=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 3)];
                dishType.typeSort=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)];
                dishType.typeName=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
                [arr addObject:dishType];
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
        
        NSString *deleteSQL=[NSString stringWithFormat:@"DELETE * FROM DISHTYPE;"];
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
