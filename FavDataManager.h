//
//  FavDataManager.h
//  TEQWIN_PROJECT
//
//  Created by Teqwin on 1/8/14.
//  Copyright (c) 2014年 Teqwin. All rights reserved.
//

#import <Foundation/Foundation.h>
extern NSString * const DataManagerDidSaveNotification;
extern NSString * const DataManagerDidSaveFailedNotification;
@interface FavDataManager : NSObject
@property (nonatomic, readonly, retain) NSManagedObjectModel *objectModel;
@property (nonatomic, readonly, retain) NSManagedObjectContext *mainObjectContext;
@property (nonatomic, readonly, retain) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (FavDataManager*)sharedInstance;
- (BOOL)save;
- (NSManagedObjectContext*)managedObjectContext;
- (BOOL)hasUpdated;


@end
