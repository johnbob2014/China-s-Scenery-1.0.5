//
//  CProvince+CoreDataProperties.h
//  China's Scenery
//
//  Created by 张保国 on 15/12/27.
//  Copyright © 2015年 ZhangBaoGuo. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CProvince.h"

NS_ASSUME_NONNULL_BEGIN

@interface CProvince (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *detail;
@property (nullable, nonatomic, retain) NSString *thumbnailName;
@property (nullable, nonatomic, retain) NSSet<CScenery *> *sceneries;

@end

@interface CProvince (CoreDataGeneratedAccessors)

- (void)addSceneriesObject:(CScenery *)value;
- (void)removeSceneriesObject:(CScenery *)value;
- (void)addSceneries:(NSSet<CScenery *> *)values;
- (void)removeSceneries:(NSSet<CScenery *> *)values;

@end

NS_ASSUME_NONNULL_END
