//
//  CSMainTabBarController.m
//  China's Scenery
//
//  Created by 张保国 on 16/1/16.
//  Copyright © 2016年 ZhangBaoGuo. All rights reserved.
//

#import "CSMainTabBarController.h"
#import "GeneralMethod.h"

@interface CSMainTabBarController ()

@end

@implementation CSMainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //加上下面的语句，让LCTabBarController更新UI
    self.itemImageRatio=0.8;
    self.tabBarColor=[GM randomUIColor];
    
    self.viewControllers=self.viewControllers;
    
    self.selectedIndex=0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
