//
//  NavigationBarVC.m
//  China's Scenery
//
//  Created by 张保国 on 15/12/25.
//  Copyright © 2015年 ZhangBaoGuo. All rights reserved.
//

#import "NavigationBarVC.h"

@interface NavigationBarVC()

@property (nonatomic,strong) UILabel *titleViewLabel;
@end

@implementation NavigationBarVC

-(void)setTitle:(NSString *)title{
    self.titleViewLabel.text=title;
}

-(void)initNavigationBarUI{
    self.navigationBar=[[DSNavigationBar alloc]initForAutoLayout];
    [self.navigationBar setNavigationBarWithColor:[GM randomUIColor]];
    [self.view addSubview:self.navigationBar];
    [self.navigationBar autoSetDimension:ALDimensionHeight toSize:fNavBarHeigth];
    [self.navigationBar autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
    
    self.titleViewLabel= [[UILabel alloc]initForAutoLayout];
    self.titleViewLabel.font=[UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    //_titleViewLabel.backgroundColor=[UIColor clearColor];
    self.titleViewLabel.textAlignment=NSTextAlignmentCenter;
    [self.view insertSubview:self.titleViewLabel aboveSubview:self.navigationBar];
    [self.titleViewLabel autoSetDimensionsToSize:CGSizeMake(200, 30)];
    [self.titleViewLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.navigationBar withOffset:10];
    [self.titleViewLabel autoAlignAxis:ALAxisVertical toSameAxisOfView:self.navigationBar];
    
    self.leftButton = [[UIButton alloc] initForAutoLayout];
    [self.view insertSubview:self.leftButton aboveSubview:self.navigationBar];
    [self.leftButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [self.leftButton autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.titleViewLabel];
    [self.leftButton autoSetDimensionsToSize:CGSizeMake(50, 30)];
    [self.leftButton addTarget:self action:@selector(leftButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    self.rightButton = [[UIButton alloc] initForAutoLayout];
    [self.view insertSubview:self.rightButton aboveSubview:self.navigationBar];
    [self.rightButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
    [self.rightButton autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.titleViewLabel];
    [self.rightButton autoSetDimensionsToSize:CGSizeMake(50, 30)];
    [self.rightButton addTarget:self action:@selector(rightButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)viewDidLoad{
    [self initNavigationBarUI];
    [self.leftButton setTitle:@" ⬅️ " forState:UIControlStateNormal];
    [self.rightButton setTitle:@" ⭐️ " forState:UIControlStateNormal];
}

-(void)leftButtonPressed:(id)sender{
    NSLog(@"点击左边按钮");
}

-(void)rightButtonPressed:(id)sender{
    NSLog(@"点击右边按钮");
}

@end
