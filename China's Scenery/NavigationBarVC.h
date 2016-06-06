//
//  NavigationBarVC.h
//  China's Scenery
//
//  Created by 张保国 on 15/12/25.
//  Copyright © 2015年 ZhangBaoGuo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DSNavigationBar.h"
#import "UIView+AutoLayout.h"
#import "GeneralMethod.h"

#define IOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 ? YES : NO)
#define fStatusBarHeight (IOS7==YES ? 0 : 20)
#define fBackHeight      (IOS7==YES ? 0 : 15)

#define fNavBarHeigth (IOS7==YES ? 64 : 44)
#define fToolBarHeigth (IOS7==YES ? 64 : 44)

#define fDeviceWidth ([UIScreen mainScreen].bounds.size.width)
#define fDeviceHeight ([UIScreen mainScreen].bounds.size.height)

@interface NavigationBarVC : UIViewController
@property (nonatomic,strong) UIButton *leftButton;
@property (nonatomic,strong) UIButton *rightButton;
@property (nonatomic,strong) DSNavigationBar *navigationBar;
@end
