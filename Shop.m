//
//  Shop.m
//  eMenuPro
//
//  Created by Li Feng on 14-2-21.
//  Copyright (c) 2014年 Gong Lingxiao. All rights reserved.
//

#import "Shop.h"

@interface Shop ()

@end

@implementation Shop
@synthesize shopID;
@synthesize loginName;
@synthesize shopAddress;
@synthesize shopName;
@synthesize shopIco;
@synthesize shopSummary;
@synthesize shopPhone;
@synthesize shopAdvert;


+(int)insert:(Shop *)shop{
    NSString *dataBasePath=[SystemUtil getDBPath];
    sqlite3 *eMenuDB;
    const char *dbPath=[dataBasePath UTF8String];
    sqlite3_stmt *statement;
    if(sqlite3_open(dbPath, &eMenuDB)==SQLITE_OK){
        NSString *insertSQL =[NSString stringWithFormat:@"INSERT INTO SHOP VALUES(\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\");", shop.shopID,
                              shop.loginName,
                              shop.shopName,
                              shop.shopAddress,
                              shop.shopIco,
                              shop.shopSummary,
                              shop.shopPhone,
                              shop.shopAdvert];
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

+ (Shop *)select : (NSString *)shopid{
    Shop *shop=[[Shop alloc]init];
    NSString *databasePath = [SystemUtil getDBPath];
    sqlite3 *eMenuDB;
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &eMenuDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM SHOP WHERE SHOPID=\"%@\";",shopid];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(eMenuDB, query_stmt, -1, &statement, NULL) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                shop.shopID = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
                shop.loginName=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
                shop.shopName=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)];
                shop.shopAddress=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 3)];
                shop.shopIco=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 4)];
                shop.shopSummary=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 5)];
                shop.shopPhone=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 6)];
                shop.shopAdvert=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 7)];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(eMenuDB);
    }
    return shop;
}

+(int)delete{
    NSString *dataBasePath=[SystemUtil getDBPath];
    sqlite3 *eMenuDB;
    const char *dbpath=[dataBasePath UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &eMenuDB)==SQLITE_OK){
        
        NSString *deleteSQL=[NSString stringWithFormat:@"DELETE FROM SHOP;"];
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
