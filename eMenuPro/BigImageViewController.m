//
//  BigImageViewController.m
//  eMenuPro
//
//  Created by Li Feng on 14-4-9.
//  Copyright (c) 2014年 Gong Lingxiao. All rights reserved.
//

#import "BigImageViewController.h"

@interface BigImageViewController ()

@end

@implementation BigImageViewController
@synthesize partflag;
@synthesize back;
@synthesize updownImage;
@synthesize dishNum;
@synthesize dishInfo;
@synthesize dishID;


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
    [self showLargeImage];
}

- (void) showLargeImage{
    
    DishInfo *mydishInfo =dishInfo;
    ShopCar *selectShopCar=[[ShopCar alloc]init];
    if ([mydishInfo.dishPrice isEqualToString:@""]||[mydishInfo.dishPrice isEqualToString:@"0"]){
        selectShopCar=[ShopCar selectWithPrice:mydishInfo.dishID withPrice:mydishInfo.smallDishPrice];
    }else{
        selectShopCar=[ShopCar selectWithPrice:mydishInfo.dishID withPrice:mydishInfo.dishPrice];
    }
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissDarkView)];
    UITapGestureRecognizer *noAction = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissView:)];
    UIImage *img;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSMutableString *uniquePath = [[NSMutableString alloc] init];
    [uniquePath appendString:[paths objectAtIndex:0]];
    [uniquePath appendString:@"/"];
    [uniquePath appendString:mydishInfo.imageName];
    img=[[UIImage alloc]initWithContentsOfFile:uniquePath];
    if (img==nil){
        img=[UIImage imageNamed:@"nopic.jpg"];
    }
    UIImageView *imageView = [[UIImageView alloc] initWithImage:img];
    [imageView setFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    imageView.userInteractionEnabled=YES;
    imageView.tag = 98;
    UIView *darkView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 100, self.view.bounds.size.width, 100)];
    darkView.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.7];
    ;
    darkView.tag = 99;
    if ([mydishInfo.dishSpicy isEqualToString:@"1"]){
        UIImageView *chiliImageView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chili1"]];
        chiliImageView.frame=CGRectMake(30, 50, 75, 42);
        [darkView addSubview:chiliImageView];
    }else if ([mydishInfo.dishSpicy isEqualToString:@"2"]){
        UIImageView *chiliImageView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chili2"]];
        chiliImageView.frame=CGRectMake(30, 50, 75, 42);
        [darkView addSubview:chiliImageView];
    }else if ([mydishInfo.dishSpicy isEqualToString:@"3"]){
        UIImageView *chiliImageView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chili3"]];
        chiliImageView.frame=CGRectMake(30, 50, 75, 42);
        [darkView addSubview:chiliImageView];
    }
    
    
    //创建了一个Label标签
    UILabel *dishIdLab = [[UILabel alloc] initWithFrame: CGRectMake(20, 8, 100, 50)];
    dishIdLab.text=mydishInfo.dishCode;
    dishIdLab.textColor=[UIColor whiteColor];
    dishIdLab.font=[UIFont systemFontOfSize:22];
    dishIdLab.backgroundColor=[UIColor clearColor];
    
    UILabel *dishNameLab = [[UILabel alloc] initWithFrame: CGRectMake(102, 50, 200, 50)];
    dishNameLab.text=mydishInfo.dishName;
    dishNameLab.textColor=[UIColor whiteColor];
    dishNameLab.font=[UIFont systemFontOfSize:30];
    dishNameLab.backgroundColor=[UIColor clearColor];
    if ([mydishInfo.smallDishPrice isEqualToString:@"0"] || [mydishInfo.bigDishPrice isEqualToString:@"0"]  ||[mydishInfo.smallDishPrice isEqualToString:@""] || [mydishInfo.bigDishPrice isEqualToString:@""]){
        partflag=2;
        UILabel *dishUnitLab = [[UILabel alloc] initWithFrame: CGRectMake(270, 52, 30, 50)];
        dishUnitLab.text=@"￥";
        dishUnitLab.textColor=[UIColor whiteColor];
        dishUnitLab.font=[UIFont systemFontOfSize:25];
        dishUnitLab.backgroundColor=[UIColor clearColor];
        UILabel *dishPriceLab = [[UILabel alloc] initWithFrame: CGRectMake(295, 50, 100, 50)];
        dishPriceLab.text=mydishInfo.dishPrice;
        dishPriceLab.textColor=[UIColor whiteColor];
        dishPriceLab.font=[UIFont systemFontOfSize:33];
        dishPriceLab.backgroundColor=[UIColor clearColor];
        [darkView addSubview:dishUnitLab];
        [darkView addSubview:dishPriceLab];
    }else{
        if ([mydishInfo.dishPrice isEqualToString:@""]||[mydishInfo.dishPrice isEqualToString:@"0"]){
            ShopCar *shopCar=[[ShopCar alloc]init];
            partflag=1;
            shopCar=[ShopCar selectWithPrice:mydishInfo.dishID withPrice:mydishInfo.smallDishPrice];
            int x=260;
            int y=65;
            int dishUnitfontSize=18;
            int dishPricefontSize=24;
            int dishPartfontSize=18;
            int dishPartPointy=65;
            int dishPartFramex=40;
            int dishPartFramey=20;
            UIColor *dishPartfontColor=[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1];
            
            
            dishUnitfontSize=28;
            dishPricefontSize=40;
            dishPartfontSize=26;
            dishPartPointy=55;
            dishPartFramex=60;
            dishPartFramey=30;
            dishPartfontColor=[UIColor colorWithRed:233/255.0 green:80/255.0 blue:20/255.0 alpha:1];
            x=260;
            y=60;
            UILabel *dishUnit1;
            UILabel *dishPrice1;
            UIButton *dishPart1;
            dishUnit1=[[UILabel alloc]initWithFrame:CGRectMake(x, y, 30, 30)];
            dishUnit1.text=@"￥";
            dishUnit1.font=[UIFont  systemFontOfSize:dishUnitfontSize];
            dishUnit1.textColor=[UIColor whiteColor];
            dishUnit1.backgroundColor=[UIColor clearColor];
            dishPrice1 = [[UILabel alloc] initWithFrame:CGRectMake(0,0,0,0)];
            [dishPrice1 setFrame:CGRectMake(x+dishUnitfontSize, y-5, [self getAppropriateSize:mydishInfo.dishPrice withFontSize:dishPricefontSize], 30)];
            dishPrice1.text=mydishInfo.smallDishPrice;
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
            [darkView addSubview:dishUnit1];
            [darkView addSubview:dishPrice1];
            [darkView addSubview:dishPart1];
            
            UILabel *dishUnit3;
            UILabel *dishPrice3;
            UIButton *dishPart3;
            x=dishPart1.frame.size.width+dishPart1.frame.origin.x+5;;
            y=65;
            dishUnitfontSize=18;
            dishPricefontSize=24;
            dishPartfontSize=18;
            dishPartPointy=65;
            dishPartFramex=40;
            dishPartFramey=20;
            dishPartfontColor=[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1];
            dishUnit3=[[UILabel alloc]initWithFrame:CGRectMake(x, y, 30, 30)];
            dishUnit3.text=@"￥";
            dishUnit3.font=[UIFont  systemFontOfSize:dishUnitfontSize];
            dishUnit3.textColor=[UIColor whiteColor];
            dishUnit3.backgroundColor=[UIColor clearColor];
            dishPrice3 = [[UILabel alloc] initWithFrame:CGRectMake(0,0,0,0)];
            [dishPrice3 setFrame:CGRectMake(x+dishUnitfontSize, y-5, [self getAppropriateSize:mydishInfo.dishPrice withFontSize:dishPricefontSize], 30)];
            dishPrice3.text=mydishInfo.bigDishPrice;
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
            [darkView addSubview:dishUnit3];
            [darkView addSubview:dishPrice3];
            [darkView addSubview:dishPart3];
        }else{
            partflag=2;
            ShopCar *shopCar=[[ShopCar alloc]init];
            shopCar=[ShopCar selectWithPrice:dishInfo.dishID withPrice:dishInfo.dishPrice];
            
            int x=260;
            int y=65;
            int dishUnitfontSize=18;
            int dishPricefontSize=24;
            int dishPartfontSize=18;
            int dishPartPointy=65;
            int dishPartFramex=40;
            int dishPartFramey=20;
            UIColor *dishPartfontColor=[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1];
            
            UILabel *dishUnit1;
            UILabel *dishPrice1;
            UIButton *dishPart1;
            dishUnit1=[[UILabel alloc]initWithFrame:CGRectMake(x, y, 30, 30)];
            dishUnit1.text=@"￥";
            dishUnit1.font=[UIFont  systemFontOfSize:dishUnitfontSize];
            dishUnit1.textColor=[UIColor whiteColor];
            dishUnit1.backgroundColor=[UIColor clearColor];
            dishPrice1 = [[UILabel alloc] initWithFrame:CGRectMake(0,0,0,0)];
            [dishPrice1 setFrame:CGRectMake(x+dishUnitfontSize, y-5, [self getAppropriateSize:mydishInfo.dishPrice withFontSize:dishPricefontSize], 30)];
            dishPrice1.text=mydishInfo.smallDishPrice;
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
            [darkView addSubview:dishUnit1];
            [darkView addSubview:dishPrice1];
            [darkView addSubview:dishPart1];
            
            UILabel *dishUnit2;
            UILabel *dishPrice2;
            UIButton *dishPart2;
            dishUnitfontSize=28;
            dishPricefontSize=40;
            dishPartfontSize=26;
            dishPartPointy=55;
            dishPartFramex=60;
            dishPartFramey=30;
            dishPartfontColor=[UIColor colorWithRed:233/255.0 green:80/255.0 blue:20/255.0 alpha:1];
            x=dishPart1.frame.size.width+dishPart1.frame.origin.x+5;
            y=60;
            dishUnit2=[[UILabel alloc]initWithFrame:CGRectMake(x, y, 30, 30)];
            dishUnit2.text=@"￥";
            dishUnit2.font=[UIFont  systemFontOfSize:dishUnitfontSize];
            dishUnit2.textColor=[UIColor whiteColor];
            dishUnit2.backgroundColor=[UIColor clearColor];
            dishPrice2 = [[UILabel alloc] initWithFrame:CGRectMake(0,0,0,0)];
            [dishPrice2 setFrame:CGRectMake(x+dishUnitfontSize, y-5, [self getAppropriateSize:mydishInfo.dishPrice withFontSize:dishPricefontSize], 30)];
            dishPrice2.text=mydishInfo.dishPrice;
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
            [darkView addSubview:dishUnit2];
            [darkView addSubview:dishPrice2];
            [darkView addSubview:dishPart2];
            UILabel *dishUnit3;
            UILabel *dishPrice3;
            UIButton *dishPart3;
            x=dishPart2.frame.size.width+dishPart2.frame.origin.x+5;;
            y=65;
            dishUnitfontSize=18;
            dishPricefontSize=24;
            dishPartfontSize=18;
            dishPartPointy=65;
            dishPartFramex=40;
            dishPartFramey=20;
            dishPartfontColor=[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1];
            dishUnit3=[[UILabel alloc]initWithFrame:CGRectMake(x, y, 30, 30)];
            dishUnit3.text=@"￥";
            dishUnit3.font=[UIFont  systemFontOfSize:dishUnitfontSize];
            dishUnit3.textColor=[UIColor whiteColor];
            dishUnit3.backgroundColor=[UIColor clearColor];
            dishPrice3 = [[UILabel alloc] initWithFrame:CGRectMake(0,0,0,0)];
            [dishPrice3 setFrame:CGRectMake(x+dishUnitfontSize, y-5, [self getAppropriateSize:mydishInfo.dishPrice withFontSize:dishPricefontSize], 30)];
            dishPrice3.text=mydishInfo.bigDishPrice;
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
            [darkView addSubview:dishUnit3];
            [darkView addSubview:dishPrice3];
            [darkView addSubview:dishPart3];
        }
        
        
    }
    UIButton *minusButton= [[UIButton alloc] initWithFrame: CGRectMake(765, 50, 38, 38)];
    UIButton *plusButton= [[UIButton alloc] initWithFrame: CGRectMake(940, 50, 38, 38)];
    minusButton.tag=40;
    plusButton.tag=40;
    [minusButton setBackgroundImage:[UIImage imageNamed:@"BigImageMinus"] forState:UIControlStateNormal];
    
    [plusButton setBackgroundImage:[UIImage imageNamed:@"BigImagePlus"] forState:UIControlStateNormal];
    [minusButton addTarget:self action:@selector(minusDish:) forControlEvents:UIControlEventTouchUpInside];
    [plusButton addTarget:self action:@selector(plusDish:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *dishCount = [[UILabel alloc] initWithFrame: CGRectMake(820, 50, 100, 38)];
    dishCount.tag=40;
    dishCount.text=selectShopCar.sellCount;
    dishCount.textColor=[UIColor whiteColor];
    dishCount.backgroundColor=[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.3];
    dishCount.font=[UIFont fontWithName:@"OriyasangamMN-Bold" size:30];
    dishCount.textAlignment=NSTextAlignmentCenter;
    
    UITextView *memo=[[UITextView alloc]initWithFrame:CGRectMake(45, 95, 950, 130)];
    memo.textColor=[UIColor whiteColor];
    memo.backgroundColor=[UIColor clearColor];
    memo.font=[UIFont  systemFontOfSize:25];
    memo.scrollEnabled=YES;
    memo.text=mydishInfo.dishMemo;
    memo.editable=NO;
    if ([mydishInfo.stock intValue]==0){
        UIImageView *soldOutImg=[[UIImageView alloc]initWithFrame:CGRectMake(620, 300, 340, 340)];
        [soldOutImg setImage:[UIImage imageNamed:@"soldOutImgHot"]];
        [imageView addSubview:soldOutImg];
    }

    //将dishIdLab标签添加进入了darkView层
    [darkView addSubview:dishIdLab];
    [darkView addSubview:dishNameLab];
    [darkView addSubview:minusButton];
    [darkView addSubview:plusButton];
    [darkView addSubview:dishCount];
    [darkView addSubview:memo];
    [darkView addGestureRecognizer:noAction];
    [imageView addSubview:darkView];
    [imageView addGestureRecognizer:tapGesture];
    [self.view addSubview:imageView];
    
}

-(int) getAppropriateSize:(NSString*)text withFontSize:(int)fontSize{
    NSString *s = text;
    UIFont *font = [UIFont  systemFontOfSize:fontSize];
    CGSize size = CGSizeMake(320,2000);
    CGSize labelsize = [s sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    return labelsize.width;
}
- (void)noAction:(UITapGestureRecognizer *) gestureRecognizer {
    
}
- (void)dismissView:(UITapGestureRecognizer *) gestureRecognizer {
    [UIView animateWithDuration:0.5 animations:^{
        
        gestureRecognizer.view.frame = CGRectMake(0, self.view.bounds.size.height - 245, self.view.bounds.size.width, 245);
        //点击
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showView:)];
        //        updownImage.image=[UIImage imageNamed:@"downButton"];
        //        [back addSubview:memo];
        [gestureRecognizer.view addGestureRecognizer:tapGesture];
    }];
}

- (void)showView:(UITapGestureRecognizer *) gestureRecognizer {
    [UIView animateWithDuration:0.5 animations:^{
        gestureRecognizer.view.frame = CGRectMake(0, self.view.bounds.size.height - 100, self.view.bounds.size.width, 100);
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissView:)];
        //        updownImage.image=[UIImage imageNamed:@"upButton"];
        [gestureRecognizer.view addGestureRecognizer:tapGesture];
    }];
}

- (void)plusDish:(UIButton *)button {
    NSInteger butnum= button.tag;
    UIImageView *imageView;
    UIView *darkView;
    DishInfo *mydishInfo =[DishInfo selectByDishID:dishID];
    ShopCar *shopCar=[[ShopCar alloc]init];
    if ([dishInfo.stock isEqualToString:@"0"]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"该菜品已售完！" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    if (partflag==1){
        shopCar=[ShopCar selectWithPrice:mydishInfo.dishID withPrice:mydishInfo.smallDishPrice];
        shopCar.dishPrice= mydishInfo.smallDishPrice;
    }else if(partflag==2){
        shopCar=[ShopCar selectWithPrice:mydishInfo.dishID withPrice:mydishInfo.dishPrice];
        shopCar.dishPrice= mydishInfo.dishPrice;
    }else{
        shopCar=[ShopCar selectWithPrice:mydishInfo.dishID withPrice:mydishInfo.bigDishPrice];
        shopCar.dishPrice= mydishInfo.bigDishPrice;
    }
    [ShopCar delete:shopCar.systemID];
    for (id obj in self.view.subviews){
        if ([obj isKindOfClass:[UIImageView class]])
        {
            if (((UIImageView*)obj).tag==98){
                imageView=(UIImageView*)obj;
            }
        }
    }
    for (id obj in imageView.subviews){
        if ([obj isKindOfClass:[UIView class]])
        {
            if (((UIView*)obj).tag==99){
                darkView=(UIView*)obj;
            }
        }
    }
    for (id obj in darkView.subviews)
    {
        if ([obj isKindOfClass:[UILabel class]])
        {
            UILabel *text = (UILabel*)obj;
            if (text.tag==butnum){
                if ([text.text isEqualToString:@""]  || text.text == nil){
                    DishInfo *mydishInfo=[DishInfo selectByDishID:dishID];
                    text.text=@"1";
                    shopCar.dishID= mydishInfo.dishID;
                    shopCar.dishName= mydishInfo.dishName;
                    shopCar.typeName= mydishInfo.typeName;
                    shopCar.sellCount= text.text;
                    shopCar.dishUnit= mydishInfo.dishUnit;
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
    int butnum= button.tag;
    UIImageView *imageView;
    UIView *darkView;
    DishInfo *mydishInfo =[DishInfo selectByDishID:dishID];
    ShopCar *shopCar=[[ShopCar alloc]init];
    if (partflag==1){
        shopCar=[ShopCar selectWithPrice:mydishInfo.dishID withPrice:mydishInfo.smallDishPrice];
        shopCar.dishPrice= mydishInfo.smallDishPrice;
    }else if(partflag==2){
        shopCar=[ShopCar selectWithPrice:mydishInfo.dishID withPrice:mydishInfo.dishPrice];
        shopCar.dishPrice= mydishInfo.dishPrice;
    }else{
        shopCar=[ShopCar selectWithPrice:mydishInfo.dishID withPrice:mydishInfo.bigDishPrice];
        shopCar.dishPrice= mydishInfo.bigDishPrice;
    }
    [ShopCar delete:shopCar.systemID];
    for (id obj in self.view.subviews){
        if ([obj isKindOfClass:[UIImageView class]])
        {
            if (((UIImageView*)obj).tag==98){
                imageView=(UIImageView*)obj;
            }
        }
    }
    for (id obj in imageView.subviews){
        if ([obj isKindOfClass:[UIView class]])
        {
            if (((UIView*)obj).tag==99){
                darkView=(UIView*)obj;
            }
        }
    }
    for (id obj in darkView.subviews)
        
    {
        if ([obj isKindOfClass:[UILabel class]])
        {
            UILabel *text = (UILabel*)obj;
            if (text.tag==butnum){
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
    int y=65;
    int dishUnitfontSize=18;
    int dishPricefontSize=24;
    int dishPartfontSize=18;
    int dishPartPointy=65;
    int dishPartFramex=40;
    int dishPartFramey=20;
    UIColor *dishPartfontColor=[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1];DishInfo *mydishInfo =[DishInfo selectByDishID:dishID];
    ShopCar *shopCar=[ShopCar selectWithPrice:mydishInfo.dishID withPrice:mydishInfo.smallDishPrice ];
    
    partflag=1;
    UIImageView *imageView;
    UIView *darkView;
    
    UILabel *hotdishNum;
    for (id obj in self.view.subviews){
        if ([obj isKindOfClass:[UIImageView class]])
        {
            if (((UIImageView*)obj).tag==98){
                imageView=(UIImageView*)obj;
            }
        }
    }
    for (id obj in imageView.subviews){
        if ([obj isKindOfClass:[UIView class]])
        {
            if (((UIView*)obj).tag==99){
                darkView=(UIView*)obj;
            }
        }
    }
    for (id obj in darkView.subviews)
    {
        if ([obj isKindOfClass:[UILabel class]])
        {
            UILabel *text = (UILabel*)obj;
            if (text.tag==40){
                hotdishNum=text;
            }
        }
    }
    hotdishNum.text=shopCar.sellCount;
    for (id obj in darkView.subviews){
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
    dishPartPointy=55;
    dishPartFramex=60;
    dishPartFramey=30;
    x=260;
    y=60;
    dishUnit1.frame=CGRectMake(x, y, 30, 30);
    dishUnit1.font=[UIFont  systemFontOfSize:dishUnitfontSize];
    dishUnit1.textColor=[UIColor whiteColor];
    dishPrice1.frame=CGRectMake(0,0,0,0);
    [dishPrice1 setFrame:CGRectMake(x+dishUnitfontSize, y-5, [self getAppropriateSize:mydishInfo.dishPrice withFontSize:dishPricefontSize], 30)];
    dishPrice1.textColor=[UIColor whiteColor];
    dishPrice1.font=[UIFont  systemFontOfSize:dishPricefontSize];
    dishPart1.frame=CGRectMake(dishPrice1.frame.size.width+dishPrice1.frame.origin.x+5, dishPartPointy, dishPartFramex, dishPartFramey);
    dishPart1.titleLabel.font=[UIFont  systemFontOfSize:dishPartfontSize];
    [dishPart1 setTitleColor:[UIColor colorWithRed:233/255.0 green:80/255.0 blue:20/255.0 alpha:1] forState:UIControlStateNormal];
    
    
    x=dishPart1.frame.size.width+dishPart1.frame.origin.x+5;
    y=65;
    dishUnitfontSize=18;
    dishPricefontSize=24;
    dishPartfontSize=18;
    dishPartPointy=65;
    dishPartFramex=40;
    dishPartFramey=20;
    dishUnit2.frame=CGRectMake(x, y, 30, 30);
    dishUnit2.font=[UIFont  systemFontOfSize:dishUnitfontSize];
    dishUnit2.textColor=[UIColor whiteColor];
    dishPrice2.frame=CGRectMake(0,0,0,0);
    [dishPrice2 setFrame:CGRectMake(x+dishUnitfontSize, y-5, [self getAppropriateSize:mydishInfo.dishPrice withFontSize:dishPricefontSize], 30)];
    dishPrice2.textColor=[UIColor whiteColor];
    dishPrice2.font=[UIFont  systemFontOfSize:dishPricefontSize];
    dishPart2.frame=CGRectMake(dishPrice2.frame.size.width+dishPrice2.frame.origin.x+5, dishPartPointy, dishPartFramex, dishPartFramey);
    dishPart2.titleLabel.font=[UIFont  systemFontOfSize:dishPartfontSize];
    [dishPart2 setTitleColor:dishPartfontColor forState:UIControlStateNormal];
    
    x=dishPart2.frame.size.width+dishPart2.frame.origin.x+5;
    if (dishPart2.frame.size.width==0){
        x=dishPart1.frame.size.width+dishPart1.frame.origin.x+5;
    }
    y=65;
    dishUnitfontSize=18;
    dishPricefontSize=24;
    dishPartfontSize=18;
    dishPartPointy=65;
    dishPartFramex=40;
    dishPartFramey=20;
    dishUnit3.frame=CGRectMake(x, y, 30, 30);
    dishUnit3.font=[UIFont  systemFontOfSize:dishUnitfontSize];
    dishUnit3.textColor=[UIColor whiteColor];
    dishPrice3.frame=CGRectMake(0,0,0,0);
    [dishPrice3 setFrame:CGRectMake(x+dishUnitfontSize, y-5, [self getAppropriateSize:mydishInfo.dishPrice withFontSize:dishPricefontSize], 30)];
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
    int y=65;
    int dishUnitfontSize=18;
    int dishPricefontSize=24;
    int dishPartfontSize=18;
    int dishPartPointy=65;
    int dishPartFramex=40;
    int dishPartFramey=20;
    UIColor *dishPartfontColor=[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1];
    DishInfo *mydishInfo =[DishInfo selectByDishID:dishID];
    ShopCar *shopCar=[ShopCar selectWithPrice:mydishInfo.dishID withPrice:mydishInfo.dishPrice ];
    partflag=2;
    UIImageView *imageView;
    UIView *darkView;
    
    UILabel *hotdishNum;
    for (id obj in self.view.subviews){
        if ([obj isKindOfClass:[UIImageView class]])
        {
            if (((UIImageView*)obj).tag==98){
                imageView=(UIImageView*)obj;
            }
        }
    }
    for (id obj in imageView.subviews){
        if ([obj isKindOfClass:[UIView class]])
        {
            if (((UIView*)obj).tag==99){
                darkView=(UIView*)obj;
            }
        }
    }
    for (id obj in darkView.subviews)
    {
        if ([obj isKindOfClass:[UILabel class]])
        {
            UILabel *text = (UILabel*)obj;
            if (text.tag==40){
                hotdishNum=text;
            }
        }
    }
    hotdishNum.text=shopCar.sellCount;
    for (id obj in darkView.subviews){
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
    [dishPrice1 setFrame:CGRectMake(x+dishUnitfontSize, y-5, [self getAppropriateSize:mydishInfo.dishPrice withFontSize:dishPricefontSize], 30)];
    dishPrice1.textColor=[UIColor whiteColor];
    dishPrice1.font=[UIFont  systemFontOfSize:dishPricefontSize];
    dishPart1.frame=CGRectMake(dishPrice1.frame.size.width+dishPrice1.frame.origin.x+5, dishPartPointy, dishPartFramex, dishPartFramey);
    dishPart1.titleLabel.font=[UIFont  systemFontOfSize:dishPartfontSize];
    [dishPart1 setTitleColor:dishPartfontColor forState:UIControlStateNormal];
    
    
    x=dishPart1.frame.size.width+dishPart1.frame.origin.x+5;;
    dishUnitfontSize=28;
    dishPricefontSize=40;
    dishPartfontSize=26;
    dishPartPointy=55;
    dishPartFramex=60;
    dishPartFramey=30;
    y=60;
    dishUnit2.frame=CGRectMake(x, y, 30, 30);
    dishUnit2.font=[UIFont  systemFontOfSize:dishUnitfontSize];
    dishUnit2.textColor=[UIColor whiteColor];
    dishPrice2.frame=CGRectMake(0,0,0,0);
    [dishPrice2 setFrame:CGRectMake(x+dishUnitfontSize, y-5, [self getAppropriateSize:mydishInfo.dishPrice withFontSize:dishPricefontSize], 30)];
    dishPrice2.textColor=[UIColor whiteColor];
    dishPrice2.font=[UIFont  systemFontOfSize:dishPricefontSize];
    dishPart2.frame=CGRectMake(dishPrice2.frame.size.width+dishPrice2.frame.origin.x+5, dishPartPointy, dishPartFramex, dishPartFramey);
    dishPart2.titleLabel.font=[UIFont  systemFontOfSize:dishPartfontSize];
    [dishPart2 setTitleColor:[UIColor colorWithRed:233/255.0 green:80/255.0 blue:20/255.0 alpha:1] forState:UIControlStateNormal];
    
    x=dishPart2.frame.size.width+dishPart2.frame.origin.x+5;;
    y=65;
    dishUnitfontSize=18;
    dishPricefontSize=24;
    dishPartfontSize=18;
    dishPartPointy=65;
    dishPartFramex=40;
    dishPartFramey=20;
    dishUnit3.frame=CGRectMake(x, y, 30, 30);
    dishUnit3.font=[UIFont  systemFontOfSize:dishUnitfontSize];
    dishUnit3.textColor=[UIColor whiteColor];
    dishPrice3.frame=CGRectMake(0,0,0,0);
    [dishPrice3 setFrame:CGRectMake(x+dishUnitfontSize, y-5, [self getAppropriateSize:mydishInfo.dishPrice withFontSize:dishPricefontSize], 30)];
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
    int y=65;
    int dishUnitfontSize=18;
    int dishPricefontSize=24;
    int dishPartfontSize=18;
    int dishPartPointy=65;
    int dishPartFramex=40;
    int dishPartFramey=20;
    UIColor *dishPartfontColor=[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1];
    DishInfo *mydishInfo =[DishInfo selectByDishID:dishID];
    ShopCar *shopCar=[ShopCar selectWithPrice:mydishInfo.dishID withPrice:mydishInfo.bigDishPrice];
    partflag=3;
    UIImageView *imageView;
    UIView *darkView;
    
    UILabel *hotdishNum;
    for (id obj in self.view.subviews){
        if ([obj isKindOfClass:[UIImageView class]])
        {
            if (((UIImageView*)obj).tag==98){
                imageView=(UIImageView*)obj;
            }
        }
    }
    for (id obj in imageView.subviews){
        if ([obj isKindOfClass:[UIView class]])
        {
            if (((UIView*)obj).tag==99){
                darkView=(UIView*)obj;
            }
        }
    }
    for (id obj in darkView.subviews)
    {
        if ([obj isKindOfClass:[UILabel class]])
        {
            UILabel *text = (UILabel*)obj;
            if (text.tag==40){
                hotdishNum=text;
            }
        }
    }
    hotdishNum.text=shopCar.sellCount;
    for (id obj in darkView.subviews){
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
    [dishPrice1 setFrame:CGRectMake(x+dishUnitfontSize, y-5, [self getAppropriateSize:mydishInfo.dishPrice withFontSize:dishPricefontSize], 30)];
    dishPrice1.textColor=[UIColor whiteColor];
    dishPrice1.font=[UIFont  systemFontOfSize:dishPricefontSize];
    dishPart1.frame=CGRectMake(dishPrice1.frame.size.width+dishPrice1.frame.origin.x+5, dishPartPointy, dishPartFramex, dishPartFramey);
    dishPart1.titleLabel.font=[UIFont  systemFontOfSize:dishPartfontSize];
    [dishPart1 setTitleColor:dishPartfontColor forState:UIControlStateNormal];
    
    
    x=dishPart1.frame.size.width+dishPart1.frame.origin.x+5;;
    y=65;
    dishUnitfontSize=18;
    dishPricefontSize=24;
    dishPartfontSize=18;
    dishPartPointy=65;
    dishPartFramex=40;
    dishPartFramey=20;
    dishUnit2.frame=CGRectMake(x, y, 30, 30);
    dishUnit2.font=[UIFont  systemFontOfSize:dishUnitfontSize];
    dishUnit2.textColor=[UIColor whiteColor];
    dishPrice2.frame=CGRectMake(0,0,0,0);
    [dishPrice2 setFrame:CGRectMake(x+dishUnitfontSize, y-5, [self getAppropriateSize:mydishInfo.dishPrice withFontSize:dishPricefontSize], 30)];
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
    dishPartPointy=55;
    dishPartFramex=60;
    dishPartFramey=30;
    y=60;
    dishUnit3.frame=CGRectMake(x, y, 30, 30);
    dishUnit3.font=[UIFont  systemFontOfSize:dishUnitfontSize];
    dishUnit3.textColor=[UIColor whiteColor];
    dishPrice3.frame=CGRectMake(0,0,0,0);
    [dishPrice3 setFrame:CGRectMake(x+dishUnitfontSize, y-5, [self getAppropriateSize:mydishInfo.dishPrice withFontSize:dishPricefontSize], 30)];
    dishPrice3.textColor=[UIColor whiteColor];
    dishPrice3.font=[UIFont  systemFontOfSize:dishPricefontSize];
    dishPart3.frame=CGRectMake(dishPrice3.frame.size.width+dishPrice3.frame.origin.x+5, dishPartPointy, dishPartFramex, dishPartFramey);
    dishPart3.titleLabel.font=[UIFont  systemFontOfSize:dishPartfontSize];
    [dishPart3 setTitleColor:[UIColor colorWithRed:233/255.0 green:80/255.0 blue:20/255.0 alpha:1]
                    forState:UIControlStateNormal];
}
- (void)dismissDarkView {
    [self.delegate dismissDarkView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
