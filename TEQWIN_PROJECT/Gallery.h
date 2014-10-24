//
//  Gallery.h
//  TEQWIN_PROJECT
//
//  Created by Teqwin on 16/9/14.
//  Copyright (c) 2014年 Teqwin. All rights reserved.
//
#import <Parse/Parse.h>
#import <UIKit/UIKit.h>
#import "Tattoo_Detail_ViewController.h"
@interface Gallery : UIViewController
{
    NSArray *imageFilesArray;
    NSMutableArray *imagesArray;
    PFFile * shareimageFile;
    UIImage *imageToShare;
    PFObject *imageObject;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;


- (IBAction)btn_share:(id)sender;
- (IBAction)like:(id)sender;

@property(nonatomic,retain) UIDocumentInteractionController *documentationInteractionController;
@property (strong, nonatomic) TattooMasterCell * tattoomasterCell;
@end
