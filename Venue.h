//
//  Venue.h
//  TEQWIN_PROJECT
//
//  Created by Teqwin on 1/8/14.
//  Copyright (c) 2014年 Teqwin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
@interface Venue : NSManagedObject
@property (nonatomic, retain) NSString * master_id;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * gender;
@property (nonatomic, retain) NSString * tel;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * website;
@property (nonatomic, retain) NSString * personage;
@property (nonatomic, retain) NSString * gallery1;
@property (nonatomic, retain) NSString * gallery2;
@property (nonatomic, retain) NSString * gallery3;
@property (nonatomic, retain) NSString * gallery4;
@property (nonatomic, retain) NSString * gallery5;
@property (nonatomic, retain) NSString * image;

@end
