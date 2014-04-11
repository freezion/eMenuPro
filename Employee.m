//
//  Employee.m
//  eMenuPro
//
//  Created by Li Feng on 14-2-24.
//  Copyright (c) 2014年 Gong Lingxiao. All rights reserved.
//

#import "Employee.h"


@interface Employee ()

@end

@implementation Employee
@synthesize  EmployeeID;
@synthesize EmployeeName;
@synthesize PassWord;


+(Employee *)select:(NSString *) employeeID withPassword:(NSString *) password{
    Employee *employee=[[Employee alloc]init];
    NSString *databasePath = [SystemUtil getDBPath];
    sqlite3 *eMenuDB;
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &eMenuDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM EMPLOYEE WHERE EMPLOYEEID=\"%@\" AND PASSWORD=\"%@\";",employeeID,password];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(eMenuDB, query_stmt, -1, &statement, NULL) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                employee.EmployeeID = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
                employee.EmployeeName=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(eMenuDB);
    }
    return employee;
}

+(int)select{
    int count=0;
    NSString *databasePath = [SystemUtil getDBPath];
    sqlite3 *eMenuDB;
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &eMenuDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT count(*) FROM EMPLOYEE;"];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(eMenuDB, query_stmt, -1, &statement, NULL) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                count = [[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)] intValue];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(eMenuDB);
    }
    return count;
}

+(int)insert:(Employee *)employee{
    NSString *dataBasePath=[SystemUtil getDBPath];
    sqlite3 *eMenuDB;
    const char *dbPath=[dataBasePath UTF8String];
    sqlite3_stmt *statement;
    if(sqlite3_open(dbPath, &eMenuDB)==SQLITE_OK){
        NSString *insertSQL =[NSString stringWithFormat:@"INSERT INTO EMPLOYEE VALUES(\"%@\",\"%@\",\"%@\");",
                              employee.EmployeeID,
                              employee.EmployeeName,
                              employee.PassWord];
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
    const char *dbpath=[dataBasePath UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &eMenuDB)==SQLITE_OK){
        
        NSString *deleteSQL=[NSString stringWithFormat:@"DELETE * FROM EMPLOYEE;"];
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
