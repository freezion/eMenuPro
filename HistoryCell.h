//
//  HistoryCell.h
//  eMenuPro
//
//  Created by Li Feng on 14-3-13.
//  Copyright (c) 2014年 Gong Lingxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryCell : UITableViewCell


@property (nonatomic,retain) IBOutlet UIImageView *backG;
@property (nonatomic,retain) IBOutlet UILabel *deskNum;
@property (nonatomic,retain) IBOutlet UILabel *dishCount;
@property (nonatomic,retain) IBOutlet UILabel *totalPrice;
@property (nonatomic,retain) IBOutlet UILabel *orderTime;
@property (nonatomic,retain) IBOutlet UILabel *employee;

@end
