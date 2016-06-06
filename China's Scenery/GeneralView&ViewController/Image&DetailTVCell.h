//
//  Image&DetailTVCell.h
//  China's Scenery
//
//  Created by 张保国 on 16/1/9.
//  Copyright © 2016年 ZhangBaoGuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Image_DetailTVCell : UITableViewCell

@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *detail;
@property (nonatomic,assign) BOOL isInFavourites;

@property (nonatomic,strong) NSURL *imageURL;
@property (nonatomic,strong) NSString *imagePath;

@property (nonatomic,strong) UIImage *image;

@property (nonatomic) UIViewContentMode imageViewContentMode;

@end
