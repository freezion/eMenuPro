//
//  Shop.h
//  eMenuPro
//
//  Created by Li Feng on 14-2-21.
//  Copyright (c) 2014年 Gong Lingxiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SystemUtil.h"
@interface Shop : NSObject{
    NSString *shopID;
    NSString *loginName;
    NSString *shopAddress;
    NSString *shopName;
    NSString *shopIco;
    NSString *shopSummary;
    NSString *shopPhone;
    NSString *shopAdvert;
}
@property (nonatomic,retain) NSString *shopID;
@property (nonatomic,retain) NSString *loginName;
@property (nonatomic,retain) NSString *shopAddress;
@property (nonatomic,retain) NSString *shopName;
@property (nonatomic,retain) NSString *shopIco;
@property (nonatomic,retain) NSString *shopSummary;
@property (nonatomic,retain) NSString *shopPhone;
@property (nonatomic,retain) NSString *shopAdvert;

//+ (int) delete:withKey:(NSString *)key withValue:(NSString *)value;
+ (int) insert:(Shop *)shop;
+ (Shop *) select:(NSString *) shopid;
+ (int) delete;
@end
