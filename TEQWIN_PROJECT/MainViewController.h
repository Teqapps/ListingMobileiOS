//
//  ViewController.h
//  SidebarDemo
//
//  Created by Simon on 28/6/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeModel.h"
#import <Parse/Parse.h>
#import "TattooMasterCell.h"
@protocol passNames <NSObject>


@end
@interface MainViewController : UIViewController <HomeModelProtocol>
{
    NSArray *imageFilesArray;
    NSMutableArray *imagesArray;
 
}
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UILabel *test;
@property (nonatomic, strong) TattooMasterCell *tattoomasterCell;
@property (weak, nonatomic) IBOutlet PFImageView *main_image;
@property (weak, nonatomic) IBOutlet UICollectionView *image_collection;

@end
