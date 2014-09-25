//
//  Fav_Map_ViewController.h
//  TEQWIN_PROJECT
//
//  Created by Teqwin on 4/8/14.
//  Copyright (c) 2014年 Teqwin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "DetailFavViewController.h"
@interface Fav_Map_ViewController : UIViewController
@property (nonatomic, assign) BOOL isFav;
@property (nonatomic, strong) NSString *venueId;
@property (strong, nonatomic) NSManagedObject *data;
@end
