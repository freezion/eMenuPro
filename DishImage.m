//
//  DishImage.m
//  eMenuPro
//
//  Created by Li Feng on 14-2-24.
//  Copyright (c) 2014年 Gong Lingxiao. All rights reserved.
//

#import "DishImage.h"

@interface DishImage ()

@end

@implementation DishImage
@synthesize dishID;
@synthesize imageID;
@synthesize imageName;

+ (NSMutableArray *) selectAllImageName{
    NSMutableArray *arr=[[NSMutableArray alloc]init];
    NSString *databasePath = [SystemUtil getDBPath];
    sqlite3 *eMenuDB;
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &eMenuDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT IMAGENAME FROM DISHIMAGE;"];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(eMenuDB, query_stmt, -1, &statement, NULL) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSString *imageName=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
                [arr addObject:imageName];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(eMenuDB);
    }
    return arr;

}


@end
