//
//  SetUpViewController.m
//  eMenuPro
//
//  Created by Li Feng on 14-3-12.
//  Copyright (c) 2014年 Gong Lingxiao. All rights reserved.
//

#import "SetUpViewController.h"

@interface SetUpViewController ()

@end

@implementation SetUpViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.view setFrame:CGRectMake(0, 0, 1024, 768)];
    [self.backG setBackgroundColor:[UIColor colorWithRed:210/255.0 green:210/255.0 blue:209/255.0 alpha:0.9]];
    UITapGestureRecognizer *noAction = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(noAction)];
    [self.backG addGestureRecognizer:noAction];
    [self.view setBackgroundColor:[UIColor clearColor]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)SyncButton:(id)sender{
    [self.delegate reSynchronous];
}
-(IBAction)skinButton:(id)sender{
    
}
-(IBAction)changeEmployeeButton:(id)sender{
    [self.delegate changeEmployee];
}
-(IBAction)changeShopButton:(id)sender{
    [self.delegate changeShop];
}
-(IBAction)aboutUsButton:(id)sender{
    NSString *iTunesLink;
    iTunesLink = @"http://www.0519517.cn/";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
}

-(IBAction)closeView:(id)sender{
    [self.delegate closeSetUpView];
}

- (void)noAction{
}


@end
