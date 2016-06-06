//
//  CProvince+Methods.h
//  China's Scenery
//
//  Created by 张保国 on 15/12/24.
//  Copyright © 2015年 ZhangBaoGuo. All rights reserved.
//

#import "CProvince.h"

@interface CProvince (Methods)

+(CProvince *)initWithName:(NSString *)aName inManagedObjectContext:(NSManagedObjectContext *)context;
+(CProvince *)newCProvinceWithName:(NSString *)aName inManagedObjectContext:(NSManagedObjectContext *)context;

+(NSArray *)cProvinceArrayInManagedObjectContext:(NSManagedObjectContext *)context;

+(BOOL)deleteAllInManagedObjectContext:(NSManagedObjectContext *)context;

@end
