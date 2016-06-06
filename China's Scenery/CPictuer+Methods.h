//
//  CPictuer+Methods.h
//  China's Scenery
//
//  Created by 张保国 on 15/12/24.
//  Copyright © 2015年 ZhangBaoGuo. All rights reserved.
//

#import "CPictuer.h"

@interface CPictuer (Methods)

+(CPictuer *)initWithName:(NSString *)aName
                inScenery:(CScenery *)aScenery
   inManagedObjectContext:(NSManagedObjectContext *)context;

+(CPictuer *)newCPictuerWithName:(NSString *)aName
                       inScenery:(CScenery *)aScenery
          inManagedObjectContext:(NSManagedObjectContext *)context;


+(NSArray *)cPictureArrayInManagedObjectContext:(NSManagedObjectContext *)context;

+(BOOL)deleteAllInManagedObjectContext:(NSManagedObjectContext *)context;

@end
