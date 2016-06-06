//
//  SceneryModel.m
//  China's Scenery
//
//  Created by 张保国 on 15/12/19.
//  Copyright © 2015年 ZhangBaoGuo. All rights reserved.
//

#import "SceneryModel.h"
#import "Qiniu.h"
#import "CSCoreDataConfig.h"
#import "AppDelegate.h"
#import "GeneralMethod.h"

#import <QNReachability.h>

const NSString * kStatus=@"status";
const NSString * kProvinces=@"provinces";
const NSString * kProvinceName=@"provinceName";
const NSString * kProvinceDetail=@"provinceDetail";
const NSString * kProvinceThumbnailName=@"provinceThumbnailName";
const NSString * kSceneries=@"sceneries";
const NSString * kSceneryName=@"sceneryName";
const NSString * kSceneryDetail=@"sceneryDetail";
const NSString * kSceneryThumbnailName=@"sceneryThumbnailName";
const NSString * kSceneryPictures=@"sceneryPictures";
const NSString * kSceneryUpdateUnix=@"sceneryUpdateUnix";
const NSString * kPictureName=@"pictureName";
const NSString * kPictureDetail =@"pictureDetail";
const NSString * kPictureThumbnailName=@"pictureThumbnailName";
const NSString * kPictureWidth =@"pictureWidth";
const NSString * kPictureHeight =@"pictureHeight";

#define ChinaSceneryDataFileName @"China-s-Scenery-Pro.json"


@interface SceneryModel()

@property (nonatomic,strong) NSArray *provinceArray;
@property (nonatomic,strong) NSTimer *mainTimer;
@property (nonatomic,strong) NSTimer *noDataTimer;
@property (nonatomic,strong) NSMutableArray *savedPicturePathArray;

//@property (nonatomic,assign) BOOL noDataNow;
@end

@implementation SceneryModel

#pragma mark - Getter&Setter
-(NSManagedObjectContext *)managedObjectContext{
    if (!_managedObjectContext) {
        AppDelegate *app=[UIApplication sharedApplication].delegate;
        _managedObjectContext=app.managedObjectContext;
    }
    return _managedObjectContext;
}

#pragma mark - canUseCellularData
@synthesize canUseCellularData=_canUseCellularData;

-(BOOL)canUseCellularData{
    //注意这里
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"canUseCellularData"];
}

-(void)setCanUseCellularData:(BOOL)canUseCellularData{
    [[NSUserDefaults standardUserDefaults] setBool:canUseCellularData forKey:@"canUseCellularData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    _canUseCellularData=canUseCellularData;
}

/*
#pragma mark - CoreData数据操作(刷新、清空、重载,前提是self.provinceArray已经更新）
-(BOOL)refreshCoreData{
    BOOL success;
    if (self.provinceArray) {
        @try {
            //开始更新数据
            for (NSDictionary *provinceDic in self.provinceArray) {
                NSString *provinceName=[provinceDic objectForKey:kProvinceName];
                if (provinceName) {
                    //Create or Refresh CProvince
                    CProvince *cProvince=[CProvince initWithName:provinceName inManagedObjectContext:self.managedObjectContext];
                    cProvince.detail=[provinceDic objectForKey:kProvinceDetail];
                    cProvince.thumbnailName=[provinceDic objectForKey:kProvinceThumbnailName];
                    
                    NSDictionary *sceneryArray=[provinceDic objectForKey:kSceneries];
                    for (NSDictionary *sceneryDic in sceneryArray) {
                        NSString *sceneryName=[sceneryDic objectForKey:kSceneryName];
                        if (sceneryName) {
                            //Create or Refresh CScenery
                            CScenery *cScenery=[CScenery initWithName:sceneryName inProvince:cProvince inManagedObjectContext:self.managedObjectContext];
                            NSArray *sceneryKeyArray=[sceneryDic allKeys];
                            if ([sceneryKeyArray containsObject:kSceneryDetail]) {
                                cScenery.detail=[sceneryDic objectForKey:kSceneryDetail];
                            }
                            if ([sceneryKeyArray containsObject:kSceneryThumbnailName]) {
                                cScenery.thumbnailName=[sceneryDic objectForKey:kSceneryThumbnailName];
                            }
                            
                            NSDictionary *pictureArray=[sceneryDic objectForKey:kSceneryPictures];
                            for (NSDictionary *pictureDic in pictureArray) {
                                NSString *pictureName=[pictureDic objectForKey:kPictureName];
                                if (pictureName) {
                                    //Create or Refresh CPicture
                                    CPictuer *cPicture=[CPictuer initWithName:pictureName inScenery:cScenery inManagedObjectContext:self.managedObjectContext];
                                    NSArray *pictureKeyArray=[pictureDic allKeys];
                                    if ([pictureKeyArray containsObject:kPictureDetail]) {
                                        NSString *pictureDetail=[pictureDic objectForKey:kPictureDetail];
                                        cPicture.detail=pictureDetail;
                                    }
                                    if ([pictureKeyArray containsObject:kPictureWidth]) {
                                        NSNumber *pictureWidth=[pictureDic objectForKey:kPictureWidth];
                                        cPicture.width=pictureWidth;
                                    }
                                    if ([pictureKeyArray containsObject:kPictureHeight]) {
                                        NSNumber *pictureHeight=[pictureDic objectForKey:kPictureHeight];
                                        cPicture.height=pictureHeight;
                                    }
                                    if ([pictureKeyArray containsObject:kPictureThumbnailName]) {
                                        cPicture.thumbnailName=[pictureDic objectForKey:kPictureThumbnailName];
                                    }

                                }
                            }//end pictureAray
                        }
                    }//end sceneryArray
                }
            }//end provinceArray

        }
        @catch (NSException *exception) {
            //<#Handle an exception thrown in the @try block#>
            NSLog(@"CoreData Exception:%@",[exception description]);
        }
        @finally {
           //<#Code that gets executed whether or not an exception is thrown#>
        }
        success=[self.managedObjectContext save:NULL];
    
    }else{
        NSLog(@"无法从数据文件中获取数据");
        success=NO;
    }
    
    if (success) {
        //发送数据更新完成通知
        [[NSNotificationCenter defaultCenter]postNotificationName:kSceneryModelRefreshedNotification object:self];
        self.noDataNow=NO;
    }
    
    return success;
}

-(BOOL)clearCoreData{
    @try {
        [CProvince deleteAllInManagedObjectContext:self.managedObjectContext];
        return YES;
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception);
        return NO;
    }
    @finally {
        return NO;
    }
}

-(BOOL)reCreateCoreData{
    BOOL clearSuccess = [self clearCoreData];
    BOOL refreshSuccess = [self refreshCoreData];
    return clearSuccess&&refreshSuccess;
}

#pragma mark - 根据CoreData数据生成JSON字典和文件


//生成JSON字典数据
-(NSArray *)createProvinceArray{
    
    NSMutableArray *provinceArray=[NSMutableArray new];
    NSArray *cProvinceArray=[CProvince cProvinceArrayInManagedObjectContext:self.managedObjectContext];
    [cProvinceArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CProvince *cProvince=(CProvince *)obj;
        NSMutableDictionary *provinceDic=[NSMutableDictionary new];
        [provinceDic setValue:cProvince.name forKey:[kProvinceName copy]];
        [provinceDic setValue:cProvince.detail forKey:[kProvinceDetail copy]];
        [provinceDic setValue:cProvince.thumbnailName forKey:[kProvinceThumbnailName copy]];
        
        NSArray *cSceneryArray=[cProvince.sceneries allObjects];
        NSMutableArray *sceneryArray=[NSMutableArray new];
        [cSceneryArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CScenery *cScenery=(CScenery *)obj;
            NSMutableDictionary *sceneryDic=[NSMutableDictionary new];
            [sceneryDic setValue:cScenery.name forKey:[kSceneryName copy]];
            [sceneryDic setValue:cScenery.thumbnailName forKey:[kSceneryThumbnailName copy]];
            [sceneryDic setValue:cScenery.detail forKey:[kSceneryDetail copy]];
            
            NSArray *cPictureArray=[cScenery.pictures allObjects];
            NSMutableArray *pictureArray=[NSMutableArray new];
            [cPictureArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                CPictuer *cPicture=(CPictuer *)obj;
                NSMutableDictionary *pictureDic=[NSMutableDictionary new];
                [pictureDic setValue:cPicture.name forKey:[kPictureName copy]];
                [pictureDic setValue:cPicture.detail forKey:[kPictureDetail copy]];
                [pictureDic setValue:cPicture.thumbnailName forKey:[kPictureThumbnailName copy]];
                [pictureDic setValue:cPicture.width forKey:[kPictureWidth copy]];
                [pictureDic setValue:cPicture.height forKey:[kPictureHeight copy]];
                
                [pictureArray addObject:pictureDic];
                
            }];//end of cPictureArray
            [sceneryDic setValue:pictureArray forKey:[kSceneryPictures copy]];
            
            [sceneryArray addObject:sceneryDic];
        }];//end of cSceneryArray
        
        [provinceDic setValue:sceneryArray forKey:[kSceneries copy]];
        [provinceArray addObject:provinceDic];
    }];//end of cProvinceArray
    
    return [NSArray arrayWithArray:provinceArray];
}

//生成JSON文件
-(NSString *)createJSONFile{
    NSString *filePath;
    
    NSMutableDictionary *dic=[NSMutableDictionary new];
    NSArray *provinceArray=[self createProvinceArray];
    if (provinceArray) {
        [dic setValue:@"OK" forKey:@"status"];
        [dic setValue:provinceArray forKey:@"provinces"];
        
        NSError *error;
        NSData *data=[NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
        
        if (data && !error) {
            
            NSDateFormatter *dateFormatter=[NSDateFormatter new];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            NSString *dateNow=[dateFormatter stringFromDate:[NSDate date]];
            
            NSURL *documentDirectory=[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask]lastObject];
            NSURL *fileLocalURLDirectory=[documentDirectory URLByAppendingPathComponent:[dateNow stringByAppendingString:@"_CSBackend"]];
            
            [[NSFileManager defaultManager] createDirectoryAtURL:fileLocalURLDirectory withIntermediateDirectories:YES attributes:nil error:NULL];
            
            NSURL *fileLocalURL=[fileLocalURLDirectory URLByAppendingPathComponent:ChinaSceneryDataFileName];
            
            filePath=[fileLocalURL path];
            
            if (![data writeToFile:filePath atomically:YES]) {
                NSLog(@"写入文件失败！");
                filePath=nil;
            }
            
        }else{
            NSLog(@"%@:%@",NSStringFromSelector(_cmd),[error localizedDescription]);
        }
    }
    NSLog(@"filePath:%@",filePath);
    return filePath;
    
}
*/



#pragma mark - init

+(instancetype)sharedModel{
    static id instance;
    static dispatch_once_t once;
    dispatch_once(&once,^{
        instance=[[self alloc]init];
    });
    return instance;
}

-(instancetype)init{
    self=[super init];
    if (self) {
        //接收文件保存通知
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(insertASavedPicture:) name:GMImageSavedToDocumentDirectoryNotification object:nil];
        
        //self.noDataTimer=[NSTimer scheduledTimerWithTimeInterval:20 target:self selector:@selector(noDataRefresh) userInfo:nil repeats:YES];
    }
    return self;
}

#pragma mark - 刷新模型

-(void)refreshCProvince{
    BOOL netWork=[self checkNetWork];
    if (netWork) {
        //网络畅通，从网络下载数据文件
        NSLog(@"从网络刷新省份...");
        NSURL *downloadURL=[[Qiniu sharedQN] downloadURLForFile:ChinaSceneryDataFileName];
        NSURLRequest *req=[NSURLRequest requestWithURL:downloadURL];
        
        NSError *sendRequestError;
        NSData *data=[NSURLConnection sendSynchronousRequest:req returningResponse:NULL error:&sendRequestError];
        if (!sendRequestError) {
            NSError *parseJSONError;
            NSDictionary *dataDic=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:NULL];
            if (!parseJSONError) {
                NSString *status=[dataDic objectForKey:@"status"];
                if ([status isEqualToString:@"OK"]) {
                    self.provinceArray=[dataDic objectForKey:@"provinces"];
                    [self refreshCProvinceCoreData];
                }
            }
        }
        
    }else{
        //网络不通，读取本地数据文件
        NSLog(@"网络不通，读取本地数据库");
    }
}

-(void)asyncRefreshCProvinceWithCompletionBlock:(CSCompletionBlock)block{
    BOOL netWork=[self checkNetWork];
    if (netWork) {
        //网络畅通，从网络下载数据文件
        NSLog(@"从网络刷新省份...");
        NSURL *downloadURL=[[Qiniu sharedQN] downloadURLForFile:ChinaSceneryDataFileName];
        NSURLRequest *req=[NSURLRequest requestWithURL:downloadURL];
        
//        NSError *sendRequestError;
//        
//        
//        NSData *data=[NSURLConnection sendSynchronousRequest:req returningResponse:NULL error:&sendRequestError];
//        if (!sendRequestError) {
//            NSError *parseJSONError;
//            NSDictionary *dataDic=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:NULL];
//            if (!parseJSONError) {
//                NSString *status=[dataDic objectForKey:@"status"];
//                if ([status isEqualToString:@"OK"]) {
//                    self.provinceArray=[dataDic objectForKey:@"provinces"];
//                    [self refreshCProvinceCoreData];
//                }
//            }
//        }
        //@try {
            [NSURLConnection sendAsynchronousRequest:req queue:[NSOperationQueue new] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
                
                if (!connectionError) {
                    NSError *parseJSONError;
                    NSDictionary *dataDic=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&parseJSONError];
                    
                    if (!parseJSONError) {
                        NSArray *keyArray=[dataDic allKeys];
                        if ([keyArray containsObject:@"status"]) {
                            NSString *status=[dataDic objectForKey:@"status"];
                            if ([status isEqualToString:@"OK"]) {
                                self.provinceArray=[dataDic objectForKey:@"provinces"];
                                [self refreshCProvinceCoreData];
                                if (block) {
                                    block();
                                }
                            }
                        }else{
                            NSLog(@"网络数据文件格式错误！");
                        }
                    }else{
                        NSLog(@"网络数据文件无法解析！");
                    }
                }else{
                    NSLog(@"%@",[connectionError localizedDescription]);
                }
                
            }];

//        }
//        @catch (NSException *exception) {
//            NSLog(@"%@:%@",NSStringFromSelector(_cmd),exception);
//        }
//        @finally {
//            if (block) {
//                block();
//            }
//            NSLog(@"刷新数据出错！ ");
//        }
        
    }else{
        //网络不通，读取本地数据文件
        NSLog(@"网络不通，读取本地数据库");
    }

}

-(void)refreshCProvinceCoreData{
    for (NSDictionary *provinceDic in self.provinceArray) {
        NSString *provinceName=[provinceDic objectForKey:kProvinceName];
        if (provinceName) {
            //Create or Refresh CProvince
            CProvince *cProvince=[CProvince initWithName:provinceName inManagedObjectContext:self.managedObjectContext];
            cProvince.detail=[provinceDic objectForKey:kProvinceDetail];
            cProvince.thumbnailName=[provinceDic objectForKey:kProvinceThumbnailName];
            
            NSDictionary *sceneryArray=[provinceDic objectForKey:kSceneries];
            for (NSDictionary *sceneryDic in sceneryArray) {
                NSArray *sceneryKeyArray=[sceneryDic allKeys];
                
                NSString *sceneryName=[sceneryDic objectForKey:kSceneryName];
                CScenery *cScenery=[CScenery initWithName:sceneryName inProvince:cProvince inManagedObjectContext:self.managedObjectContext];
                if ([sceneryKeyArray containsObject:kSceneryThumbnailName]) {
                    cScenery.thumbnailName=[sceneryDic objectForKey:kSceneryThumbnailName];
                }
            }//end sceneryArray
        }
    }//end provinceArray
}

-(void)refreshCScenery:(NSString *)sceneryName{
    if (sceneryName) {
        BOOL netWork=[self checkNetWork];
        if (netWork) {
            //网络畅通，从网络下载数据文件
            NSLog(@"从网络刷新风景...");
            NSString *sceneryJSONFileName=[sceneryName stringByAppendingString:@".json"];
            NSURL *downloadURL=[[Qiniu sharedQN] downloadURLForFile:sceneryJSONFileName];
            NSURLRequest *req=[NSURLRequest requestWithURL:downloadURL];
            
            NSError *sendRequestError;
            NSData *data=[NSURLConnection sendSynchronousRequest:req returningResponse:NULL error:&sendRequestError];
            if (!sendRequestError) {
                NSError *parseJSONError;
                NSDictionary *sceneryDic=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:NULL];
                if (!parseJSONError) {
                    NSArray *sceneryKeyArray=[sceneryDic allKeys];
                    if ([sceneryKeyArray containsObject:kSceneryName]) {
                        [self refreshCSceneryCoreData:sceneryDic];
                    }else{
                        NSLog(@"网络数据文件格式错误！");
                    }
                }else{
                    NSLog(@"网络数据文件无法解析！");
                }
            }else{
                NSLog(@"%@",[sendRequestError localizedDescription]);
            }
            
        }else{
            //网络不通，读取本地数据文件
            NSLog(@"网络不通，读取本地数据库");
        }

    }
}

-(void)asyncRefreshCScenery:(NSString *)sceneryName completionBlock:(CSCompletionBlock)block{
    if (sceneryName) {
        BOOL netWork=[self checkNetWork];
        if (netWork) {
            //网络畅通，从网络下载数据文件
            NSLog(@"从网络刷新风景...");
            NSString *sceneryJSONFileName=[sceneryName stringByAppendingString:@".json"];
            NSURL *downloadURL=[[Qiniu sharedQN] downloadURLForFile:sceneryJSONFileName];
            NSURLRequest *req=[NSURLRequest requestWithURL:downloadURL];
            
            //@try {
                [NSURLConnection sendAsynchronousRequest:req queue:[NSOperationQueue new] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
                    if (!connectionError) {
                        NSError *parseJSONError;
                        NSDictionary *sceneryDic=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:NULL];
                        //NSLog(@"%@",sceneryDic);
                        
                        if (!parseJSONError) {
                            NSArray *sceneryKeyArray=[sceneryDic allKeys];
                            if ([sceneryKeyArray containsObject:kSceneryName]) {
                                [self refreshCSceneryCoreData:sceneryDic];
                                if (block) {
                                    block();
                                }
                            }else{
                                NSLog(@"网络数据文件格式错误！");
                            }
                        }else{
                            NSLog(@"网络数据文件无法解析！");
                        }
                    }else{
                        NSLog(@"%@",[connectionError localizedDescription]);
                    }
                    
                }];

//            }
//            @catch (NSException *exception) {
//                NSLog(@"%@:%@",NSStringFromSelector(_cmd),exception);
//            }
//            @finally {
//                if (block) {
//                    block();
//                }
//                
//            }
        }else{
            //网络不通，读取本地数据文件
            NSLog(@"网络不通，读取本地数据库");
        }
    }

}

-(void)refreshCSceneryCoreData:(NSDictionary *)sceneryDic{
    //Create or Refresh CScenery
    NSString *sceneryName=[sceneryDic objectForKey:kSceneryName];
    NSString *provinceName=[sceneryDic objectForKey:kProvinceName];
    CProvince *cProvince=[CProvince initWithName:provinceName inManagedObjectContext:self.managedObjectContext];
    CScenery *cScenery=[CScenery initWithName:sceneryName inProvince:cProvince inManagedObjectContext:self.managedObjectContext];
    NSArray *sceneryKeyArray=[sceneryDic allKeys];
    if ([sceneryKeyArray containsObject:kSceneryDetail]) {
        cScenery.detail=[sceneryDic objectForKey:kSceneryDetail];
    }
    
    if ([sceneryKeyArray containsObject:kSceneryUpdateUnix]) {
        cScenery.updateUnix=[sceneryDic objectForKey:kSceneryUpdateUnix];
    }
    if ([sceneryKeyArray containsObject:kProvinceName]) {
        cScenery.provinceName=[sceneryDic objectForKey:kProvinceName];
    }
    
    
    NSDictionary *pictureArray=[sceneryDic objectForKey:kSceneryPictures];
    for (NSDictionary *pictureDic in pictureArray) {
        NSString *pictureName=[pictureDic objectForKey:kPictureName];
        if (pictureName) {
            //Create or Refresh CPicture
            CPictuer *cPicture=[CPictuer initWithName:pictureName inScenery:cScenery inManagedObjectContext:self.managedObjectContext];
            NSArray *pictureKeyArray=[pictureDic allKeys];
            if ([pictureKeyArray containsObject:kPictureDetail]) {
                NSString *pictureDetail=[pictureDic objectForKey:kPictureDetail];
                cPicture.detail=pictureDetail;
            }
            if ([pictureKeyArray containsObject:kPictureWidth]) {
                NSNumber *pictureWidth=[pictureDic objectForKey:kPictureWidth];
                cPicture.width=pictureWidth;
            }
            if ([pictureKeyArray containsObject:kPictureHeight]) {
                NSNumber *pictureHeight=[pictureDic objectForKey:kPictureHeight];
                cPicture.height=pictureHeight;
            }
            if ([pictureKeyArray containsObject:kPictureThumbnailName]) {
                cPicture.thumbnailName=[pictureDic objectForKey:kPictureThumbnailName];
            }
            
        }
    }//end pictureAray

}

/*
-(void)parseJSONFromFile:(NSURL *)fileURL{
    if (fileURL) {
        //NSLog(@"解析数据:\n");
        NSData *data=[NSData dataWithContentsOfURL:fileURL];
        //NSLog(@"%@",data);
        NSError *parseJSONError;
        NSDictionary *dataDic=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&parseJSONError];
        if (!parseJSONError) {
            NSString *status=[dataDic objectForKey:@"status"];
            if ([status isEqualToString:@"OK"]) {
                self.provinceArray=[dataDic objectForKey:@"provinces"];
                //NSLog(@"数据解析成功!\n");
                //NSLog(@"%@",self.provinceArray);
                [self refreshCoreData];
            }
        }
    }
}
*/

#pragma mark - 设置模型的定时刷新
-(void)setRefreshInterval:(NSTimeInterval)refreshInterval{
    _refreshInterval=refreshInterval;
    if (refreshInterval) {
        self.mainTimer=nil;
        self.mainTimer=[NSTimer scheduledTimerWithTimeInterval:refreshInterval target:self selector:@selector(asyncRefreshCProvinceWithCompletionBlock:) userInfo:nil repeats:YES];
    }else{
        self.mainTimer=nil;
    }
}

#pragma mark - Deal Image Saved Notification
-(void)insertASavedPicture:(NSNotification *)noti{
    NSLog(@"SceneryModel_GetNoti: image saved noti");
    NSString *picturePath=noti.userInfo[GMImagePathKey];
    
    if (picturePath && ![self.savedPicturePathArray containsObject:picturePath]) {
        [self.savedPicturePathArray addObject:picturePath];
        
        NSArray *saveArray=[NSArray arrayWithArray:self.savedPicturePathArray];
        [[NSUserDefaults standardUserDefaults] setObject:saveArray forKey:kSavedPicturePathArray];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        NSLog(@"SavedImage count:%lu",(unsigned long)[self.savedPicturePathArray count]);
    }
    
}

-(NSMutableArray *)savedPicturePathArray{
    if (!_savedPicturePathArray) {
        NSArray *oldArray=(NSArray *)[[NSUserDefaults standardUserDefaults] objectForKey:kSavedPicturePathArray];
        if (oldArray && [oldArray count]) {
            _savedPicturePathArray=[NSMutableArray arrayWithArray:oldArray];
        }else{
            _savedPicturePathArray=[[NSMutableArray alloc]init];
        }
    }
    return _savedPicturePathArray;
}

-(void)asyncClearSavedImageWithCompletionBlock:(CSCompletionBlock)block{
    dispatch_async(low_Priority_Queue, ^{
        //NSLog(@"%@",self.savedPicturePathArray);
        [self.savedPicturePathArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *filePath=(NSString *)obj;
            NSError *error;
            if ([[NSFileManager defaultManager] removeItemAtPath:filePath error:&error]) {
                NSLog(@"%lu %@ has deleted!",(unsigned long)idx,[filePath lastPathComponent]);
            }else{
                NSLog(@"%@",[error description]);
            }
        }];
        
        //删除时不要忘记修改存储！！！
        self.savedPicturePathArray=[[NSMutableArray alloc]init];
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:kSavedPicturePathArray];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        if (block) {
            block();
        }
        
    });
}

-(void)sizeOfSavedImage{
    [self.savedPicturePathArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *filePath=(NSString *)obj;
        NSLog(@"%@",filePath);
        NSDictionary *attribute=[[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:NULL];
        //NSInteger fileSize=[[attribute objectForKey:NSFileSize] integerValue];
        NSLog(@"%llu",[attribute fileSize]);
    }];
}

#pragma mark - 检查网络状态
-(BOOL)checkNetWork{
    BOOL netWork=NO;
    QNReachability *reachability=[QNReachability reachabilityForInternetConnection];
    QNNetworkStatus networkStatus=[reachability currentReachabilityStatus];
    
    CGFloat screenWidth=[UIScreen mainScreen].bounds.size.width;
    switch (networkStatus) {
            
        case QNReachableViaWiFi:{
            //NSLog(@"QNReachableViaWiFi");
            netWork=YES;
        }
            break;
            
        case QNReachableViaWWAN:{
            
            if (self.canUseCellularData) {
                //NSLog(@"%d",self.canUseCellularData);
                netWork=YES;
                //NSLog(@"QNReachableViaWWAN");
            }else{
                netWork=NO;
                [GM showTipsLabelWithSize:CGSizeMake(screenWidth/2, 80) tips:@"蜂窝移动数据已被禁用!" removeAfterDelay:0.8];
//                dispatch_once_t once;
//                dispatch_once(&once, ^{
//                    [GM showTipsLabelWithSize:CGSizeMake(screenWidth/2, 80) tips:@"蜂窝移动数据已被禁用!" removeAfterDelay:2];
//                });
            }
        }
            break;
            
        case QNNotReachable:{
            netWork=NO;
            //NSLog(@"QNNotReachable");
            [GM showTipsLabelWithSize:CGSizeMake(screenWidth/2, 80) tips:@"当前网络不可用!" removeAfterDelay:0.8];
//            dispatch_once_t once;
//            dispatch_once(&once, ^{
//                [GM showTipsLabelWithSize:CGSizeMake(screenWidth/2, 80) tips:@"当前网络不可用!" removeAfterDelay:2];
//            });
        }
            break;
            
        default:
            break;
    }
    
    return netWork;
}


/*
- (NSArray *)sceneryArrayInProvince:(NSString *)provinceName{
    NSMutableArray *array=[[NSMutableArray alloc]init];
    
    if (self.provinceArray) {
        for (NSDictionary *provinceDic in self.provinceArray) {
            NSString *name=[provinceDic objectForKey:kProvinceName];
            if ([name isEqualToString:provinceName]) {
                array=[provinceDic objectForKey:kSceneries];
            }
        }
    }
    //NSLog(@"sceneryArray\n%@",array);
    return array;
}

- (NSArray *)pictureArrayInScenery:(NSString *)sceneryName inProvince:(NSString *)provinceName{
    NSMutableArray *array=[[NSMutableArray alloc]init];
    
    NSArray *sceneryArray=[self sceneryArrayInProvince:provinceName];
    if (sceneryArray) {
        for (NSDictionary *sceneryDic in sceneryArray) {
            NSString *name=[sceneryDic objectForKey:kSceneryName];
            if ([name isEqualToString:sceneryName]) {
                array=[sceneryDic objectForKey:kSceneryPictures];
            }
        }
    }
    //NSLog(@"pictureArray\n%@",array);
    return array;
}
 */

/*
#pragma mark - Qiniu Methods
-(NSURL *)fileURLWithName:(NSString *)fileName fromQiniu:(Qiniu *)qn{
    if(!fileName) return nil;
    NSURL *fileURL;
    
    NSString *filePath=[GM filePathInDocumentDirectory:fileName];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        fileURL=[NSURL fileURLWithPath:filePath];
    }else{
        fileURL=[qn downloadURLWithName:fileName];
    }

    return fileURL;
}
*/
@end
