//
//  CScenery+Methods.h
//  China's Scenery
//
//  Created by 张保国 on 15/12/24.
//  Copyright © 2015年 ZhangBaoGuo. All rights reserved.
//

#import "CScenery.h"

@interface CScenery (Methods)

+(CScenery *)initWithName:(NSString *)aName
               inProvince:(CProvince *)aProvince
   inManagedObjectContext:(NSManagedObjectContext *)context;


+(CScenery *)newCSceneryWithName:(NSString *)aName
                      inProvince:(CProvince *)aProvince
          inManagedObjectContext:(NSManagedObjectContext *)context;

+(NSArray *)cSceneryArrayInManagedObjectContext:(NSManagedObjectContext *)context;

+(BOOL)deleteAllInManagedObjectContext:(NSManagedObjectContext *)context;

@end
