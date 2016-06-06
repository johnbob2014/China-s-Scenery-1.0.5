//
//  CScenery+CoreDataProperties.h
//  China's Scenery
//
//  Created by 张保国 on 16/1/23.
//  Copyright © 2016年 ZhangBaoGuo. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CScenery.h"

NS_ASSUME_NONNULL_BEGIN

@interface CScenery (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *detail;
@property (nullable, nonatomic, retain) NSNumber *isInFavourites;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *thumbnailName;
@property (nullable, nonatomic, retain) NSString *provinceName;
@property (nullable, nonatomic, retain) NSNumber *updateUnix;
@property (nullable, nonatomic, retain) NSSet<CPictuer *> *pictures;
@property (nullable, nonatomic, retain) CProvince *province;

@end

@interface CScenery (CoreDataGeneratedAccessors)

- (void)addPicturesObject:(CPictuer *)value;
- (void)removePicturesObject:(CPictuer *)value;
- (void)addPictures:(NSSet<CPictuer *> *)values;
- (void)removePictures:(NSSet<CPictuer *> *)values;

@end

NS_ASSUME_NONNULL_END
