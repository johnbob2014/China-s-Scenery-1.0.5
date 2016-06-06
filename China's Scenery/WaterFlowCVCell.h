//
//  WaterFlowCVCell.h
//  WaterFlowCollectionView
//
//  Created by 张保国 on 15/12/20.
//  Copyright © 2015年 ZhangBaoGuo. All rights reserved.
//

#import <UIKit/UIKit.h>

#define CORNER_FONT_STANDARD_HEIGHT 180.0
#define CORNER_RADIUS 3.0

@interface WaterFlowCVCell : UICollectionViewCell

@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSURL *imageURL;
@property (nonatomic,strong) NSString *imagePath;

@property (nonatomic,strong) UIImage *image;

@property (nonatomic) UIViewContentMode imageViewContentMode;

@end
