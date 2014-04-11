//
//  Employee.h
//  eMenuPro
//
//  Created by Li Feng on 14-2-24.
//  Copyright (c) 2014年 Gong Lingxiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SystemUtil.h"
@interface Employee : NSObject{
    NSString *EmployeeID;
    NSString *EmployeeName;
    NSString *PassWord;
}
@property (nonatomic,retain) NSString *EmployeeID;
@property (nonatomic,retain) NSString *EmployeeName;
@property (nonatomic,retain) NSString *PassWord;

+ (int) insert:(Employee *)employee;
+ (int)select;
+ (Employee *) select:(NSString *) employeeID withPassword:(NSString *) password;
+ (int) delete;
@end
