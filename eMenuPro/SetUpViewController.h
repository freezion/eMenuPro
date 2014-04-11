//
//  SetUpViewController.h
//  eMenuPro
//
//  Created by Li Feng on 14-3-12.
//  Copyright (c) 2014年 Gong Lingxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SetUpViewDelegate <NSObject>
- (void)reSynchronous;
-(void)changeskin;
-(void)changeEmployee;
-(void)changeShop;
-(void)aboutUs;
-(void)closeSetUpView;
@end


@interface SetUpViewController : UIViewController

@property (nonatomic, retain) id<SetUpViewDelegate> delegate;

@property (nonatomic, retain) IBOutlet UIImageView *backG;
-(IBAction)SyncButton:(id)sender;
-(IBAction)skinButton:(id)sender;
-(IBAction)changeEmployeeButton:(id)sender;
-(IBAction)changeShopButton:(id)sender;
-(IBAction)aboutUsButton:(id)sender;

-(IBAction)closeView:(id)sender;
@end
