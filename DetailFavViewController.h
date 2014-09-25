//
//  DetailFavViewController.h
//  TEQWIN_PROJECT
//
//  Created by Teqwin on 4/8/14.
//  Copyright (c) 2014年 Teqwin. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#import <MessageUI/MessageUI.h>
@import CoreData;
@interface DetailFavViewController : UIViewController<MFMailComposeViewControllerDelegate,UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate >
{
    NSMutableArray *list;
}
@property (nonatomic, assign) BOOL isFav;
@property (nonatomic, strong) NSString *venueId;
@property (strong, nonatomic) NSManagedObject *data;
@property (weak, nonatomic) IBOutlet UITableView *tabelview;

@property (weak, nonatomic) IBOutlet UIScrollView *favscroll;

@property (weak, nonatomic) IBOutlet UIButton *favButton;

@end
