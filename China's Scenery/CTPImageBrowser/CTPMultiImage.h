//
//  CTPMultiImage.h
//  China's Scenery
//
//  Created by 张保国 on 16/1/13.
//  Copyright © 2016年 ZhangBaoGuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CTPMultiImage : NSObject

@property (nonatomic,strong) UIImage *sdImage;
@property (nonatomic,strong) UIImage *hdImage;
@property (nonatomic,strong) UIImage *placeholderImage;
@property (nonatomic,strong) NSURL *sdURL;
@property (nonatomic,strong) NSURL *hdURL;
@property (nonatomic,strong) NSString *imageDetail;

+(CTPMultiImage *)initWithSdImage:(UIImage *)sdImage
                       hdImage:(UIImage *)hdImage
              placeholderImage:(UIImage *)placeholderImage
                         sdURL:(NSURL *)sdURL
                         hdURL:(NSURL *)hdURL
                   imageDetail:(NSString *)imageDetail;

@end
