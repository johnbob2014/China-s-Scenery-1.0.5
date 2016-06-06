//
//  CScenery+Methods.m
//  China's Scenery
//
//  Created by 张保国 on 15/12/24.
//  Copyright © 2015年 ZhangBaoGuo. All rights reserved.
//

#import "CScenery+Methods.h"

@implementation CScenery (Methods)

+(CScenery *)initWithName:(NSString *)aName
               inProvince:(CProvince *)aProvince
   inManagedObjectContext:(NSManagedObjectContext *)context;
{
    CScenery *cScenery=nil;
    
    if (context) {
        NSFetchRequest *fetchRequest=[NSFetchRequest fetchRequestWithEntityName:@"CScenery"];
        fetchRequest.predicate=[NSPredicate predicateWithFormat:@"(name=%@) && (province=%@)",aName,aProvince];
        NSError *fetchError;
        NSArray *matches=[context executeFetchRequest:fetchRequest error:&fetchError];
        
        if (!matches || fetchError || [matches count]>1) {
            NSLog(@"Create new CScenery Error!");
        }else if([matches count]==1){
            cScenery=[matches firstObject];
        }else if([matches count]==0){
            cScenery=[CScenery newCSceneryWithName:aName inProvince:aProvince inManagedObjectContext:context];
        }
    }
    
    return cScenery;

}

+(CScenery *)newCSceneryWithName:(NSString *)aName
               inProvince:(CProvince *)aProvince
   inManagedObjectContext:(NSManagedObjectContext *)context;
{
    CScenery *newScenery=[NSEntityDescription insertNewObjectForEntityForName:@"CScenery" inManagedObjectContext:context];
    newScenery.name=aName;
    newScenery.province=aProvince;
    
    return newScenery;
}


+(NSArray *)cSceneryArrayInManagedObjectContext:(NSManagedObjectContext *)context{
    NSFetchRequest *fetchRequest=[NSFetchRequest fetchRequestWithEntityName:@"CScenery"];
    fetchRequest.predicate=nil;
    fetchRequest.sortDescriptors=@[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES selector:@selector(localizedStandardCompare:)]];
    NSError *fetchError;
    NSArray *matches=[context executeFetchRequest:fetchRequest error:&fetchError];
    return matches;
}

+(BOOL)deleteAllInManagedObjectContext:(NSManagedObjectContext *)context{
    NSArray *all=[CScenery cSceneryArrayInManagedObjectContext:context];
    for (CScenery *cScenery in all) {
        [context deleteObject:cScenery];
    }
    
    BOOL success=[context save:NULL];
    if (success) {
        NSLog(@"CScenery 已经清空!");
    }else{
        NSLog(@"CScenery 清空失败!");
    }
    
    return success;
}

@end
