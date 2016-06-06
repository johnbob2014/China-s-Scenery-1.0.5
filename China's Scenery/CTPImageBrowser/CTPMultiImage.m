//
//  CTPMultiImage.m
//  China's Scenery
//
//  Created by 张保国 on 16/1/13.
//  Copyright © 2016年 ZhangBaoGuo. All rights reserved.
//

#import "CTPMultiImage.h"

@implementation CTPMultiImage

+(CTPMultiImage *)initWithSdImage:(UIImage *)sdImage
                       hdImage:(UIImage *)hdImage
              placeholderImage:(UIImage *)placeholderImage
                         sdURL:(NSURL *)sdURL
                         hdURL:(NSURL *)hdURL
                   imageDetail:(NSString *)imageDetail{
    CTPMultiImage *new=[[CTPMultiImage alloc]init];
    if (new) {
        new.sdImage=sdImage;
        new.hdImage=hdImage;
        new.placeholderImage=placeholderImage;
        new.sdURL=sdURL;
        new.hdURL=hdURL;
        new.imageDetail=imageDetail;
    }
    return new;
}

@end
