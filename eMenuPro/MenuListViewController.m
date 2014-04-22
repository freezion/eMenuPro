//
//  MenuListViewController.m
//  eMenuPro
//
//  Created by Li Feng on 14-3-6.
//  Copyright (c) 2014年 Gong Lingxiao. All rights reserved.
//

#import "MenuListViewController.h"

@interface MenuListViewController ()

@end

@implementation MenuListViewController
@synthesize page;
@synthesize pageList;
@synthesize hotDish;
@synthesize back;
@synthesize updownImage;
@synthesize hotdishNum;
@synthesize memo;
@synthesize partdishCount;
@synthesize partflag;


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
    [self.view setFrame:CGRectMake(0, 0, 1024, 595)];
    if (hotDish==0){
        [self.view addSubview:[self createHotImage]];
    }else{
        [self createPageView];
    }
	// Do any additional setup after loading the view.
}

-(void) createPageView{
    for (int i=0; i<pageList.count; i++) {
    [self.view addSubview:[self createImage:i]];
    }
}

-(UIImageView*) createHotImage{

    DishInfo *dishInfo =[pageList objectAtIndex:0];
    if ([dishInfo.smallDishPrice isEqualToString:@"0"] || [dishInfo.bigDishPrice isEqualToString:@"0"]  ||[dishInfo.smallDishPrice isEqualToString:@""] || [dishInfo.bigDishPrice isEqualToString:@""]){
        ShopCar *shopCar=[[ShopCar alloc]init];
        shopCar=[ShopCar selectWithPrice:dishInfo.dishID withPrice:dishInfo.dishPrice];
        partflag=2;
        UIImageView *imageView;
        UIImage *img;
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSMutableString *uniquePath = [[NSMutableString alloc] init];
        [uniquePath appendString:[paths objectAtIndex:0]];
        [uniquePath appendString:@"/"];
        [uniquePath appendString:dishInfo.imageName];
        img=[[UIImage alloc]initWithContentsOfFile:uniquePath];
        if (img==nil){
            img=[UIImage imageNamed:@"nopic.jpg"];
        }
        imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 1024, 595)];
        imageView.image=img;
        imageView.userInteractionEnabled = YES;
        imageView.tag=1;
        back=[[UIView alloc] initWithFrame:CGRectMake(0, 515, 1024, 95)];
        back.tag=50;
        [back setBackgroundColor: [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.5]];
        UILabel *dishId=[[UILabel alloc]initWithFrame:CGRectMake(20, 10, 100, 25)];
        UILabel *dishName=[[UILabel alloc]initWithFrame:CGRectMake(45, 40, 200, 30)];
        updownImage=[[UIImageView alloc]initWithFrame:CGRectMake(490, 8, 67, 13)];
        UIButton *minusBtn=[[UIButton alloc]initWithFrame:CGRectMake(770, 32, 38, 38)];
        UIButton *plusBtn=[[UIButton alloc]initWithFrame:CGRectMake(950, 32, 38, 38)];
        hotdishNum=[[UITextField alloc]initWithFrame:CGRectMake(830, 32, 100, 38)];
        memo=[[UITextView alloc]initWithFrame:CGRectMake(45, 80, 930,90)];
        memo.textColor=[UIColor whiteColor];
        memo.backgroundColor=[UIColor clearColor];
        memo.font=[UIFont  systemFontOfSize:25];
        memo.scrollEnabled=YES;
        memo.text=dishInfo.dishMemo;
        memo.editable=NO;
        UILabel *dishUnitLab = [[UILabel alloc] initWithFrame: CGRectMake(270, 32, 30, 50)];
        dishUnitLab.text=@"￥";
        dishUnitLab.textColor=[UIColor whiteColor];
        dishUnitLab.font=[UIFont systemFontOfSize:25];
        dishUnitLab.backgroundColor=[UIColor clearColor];
        UILabel *dishPriceLab = [[UILabel alloc] initWithFrame: CGRectMake(295, 30, 100, 50)];
        dishPriceLab.text=dishInfo.dishPrice;
        dishPriceLab.textColor=[UIColor whiteColor];
        dishPriceLab.font=[UIFont systemFontOfSize:33];
        dishPriceLab.backgroundColor=[UIColor clearColor];
        dishId.text=dishInfo.dishCode;
        dishId.textColor=[UIColor whiteColor];
        dishId.backgroundColor=[UIColor clearColor];
        dishId.font=[UIFont  systemFontOfSize:20];
        dishName.text=dishInfo.dishName;
        dishName.textColor=[UIColor whiteColor];
        dishName.backgroundColor=[UIColor clearColor];
        dishName.font=[UIFont  systemFontOfSize:32];
        [minusBtn setBackgroundImage:[UIImage imageNamed:@"RecommendMinus"] forState:UIControlStateNormal];
        [minusBtn addTarget:self action:@selector(minusHotDish:) forControlEvents:UIControlEventTouchUpInside];
        [plusBtn setBackgroundImage:[UIImage imageNamed:@"RecommendPlus"] forState:UIControlStateNormal];
        [plusBtn addTarget:self action:@selector(plusHotDish:) forControlEvents:UIControlEventTouchUpInside];
        hotdishNum.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.3];
        hotdishNum.textColor=[UIColor whiteColor];
        hotdishNum.font=[UIFont  systemFontOfSize:30];
        //textField居中对齐
        hotdishNum.textAlignment=NSTextAlignmentCenter;
        hotdishNum.tag=5;
        if (shopCar!=nil){
            hotdishNum.text=shopCar.sellCount;
        }
        hotdishNum.enabled=NO;
        updownImage.image=[UIImage imageNamed:@"upButton"];
        updownImage.alpha=0.3;
        if ([dishInfo.stock intValue]==0){
            UIImageView *soldOutImg=[[UIImageView alloc]initWithFrame:CGRectMake(600, 150, 340, 340)];
            [soldOutImg setImage:[UIImage imageNamed:@"soldOutImgHot"]];
            [imageView addSubview:soldOutImg];
        }
        
        UITapGestureRecognizer *tapGestureDark = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissDarkViewDark:)];
        [back addSubview:updownImage];
        [back addSubview:dishId];
        [back addSubview:dishName];
        [back addSubview:minusBtn];
        [back addSubview:plusBtn];
        [back addSubview:hotdishNum];
        [back addSubview:dishUnitLab];
        [back addSubview:dishPriceLab];
        [back addGestureRecognizer:tapGestureDark];
        UIImageView *recommend=[[UIImageView alloc]initWithFrame:CGRectMake(30, 0, 68, 133)];
        recommend.image=[UIImage imageNamed:@"Recommend"];
        [imageView addSubview:recommend];
        [imageView addSubview:back];
        return imageView;

    }else{
        if ([dishInfo.dishPrice isEqualToString:@""]||[dishInfo.dishPrice isEqualToString:@"0"]){
            ShopCar *shopCar=[[ShopCar alloc]init];
            partflag=1;
            shopCar=[ShopCar selectWithPrice:dishInfo.dishID withPrice:dishInfo.smallDishPrice];
            int x=260;
            int y=45;
            int dishUnitfontSize=18;
            int dishPricefontSize=24;
            int dishPartfontSize=18;
            int dishPartPointy=45;
            int dishPartFramex=40;
            int dishPartFramey=20;
            UIColor *dishPartfontColor=[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1];
            
            UIImageView *imageView;
            UIImage *img;
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
            NSMutableString *uniquePath = [[NSMutableString alloc] init];
            [uniquePath appendString:[paths objectAtIndex:0]];
            [uniquePath appendString:@"/"];
            [uniquePath appendString:dishInfo.imageName];
            img=[[UIImage alloc]initWithContentsOfFile:uniquePath];
            if (img==nil){
                img=[UIImage imageNamed:@"nopic.jpg"];
            }
            imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 1024, 595)];
            imageView.image=img;
            imageView.userInteractionEnabled = YES;
            imageView.tag=1;
            back=[[UIView alloc] initWithFrame:CGRectMake(0, 515, 1024, 95)];
            back.tag=50;
            [back setBackgroundColor: [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.5]];
            UILabel *dishId=[[UILabel alloc]initWithFrame:CGRectMake(20, 10, 100, 25)];
            UILabel *dishName=[[UILabel alloc]initWithFrame:CGRectMake(45, 40, 200, 30)];
            dishUnitfontSize=28;
            dishPricefontSize=40;
            dishPartfontSize=26;
            dishPartPointy=35;
            dishPartFramex=60;
            dishPartFramey=30;
            dishPartfontColor=[UIColor colorWithRed:233/255.0 green:80/255.0 blue:20/255.0 alpha:1];
            x=260;
            y=40;
            UILabel *dishUnit1;
            UILabel *dishPrice1;
            UIButton *dishPart1;
            dishUnit1=[[UILabel alloc]initWithFrame:CGRectMake(x, y, 30, 30)];
            dishUnit1.text=@"￥";
            dishUnit1.font=[UIFont  systemFontOfSize:dishUnitfontSize];
            dishUnit1.textColor=[UIColor whiteColor];
            dishUnit1.backgroundColor=[UIColor clearColor];
            dishPrice1 = [[UILabel alloc] initWithFrame:CGRectMake(0,0,0,0)];
            [dishPrice1 setFrame:CGRectMake(x+dishUnitfontSize, y-5, [self getAppropriateSize:dishInfo.dishPrice withFontSize:dishPricefontSize], 30)];
            dishPrice1.text=dishInfo.smallDishPrice;
            dishPrice1.textColor=[UIColor whiteColor];
            dishPrice1.backgroundColor=[UIColor clearColor];
            dishPrice1.font=[UIFont  systemFontOfSize:dishPricefontSize];
            dishPart1=[[UIButton alloc]initWithFrame:CGRectMake(dishPrice1.frame.size.width+dishPrice1.frame.origin.x+5, dishPartPointy, dishPartFramex, dishPartFramey)];
            [dishPart1 addTarget:self action:@selector(dishPart1:) forControlEvents:UIControlEventTouchUpInside];
            [dishPart1 setTitle:@"小份" forState:UIControlStateNormal];
            [dishPart1 setBackgroundColor:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.5]];
            dishPart1.titleLabel.font=[UIFont  systemFontOfSize:dishPartfontSize];
            [dishPart1 setTitleColor:dishPartfontColor forState:UIControlStateNormal];
            dishUnit1.tag=10;
            dishPrice1.tag=11;
            dishPart1.tag=12;
            [back addSubview:dishUnit1];
            [back addSubview:dishPrice1];
            [back addSubview:dishPart1];
            
            UILabel *dishUnit3;
            UILabel *dishPrice3;
            UIButton *dishPart3;
            x=dishPart1.frame.size.width+dishPart1.frame.origin.x+5;;
            y=45;
            dishUnitfontSize=18;
            dishPricefontSize=24;
            dishPartfontSize=18;
            dishPartPointy=45;
            dishPartFramex=40;
            dishPartFramey=20;
            dishPartfontColor=[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1];
            dishUnit3=[[UILabel alloc]initWithFrame:CGRectMake(x, y, 30, 30)];
            dishUnit3.text=@"￥";
            dishUnit3.font=[UIFont  systemFontOfSize:dishUnitfontSize];
            dishUnit3.textColor=[UIColor whiteColor];
            dishUnit3.backgroundColor=[UIColor clearColor];
            dishPrice3 = [[UILabel alloc] initWithFrame:CGRectMake(0,0,0,0)];
            [dishPrice3 setFrame:CGRectMake(x+dishUnitfontSize, y-5, [self getAppropriateSize:dishInfo.dishPrice withFontSize:dishPricefontSize], 30)];
            dishPrice3.text=dishInfo.bigDishPrice;
            dishPrice3.textColor=[UIColor whiteColor];
            dishPrice3.backgroundColor=[UIColor clearColor];
            dishPrice3.font=[UIFont  systemFontOfSize:dishPricefontSize];
            dishPart3=[[UIButton alloc]initWithFrame:CGRectMake(dishPrice3.frame.size.width+dishPrice3.frame.origin.x+5, dishPartPointy, dishPartFramex, dishPartFramey)];
            [dishPart3 addTarget:self action:@selector(dishPart3:) forControlEvents:UIControlEventTouchUpInside];
            [dishPart3 setTitle:@"大份" forState:UIControlStateNormal];
            [dishPart3 setBackgroundColor:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.5]];
            dishPart3.titleLabel.font=[UIFont  systemFontOfSize:dishPartfontSize];
            [dishPart3 setTitleColor:dishPartfontColor forState:UIControlStateNormal];
            dishUnit3.tag=30;
            dishPrice3.tag=31;
            dishPart3.tag=32;
            [back addSubview:dishUnit3];
            [back addSubview:dishPrice3];
            [back addSubview:dishPart3];
        
            
            updownImage=[[UIImageView alloc]initWithFrame:CGRectMake(490, 8, 67, 13)];
            UIButton *minusBtn=[[UIButton alloc]initWithFrame:CGRectMake(770, 32, 38, 38)];
            UIButton *plusBtn=[[UIButton alloc]initWithFrame:CGRectMake(950, 32, 38, 38)];
            hotdishNum=[[UITextField alloc]initWithFrame:CGRectMake(830, 32, 100, 38)];
            memo=[[UITextView alloc]initWithFrame:CGRectMake(45, 80, 930,90)];
            memo.textColor=[UIColor whiteColor];
            memo.backgroundColor=[UIColor clearColor];
            memo.font=[UIFont  systemFontOfSize:25];
            memo.scrollEnabled=YES;
            memo.text=dishInfo.dishMemo;
            memo.editable=NO;
            
            dishId.text=dishInfo.dishCode;
            dishId.textColor=[UIColor whiteColor];
            dishId.backgroundColor=[UIColor clearColor];
            dishId.font=[UIFont  systemFontOfSize:20];
            dishName.text=dishInfo.dishName;
            dishName.textColor=[UIColor whiteColor];
            dishName.backgroundColor=[UIColor clearColor];
            dishName.font=[UIFont  systemFontOfSize:32];
            [minusBtn setBackgroundImage:[UIImage imageNamed:@"RecommendMinus"] forState:UIControlStateNormal];
            [minusBtn addTarget:self action:@selector(minusHotDish:) forControlEvents:UIControlEventTouchUpInside];
            [plusBtn setBackgroundImage:[UIImage imageNamed:@"RecommendPlus"] forState:UIControlStateNormal];
            [plusBtn addTarget:self action:@selector(plusHotDish:) forControlEvents:UIControlEventTouchUpInside];
            hotdishNum.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.3];
            hotdishNum.textColor=[UIColor whiteColor];
            hotdishNum.font=[UIFont  systemFontOfSize:30];
            //textField居中对齐
            hotdishNum.textAlignment=NSTextAlignmentCenter;
            hotdishNum.tag=5;
            if (shopCar!=nil){
                hotdishNum.text=shopCar.sellCount;
            }
            hotdishNum.enabled=NO;
            updownImage.image=[UIImage imageNamed:@"upButton"];
            updownImage.alpha=0.3;
            UITapGestureRecognizer *tapGestureDark = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissDarkViewDark:)];
            
            if ([dishInfo.stock intValue]==0){
                UIImageView *soldOutImg=[[UIImageView alloc]initWithFrame:CGRectMake(600, 150, 340, 340)];
                [soldOutImg setImage:[UIImage imageNamed:@"soldOutImgHot"]];
                [imageView addSubview:soldOutImg];
            }
            [back addSubview:updownImage];
            [back addSubview:dishId];
            [back addSubview:dishName];
            [back addSubview:minusBtn];
            [back addSubview:plusBtn];
            [back addSubview:hotdishNum];
            [back addGestureRecognizer:tapGestureDark];
            UIImageView *recommend=[[UIImageView alloc]initWithFrame:CGRectMake(30, 0, 68, 133)];
            recommend.image=[UIImage imageNamed:@"Recommend"];
            [imageView addSubview:recommend];
            [imageView addSubview:back];
            return imageView;
        }else{
            partflag=2;
            ShopCar *shopCar=[[ShopCar alloc]init];
            shopCar=[ShopCar selectWithPrice:dishInfo.dishID withPrice:dishInfo.dishPrice];

            int x=260;
            int y=45;
            int dishUnitfontSize=18;
            int dishPricefontSize=24;
            int dishPartfontSize=18;
            int dishPartPointy=45;
            int dishPartFramex=40;
            int dishPartFramey=20;
            UIColor *dishPartfontColor=[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1];
        
            UIImageView *imageView;
            UIImage *img;
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
            NSMutableString *uniquePath = [[NSMutableString alloc] init];
            [uniquePath appendString:[paths objectAtIndex:0]];
            [uniquePath appendString:@"/"];
            [uniquePath appendString:dishInfo.imageName];
            img=[[UIImage alloc]initWithContentsOfFile:uniquePath];
            if (img==nil){
                img=[UIImage imageNamed:@"nopic.jpg"];
            }
            imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 1024, 595)];
            imageView.image=img;
            imageView.userInteractionEnabled = YES;
            imageView.tag=1;
            back=[[UIView alloc] initWithFrame:CGRectMake(0, 515, 1024, 95)];
            back.tag=50;
            [back setBackgroundColor: [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.5]];
            UILabel *dishId=[[UILabel alloc]initWithFrame:CGRectMake(20, 10, 100, 25)];
            UILabel *dishName=[[UILabel alloc]initWithFrame:CGRectMake(45, 40, 200, 30)];
            
            UILabel *dishUnit1;
            UILabel *dishPrice1;
            UIButton *dishPart1;
                dishUnit1=[[UILabel alloc]initWithFrame:CGRectMake(x, y, 30, 30)];
                dishUnit1.text=@"￥";
                dishUnit1.font=[UIFont  systemFontOfSize:dishUnitfontSize];
                dishUnit1.textColor=[UIColor whiteColor];
                dishUnit1.backgroundColor=[UIColor clearColor];
                dishPrice1 = [[UILabel alloc] initWithFrame:CGRectMake(0,0,0,0)];
                [dishPrice1 setFrame:CGRectMake(x+dishUnitfontSize, y-5, [self getAppropriateSize:dishInfo.dishPrice withFontSize:dishPricefontSize], 30)];
                dishPrice1.text=dishInfo.smallDishPrice;
                dishPrice1.textColor=[UIColor whiteColor];
                dishPrice1.backgroundColor=[UIColor clearColor];
                dishPrice1.font=[UIFont  systemFontOfSize:dishPricefontSize];
                dishPart1=[[UIButton alloc]initWithFrame:CGRectMake(dishPrice1.frame.size.width+dishPrice1.frame.origin.x+5, dishPartPointy, dishPartFramex, dishPartFramey)];
                [dishPart1 addTarget:self action:@selector(dishPart1:) forControlEvents:UIControlEventTouchUpInside];
                [dishPart1 setTitle:@"小份" forState:UIControlStateNormal];
                [dishPart1 setBackgroundColor:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.5]];
                dishPart1.titleLabel.font=[UIFont  systemFontOfSize:dishPartfontSize];
                [dishPart1 setTitleColor:dishPartfontColor forState:UIControlStateNormal];
                dishUnit1.tag=10;
                dishPrice1.tag=11;
                dishPart1.tag=12;
                [back addSubview:dishUnit1];
                [back addSubview:dishPrice1];
                [back addSubview:dishPart1];
            UILabel *dishUnit2;
            UILabel *dishPrice2;
            UIButton *dishPart2;
                    dishUnitfontSize=28;
                    dishPricefontSize=40;
                    dishPartfontSize=26;
                    dishPartPointy=35;
                    dishPartFramex=60;
                    dishPartFramey=30;
                    dishPartfontColor=[UIColor colorWithRed:233/255.0 green:80/255.0 blue:20/255.0 alpha:1];
                    x=dishPart1.frame.size.width+dishPart1.frame.origin.x+5;
                    y=40;
                dishUnit2=[[UILabel alloc]initWithFrame:CGRectMake(x, y, 30, 30)];
                dishUnit2.text=@"￥";
                dishUnit2.font=[UIFont  systemFontOfSize:dishUnitfontSize];
                dishUnit2.textColor=[UIColor whiteColor];
                dishUnit2.backgroundColor=[UIColor clearColor];
                dishPrice2 = [[UILabel alloc] initWithFrame:CGRectMake(0,0,0,0)];
                [dishPrice2 setFrame:CGRectMake(x+dishUnitfontSize, y-5, [self getAppropriateSize:dishInfo.dishPrice withFontSize:dishPricefontSize], 30)];
                dishPrice2.text=dishInfo.dishPrice;
                dishPrice2.textColor=[UIColor whiteColor];
                dishPrice2.backgroundColor=[UIColor clearColor];
                dishPrice2.font=[UIFont  systemFontOfSize:dishPricefontSize];
                dishPart2=[[UIButton alloc]initWithFrame:CGRectMake(dishPrice2.frame.size.width+dishPrice2.frame.origin.x+5, dishPartPointy, dishPartFramex, dishPartFramey)];
                [dishPart2 addTarget:self action:@selector(dishPart2:) forControlEvents:UIControlEventTouchUpInside];
                [dishPart2 setTitle:@"中份" forState:UIControlStateNormal];
                [dishPart2 setBackgroundColor:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.5]];
                dishPart2.titleLabel.font=[UIFont  systemFontOfSize:dishPartfontSize];
                [dishPart2 setTitleColor:dishPartfontColor forState:UIControlStateNormal];
                dishPrice2.tag=21;
                dishUnit2.tag=20;
                dishPart2.tag=22;
                [back addSubview:dishUnit2];
                [back addSubview:dishPrice2];
                [back addSubview:dishPart2];
            UILabel *dishUnit3;
            UILabel *dishPrice3;
            UIButton *dishPart3;
                    x=dishPart2.frame.size.width+dishPart2.frame.origin.x+5;;
                    y=45;
                    dishUnitfontSize=18;
                    dishPricefontSize=24;
                    dishPartfontSize=18;
                    dishPartPointy=45;
                    dishPartFramex=40;
                    dishPartFramey=20;
                    dishPartfontColor=[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1];
                dishUnit3=[[UILabel alloc]initWithFrame:CGRectMake(x, y, 30, 30)];
                dishUnit3.text=@"￥";
                dishUnit3.font=[UIFont  systemFontOfSize:dishUnitfontSize];
                dishUnit3.textColor=[UIColor whiteColor];
                dishUnit3.backgroundColor=[UIColor clearColor];
                dishPrice3 = [[UILabel alloc] initWithFrame:CGRectMake(0,0,0,0)];
                [dishPrice3 setFrame:CGRectMake(x+dishUnitfontSize, y-5, [self getAppropriateSize:dishInfo.dishPrice withFontSize:dishPricefontSize], 30)];
                dishPrice3.text=dishInfo.bigDishPrice;
                dishPrice3.textColor=[UIColor whiteColor];
                dishPrice3.backgroundColor=[UIColor clearColor];
                dishPrice3.font=[UIFont  systemFontOfSize:dishPricefontSize];
                dishPart3=[[UIButton alloc]initWithFrame:CGRectMake(dishPrice3.frame.size.width+dishPrice3.frame.origin.x+5, dishPartPointy, dishPartFramex, dishPartFramey)];
                [dishPart3 addTarget:self action:@selector(dishPart3:) forControlEvents:UIControlEventTouchUpInside];
                [dishPart3 setTitle:@"大份" forState:UIControlStateNormal];
                [dishPart3 setBackgroundColor:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.5]];
                dishPart3.titleLabel.font=[UIFont  systemFontOfSize:dishPartfontSize];
                [dishPart3 setTitleColor:dishPartfontColor forState:UIControlStateNormal];
                dishUnit3.tag=30;
                dishPrice3.tag=31;
                dishPart3.tag=32;
                [back addSubview:dishUnit3];
                [back addSubview:dishPrice3];
                [back addSubview:dishPart3];
            
            updownImage=[[UIImageView alloc]initWithFrame:CGRectMake(490, 8, 67, 13)];
            UIButton *minusBtn=[[UIButton alloc]initWithFrame:CGRectMake(770, 32, 38, 38)];
            UIButton *plusBtn=[[UIButton alloc]initWithFrame:CGRectMake(950, 32, 38, 38)];
            hotdishNum=[[UITextField alloc]initWithFrame:CGRectMake(830, 32, 100, 38)];
            memo=[[UITextView alloc]initWithFrame:CGRectMake(45, 80, 930,90)];
            memo.textColor=[UIColor whiteColor];
            memo.backgroundColor=[UIColor clearColor];
            memo.font=[UIFont  systemFontOfSize:25];
            memo.scrollEnabled=YES;
            memo.text=dishInfo.dishMemo;
            memo.editable=NO;
            
            dishId.text=dishInfo.dishCode;
            dishId.textColor=[UIColor whiteColor];
            dishId.backgroundColor=[UIColor clearColor];
            dishId.font=[UIFont  systemFontOfSize:20];
            dishName.text=dishInfo.dishName;
            dishName.textColor=[UIColor whiteColor];
            dishName.backgroundColor=[UIColor clearColor];
            dishName.font=[UIFont  systemFontOfSize:32];
            [minusBtn setBackgroundImage:[UIImage imageNamed:@"RecommendMinus"] forState:UIControlStateNormal];
            [minusBtn addTarget:self action:@selector(minusHotDish:) forControlEvents:UIControlEventTouchUpInside];
            [plusBtn setBackgroundImage:[UIImage imageNamed:@"RecommendPlus"] forState:UIControlStateNormal];
            [plusBtn addTarget:self action:@selector(plusHotDish:) forControlEvents:UIControlEventTouchUpInside];
            hotdishNum.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.3];
            hotdishNum.textColor=[UIColor whiteColor];
            hotdishNum.font=[UIFont  systemFontOfSize:30];
            //textField居中对齐
            hotdishNum.textAlignment=NSTextAlignmentCenter;
            hotdishNum.tag=5;
            if (shopCar!=nil){
                hotdishNum.text=shopCar.sellCount;
            }
            hotdishNum.enabled=NO;
            updownImage.image=[UIImage imageNamed:@"upButton"];
            updownImage.alpha=0.3;
            UITapGestureRecognizer *tapGestureDark = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissDarkViewDark:)];
            
            if ([dishInfo.stock intValue]==0){
                UIImageView *soldOutImg=[[UIImageView alloc]initWithFrame:CGRectMake(600, 150, 340, 340)];
                [soldOutImg setImage:[UIImage imageNamed:@"soldOutImgHot"]];
                [imageView addSubview:soldOutImg];
            }
            [back addSubview:updownImage];
            [back addSubview:dishId];
            [back addSubview:dishName];
            [back addSubview:minusBtn];
            [back addSubview:plusBtn];
            [back addSubview:hotdishNum];
            [back addGestureRecognizer:tapGestureDark];
            UIImageView *recommend=[[UIImageView alloc]initWithFrame:CGRectMake(30, 0, 68, 133)];
            recommend.image=[UIImage imageNamed:@"Recommend"];
            [imageView addSubview:recommend];
            [imageView addSubview:back];
            return imageView;
        }
        }
}



-(void) dishPart1:(UIButton*)sender{
    UILabel *dishUnit1;
    UILabel *dishPrice1;
    UIButton *dishPart1;
    UILabel *dishUnit2;
    UILabel *dishPrice2;
    UIButton *dishPart2;
    UILabel *dishUnit3;
    UILabel *dishPrice3;
    UIButton *dishPart3;
    int x=260;
    int y=45;
    int dishUnitfontSize=18;
    int dishPricefontSize=24;
    int dishPartfontSize=18;
    int dishPartPointy=45;
    int dishPartFramex=40;
    int dishPartFramey=20;
    UIColor *dishPartfontColor=[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1];
    DishInfo *dishInfo =[pageList objectAtIndex:0];
    ShopCar *shopCar=[ShopCar selectWithPrice:dishInfo.dishID withPrice:dishInfo.smallDishPrice ];
    hotdishNum.text=shopCar.sellCount;
    partflag=1;
    for (id obj in back.subviews){
        if ([obj isKindOfClass:[UILabel class]])
        {
            if (((UILabel*)obj).tag==10){
                dishUnit1=(UILabel*)obj;
            }
            if (((UILabel*)obj).tag==20){
                dishUnit2=(UILabel*)obj;
            }
            if (((UILabel*)obj).tag==30){
                dishUnit3=(UILabel*)obj;
            }
            if (((UILabel*)obj).tag==11){
                dishPrice1=(UILabel*)obj;
            }
            if (((UILabel*)obj).tag==21){
                dishPrice2=(UILabel*)obj;
            }
            if (((UILabel*)obj).tag==31){
                dishPrice3=(UILabel*)obj;
            }
        }else if ([obj isKindOfClass:[UIButton class]]){
            if (((UIButton*)obj).tag==12){
                dishPart1=(UIButton*)obj;
            }
            if (((UIButton*)obj).tag==22){
                dishPart2=(UIButton*)obj;
            }
            if (((UIButton*)obj).tag==32){
                dishPart3=(UIButton*)obj;
            }
        }
    }
    dishUnitfontSize=28;
    dishPricefontSize=40;
    dishPartfontSize=26;
    dishPartPointy=35;
    dishPartFramex=60;
    dishPartFramey=30;
    x=260;
    y=40;
    dishUnit1.frame=CGRectMake(x, y, 30, 30);
    dishUnit1.font=[UIFont  systemFontOfSize:dishUnitfontSize];
    dishUnit1.textColor=[UIColor whiteColor];
    dishPrice1.frame=CGRectMake(0,0,0,0);
    [dishPrice1 setFrame:CGRectMake(x+dishUnitfontSize, y-5, [self getAppropriateSize:dishInfo.dishPrice withFontSize:dishPricefontSize], 30)];
    dishPrice1.textColor=[UIColor whiteColor];
    dishPrice1.font=[UIFont  systemFontOfSize:dishPricefontSize];
    dishPart1.frame=CGRectMake(dishPrice1.frame.size.width+dishPrice1.frame.origin.x+5, dishPartPointy, dishPartFramex, dishPartFramey);
    dishPart1.titleLabel.font=[UIFont  systemFontOfSize:dishPartfontSize];
    [dishPart1 setTitleColor:[UIColor colorWithRed:233/255.0 green:80/255.0 blue:20/255.0 alpha:1] forState:UIControlStateNormal];
    
    
    x=dishPart1.frame.size.width+dishPart1.frame.origin.x+5;
    y=45;
    dishUnitfontSize=18;
    dishPricefontSize=24;
    dishPartfontSize=18;
    dishPartPointy=45;
    dishPartFramex=40;
    dishPartFramey=20;
    dishUnit2.frame=CGRectMake(x, y, 30, 30);
    dishUnit2.font=[UIFont  systemFontOfSize:dishUnitfontSize];
    dishUnit2.textColor=[UIColor whiteColor];
    dishPrice2.frame=CGRectMake(0,0,0,0);
    [dishPrice2 setFrame:CGRectMake(x+dishUnitfontSize, y-5, [self getAppropriateSize:dishInfo.dishPrice withFontSize:dishPricefontSize], 30)];
    dishPrice2.textColor=[UIColor whiteColor];
    dishPrice2.font=[UIFont  systemFontOfSize:dishPricefontSize];
    dishPart2.frame=CGRectMake(dishPrice2.frame.size.width+dishPrice2.frame.origin.x+5, dishPartPointy, dishPartFramex, dishPartFramey);
    dishPart2.titleLabel.font=[UIFont  systemFontOfSize:dishPartfontSize];
    [dishPart2 setTitleColor:dishPartfontColor forState:UIControlStateNormal];

    x=dishPart2.frame.size.width+dishPart2.frame.origin.x+5;
    if (dishPart2.frame.size.width==0){
        x=dishPart1.frame.size.width+dishPart1.frame.origin.x+5;
    }
    y=45;
    dishUnitfontSize=18;
    dishPricefontSize=24;
    dishPartfontSize=18;
    dishPartPointy=45;
    dishPartFramex=40;
    dishPartFramey=20;
    dishUnit3.frame=CGRectMake(x, y, 30, 30);
    dishUnit3.font=[UIFont  systemFontOfSize:dishUnitfontSize];
    dishUnit3.textColor=[UIColor whiteColor];
    dishPrice3.frame=CGRectMake(0,0,0,0);
    [dishPrice3 setFrame:CGRectMake(x+dishUnitfontSize, y-5, [self getAppropriateSize:dishInfo.dishPrice withFontSize:dishPricefontSize], 30)];
    dishPrice3.textColor=[UIColor whiteColor];
    dishPrice3.font=[UIFont  systemFontOfSize:dishPricefontSize];
    dishPart3.frame=CGRectMake(dishPrice3.frame.size.width+dishPrice3.frame.origin.x+5, dishPartPointy, dishPartFramex, dishPartFramey);
    dishPart3.titleLabel.font=[UIFont  systemFontOfSize:dishPartfontSize];
    [dishPart3 setTitleColor:dishPartfontColor forState:UIControlStateNormal];
    
}
-(void) dishPart2:(UIButton*)sender{
    UILabel *dishUnit1;
    UILabel *dishPrice1;
    UIButton *dishPart1;
    UILabel *dishUnit2;
    UILabel *dishPrice2;
    UIButton *dishPart2;
    UILabel *dishUnit3;
    UILabel *dishPrice3;
    UIButton *dishPart3;
    int x=260;
    int y=45;
    int dishUnitfontSize=18;
    int dishPricefontSize=24;
    int dishPartfontSize=18;
    int dishPartPointy=45;
    int dishPartFramex=40;
    int dishPartFramey=20;
    UIColor *dishPartfontColor=[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1];
    DishInfo *dishInfo =[pageList objectAtIndex:0];
    ShopCar *shopCar=[ShopCar selectWithPrice:dishInfo.dishID withPrice:dishInfo.dishPrice ];
    hotdishNum.text=shopCar.sellCount;
    partflag=2;
    for (id obj in back.subviews){
        if ([obj isKindOfClass:[UILabel class]])
        {
            if (((UILabel*)obj).tag==10){
                dishUnit1=(UILabel*)obj;
            }
            if (((UILabel*)obj).tag==20){
                dishUnit2=(UILabel*)obj;
            }
            if (((UILabel*)obj).tag==30){
                dishUnit3=(UILabel*)obj;
            }
            if (((UILabel*)obj).tag==11){
                dishPrice1=(UILabel*)obj;
            }
            if (((UILabel*)obj).tag==21){
                dishPrice2=(UILabel*)obj;
            }
            if (((UILabel*)obj).tag==31){
                dishPrice3=(UILabel*)obj;
            }
        }else if ([obj isKindOfClass:[UIButton class]]){
            if (((UIButton*)obj).tag==12){
                dishPart1=(UIButton*)obj;
            }
            if (((UIButton*)obj).tag==22){
                dishPart2=(UIButton*)obj;
            }
            if (((UIButton*)obj).tag==32){
                dishPart3=(UIButton*)obj;
            }
        }
    }
    dishUnit1.frame=CGRectMake(x, y, 30, 30);
    dishUnit1.font=[UIFont  systemFontOfSize:dishUnitfontSize];
    dishUnit1.textColor=[UIColor whiteColor];
    dishPrice1.frame=CGRectMake(0,0,0,0);
    [dishPrice1 setFrame:CGRectMake(x+dishUnitfontSize, y-5, [self getAppropriateSize:dishInfo.dishPrice withFontSize:dishPricefontSize], 30)];
    dishPrice1.textColor=[UIColor whiteColor];
    dishPrice1.font=[UIFont  systemFontOfSize:dishPricefontSize];
    dishPart1.frame=CGRectMake(dishPrice1.frame.size.width+dishPrice1.frame.origin.x+5, dishPartPointy, dishPartFramex, dishPartFramey);
    dishPart1.titleLabel.font=[UIFont  systemFontOfSize:dishPartfontSize];
    [dishPart1 setTitleColor:dishPartfontColor forState:UIControlStateNormal];
    
    
    x=dishPart1.frame.size.width+dishPart1.frame.origin.x+5;;
    dishUnitfontSize=28;
    dishPricefontSize=40;
    dishPartfontSize=26;
    dishPartPointy=35;
    dishPartFramex=60;
    dishPartFramey=30;
    y=40;
    dishUnit2.frame=CGRectMake(x, y, 30, 30);
    dishUnit2.font=[UIFont  systemFontOfSize:dishUnitfontSize];
    dishUnit2.textColor=[UIColor whiteColor];
    dishPrice2.frame=CGRectMake(0,0,0,0);
    [dishPrice2 setFrame:CGRectMake(x+dishUnitfontSize, y-5, [self getAppropriateSize:dishInfo.dishPrice withFontSize:dishPricefontSize], 30)];
    dishPrice2.textColor=[UIColor whiteColor];
    dishPrice2.font=[UIFont  systemFontOfSize:dishPricefontSize];
    dishPart2.frame=CGRectMake(dishPrice2.frame.size.width+dishPrice2.frame.origin.x+5, dishPartPointy, dishPartFramex, dishPartFramey);
    dishPart2.titleLabel.font=[UIFont  systemFontOfSize:dishPartfontSize];
    [dishPart2 setTitleColor:[UIColor colorWithRed:233/255.0 green:80/255.0 blue:20/255.0 alpha:1] forState:UIControlStateNormal];
    
    x=dishPart2.frame.size.width+dishPart2.frame.origin.x+5;;
    y=45;
    dishUnitfontSize=18;
    dishPricefontSize=24;
    dishPartfontSize=18;
    dishPartPointy=45;
    dishPartFramex=40;
    dishPartFramey=20;
    dishUnit3.frame=CGRectMake(x, y, 30, 30);
    dishUnit3.font=[UIFont  systemFontOfSize:dishUnitfontSize];
    dishUnit3.textColor=[UIColor whiteColor];
    dishPrice3.frame=CGRectMake(0,0,0,0);
    [dishPrice3 setFrame:CGRectMake(x+dishUnitfontSize, y-5, [self getAppropriateSize:dishInfo.dishPrice withFontSize:dishPricefontSize], 30)];
    dishPrice3.textColor=[UIColor whiteColor];
    dishPrice3.font=[UIFont  systemFontOfSize:dishPricefontSize];
    dishPart3.frame=CGRectMake(dishPrice3.frame.size.width+dishPrice3.frame.origin.x+5, dishPartPointy, dishPartFramex, dishPartFramey);
    dishPart3.titleLabel.font=[UIFont  systemFontOfSize:dishPartfontSize];
    [dishPart3 setTitleColor:dishPartfontColor forState:UIControlStateNormal];
}
-(void) dishPart3:(UIButton*)sender{
    UILabel *dishUnit1;
    UILabel *dishPrice1;
    UIButton *dishPart1;
    UILabel *dishUnit2;
    UILabel *dishPrice2;
    UIButton *dishPart2;
    UILabel *dishUnit3;
    UILabel *dishPrice3;
    UIButton *dishPart3;
    int x=260;
    int y=45;
    int dishUnitfontSize=18;
    int dishPricefontSize=24;
    int dishPartfontSize=18;
    int dishPartPointy=45;
    int dishPartFramex=40;
    int dishPartFramey=20;
    UIColor *dishPartfontColor=[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1];
    DishInfo *dishInfo =[pageList objectAtIndex:0];
    ShopCar *shopCar=[ShopCar selectWithPrice:dishInfo.dishID withPrice:dishInfo.bigDishPrice];
    hotdishNum.text=shopCar.sellCount;
    partflag=3;
    for (id obj in back.subviews){
        if ([obj isKindOfClass:[UILabel class]])
        {
            if (((UILabel*)obj).tag==10){
                dishUnit1=(UILabel*)obj;
            }
            if (((UILabel*)obj).tag==20){
                dishUnit2=(UILabel*)obj;
            }
            if (((UILabel*)obj).tag==30){
                dishUnit3=(UILabel*)obj;
            }
            if (((UILabel*)obj).tag==11){
                dishPrice1=(UILabel*)obj;
            }
            if (((UILabel*)obj).tag==21){
                dishPrice2=(UILabel*)obj;
            }
            if (((UILabel*)obj).tag==31){
                dishPrice3=(UILabel*)obj;
            }
        }else if ([obj isKindOfClass:[UIButton class]]){
            if (((UIButton*)obj).tag==12){
                dishPart1=(UIButton*)obj;
            }
            if (((UIButton*)obj).tag==22){
                dishPart2=(UIButton*)obj;
            }
            if (((UIButton*)obj).tag==32){
                dishPart3=(UIButton*)obj;
            }
        }
    }
    dishUnit1.frame=CGRectMake(x, y, 30, 30);
    dishUnit1.font=[UIFont  systemFontOfSize:dishUnitfontSize];
    dishUnit1.textColor=[UIColor whiteColor];
    dishPrice1.frame=CGRectMake(0,0,0,0);
    [dishPrice1 setFrame:CGRectMake(x+dishUnitfontSize, y-5, [self getAppropriateSize:dishInfo.dishPrice withFontSize:dishPricefontSize], 30)];
    dishPrice1.textColor=[UIColor whiteColor];
    dishPrice1.font=[UIFont  systemFontOfSize:dishPricefontSize];
    dishPart1.frame=CGRectMake(dishPrice1.frame.size.width+dishPrice1.frame.origin.x+5, dishPartPointy, dishPartFramex, dishPartFramey);
    dishPart1.titleLabel.font=[UIFont  systemFontOfSize:dishPartfontSize];
    [dishPart1 setTitleColor:dishPartfontColor forState:UIControlStateNormal];
    
    
    x=dishPart1.frame.size.width+dishPart1.frame.origin.x+5;;
    y=45;
    dishUnitfontSize=18;
    dishPricefontSize=24;
    dishPartfontSize=18;
    dishPartPointy=45;
    dishPartFramex=40;
    dishPartFramey=20;
    dishUnit2.frame=CGRectMake(x, y, 30, 30);
    dishUnit2.font=[UIFont  systemFontOfSize:dishUnitfontSize];
    dishUnit2.textColor=[UIColor whiteColor];
    dishPrice2.frame=CGRectMake(0,0,0,0);
    [dishPrice2 setFrame:CGRectMake(x+dishUnitfontSize, y-5, [self getAppropriateSize:dishInfo.dishPrice withFontSize:dishPricefontSize], 30)];
    dishPrice2.textColor=[UIColor whiteColor];
    dishPrice2.font=[UIFont  systemFontOfSize:dishPricefontSize];
    dishPart2.frame=CGRectMake(dishPrice2.frame.size.width+dishPrice2.frame.origin.x+5, dishPartPointy, dishPartFramex, dishPartFramey);
    dishPart2.titleLabel.font=[UIFont  systemFontOfSize:dishPartfontSize];
    [dishPart2 setTitleColor:dishPartfontColor forState:UIControlStateNormal];

    x=dishPart2.frame.size.width+dishPart2.frame.origin.x+5;
    if (dishPart2.frame.size.width==0){
        x=dishPart1.frame.size.width+dishPart1.frame.origin.x+5;
    }
    dishUnitfontSize=28;
    dishPricefontSize=40;
    dishPartfontSize=26;
    dishPartPointy=35;
    dishPartFramex=60;
    dishPartFramey=30;
    y=40;
    dishUnit3.frame=CGRectMake(x, y, 30, 30);
    dishUnit3.font=[UIFont  systemFontOfSize:dishUnitfontSize];
    dishUnit3.textColor=[UIColor whiteColor];
    dishPrice3.frame=CGRectMake(0,0,0,0);
    [dishPrice3 setFrame:CGRectMake(x+dishUnitfontSize, y-5, [self getAppropriateSize:dishInfo.dishPrice withFontSize:dishPricefontSize], 30)];
    dishPrice3.textColor=[UIColor whiteColor];
    dishPrice3.font=[UIFont  systemFontOfSize:dishPricefontSize];
    dishPart3.frame=CGRectMake(dishPrice3.frame.size.width+dishPrice3.frame.origin.x+5, dishPartPointy, dishPartFramex, dishPartFramey);
    dishPart3.titleLabel.font=[UIFont  systemFontOfSize:dishPartfontSize];
    [dishPart3 setTitleColor:[UIColor colorWithRed:233/255.0 green:80/255.0 blue:20/255.0 alpha:1]
 forState:UIControlStateNormal];
}

-(int) getAppropriateSize:(NSString*)text withFontSize:(int)fontSize{
    NSString *s = text;
    UIFont *font = [UIFont  systemFontOfSize:fontSize];
    CGSize size = CGSizeMake(320,2000);
    CGSize labelsize = [s sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    return labelsize.width;
}


- (void)dismissDarkViewDark:(UITapGestureRecognizer *) gestureRecognizer {
    [UIView animateWithDuration:0.5 animations:^{
        back.frame = CGRectMake(0, 415, self.view.bounds.size.width, 195);
        //点击
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showDarkViewDark:)];
        updownImage.image=[UIImage imageNamed:@"downButton"];
        [back addSubview:memo];
        [back addGestureRecognizer:tapGesture];
    }];
}

- (void)showDarkViewDark:(UITapGestureRecognizer *) gestureRecognizer {
    [UIView animateWithDuration:0.5 animations:^{
        back.frame = CGRectMake(0, 515, self.view.bounds.size.width, 95);
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissDarkViewDark:)];
        updownImage.image=[UIImage imageNamed:@"upButton"];
        [back addGestureRecognizer:tapGesture];
    }];
}

- (void)plusHotDish:(UIButton *)button {
    DishInfo *dishInfo =[pageList objectAtIndex:0];
    ShopCar *shopCar=[[ShopCar alloc]init];
    if (partflag==1){
        shopCar=[ShopCar selectWithPrice:dishInfo.dishID withPrice:dishInfo.smallDishPrice];
        shopCar.dishPrice= dishInfo.smallDishPrice;
    }else if(partflag==2){
        shopCar=[ShopCar selectWithPrice:dishInfo.dishID withPrice:dishInfo.dishPrice];
        shopCar.dishPrice= dishInfo.dishPrice;
    }else{
        shopCar=[ShopCar selectWithPrice:dishInfo.dishID withPrice:dishInfo.bigDishPrice];
        shopCar.dishPrice= dishInfo.bigDishPrice;
    }
    if ([dishInfo.stock isEqualToString:@"0"]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"该菜品已售完！" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    [ShopCar delete:shopCar.systemID];
    if ([hotdishNum.text isEqualToString:@""]  || hotdishNum.text == nil){
        hotdishNum.text=@"1";
        shopCar.dishID= dishInfo.dishID;
        shopCar.dishName= dishInfo.dishName;
        shopCar.typeName= dishInfo.typeName;
        shopCar.sellCount= hotdishNum.text;
        shopCar.dishUnit= dishInfo.dishUnit;
        shopCar.memo= @"";
        shopCar.dishStatus=@"0";
        [ShopCar insert:shopCar];
        [self.delegate setBadge];
    }else{
        hotdishNum.text= [NSString stringWithFormat:@"%d",([hotdishNum.text intValue]+1)];
        shopCar.sellCount= hotdishNum.text;
        [ShopCar insert:shopCar];
    }

}

- (void)minusHotDish:(UIButton *)button {
    DishInfo *dishInfo =[pageList objectAtIndex:0];
    ShopCar *shopCar=[[ShopCar alloc]init];
    if (partflag==1){
        shopCar=[ShopCar selectWithPrice:dishInfo.dishID withPrice:dishInfo.smallDishPrice];
        shopCar.dishPrice= dishInfo.smallDishPrice;
    }else if(partflag==2){
        shopCar=[ShopCar selectWithPrice:dishInfo.dishID withPrice:dishInfo.dishPrice];
        shopCar.dishPrice= dishInfo.dishPrice;
    }else{
        shopCar=[ShopCar selectWithPrice:dishInfo.dishID withPrice:dishInfo.bigDishPrice];
        shopCar.dishPrice= dishInfo.bigDishPrice;
    }
    [ShopCar delete:shopCar.systemID];
    if ([hotdishNum.text isEqualToString:@""]  || hotdishNum.text == nil || [hotdishNum.text intValue]<2){
        hotdishNum.text=@"";
        [self.delegate setBadge];
    }else{
        hotdishNum.text= [NSString stringWithFormat:@"%d",([hotdishNum.text intValue]-1)];
        shopCar.sellCount= hotdishNum.text;
        [ShopCar insert:shopCar];
    }
}

-(UIImageView*) createImage:(int) i{
    int j=i/3;
    int k=i%3;
    DishInfo *dishInfo =[pageList objectAtIndex:i];
    ShopCar *shopCar=[[ShopCar alloc]init];
    if ([dishInfo.dishPrice isEqualToString:@""] || [dishInfo.dishPrice isEqualToString:@"0"]){
        shopCar=[ShopCar selectWithPrice:dishInfo.dishID withPrice:dishInfo.smallDishPrice];
    }else{
        shopCar=[ShopCar selectWithPrice:dishInfo.dishID withPrice:dishInfo.dishPrice];
    }
    UITapGestureRecognizer *noAction = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(noAction:)];
    UIImageView *imageView;
    UIImage *img;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSMutableString *uniquePath = [[NSMutableString alloc] init];
    [uniquePath appendString:[paths objectAtIndex:0]];
    [uniquePath appendString:@"/Sml"];
    [uniquePath appendString:dishInfo.imageName];
    img=[[UIImage alloc]initWithContentsOfFile:uniquePath];
    if (img==nil){
        img=[UIImage imageNamed:@"nopic.jpg"];
    }
    imageView=[[UIImageView alloc]initWithFrame:CGRectMake(17+k*335, 44+266*j, 320, 240)];
    imageView.image=img;
    imageView.userInteractionEnabled = YES;
    imageView.tag=i;
    
    
    UITapGestureRecognizer * g = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickPhoto:)];
    [imageView addGestureRecognizer:g ];
    
    
    back=[[UIView alloc] initWithFrame:CGRectMake(0, 208, 320, 32)];
    [back setBackgroundColor: [UIColor colorWithPatternImage: [UIImage imageNamed: @"dishInfoBox"]]];
    back.alpha=0.75;
    UILabel *dishId=[[UILabel alloc]initWithFrame:CGRectMake(7, 217, 45, 22)];
    UILabel *dishName=[[UILabel alloc]initWithFrame:CGRectMake(50, 214, 100, 22)];
    UILabel *dishUnit=[[UILabel alloc]initWithFrame:CGRectMake(138, 216, 17, 22)];
    UILabel *dishPrice=[[UILabel alloc]initWithFrame:CGRectMake(150, 214, 45, 22)];
    UIButton *minusBtn=[[UIButton alloc]initWithFrame:CGRectMake(200, 214, 22, 22)];
    UIButton *plusBtn=[[UIButton alloc]initWithFrame:CGRectMake(292, 214, 22, 22)];
    UILabel *dishNumBack=[[UILabel alloc]initWithFrame:CGRectMake(231, 214, 53, 22)];
    UITextField *dishNum=[[UITextField alloc]initWithFrame:CGRectMake(231, 214, 53, 22)];
    // 设定是否自适应大小
    //dishId.sizeToFit;
    dishId.textColor=[UIColor whiteColor];
    dishId.backgroundColor=[UIColor clearColor];
    dishId.font=[UIFont  systemFontOfSize:12];
    dishId.text=dishInfo.dishCode;
    dishName.text=dishInfo.dishName;
    dishName.textColor=[UIColor whiteColor];
    dishName.backgroundColor=[UIColor clearColor];
    dishUnit.text=@"￥";
    dishUnit.font=[UIFont  systemFontOfSize:14];
    dishUnit.textColor=[UIColor whiteColor];
    dishUnit.backgroundColor=[UIColor clearColor];
    dishPrice.text=dishInfo.dishPrice;
    if ([dishInfo.dishPrice isEqualToString:@""] || [dishInfo.dishPrice isEqualToString:@"0"]){
        dishPrice.text=dishInfo.smallDishPrice;
    }
    dishPrice.textColor=[UIColor whiteColor];
    dishPrice.backgroundColor=[UIColor clearColor];
    [minusBtn setBackgroundImage:[UIImage imageNamed:@"minus"] forState:UIControlStateNormal];
    [minusBtn addTarget:self action:@selector(minusDish:) forControlEvents:UIControlEventTouchUpInside];
    
    minusBtn.tag=i;
    [plusBtn setBackgroundImage:[UIImage imageNamed:@"plus"] forState:UIControlStateNormal];
    [plusBtn addTarget:self action:@selector(plusDish:) forControlEvents:UIControlEventTouchUpInside];
    plusBtn.tag=i;
    dishNumBack.backgroundColor=[UIColor whiteColor];
    dishNumBack.alpha=0.3;
    dishNum.background = false;
    dishNum.textColor=[UIColor whiteColor];
    //textField居中对齐
    dishNum.textAlignment=NSTextAlignmentCenter;
    dishNum.tag=i;
    if (shopCar!=nil){
        dishNum.text=shopCar.sellCount;
    }
    if ([dishInfo.stock intValue]==0){
        UIImageView *soldOutImg=[[UIImageView alloc]initWithFrame:CGRectMake(180, 80, 120, 120)];
        [soldOutImg setImage:[UIImage imageNamed:@"soldOutImg"]];
        [imageView addSubview:soldOutImg];
    }
    dishNum.enabled=NO;
    [back addGestureRecognizer:noAction];
    [imageView addSubview:back];
    [imageView addSubview:dishId];
    [imageView addSubview:dishName];
    [imageView addSubview:dishUnit];
    [imageView addSubview:dishPrice];
    [imageView addSubview:minusBtn];
    [imageView addSubview:plusBtn];
    [imageView addSubview:dishNumBack];
    [imageView addSubview:dishNum];
    return imageView;
}

- (void)clickPhoto:(UITapGestureRecognizer*)recognizer{
    UIImageView *tableGridImage = (UIImageView*)recognizer.view;
    int i=tableGridImage.tag;
    DishInfo *dishInfo =[pageList objectAtIndex:i];
    UIImage *image = tableGridImage.image;
    [self.delegate showLargeImage:image withDishID:dishInfo.dishID];

}

- (void)plusDish:(UIButton *)button {
    int num= button.tag;
    UIImageView *imageView;
    DishInfo *dishInfo =[pageList objectAtIndex:num];
    ShopCar *shopCar;
    if ([dishInfo.stock isEqualToString:@"0"]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"该菜品已售完！" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    if ([dishInfo.dishPrice isEqualToString:@""] || [dishInfo.dishPrice isEqualToString:@"0"]){
        shopCar=[ShopCar selectWithPrice:dishInfo.dishID withPrice:dishInfo.smallDishPrice];
        shopCar.dishPrice=dishInfo.smallDishPrice;
    }else{
        shopCar=[ShopCar selectWithPrice:dishInfo.dishID withPrice:dishInfo.dishPrice];
        shopCar.dishPrice=dishInfo.dishPrice;
    }
    [ShopCar delete:shopCar.systemID];
    for (id obj in self.view.subviews){
         if ([obj isKindOfClass:[UIImageView class]])
         {
              if (((UIImageView*)obj).tag==num){
                  imageView=(UIImageView*)obj;
              }
         }
    }
    for (id obj in imageView.subviews)
    {
        if ([obj isKindOfClass:[UITextField class]])
        {
            UITextField *text = (UITextField*)obj;
            if (text.tag==num){
                if ([text.text isEqualToString:@""]  || text.text == nil){
                    text.text=@"1";
                    shopCar.dishID= dishInfo.dishID;
                    shopCar.dishName= dishInfo.dishName;
                    shopCar.typeName= dishInfo.typeName;
                    shopCar.sellCount= text.text;
                    shopCar.dishUnit= dishInfo.dishUnit;
                    shopCar.memo= @"";
                    shopCar.dishStatus=@"0";
                    [ShopCar insert:shopCar];
                    [self.delegate setBadge];
                }else{
                text.text= [NSString stringWithFormat:@"%d",([text.text intValue]+1)];
                    shopCar.sellCount= text.text;
                    [ShopCar insert:shopCar];
                }
            }
        }
    }
}

- (void)minusDish:(UIButton *)button {
    int num= button.tag;
    UIImageView *imageView;
    DishInfo *dishInfo =[pageList objectAtIndex:num];
    ShopCar *shopCar;
    if ([dishInfo.dishPrice isEqualToString:@""] || [dishInfo.dishPrice isEqualToString:@"0"]){
        shopCar=[ShopCar selectWithPrice:dishInfo.dishID withPrice:dishInfo.smallDishPrice];
    }else{
        shopCar=[ShopCar selectWithPrice:dishInfo.dishID withPrice:dishInfo.dishPrice];
    }
    [ShopCar delete:shopCar.systemID];
    for (id obj in self.view.subviews){
        if ([obj isKindOfClass:[UIImageView class]])
        {
            if (((UIImageView*)obj).tag==num){
                imageView=(UIImageView*)obj;
            }
        }
    }
    for (id obj in imageView.subviews)
    {
        if ([obj isKindOfClass:[UITextField class]])
        {
            UITextField *text = (UITextField*)obj;
            if (text.tag==num){
                if ([text.text isEqualToString:@""]  || text.text == nil || [text.text intValue]<2){
                    text.text=@"";
                    [self.delegate setBadge];
                }else{
                text.text= [NSString stringWithFormat:@"%d",([text.text intValue]-1)];
                    shopCar.sellCount= text.text;
                    [ShopCar insert:shopCar];
                }
            }
        }
    }
}

- (void)noAction:(UITapGestureRecognizer *) gestureRecognizer {
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
