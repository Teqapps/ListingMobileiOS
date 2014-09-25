//
//  Fav_Map_ViewController.m
//  TEQWIN_PROJECT
//
//  Created by Teqwin on 4/8/14.
//  Copyright (c) 2014年 Teqwin. All rights reserved.
//
#import "FavDataManager.h"
#import "Venue.h"
@import CoreData;
#import "Fav_Map_ViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "DetailFavViewController.h"
@interface Fav_Map_ViewController ()

@end

@implementation Fav_Map_ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
// self.data 既資料係內存資料(coredata) 姐係save 我的最愛資料 就會放入去
    MKMapItem * currentLocation =[MKMapItem mapItemForCurrentLocation];
    
       NSNumber *lat = [self.data valueForKey:@"latitude"];
    NSNumber *lng = [self.data valueForKey:@"longitude"];

    
    MKPlacemark *place=[[MKPlacemark alloc]
                        initWithCoordinate:
                        CLLocationCoordinate2DMake([lat doubleValue],[lng doubleValue])
                        addressDictionary:nil];
    MKMapItem *pin =[[MKMapItem alloc]
                     initWithPlacemark:place];
    
    pin.name =[self.data valueForKey:@"name"];
    pin.phoneNumber =[self.data valueForKey:@"tel"];
    
    
    NSArray *array =[[NSArray alloc]initWithObjects:currentLocation,pin, nil];
    
    NSDictionary * param =[NSDictionary dictionaryWithObject://MKLaunchOptionsDirectionsModeDriving forKey:MKLaunchOptionsDirectionsModeKey];
                           MKLaunchOptionsDirectionsModeWalking forKey:MKLaunchOptionsDirectionsModeKey];
    [MKMapItem openMapsWithItems:array launchOptions:param];}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
