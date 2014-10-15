//
//  LoginUIViewController.h
//  FBLoginUIControlSample
//
//  Created by Luz Caballero on 9/17/13.
//  Copyright (c) 2013 Facebook Inc. All rights reserved.
//
#import "TattooMasterCell.h"
#import "Tattoo_Detail_ViewController.h"
#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import <Parse/Parse.h>
#import <Parse/PFLogInViewController.h>
@interface LoginUIViewController : UIViewController<PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate,UITableViewDataSource, UITableViewDelegate>
{
    NSArray * likearray;
     NSArray *count;
    NSArray *imageFilesArray;
    NSMutableArray *imagesArray;
    PFObject *selectobject;
    NSString * favstring;
    
}
- (IBAction)wholiked:(id)sender;
@property (nonatomic, assign) BOOL isFav;
@property (weak, nonatomic) IBOutlet UILabel *welcomeLabel;
@property (weak, nonatomic) IBOutlet PFImageView *profile_image;
@property (weak, nonatomic) IBOutlet UITableView *TABLEVIEW;
@property (weak, nonatomic) IBOutlet UIButton *logout;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UIImageView *fbprofile;
@property (weak, nonatomic) IBOutlet UILabel *bookmarkcount;
@property (weak, nonatomic) IBOutlet UILabel *likecount;

- (IBAction)logOutButtonTapAction:(id)sender;
- (IBAction)showbookmark:(id)sender;
- (IBAction)showlike:(id)sender;






@end
