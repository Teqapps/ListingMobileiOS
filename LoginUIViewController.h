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
     NSArray *count;
    NSArray *imageFilesArray;
    NSMutableArray *imagesArray;
    PFObject *selectobject;
}
@property (nonatomic, assign) BOOL isFav;
@property (weak, nonatomic) IBOutlet UILabel *welcomeLabel;
@property (weak, nonatomic) IBOutlet PFImageView *profile_image;
@property (weak, nonatomic) IBOutlet UITableView *TABLEVIEW;
@property (weak, nonatomic) IBOutlet UIButton *logout;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;

- (IBAction)logOutButtonTapAction:(id)sender;






@end
