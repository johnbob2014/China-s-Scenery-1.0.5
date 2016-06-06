//
//  SceneryModel.h
//  China's Scenery
//
//  Created by 张保国 on 15/12/19.
//  Copyright © 2015年 ZhangBaoGuo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>
#import "Qiniu.h"

@class Qiniu;

extern const NSString * kStatus;
extern const NSString * kProvinces;
extern const NSString * kProvinceName;
extern const NSString * kProvinceDetail;
extern const NSString * kProvinceThumbnailName;
extern const NSString * kSceneries;
extern const NSString * kSceneryName;
extern const NSString * kSceneryDetail;
extern const NSString * kSceneryThumbnailName;
extern const NSString * kSceneryPictures;
extern const NSString * kSceneryUpdateUnix;
extern const NSString * kPictureName;
extern const NSString * kPictureThumbnailName;
extern const NSString * kPictureDetail;
extern const NSString * kPictureWidth;
extern const NSString * kPictureHeight;


#define kSavedPicturePathArray @"kSavedPicturePathArray"
#define kSceneryModelRefreshedNotification @"kSceneryModelRefreshedNotification"
#define CSTimeout 6.0f

//typedef void(^ProvinceRefreshCompletionBlock)(NSDate *date);
//typedef void(^SceneryRefreshCompletionBlock)();
typedef void(^CSCompletionBlock)();

@interface SceneryModel : NSObject

@property (nonatomic,assign) NSTimeInterval refreshInterval;

@property (nonatomic,strong) NSManagedObjectContext *managedObjectContext;

@property (nonatomic,assign) BOOL canUseCellularData;

+(instancetype)sharedModel;

-(void)refreshCProvince;
-(void)asyncRefreshCProvinceWithCompletionBlock:(CSCompletionBlock)block;

-(void)refreshCScenery:(NSString *)sceneryName;
-(void)asyncRefreshCScenery:(NSString *)sceneryName completionBlock:(CSCompletionBlock)block;

-(BOOL)checkNetWork;

-(void)sizeOfSavedImage;

-(void)asyncClearSavedImageWithCompletionBlock:(CSCompletionBlock)block;

@end
