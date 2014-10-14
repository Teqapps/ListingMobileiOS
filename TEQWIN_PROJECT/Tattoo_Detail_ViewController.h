//
//  Tattoo_Detail_ViewController.h
//  TEQWIN_PROJECT
//
//  Created by Teqwin on 29/7/14.
//  Copyright (c) 2014年 Teqwin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Tattoo_Master_Info.h"
#import <MessageUI/MessageUI.h>
#import "TattooMasterCell.h"
@interface Tattoo_Detail_ViewController : UIViewController<MFMailComposeViewControllerDelegate,UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate >

{
    PFObject *imageObject;
        NSArray *imageFilesArray;
        NSMutableArray *imagesArray;
    NSArray * count;
    PFObject *object;
    NSMutableArray *list;
    NSArray*imageFilesArray_image;
}


@property (weak, nonatomic) IBOutlet UICollectionView *imagesCollection;

@property (weak, nonatomic) IBOutlet UIImageView *fav_image;
- (IBAction)favButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *favButton;
- (IBAction)bookmarkbtn:(id)sender;


@property (weak, nonatomic) IBOutlet UILabel *master_name;



@property (strong, nonatomic) Tattoo_Master_Info *selectedTattoo_Master;

@property (weak, nonatomic) IBOutlet UILabel *count_like;

@property (strong, nonatomic) NSDictionary *data;
@property (weak, nonatomic) IBOutlet UIImageView *bookmark_image;

@property (weak, nonatomic) IBOutlet UICollectionView *s;
@property (nonatomic, assign) BOOL isbookmark;
@property (nonatomic, assign) BOOL isFav;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSString *venueId;


@property (weak, nonatomic) IBOutlet PFImageView *profileimage;

@property (nonatomic, strong) TattooMasterCell *tattoomasterCell;
@end
