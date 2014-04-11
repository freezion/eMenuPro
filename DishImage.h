//
//  DishImage.h
//  eMenuPro
//
//  Created by Li Feng on 14-2-24.
//  Copyright (c) 2014年 Gong Lingxiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SystemUtil.h"
@interface DishImage : NSObject{
    NSString *imageID;
    NSString *dishID;
    NSString *imageName;
}

@property (nonatomic,retain) NSString *imageID;
@property (nonatomic,retain) NSString *dishID;
@property (nonatomic,retain) NSString *imageName;

+ (NSMutableArray *) selectAllImageName;

@end
