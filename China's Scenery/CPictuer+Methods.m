//
//  CPictuer+Methods.m
//  China's Scenery
//
//  Created by 张保国 on 15/12/24.
//  Copyright © 2015年 ZhangBaoGuo. All rights reserved.
//

#import "CPictuer+Methods.h"

@implementation CPictuer (Methods)

+(CPictuer *)initWithName:(NSString *)aName
                inScenery:(CScenery *)aScenery
   inManagedObjectContext:(NSManagedObjectContext *)context{
    CPictuer *cPicture=nil;
    
    if (context) {
        NSFetchRequest *fetchRequest=[NSFetchRequest fetchRequestWithEntityName:@"CPictuer"];
        fetchRequest.predicate=[NSPredicate predicateWithFormat:@"(name=%@) && (scenery=%@)",aName,aScenery];
        NSError *fetchError;
        NSArray *matches=[context executeFetchRequest:fetchRequest error:&fetchError];
        
        if (!matches || fetchError || [matches count]>1) {
            NSLog(@"Create new CPictuer Error!");
        }else if([matches count]==1){
            cPicture=[matches firstObject];
        }else if([matches count]==0){
            cPicture=[CPictuer newCPictuerWithName:aName inScenery:aScenery inManagedObjectContext:context];
        }
    }
    
    return cPicture;
}

+(CPictuer *)newCPictuerWithName:(NSString *)aName
                inScenery:(CScenery *)aScenery
   inManagedObjectContext:(NSManagedObjectContext *)context{
    
    CPictuer *newPicture=[NSEntityDescription insertNewObjectForEntityForName:@"CPictuer" inManagedObjectContext:context];
    newPicture.name=aName;
    newPicture.thumbnailName=[@"SD-" stringByAppendingString:aName];
    newPicture.scenery=aScenery;
    return newPicture;
}


+(NSArray *)cPictureArrayInManagedObjectContext:(NSManagedObjectContext *)context{
    NSFetchRequest *fetchRequest=[NSFetchRequest fetchRequestWithEntityName:@"CPictuer"];
    fetchRequest.predicate=nil;
    fetchRequest.sortDescriptors=@[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES selector:@selector(localizedStandardCompare:)]];
    NSError *fetchError;
    NSArray *matches=[context executeFetchRequest:fetchRequest error:&fetchError];
    return matches;
}

+(BOOL)deleteAllInManagedObjectContext:(NSManagedObjectContext *)context{
    NSArray *all=[CPictuer cPictureArrayInManagedObjectContext:context];
    for (CPictuer *cPictuer in all) {
        [context deleteObject:cPictuer];
    }
    
    BOOL success=[context save:NULL];
    if (success) {
        NSLog(@"CPictuer 已经清空!");
    }else{
        NSLog(@"CPictuer 清空失败!");
    }
    
    return success;
}

@end
