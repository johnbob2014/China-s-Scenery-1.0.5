//
//  CTPImageBrowserVC.h
//  CTPImageView
//
//  Created by 张保国 on 16/1/5.
//  Copyright © 2016年 ZhangBaoGuo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CTPMultiImage.h"

@interface CTPImageBrowserVC : UIViewController

@property (nonatomic, strong) NSArray *multiImageArray;
@property (nonatomic, assign) NSInteger currentImageIndex;
@property (nonatomic, assign) NSInteger imageCount;

@end
