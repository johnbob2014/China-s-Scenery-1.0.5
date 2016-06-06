//
//  GeneralMethod.h
//  China's Scenery
//
//  Created by 张保国 on 16/1/2.
//  Copyright © 2016年 ZhangBaoGuo. All rights reserved.
//

#import <UIKit/UIKit.h>

#define WeakSelf(className) __typeof (&*self) __weak weakSelf=self

#define GMImageSavedToDocumentDirectoryNotification @"GMImageSavedToDocumentDirectoryNotification"
#define GMImagePathKey @"GMImagePathKey"

#define default_Priority_Queue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define high_Priority_Queue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)
#define low_Priority_Queue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0)

@interface GM : NSObject
/*
 根据字符串内容返回显示字符串所需要的空大小
 */
+(CGSize)sizeForString:(NSString *)string usingFont:(UIFont *)font maxSize:(CGSize)maxSize;

+(UIColor *)randomUIColor;

+(void)logRect:(CGRect)rect;
+(void)logSize:(CGSize)size;

+(NSString *)filePathInDocumentDirectory:(NSString *)fileName;

+(void)saveImageToDocumentDirectory:(UIImage *)image forName:(NSString *)name;

+(void)showTipsLabelWithSize:(CGSize)size tips:(NSString *)tips removeAfterDelay:(NSTimeInterval)delay;

+(UIFont *)bodyFontWithSizeMultiplier:(CGFloat)multiplier;

+ (UIImage *)thumbImageFromImage:(UIImage *)sourceImage limitSize:(CGSize)limitSize;

@end
