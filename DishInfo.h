//
//  DishInfo.h
//  eMenuPro
//
//  Created by Li Feng on 14-2-20.
//  Copyright (c) 2014年 Gong Lingxiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SystemUtil.h"
@interface DishInfo : NSObject{
    NSString *dishCode;
    NSString *dishID;
    NSString *dishName;
    NSString *dishMemo;
    NSString *dishIntro;
    NSString *dishPrice;
    NSString *dishSellPrice;
    NSString *dishStatus;
    NSString *dishUnit;
    NSString *smallDishPrice;
    NSString *bigDishPrice;
    NSString *dishSpicy;
    NSString *isHot;
    NSString *stock;
    
    NSString *dishTypeID;
    NSString *typeName;
    NSString *typeSort;
    NSString *typeDescribe;
    
    NSString *imageID;
    NSString *imageName;
}
@property(nonatomic,retain) NSString *dishID;
@property(nonatomic,retain) NSString *dishCode;
@property(nonatomic,retain) NSString *dishName;
@property(nonatomic,retain) NSString *dishMemo;
@property(nonatomic,retain) NSString *dishIntro;
@property(nonatomic,retain) NSString *dishPrice;
@property(nonatomic,retain) NSString *dishSellPrice;
@property(nonatomic,retain) NSString *dishStatus;
@property(nonatomic,retain) NSString *dishUnit;
@property(nonatomic,retain) NSString *smallDishPrice;
@property(nonatomic,retain) NSString *bigDishPrice;
@property(nonatomic,retain) NSString *dishSpicy;
@property(nonatomic,retain) NSString *isHot;
@property(nonatomic,retain) NSString *stock;
@property(nonatomic,retain) NSString *dishTypeID;
@property(nonatomic,retain) NSString *typeName;
@property(nonatomic,retain) NSString *typeSort;
@property(nonatomic,retain) NSString *typeDescribe;
@property(nonatomic,retain) NSString *imageID;
@property(nonatomic,retain) NSString *imageName;


+ (int) insert:(DishInfo *)dish;
+ (DishInfo *) selectByDishID:(NSString*)dishID;
+ (NSMutableArray *) selectAll;
+ (NSMutableArray *) selectAllByType :(NSString*)typeId;
+ (NSMutableArray *) selectAllByIsHot :(NSString*)isHot;
+ (NSMutableArray *) selectBySearchKey:(NSString*)searchText;
+ (int) delete;
+ (int) deleteImage;
+ (int) update:(DishInfo *)dish;
@end
