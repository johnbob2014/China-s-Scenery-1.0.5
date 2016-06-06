//
//  CPictuer+CoreDataProperties.h
//  China's Scenery
//
//  Created by 张保国 on 15/12/27.
//  Copyright © 2015年 ZhangBaoGuo. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CPictuer.h"

NS_ASSUME_NONNULL_BEGIN

@interface CPictuer (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *detail;
@property (nullable, nonatomic, retain) NSNumber *height;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSNumber *width;
@property (nullable, nonatomic, retain) NSString *thumbnailName;
@property (nullable, nonatomic, retain) CScenery *scenery;

@end

NS_ASSUME_NONNULL_END
