//
//  myAlert.m
//  eMenuPro
//
//  Created by Li Feng on 14-3-18.
//  Copyright (c) 2014年 Gong Lingxiao. All rights reserved.
//
#define kAlertViewBounce         20
#define kAlertViewBorder         10
#define kAlertButtonHeight       44

#define kAlertViewTitleFont             [UIFont boldSystemFontOfSize:20]
#define kAlertViewTitleTextColor        [UIColor colorWithRed:19/255.0 green:19/255.0 blue:19/255.0 alpha:0.5]

#define kAlertViewTitleShadowColor      [UIColor blackColor]
#define kAlertViewTitleShadowOffset     CGSizeMake(0, -1)

#define kAlertViewMessageFont           [UIFont systemFontOfSize:18]
#define kAlertViewMessageTextColor      [UIColor colorWithWhite:244.0/255.0 alpha:1.0]
#define kAlertViewMessageShadowColor    [UIColor blackColor]
#define kAlertViewMessageShadowOffset   CGSizeMake(0, -1)

#define kAlertViewButtonFont            [UIFont boldSystemFontOfSize:18]
#define kAlertViewButtonTextColor       [UIColor whiteColor]
#define kAlertViewButtonShadowColor     [UIColor blackColor]
#define kAlertViewButtonShadowOffset    CGSizeMake(0, -1)

#define kAlertViewBackgroundColor            [UIColor colorWithRed:19/255.0 green:19/255.0 blue:19/255.0 alpha:0.7]
#import "myAlert.h"

@implementation myAlert

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)layoutSubviews{
    for (UIView *v in self.subviews) {
        if ([v isKindOfClass:[UIImageView class]]) {
            UIImageView *imageV = (UIImageView *)v;
            imageV.backgroundColor=kAlertViewBackgroundColor;
        }
        if ([v isKindOfClass:[UILabel class]]) {
            UILabel *label = (UILabel *)v;
            if ([label.text isEqualToString:self.title]) {
                //label.font = [kAlertViewTitleFont retain];
                label.numberOfLines = 0;
                label.lineBreakMode = NSLineBreakByWordWrapping;
                label.textColor = kAlertViewTitleTextColor;
                label.backgroundColor = [UIColor clearColor];
                label.textAlignment = NSTextAlignmentCenter;
                label.shadowColor = kAlertViewTitleShadowColor;
                label.shadowOffset = kAlertViewTitleShadowOffset;
            }else{
                //label.font = [kAlertViewMessageFont retain];
                label.numberOfLines = 0;
                label.lineBreakMode = NSLineBreakByWordWrapping;
                label.textColor = kAlertViewMessageTextColor;
                label.backgroundColor = [UIColor clearColor];
                label.textAlignment = NSTextAlignmentCenter;
                label.shadowColor = kAlertViewMessageShadowColor;
                label.shadowOffset = kAlertViewMessageShadowOffset;
            }
        }
        if ([v isKindOfClass:NSClassFromString(@"UIAlertButton")]) {
            UIButton *button = (UIButton *)v;
            UIImage *image = nil;
            if (button.tag == 1) {
                image = [UIImage imageNamed:[NSString stringWithFormat:@"alert-%@-button.png", @"gray"]];
            }else{
                image = [UIImage imageNamed:[NSString stringWithFormat:@"alert-%@-button.png", @"black"]];
            }
            image = [image stretchableImageWithLeftCapWidth:(int)(image.size.width+1)>>1 topCapHeight:0];
            button.titleLabel.font = kAlertViewButtonFont;
            button.titleLabel.minimumScaleFactor = 10;
            button.titleLabel.textAlignment = NSTextAlignmentCenter;
            button.titleLabel.shadowOffset = kAlertViewButtonShadowOffset;
            button.backgroundColor = [UIColor colorWithRed:19/255.0 green:19/255.0 blue:19/255.0 alpha:0.5]
;
            //[button setBackgroundImage:image forState:UIControlStateNormal];
            [button setTitleColor:kAlertViewButtonTextColor forState:UIControlStateNormal];
            [button setTitleShadowColor:kAlertViewButtonShadowColor forState:UIControlStateNormal];
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
