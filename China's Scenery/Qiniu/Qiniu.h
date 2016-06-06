//
//  Qiniu.h
//  WaterFlowCollectionView
//
//  Created by 张保国 on 15/12/20.
//  Copyright © 2015年 ZhangBaoGuo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Qiniu : NSObject

@property (strong,nonatomic) NSString *QNURL;
@property (strong,nonatomic) NSString *QNBucketName;
@property (strong,nonatomic) NSString *QNAccessKey;
@property (strong,nonatomic) NSString *QNSecretKey;

-(instancetype)initWithQNURL:(NSString *)url
            withQNBucketName:(NSString *)bucketName
             withQNAccessKey:(NSString *)accessKey
             withQNSecretKey:(NSString *)secretKey;


-(NSURL *)downloadURLForFile:(NSString *)fileName;
+(NSURL *)downloadURLForFile:(NSString *)fileName urlString:(NSString *)urlString accessKey:(NSString *)accessKey secretKey:(NSString *)secretKey;

+(instancetype)sharedQN;

-(NSString *)upToken;
+(NSString *)upTokenWithBucketName:(NSString *)bucketName accessKey:(NSString *)accessKey secretKey:(NSString *)secretKey;

-(NSString *)accessToken:(NSString *)string;
+(NSString *)accessToken:(NSString *)string accessKey:(NSString *)accessKey secretKey:(NSString *)secretKey;

-(BOOL)syncDeleteFile:(NSString *)fileName;
+(BOOL)syncDeleteFile:(NSString *)fileName bucketName:(NSString *)bucketName accessKey:(NSString *)accessKey secretKey:(NSString *)secretKey;

-(BOOL)syncMoveFromFile:(NSString *)srcFileName toFile:(NSString *)destFileName;
+(BOOL)syncMoveFromFile:(NSString *)srcFileName toFile:(NSString *)destFileName bucketName:(NSString *)bucketName accessKey:(NSString *)accessKey secretKey:(NSString *)secretKey;

@end
