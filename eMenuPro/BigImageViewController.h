//
//  BigImageViewController.h
//  eMenuPro
//
//  Created by Li Feng on 14-4-9.
//  Copyright (c) 2014年 Gong Lingxiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopCar.h"
#import "DishInfo.h"

@protocol BigImageViewControllerDelegate <NSObject>
- (void) setBadge;
- (void)dismissDarkView;
@end

@interface BigImageViewController : UIViewController

@property (nonatomic, retain) id<BigImageViewControllerDelegate> delegate;
@property (nonatomic, retain) UIView *back;
@property (nonatomic) int partflag;
@property (nonatomic, retain) UIImageView *updownImage;
@property (nonatomic, retain) UITextView *memo;
@property (nonatomic, retain) UITextField *dishNum;
@property (nonatomic,retain) DishInfo *dishInfo;
@property (nonatomic,retain) NSString *dishID;

@end
