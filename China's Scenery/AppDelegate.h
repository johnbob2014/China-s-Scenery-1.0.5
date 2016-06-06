//
//  AppDelegate.h
//  China's Scenery
//
//  Created by 张保国 on 15/12/18.
//  Copyright © 2015年 ZhangBaoGuo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
//#import "SceneryModel.h"

//extern const SceneryModel *csModel;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

//@property (retain,nonatomic) SceneryModel *sceneryModel;

//@property (retain,nonatomic) NSOperationQueue *operationQueue;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

