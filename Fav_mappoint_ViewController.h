//
//  Fav_mappoint_ViewController.h
//  TEQWIN_PROJECT
//
//  Created by Teqwin on 5/8/14.
//  Copyright (c) 2014年 Teqwin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "DetailFavViewController.h"
@interface Fav_mappoint_ViewController : UIViewController
@property (nonatomic, assign) BOOL isFav;
@property (nonatomic, strong) NSString *venueId;
@property (weak, nonatomic) IBOutlet MKMapView *mymap;
@property (strong, nonatomic) NSManagedObject *data;
@end
