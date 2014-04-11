//
//  DishType.h
//  eMenuPro
//
//  Created by Li Feng on 14-2-24.
//  Copyright (c) 2014年 Gong Lingxiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SystemUtil.h"
@interface DishType : NSObject{
    NSString *typeID;
    NSString *typeName;
    NSString *typeSort;
    NSString *typeDescribe;
}
@property (nonatomic,retain) NSString *typeID;
@property (nonatomic,retain) NSString *typeName;
@property (nonatomic,retain) NSString *typeSort;
@property (nonatomic,retain) NSString *typeDescribe;

+ (int) insert:(DishType *)dishType;
+ (NSMutableArray *) selectAll;
+ (int) delete;
@end
