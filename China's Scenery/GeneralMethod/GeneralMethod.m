//
//  GeneralMethod.m
//  China's Scenery
//
//  Created by 张保国 on 16/1/2.
//  Copyright © 2016年 ZhangBaoGuo. All rights reserved.
//

#import "GeneralMethod.h"

@implementation GM

+(UIFont *)bodyFontWithSizeMultiplier:(CGFloat)multiplier{
    UIFont *bodyFont=[UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    return [UIFont fontWithName:bodyFont.fontName size:bodyFont.pointSize*multiplier];
}

+(CGSize)sizeForString:(NSString *)string usingFont:(UIFont *)font maxSize:(CGSize)maxSize{
    
    NSStringDrawingOptions stringDrawingOptions=NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    
    NSMutableParagraphStyle *paragraphStyle=[[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode=NSLineBreakByCharWrapping;
    NSDictionary *attributesDic=@{NSFontAttributeName:font,
                                  NSParagraphStyleAttributeName:paragraphStyle};
    
    CGRect rect=[string boundingRectWithSize:maxSize
                                     options:stringDrawingOptions
                                  attributes:attributesDic
                                     context:nil];
    
    return rect.size;
}

+(UIColor *)randomUIColor{
    CGFloat randomRed=MIN((CGFloat)(arc4random()%11)/10, 1.0);
    CGFloat randomGreen=MIN((CGFloat)(arc4random()%11)/10, 1.0);
    CGFloat randomBlue=MIN((CGFloat)(arc4random()%11)/10, 1.0);
    CGFloat randomAlpha=MIN((CGFloat)(arc4random()%11)/10, 1.0);
    return [UIColor colorWithRed:randomRed green:randomGreen blue:randomBlue alpha:randomAlpha];
}

+(void)showTipsLabelWithSize:(CGSize)size tips:(NSString *)tips removeAfterDelay:(NSTimeInterval)delay{
    UILabel *label = [[UILabel alloc] init];
    
    label.font = [UIFont systemFontOfSize:16];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor colorWithRed:0.1f green:0.1f blue:0 alpha:0.9f];
    label.layer.cornerRadius = 5;
    label.clipsToBounds = YES;
    label.textAlignment = NSTextAlignmentCenter;
    
    label.text=tips;
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    label.center=window.center;
    label.bounds=CGRectMake(0, 0, size.width, size.height);
    [[UIApplication sharedApplication].keyWindow addSubview:label];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:label];
    [label performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:delay];
}

+(void)logRect:(CGRect)rect{
    NSLog(@"%0.f,%0.f,%0.f,%0.f",rect.origin.x,rect.origin.y,rect.size.width,rect.size.height);
}

+(void)logSize:(CGSize)size{
    NSLog(@"%0.f,%0.f",size.width,size.height);
}

+(NSString *)filePathInDocumentDirectory:(NSString *)fileName{
    if (!fileName) {
        return nil;
    }
    
    NSURL *documentDirectory=[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask]lastObject];
    NSURL *fileLocalURL=[documentDirectory URLByAppendingPathComponent:fileName];
    NSString *filePath=[fileLocalURL path];
    
    return filePath;
}


+(void)saveImageToDocumentDirectory:(UIImage *)image forName:(NSString *)name{
    NSString *filePath=[GM filePathInDocumentDirectory:name];
    NSData *fileData=UIImageJPEGRepresentation(image, 1);
    
    if ([fileData writeToFile:filePath atomically:YES]) {
        NSLog(@"GM_Noti: %@ has saved to local!",name);
        NSMutableDictionary *userInfo=[NSMutableDictionary new];
        [userInfo setValue:filePath forKey:GMImagePathKey];
        [[NSNotificationCenter defaultCenter] postNotificationName:GMImageSavedToDocumentDirectoryNotification object:nil userInfo:userInfo];
    }
}

+ (UIImage *)thumbImageFromImage:(UIImage *)sourceImage limitSize:(CGSize)limitSize {
    if (sourceImage.size.width <= limitSize.width && sourceImage.size.height <= limitSize.height) {
        return sourceImage;
    }
    CGSize thumbSize;
    if (sourceImage.size.width / sourceImage.size.height > limitSize.width / limitSize.height){
        thumbSize.width = limitSize.width;
        thumbSize.height = limitSize.width / sourceImage.size.width * sourceImage.size.height;
    }
    else {
        thumbSize.height = limitSize.height;
        thumbSize.width = limitSize.height / sourceImage.size.height * sourceImage.size.width;
    }
    UIGraphicsBeginImageContext(thumbSize);
    [sourceImage drawInRect:(CGRect){CGPointZero,thumbSize}];
    UIImage *thumbImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return thumbImg;
}

@end
