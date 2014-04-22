//
//  CustomDishViewController.m
//  eMenuPro
//
//  Created by Li Feng on 14-3-18.
//  Copyright (c) 2014年 Gong Lingxiao. All rights reserved.
//

#import "CustomDishViewController.h"
#define NUMBERS @"1234567890./n"

@interface CustomDishViewController ()

@end

@implementation CustomDishViewController
@synthesize dishMenuText;
@synthesize dishNameText;
@synthesize dishPriceText;

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
    [self.backG setBackgroundColor:[UIColor colorWithRed:210/255.0 green:210/255.0 blue:209/255.0 alpha:0.99]];
    UITapGestureRecognizer *noAction = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(noAction)];
    [self.backG addGestureRecognizer:noAction];
    [self.view setBackgroundColor:[UIColor clearColor]];
    dishNameText.delegate=self;
    dishPriceText.delegate=self;
    dishMenuText.delegate=self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)addDish:(id)sender{
    ShopCar *shopCar=[[ShopCar alloc]init];
    if ([dishNameText.text isEqualToString:@""] || dishNameText.text==nil){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"菜名不能为空，请重新输入菜名!" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    shopCar.dishName=dishNameText.text;
    
    
    if ([dishPriceText.text isEqualToString:@""] || dishPriceText.text==nil){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"单价不能为空，请重新输入单价!" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    NSString *regex = @"^[1-9]\\d*(\\.\\d{1,2})?|0\\.\\d?[1-9]$";
    NSPredicate *prd = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL canChange= [prd evaluateWithObject:dishPriceText.text];
    if (!canChange){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"单价不符合要求，请重新输入单价!" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    shopCar.dishPrice=dishPriceText.text;

    shopCar.memo=dishMenuText.text;
    if ([dishMenuText.text isEqualToString:@""] || dishMenuText.text==nil){
        shopCar.memo=@"";
    }
    shopCar.sellCount=@"1";
    shopCar.typeName=@"自定义";
    shopCar.dishID=@"";
    shopCar.dishUnit=@"份";
    shopCar.dishStatus=@"0";
    [self.delegate customToAddDish:shopCar];
}
- (void)noAction{
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.tag==10){
        if (range.location >= 24)
            return NO; // return NO to not change text
        return YES;

    }else if(textField.tag==11){
        NSCharacterSet *cs;
        cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS]invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs]componentsJoinedByString:@""];
        BOOL canChange = [string isEqualToString:filtered];
        
        if (range.location >= 8)
            return NO; // return NO to not change text
        return canChange;
    }else if(textField.tag==12){
        if (range.location >= 56)
            return NO; // return NO to not change text
        return YES;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];    //主要是[receiver resignFirstResponder]在哪调用就能把receiver对应的键盘往下收
    return YES;
}

-(IBAction)closeView:(id)sender{
    [self.delegate closeCustomDishView];
}
@end
