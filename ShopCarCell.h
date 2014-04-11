//
//  ShopCarCell.h
//  eMenuPro
//
//  Created by Li Feng on 14-3-11.
//  Copyright (c) 2014年 Gong Lingxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopCarCell : UITableViewCell

@property (nonatomic,retain) IBOutlet UILabel *dishID;
@property (nonatomic,retain) IBOutlet UILabel *dishUnit;
@property (nonatomic,retain) IBOutlet UILabel *dishPrice;
@property (nonatomic,retain) IBOutlet UIButton *minusButton;
@property (nonatomic,retain) IBOutlet UIButton *plusButton;
@property (nonatomic,retain) IBOutlet UITextField *dishCount;
@property (nonatomic,retain) IBOutlet UILabel *dishCountLab;

@property (nonatomic,retain) IBOutlet UILabel *dropDownList;
@property (nonatomic,retain) IBOutlet UILabel *dishSumUint;
@property (nonatomic,retain) IBOutlet UILabel *dishSumPrice;
@property (nonatomic,retain) IBOutlet UITextField *dishMenu;
@property (nonatomic,retain) IBOutlet UILabel *dishMenuLab;

@property (nonatomic,retain) IBOutlet UIButton *CancelButton;



@end
