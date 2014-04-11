//
//  CustomDishViewController.h
//  eMenuPro
//
//  Created by Li Feng on 14-3-18.
//  Copyright (c) 2014年 Gong Lingxiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopCar.h"
#import <regex.h>

@protocol CustomDishViewDelegate <NSObject>
-(void)closeCustomDishView;
-(void)customToAddDish:(ShopCar*)dish;
@end

@interface CustomDishViewController : UIViewController<UITextFieldDelegate>


@property (nonatomic, retain) id<CustomDishViewDelegate> delegate;
@property (nonatomic, retain) IBOutlet UITextField *dishNameText;
@property (nonatomic, retain) IBOutlet UITextField *dishPriceText;
@property (nonatomic, retain) IBOutlet UITextField *dishMenuText;
@property (nonatomic, retain) IBOutlet UIImageView *backG;

-(IBAction)closeView:(id)sender;

-(IBAction)addDish:(id)sender;

@end
