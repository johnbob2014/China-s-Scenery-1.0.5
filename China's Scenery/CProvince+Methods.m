//
//  CProvince+Methods.m
//  China's Scenery
//
//  Created by 张保国 on 15/12/24.
//  Copyright © 2015年 ZhangBaoGuo. All rights reserved.
//

#import "CProvince+Methods.h"

@implementation CProvince (Methods)

+(CProvince *)initWithName:(NSString *)aName inManagedObjectContext:(NSManagedObjectContext *)context{
    CProvince *cProivnce=nil;
    
    if (context) {
        NSFetchRequest *fetchRequest=[NSFetchRequest fetchRequestWithEntityName:@"CProvince"];
        fetchRequest.predicate=[NSPredicate predicateWithFormat:@"name=%@",aName];
        NSError *fetchError;
        NSArray *matches=[context executeFetchRequest:fetchRequest error:&fetchError];
        
        if (!matches || fetchError || [matches count]>1) {
            NSLog(@"Create new CProvince Error!");
        }else if([matches count]){
            cProivnce=[matches firstObject];
        }else if([matches count]==0){
            cProivnce=[CProvince newCProvinceWithName:aName inManagedObjectContext:context];
        }
    }
    
    return cProivnce;
}

+(CProvince *)newCProvinceWithName:(NSString *)aName inManagedObjectContext:(NSManagedObjectContext *)context{
    CProvince *newProvince=[NSEntityDescription insertNewObjectForEntityForName:@"CProvince" inManagedObjectContext:context];
    newProvince.name=aName;
    return newProvince;
}

+(NSArray *)cProvinceArrayInManagedObjectContext:(NSManagedObjectContext *)context{
    NSFetchRequest *fetchRequest=[NSFetchRequest fetchRequestWithEntityName:@"CProvince"];
    fetchRequest.predicate=nil;
    fetchRequest.sortDescriptors=@[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES selector:@selector(localizedStandardCompare:)]];
    NSError *fetchError;
    NSArray *matches=[context executeFetchRequest:fetchRequest error:&fetchError];
    return matches;
}

+(BOOL)deleteAllInManagedObjectContext:(NSManagedObjectContext *)context{
    NSArray *all=[CProvince cProvinceArrayInManagedObjectContext:context];
    for (CProvince *cProvince in all) {
        [context deleteObject:cProvince];
    }
    
    BOOL success=[context save:NULL];
    if (success) {
        NSLog(@"CProvince 已经清空!");
    }else{
        NSLog(@"CProvince 清空失败!");
    }
    
    return success;
}

@end
